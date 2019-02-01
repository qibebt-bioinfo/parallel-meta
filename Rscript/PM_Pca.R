#################################################################
# Function: PCA
# Call: Rscript PM_pca.R -m meta_data -i abund_file [-l T/F -o outfile -a axesfile]
# R packages used: optparse vegan ggplot2 grid
# Update: 2016-09-22,Zheng Sun, Yanhai Gong, Xiaoquan Su
# Last update: 2018-5-11, Wang Honglei, Xiaoquan Su
#################################################################

## install necessary libraries
p <- c("optparse","vegan","ggplot2","grid")
usePackage <- function(p) {
  if (!is.element(p, installed.packages()[,1]))
    install.packages(p, dep=TRUE, repos="http://cran.us.r-project.org/")
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
  make_option(c("-m", "--meta_data"), type="character", help="Input meta data file [Required]"),  
  make_option(c("-l", "--drawlabel"), type="logical", default=F,help="If enable the sample label [Optional, default %default]"),
  make_option(c("-o", "--outfile"), type="character", default='pca.pdf', help="Output PCA figure [default %default]"),
   make_option(c("-p", "--pointsize"), type="double", default=6.0, help="Point size on PCA plot [default %default]")
  #make_option(c("-a", "--axesfile"), type="character", default='pca_axes.txt', help="Output PCA axes [default %default]")
)
opts <- parse_args(OptionParser(option_list=option_list), args=args)
ps <- opts$pointsize

# paramenter checking
if(is.null(opts$meta_data)) stop('Please input a meta data file')
if(is.null(opts$abund_file)) stop('Please input a feature table (*.Abd)')

axesfile<-paste(opts$outfile, ".pc", sep="")

## load data
# import meta file
meta_orig <- read.table(file=opts$meta_data, header=TRUE, row.names=1)
# import abundance file
abund_orig <- read.table(file=opts$abund_file, header=TRUE, row.names=1)

## main calc & draw function definition
PM_pca <- function(da, md) {
  rn <- rownames(da)
  cn <- colnames(da)
  
  meta <- md[lapply(md, class)=="factor"]
  n <- ncol(meta)
  
  sampleNumber <- length(rn)
  
  da.dist <- vegdist(da,method="euclidean")
  da.b.pca <- cmdscale(da.dist, k=3, eig=TRUE, add=TRUE)
  
  colnames(da.b.pca$points)<-c("PC1","PC2","PC3")
  data<-as.data.frame(da.b.pca$points)
  loadings <- signif(da.b.pca$eig/sum(da.b.pca$eig)*100, digits=3)
  
  # write axes file
  write.table(data,file=axesfile,sep="\t",quote=FALSE,col.names=NA)
  
  data$group<-rownames(data)
  data$group2<-data$group
  
  pdf(opts$outfile,width=3*10,height=7*n)
  grid.newpage()
  pushViewport(viewport(layout=grid.layout(n,3)))
  vplayout<-function(x,y)
    viewport(layout.pos.row=x,layout.pos.col=y)
  
  for (i in 1:n) {
    gnum <- nlevels(as.factor(meta[,i]))
    gcol <- rainbow(gnum)
    #gshape <- sample(0:19,gnum)
    data$group <- meta[,i] # grouping information
    
    if (opts$drawlabel) {
      pca12<-ggplot() +
        geom_point(data=data,aes(x=PC1,y=PC2,color=group),stat='identity',size=ps) + 
        geom_text(data=data,aes(x=PC1,y=PC2,label=group2),hjust=0,vjust=-1,alpha=0.8) +
        scale_colour_manual(values=gcol)+guides(col=guide_legend(colnames(meta)[i],ncol=ceiling(gnum/14))) +
        xlab(paste("PC1 (",loadings[1],"%)")) + ylab(paste("PC2 (",loadings[2],"%)")) + geom_vline(xintercept=0,linetype="longdash") + geom_hline(yintercept=0,linetype="longdash") +
        theme(axis.text.x=element_text(size=12,colour="black"),
              axis.text.y=element_text(size=12,colour="black"),
              axis.title.x=element_text(size=16),
              axis.title.y=element_text(size=16),
              legend.key=element_rect(colour="black",size=0.2),
              panel.border=element_rect(fill=NA),
              panel.grid.minor=element_blank(),
              panel.background=element_blank())
      
      
      pca13<-ggplot() +
        geom_point(data=data,aes(x=PC1,y=PC3,colour=group),stat='identity',size=ps) +
        geom_text(data=data,aes(x=PC1,y=PC3,label=group2),hjust=0,vjust=-1,alpha=0.8) +
        scale_colour_manual(values=gcol)+guides(col=guide_legend(colnames(meta)[i],ncol=ceiling(gnum/14))) +
        xlab(paste("PC1 (",loadings[1],"%)")) + ylab(paste("PC3 (",loadings[3],"%)")) + geom_vline(xintercept=0,linetype="longdash") + geom_hline(yintercept=0,linetype="longdash") +
        theme(axis.text.x=element_text(size=12,colour="black"),
              axis.text.y=element_text(size=12,colour="black"),
              axis.title.x=element_text(size=16),
              axis.title.y=element_text(size=16),
              legend.key=element_rect(colour="black",size=0.2),
              panel.border=element_rect(fill=NA),
              panel.grid.minor=element_blank(),
              panel.background=element_blank())
      
      pca23<-ggplot() +
        geom_point(data=data,aes(x=PC2,y=PC3,colour=group),stat='identity',size=ps) +
        geom_text(data=data,aes(x=PC2,y=PC3,label=group2),hjust=0,vjust=-1,alpha=0.8) +
        scale_colour_manual(values=gcol)+guides(col=guide_legend(colnames(meta)[i],ncol=ceiling(gnum/14))) +
        xlab(paste("PC2 (",loadings[2],"%)")) + ylab(paste("PC3 (",loadings[3],"%)")) + geom_vline(xintercept=0,linetype="longdash") + geom_hline(yintercept=0,linetype="longdash") +
        theme(axis.text.x=element_text(size=12,colour="black"),
              axis.text.y=element_text(size=12,colour="black"),
              axis.title.x=element_text(size=16),
              axis.title.y=element_text(size=16),
              legend.key=element_rect(colour="black",size=0.2),
              panel.border=element_rect(fill=NA),
              panel.grid.minor=element_blank(),
              panel.background=element_blank())
    } else {
      pca12<-ggplot() +
        geom_point(data=data,aes(x=PC1,y=PC2,color=group),stat='identity',size=ps) + 
        scale_colour_manual(values=gcol)+guides(col=guide_legend(colnames(meta)[i],ncol=ceiling(gnum/14))) +
        xlab(paste("PC1 (",loadings[1],"%)")) + ylab(paste("PC2 (",loadings[2],"%)")) + geom_vline(xintercept=0,linetype="longdash") + geom_hline(yintercept=0,linetype="longdash") +
        theme(axis.text.x=element_text(size=12,colour="black"),
              axis.text.y=element_text(size=12,colour="black"),
              axis.title.x=element_text(size=16),
              axis.title.y=element_text(size=16),
              legend.key=element_rect(colour="black",size=0.2),
              panel.border=element_rect(fill=NA),
              panel.grid.minor=element_blank(),
              panel.background=element_blank())
      
      
      pca13<-ggplot() +
        geom_point(data=data,aes(x=PC1,y=PC3,colour=group),stat='identity',size=ps) +
        scale_colour_manual(values=gcol)+guides(col=guide_legend(colnames(meta)[i],ncol=ceiling(gnum/14))) +
        xlab(paste("PC1 (",loadings[1],"%)")) + ylab(paste("PC3 (",loadings[3],"%)")) + geom_vline(xintercept=0,linetype="longdash") + geom_hline(yintercept=0,linetype="longdash") +
        theme(axis.text.x=element_text(size=12,colour="black"),
              axis.text.y=element_text(size=12,colour="black"),
              axis.title.x=element_text(size=16),
              axis.title.y=element_text(size=16),
              legend.key=element_rect(colour="black",size=0.2),
              panel.border=element_rect(fill=NA),
              panel.grid.minor=element_blank(),
              panel.background=element_blank())
      
      pca23<-ggplot() +
        geom_point(data=data,aes(x=PC2,y=PC3,colour=group),stat='identity',size=ps) +
        scale_colour_manual(values=gcol)+guides(col=guide_legend(colnames(meta)[i],ncol=ceiling(gnum/14))) +
        xlab(paste("PC2 (",loadings[2],"%)")) + ylab(paste("PC3 (",loadings[3],"%)")) + geom_vline(xintercept=0,linetype="longdash") + geom_hline(yintercept=0,linetype="longdash") +
        theme(axis.text.x=element_text(size=12,colour="black"),
              axis.text.y=element_text(size=12,colour="black"),
              axis.title.x=element_text(size=16),
              axis.title.y=element_text(size=16),
              legend.key=element_rect(colour="black",size=0.2),
              panel.border=element_rect(fill=NA),
              panel.grid.minor=element_blank(),
              panel.background=element_blank())
    }
    
    print(pca12,vp=vplayout(i,1))
    print(pca13,vp=vplayout(i,2))
    print(pca23,vp=vplayout(i,3))
  }
  
  invisible(dev.off())
  
}

## calc
PM_pca(da=abund_orig, md=meta_orig)
