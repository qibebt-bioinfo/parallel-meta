#################################################################
# Function: Abundance distribution analysis
# Call: Rscript PM_Distribution.R -i abund_file -o outfile
# R packages used: optparse, reshape2, ggplot2,RColorBrewer, grDevices
# Last update: 2017-10-31, Zheng Sun, Xiaoquan Su, Honglei Wang 
# data_matrix -> Unclassified
#################################################################
# install necessary libraries
p <- c("optparse","reshape2","ggplot2","RColorBrewer")
usePackage <- function(p) {
  if (!is.element(p, installed.packages()[,1]))
    install.packages(p, dep=TRUE, repos="http://mirrors.opencas.cn/cran/")
  suppressWarnings(suppressMessages(invisible(require(p, character.only=TRUE))))
}
invisible(lapply(p, usePackage))
## clean R environment
rm(list = ls())
setwd('./')
## parsing arguments
args <- commandArgs(trailingOnly=TRUE)
# make option list and parse command line
option_list <- list(
  make_option(c("-i", "--abund_file"), type="character", help="Input feature table with relative abundance (*.Abd) [Required]"),
  make_option(c("-m", "--meta_data"), type="character", help="Input meta data file [Optional]"),
  make_option(c("-o", "--out_dir"), type="character", default='Distribution', help="Output directory [default %default]"),
  make_option(c("-p", "--prefix"), type="character", default='Out', help="Output file prefix [default %default]"),
  make_option(c("-t", "--threshold"), type="double", default=0.01, help="Average value threshold [Optional, default %default]")
)
opts <- parse_args(OptionParser(option_list=option_list), args=args)
# paramenter checking
if(is.null(opts$abund_file)) stop('Please input a feature table (*.Abd)')
# load data
matrixfile <- opts$abund_file
mapfile <- opts$meta_data
ave_t <- opts$threshold
outpath <- opts$out_dir
dir.create(outpath)
#------------------------------------------------------------------------------------
disbar <- read.table(matrixfile,header = T, row.names = 1,sep="\t")
#-----------Edit
disbarm <- t(disbar)
#---------------
disbar <-disbar[order(rownames(disbar)),]
disbar <- t(disbar)

disbar <- disbar[names(sort(rowSums(disbar),decreasing = T)),]
disbar <- floor(disbar*1000000)/1000000
 Unclassified_other <- disbar[which(apply(disbar,1,mean) <= ave_t),]

invisible(if (sum( Unclassified_other) ==0 ) ( Unclassified_big <- disbar))
invisible(if (sum( Unclassified_other) !=0 ) ( Unclassified_big <- disbar[-(which(apply(disbar,1,mean) <= ave_t)),]))

widforpdf <- ncol(disbar)
 Unclassified_other <- as.matrix( Unclassified_other)
if (dim( Unclassified_other)[2] ==1 )  Unclassified_other <- t( Unclassified_other)

if (is.null( Unclassified_other)==F) {
  disbar <- rbind( Unclassified_big,"Other"=c(colSums( Unclassified_other)),deparse.level = 2)
}

if (mean(colSums(disbar))<0.9999) {                         #Complete to 100%
  if (rownames(disbar)[nrow(disbar)]=="Other") {
    disbar[nrow(disbar),] <- disbar[nrow(disbar),]+(1-colSums(disbar))
  }
  else {
    disbar <- rbind(disbar,"other"=(sapply((1-colSums(disbar)),function(x)max(x,0))),deparse.level = 2)
  }
}
colours <- c(brewer.pal(9, "Set1"),brewer.pal(8, "Set2"),brewer.pal(12, "Set3"),sample(rainbow(length(colnames(t(disbar)))),length(colnames(t(disbar)))))
meltdata <- melt(abs(data.matrix(t(disbar))),varnames=c("Samples","Cutline"),value.name="Relative_Abundance")

#-----------------------------------------------------------------------------------------
if(is.null(opts$meta_data)) {
  pp<-ggplot(meltdata,aes(x=Samples,y=Relative_Abundance,fill=Cutline))+
    geom_bar(stat='identity')+ ylab("Relative Abundance")+ xlab("Samples")+
    scale_x_discrete(limits=c(colnames(disbarm)))+
    scale_y_continuous(breaks=c(0,0.25,0.5,0.75,1),labels=c("0","25%","50%","75%","100%"))+
    guides(fill = guide_legend(reverse=TRUE ,ncol = (ceiling(nrow(disbar)/35))))+
    scale_fill_manual (values=colours) +
    theme(legend.position="right",axis.text.x=element_text(size=12,colour="black",angle=90,vjust=0.5),
          axis.text.y=element_text(size=12,colour="black"), axis.title.x=element_text(size=16),
          axis.title.y=element_text(size=16),panel.grid.major=element_line(colour=NA))
  suppressWarnings(ggsave(paste(outpath, "/", opts$prefix, ".distribution.pdf",sep=""),plot=pp,width=ceiling(16+widforpdf/8),height=10, limitsize=FALSE))
}
if(is.null(opts$meta_data)==F) {
  data_map <- read.table(mapfile,header = T, row.names= 1,sep="\t")
  data_map <- data_map[order(rownames(data_map)),]

# Print OTU results
pp<-ggplot(meltdata,aes(x=Samples,y=Relative_Abundance,fill=Cutline))+
    geom_bar(stat='identity')+ ylab("Relative Abundance")+ xlab("Samples")+
    scale_x_discrete(limits=c(colnames(disbarm)))+
    scale_y_continuous(breaks=c(0,0.25,0.5,0.75,1),labels=c("0","25%","50%","75%","100%"))+
    guides(fill = guide_legend(reverse=TRUE ,ncol = (ceiling(nrow(disbar)/35))))+
    scale_fill_manual (values=colours) +
    theme(legend.position="right",axis.text.x=element_text(size=12,colour="black",angle=90,vjust=0.5),
          axis.text.y=element_text(size=12,colour="black"), axis.title.x=element_text(size=16),
          axis.title.y=element_text(size=16),panel.grid.major=element_line(colour=NA))
  suppressWarnings(ggsave(paste(outpath, "/", opts$prefix, ".distribution.pdf",sep=""),plot=pp,width=ceiling(16+widforpdf/8),height=10, limitsize=FALSE))
########

for (i in 1:ncol(data_map)) {
  if (is.factor(data_map[1,i])==T) {
    tempframe <- data.frame(meltdata,dv=data_map[,i])
    pp<-ggplot(tempframe,aes(x=Samples,y=Relative_Abundance,fill=Cutline))+
      geom_bar(stat = "identity")+ ylab("Relative Abundance")+ xlab("Samples")+
        #scale_x_discrete(limits=c(colnames(disbar)))+
      scale_y_continuous(breaks=c(0,0.25,0.5,0.75,1),labels=c("0","25%","50%","75%","100%"))+
      guides(fill = guide_legend(reverse=TRUE ,ncol = (ceiling(nrow(disbar)/35))))+
      scale_fill_manual (values=colours) +
      facet_grid(~ dv,scales="free_x",space="free_x")+ 
      theme(legend.position="right",axis.text.x=element_text(size=12,colour="black",angle=90,vjust=0.5),
            axis.text.y=element_text(size=12,colour="black"), axis.title.x=element_text(size=16),
            axis.title.y=element_text(size=16),panel.grid.major=element_line(colour=NA))
    suppressWarnings(ggsave(paste(outpath,"/", opts$prefix, ".", colnames(data_map)[i],".distribution.pdf",sep=""),plot=pp,height=10,width=ceiling(16+widforpdf/8),limitsize=FALSE))
  }}}


