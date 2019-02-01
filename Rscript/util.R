#-------------------------------
# R funtions for TaxaSummary analysis.
#-------------------------------
# Last update: 20170115, HuangShi

p <- c("reshape","ggplot2","pheatmap","pROC","combinat","plyr","vegan","optparse")
usePackage <- function(p) {
    if (!is.element(p, installed.packages()[,1]))
        install.packages(p, dep = TRUE, repos =c("http://rstudio.org/_packages", "http://cran.rstudio.com"))
    suppressWarnings(suppressMessages(invisible(require(p, character.only = TRUE))))
}
suppressWarnings(suppressMessages(invisible(lapply(p, usePackage))))

#clustering for "types"
#-------------------------------
## KL/JS divergence measure for relative-abundance(density/frequency) data
#-------------------------------
JSD<-function(object, eps=10^-4, overlap=TRUE,...)
{
    if(!is.numeric(object))
        stop("object must be a numeric matrix\n")
    
    z <- matrix(NA, nrow=ncol(object), ncol=ncol(object))
    colnames(z) <- rownames(z) <- colnames(object)
    
    w <- object < eps
    if (any(w)) object[w] <- eps
## If you takes as input a matrix of density values 
## with one row per observation and one column per 
## distribution, add following statement below.
 # object <- sweep(object, 2, colSums(object) , "/")
    
    for(k in seq_len(ncol(object)-1)){
      for(l in 2:ncol(object)){
        ok <- (object[, k] > eps) & (object[, l] > eps)
        if (!overlap | any(ok)) {
          m=0.5*(object[,k]+object[,l])
          z[k,l] <- sqrt(0.5*sum(object[,k] *(log(object[,k]) - log(m)))+0.5*sum(object[,l] *(log(object[,l]) - log(m))))
          z[l,k] <- sqrt(0.5*sum(object[,l] *(log(object[,l]) - log(m)))+0.5*sum(object[,k] *(log(object[,k]) - log(m))))
        }
      }
    }
    diag(z)<-0
    z
}

#-------------------------------
PAM.best<-function(matrix,dist.mat){
#-------------------------------
# matrix: 
#         row.names	Sample_id
#         col.names	Varibles
# For example, data should be organized like this:
# Sample_id	V1	V2	V3	etc...
# sample_0001	15	6	25
# sample_0002	7	9	32
# etc...
#-------------------------------
 if(!is.numeric(matrix))
        stop("matrix must be a numeric matrix\n")
 if(!is.numeric(dist.mat) && class(dist.mat)=="dist")
        stop("dist.mat must be numeric distance matrix\n")
#-------------------------------
# nc - number_of_clusters
#-------------------------------
min_nc=2
if(nrow(matrix)>20){
max_nc=20} else {
max_nc=nrow(matrix)-1}
res <- array(0,c(max_nc-min_nc+1, 2))
res[,1] <- min_nc:max_nc
siavgs <- array(0,c(max_nc-min_nc+1, 2))
siavgs[,1] <- min_nc:max_nc
clusters <- NULL
for (nc in min_nc:max_nc)
{
cl <- pam(dist.mat, nc, diss=TRUE)
res[nc-min_nc+1,2] <- CH <- index.G1(matrix,cl$cluster,d=dist.mat,centrotypes="medoids")
siavgs[nc-1,2]<-cl$silinfo$avg.width
clusters <- rbind(clusters, cl$cluster)
}
CH_nc<-(min_nc:max_nc)[which.max(res[,2])]
Si_nc<-(min_nc:max_nc)[which.max(siavgs[,2])]
print(paste("max CH for",CH_nc,"clusters=",max(res[,2])))
print(paste("max Si for",Si_nc,"clusters=",max(siavgs[,2])))

CH_cluster<-clusters[which.max(res[,2]),]
Si_cluster<-clusters[which.max(siavgs[,2]),]
objectList      <- list()
    objectList$min_nc <- min_nc
    objectList$max_nc <- max_nc
    objectList$CH     <- CH_cluster
    objectList$Si     <- Si_cluster
    objectList$CH_nc  <- CH_nc
    objectList$Si_nc  <- Si_nc
    objectList$res    <- res
    objectList$siavgs <- siavgs
    return(objectList)
}

#--------------------------------------------------
rangeScaling <- function(v) {
themin <- min(v)
themax <- max(v) 
v <- (v- themin) / (themax - themin)
return(v)
}
#--------------------------------------------------
paretoScaling <- function(v) {
themean <- mean(v)
thesd <- sd(v) 
v <- (v- themean) / sqrt(thesd)
return(v)
}
#--------------------------------------------------
PlotCorrHeatMap<-function(cor.method, colors, data){
    main <- xlab <- ylab <- NULL;
    #print (dim(data));
    #write.csv(data,file="test.csv"); # debug
    
    # Decide size of margins and length of labels
    labelLen<-max(nchar(colnames(data)))
    margins<-c(12, 12)

    if(ncol(data) > 500){
        filter.val <- apply(data.matrix(data), 2, IQR, na.rm=T);
        rk <- rank(-filter.val, ties.method='random');
        data <- as.data.frame(data[,rk < 500]);
        
        print("Data is reduced to 500 vars ..");
    }

    #colnames(data)<-substr(colnames(data), 1, labelLen);
     corr.mat<-cor(data, method=cor.method);

    # set up parameter for heatmap
    suppressMessages(require(RColorBrewer));
    suppressMessages(require(gplots));
    if(colors=="jet"){
        colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan","#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))(256) 
    }else if(colors=="gbr"){
        colors <- colorRampPalette(c("green", "black", "red"), space="rgb")(256);
    }else if(colors == "heat"){
        colors <- heat.colors(256);
    }else if(colors == "topo"){
        colors <- topo.colors(256);
    }else{
        colors <- rev(colorRampPalette(brewer.pal(10, "RdBu"))(256));
    }
    
    heatmap<-heatmap.2(corr.mat,
             Rowv=TRUE,
             Colv=TRUE,
            #dendrogram= c("none"),
             distfun = dist,
             hclustfun = hclust,
             xlab = xlab,
             ylab = ylab,
             key=TRUE,
             keysize=0.8, # size of the key in the chart
             trace="none",
             density.info=c("none"),
             margins=margins,
            #col=brewer.pal(10,"PiYG")
             main = main,
             col=colors
             )
    objectList      <- list()
    objectList$heatmap  <- heatmap
    objectList$corr.mat <- corr.mat
    return(objectList)
}
#--------------------------------------------------
CleanData <-function(bdata, removeNA=T, removeNeg=T){
    if(sum(bdata==Inf)>0){
        inx <- bdata == Inf;
        bdata[inx] <- NA;
        bdata[inx] <- max(bdata, na.rm=T)*2
    }
    if(sum(bdata==-Inf)>0){
        inx <- bdata == -Inf;
        bdata[inx] <- NA;
        bdata[inx] <- min(bdata, na.rm=T)/2
    }
    if(removeNA){
        if(sum(is.na(bdata))>0){
            bdata[is.na(bdata)] <- min(bdata, na.rm=T)/2
        }
    }
    if(removeNeg){
        if(sum(bdata<=0) > 0){
            inx <- bdata <= 0;
            bdata[inx] <- NA;
            bdata[inx] <- min(bdata, na.rm=T)/2
        }
    }
    bdata;
}
#--------------------------------Cbind for unequal length vectors
padNA <- function (mydata, rowsneeded, first = TRUE) {
           temp1 = colnames(mydata)
           rowsneeded = rowsneeded - nrow(mydata)
           temp2 = setNames(
             data.frame(matrix(rep(NA, length(temp1) * rowsneeded), 
                               ncol = length(temp1))), temp1)
           if (isTRUE(first)) rbind(mydata, temp2)
           else rbind(temp2, mydata)
         }
          
         dotnames <- function(...) {
           vnames <- as.list(substitute(list(...)))[-1L]
           vnames <- unlist(lapply(vnames,deparse), FALSE, FALSE)
           vnames
         }
          
         Cbind <- function(..., first = TRUE) {
           Names <- dotnames(...)
           datalist <- setNames(list(...), Names)
           nrows <- max(sapply(datalist, function(x) 
             ifelse(is.null(dim(x)), length(x), nrow(x))))
           datalist <- lapply(seq_along(datalist), function(x) {
             z <- datalist[[x]]
             if (is.null(dim(z))) {
               z <- setNames(data.frame(z), Names[x])
             } else {
               if (is.null(colnames(z))) {
                 colnames(z) <- paste(Names[x], sequence(ncol(z)), sep = "_")
               } else {
                 colnames(z) <- colnames(z)
               }
             }
             padNA(z, rowsneeded = nrows, first = first)
           })
           do.call(cbind, datalist)
         }
#--------------------------------------------------Last update: 20170101
DistBoxplot1<-function(dm,group,dm_name='',group_name='',IndividualID=NULL,outpath='./'){
         if(  ncol(dm)!=nrow(dm) & any(is.na(dm))==TRUE)
            stop('The distance matrix is not squared')
         if( length(unique(group))==1)
            stop('At least two levels for a given sample category in your metadata file are required.')
         if( length(group)!=nrow(dm))
            stop('The number of rows in metadata and distance matrix are not equal')
         if(nlevels(group)>length(group)*0.9)
            stop('The number of levels in a certain category can not exceed 90% of total number of samples')
#--------------------------------         
         dm<-dm[order(rownames(dm)),]; dm<-dm[,order(colnames(dm))]
         dm<-dm[order(group),order(group)]
         group_ordered<-group[order(group)]
         fac<-factor(group_ordered)
         names(fac)<-rownames(dm)
         
         if(!is.null(IndividualID)){
         Ind<-IndividualID[order(group)]
         names(Ind)<-rownames(dm)
         }
         
         fac_list<-split(fac,fac)
#--------------------------------
         #install.packages('combinat')
         require(combinat)
         require(plyr)
         require(pheatmap)
         require(ggplot2)
#--------------------------------Cbind for unequal length vectors
         padNA <- function (mydata, rowsneeded, first = TRUE) {
           temp1 = colnames(mydata)
           rowsneeded = rowsneeded - nrow(mydata)
           temp2 = setNames(
             data.frame(matrix(rep(NA, length(temp1) * rowsneeded), 
                               ncol = length(temp1))), temp1)
           if (isTRUE(first)) rbind(mydata, temp2)
           else rbind(temp2, mydata)
         }
          
         dotnames <- function(...) {
           vnames <- as.list(substitute(list(...)))[-1L]
           vnames <- unlist(lapply(vnames,deparse), FALSE, FALSE)
           vnames
         }
          
         Cbind <- function(..., first = TRUE) {
           Names <- dotnames(...)
           datalist <- setNames(list(...), Names)
           nrows <- max(sapply(datalist, function(x) 
             ifelse(is.null(dim(x)), length(x), nrow(x))))
           datalist <- lapply(seq_along(datalist), function(x) {
             z <- datalist[[x]]
             if (is.null(dim(z))) {
               z <- setNames(data.frame(z), Names[x])
             } else {
               if (is.null(colnames(z))) {
                 colnames(z) <- paste(Names[x], sequence(ncol(z)), sep = "_")
               } else {
                 colnames(z) <- colnames(z)
               }
             }
             padNA(z, rowsneeded = nrows, first = first)
           })
           do.call(cbind, datalist)
         }
#--------------------------------
         between_fac<-combn(levels(fac),2)
         within_fac<-matrix(rep(levels(fac),each=2),nrow=2,ncol=nlevels(fac))
         all_fac<-cbind(between_fac,within_fac)
         if(nlevels(fac)>2){num_between_fac<-ncol(between_fac)}else{
                            num_between_fac<-1}
         num_within_fac<-ncol(within_fac)
         num_all_fac<-ncol(all_fac)
#--------------------------------
dm_values<-matrix(NA,ncol=num_all_fac)
Ind_dm_values<-matrix(NA,ncol=5)
for(i in 1:num_all_fac){
         IDnames_1<-names(fac_list[[all_fac[1,i]]])
         IDnames_2<-names(fac_list[[all_fac[2,i]]])
         fac_names_1<-all_fac[1,i]
         fac_names_2<-all_fac[2,i]
         sub_dm<-data.matrix(dm[IDnames_1,IDnames_2])
         if(is.null(IndividualID)){
         if(i<=num_between_fac){
                                dm_value<-as.vector(sub_dm)
                                }else{
                                dm_value<-sub_dm[lower.tri(sub_dm,diag = FALSE)]
                                }      
         if(is.na(data.matrix(dm_values)[1])){
                                dm_values<-dm_value}else{
                                dm_values<-Cbind(dm_values,dm_value)
                                }
         }else{
         if(i<=num_between_fac){
                                rownames(sub_dm)<-paste(rownames(sub_dm),Ind[IDnames_1],sep="@")
                                colnames(sub_dm)<-paste(colnames(sub_dm),Ind[IDnames_2],sep="@")
                                melt_sub_dm<-melt(sub_dm)
                                Row_Ind<-do.call(rbind,strsplit(as.character(melt_sub_dm$X1),"@",fixed=TRUE))
                                Col_Ind<-do.call(rbind,strsplit(as.character(melt_sub_dm$X2),"@",fixed=TRUE))
                                melt_sub_dm<-data.frame(Row_Ind,Col_Ind,v=melt_sub_dm$value)
                                colnames(melt_sub_dm)<-c("Sample_1","Subject_1","Sample_2","Subject_2","Dist")
                                Ind_dm_value<-melt_sub_dm[which(melt_sub_dm$Subject_1==melt_sub_dm$Subject_2),]
                                                    
         if(is.na(Ind_dm_values[1,1]) & nrow(Ind_dm_value)!=0){Ind_dm_values<-Ind_dm_value}else{
                                                               Ind_dm_values<-rbind(Ind_dm_values,Ind_dm_value) }                            
         }
         }       
         }
        
#--------------------------------Output distance-values table
if(!is.null(IndividualID)){
         if(nlevels(fac)>2){group_ann<-rep(apply(between_fac,2,paste,collapse='_VS._'),each=length(unique(Ind)))}else{
                            group_ann<-rep(paste(between_fac,collapse='_VS._'),each=length(unique(Ind)))}
         Ind_dm_values<-cbind(group=group_ann,Ind_dm_values)
         group_name<-paste(group_name,"IndividualID",sep="4")
         filepath<-sprintf('%s%s%s%s%s',outpath,dm_name,'.',group_name,'.Ind_dm_values.xls')
         sink(filepath);write.table(Ind_dm_values,quote=FALSE,sep='\t',row.names = FALSE);sink()
         
   #-----Output distance-values boxplot
         
         plot<-qplot(x=group, y=Dist, data=Ind_dm_values, geom='boxplot',main='',ylab=paste(dm_name,'_Distance',sep=''))+
               coord_flip()+ theme_bw()
         suppressMessages(ggsave(filename=paste(outpath,dm_name,'.',group_name,'.boxplot.ggplot.pdf',sep=''),plot=plot, height=ifelse(nlevels(fac)>2,nlevels(fac),2)))
         invisible(Ind_dm_values)
         
   }else{
         
         colnames(dm_values)<-apply(all_fac,2,paste,collapse='_VS._')
   #-----
         All_Between<-as.vector(dm_values[,1:num_between_fac])
         All_Within<-as.vector(dm_values[,-(1:num_between_fac)])
         All_Between<-All_Between[!is.na(All_Between)]
         All_Within<-All_Within[!is.na(All_Within)]
   #-----Objects to return
         if(length(All_Between)>2 & length(All_Within)>2){
         p_t<-t.test(All_Between,All_Within)$p.value
         p_w<-wilcox.test(All_Between,All_Within)$p.value}else{
         p_t<-NA
         p_w<-NA}
         dm_all_values<-Cbind(All_Within,All_Between)
         dm_values<-Cbind(dm_all_values,dm_values)
   #-----Output distance-values table         
         filepath<-sprintf('%s%s%s%s%s',outpath,dm_name,'.',group_name,'.dm_values.xls')
         sink(filepath);write.table(dm_values,quote=FALSE,sep='\t',row.names=FALSE);sink()
   if(nlevels(group)<30){
   #-----Output distance-values boxplot
         suppressMessages(dm_melt<-melt(dm_values[,which(apply(dm_values,2,function(x)sum(is.na(x))<=length(x)))])) # To delete columns containing All "NA" and only one value
         dm_melt<-dm_melt[which(!is.na(dm_melt$value)),]
         plot<-qplot(x=variable, y=value, data=dm_melt, geom='boxplot',position='dodge',main='',ylab=paste(dm_name,'_Distance',sep=''))+
               coord_flip()+ theme_bw()
         suppressMessages(ggsave(filename=paste(outpath,dm_name,'.',group_name,'.boxplots.ggplot.pdf',sep=''),plot=plot))
   #-----Output statistical results
         suppressMessages(dm_melt<-melt(dm_values[,which(apply(dm_values,2,function(x)sum(is.na(x))<=length(x)-2))])) # To delete columns containing All "NA" and only one value
         dm_melt<-dm_melt[which(!is.na(dm_melt$value)),]
         p<-pairwise.wilcox.test(dm_melt$value,factor(dm_melt$variable))$p.value
         sink(paste(outpath,dm_name,'.',group_name,'.dm_stats_P_values(Wilcoxon-test).xls',sep=''));cat('\t');write.table(p,quote=FALSE,sep='\t');sink()
         if(length(unique(as.vector(p)[!is.na(p)]))>1)
         pheatmap(p,cluster_rows = FALSE, cluster_cols = FALSE,display_numbers = T,main=group_name,filename=paste(outpath,dm_name,'.',group_name,'.dm_stats_P_values(T-test).pdf',sep=''))
   }
   
    objectList      <- list()
    objectList$dm_values     <- dm_values
    objectList$dm_all_values <- dm_all_values
    objectList$p_t    <- p_t
    objectList$p_w    <- p_w
    
    invisible(objectList)
         }
         }

#--------------------------------------------------
#--------------------------------------------------Last update: 20170115
DistBoxplot<-function(dm,group,dm_name='',group_name='',IndividualID=NULL,outpath='./'){
    if(  ncol(dm)!=nrow(dm) & any(is.na(dm))==TRUE)
    stop('The distance matrix is not squared')
    if( length(unique(group))==1)
    stop('At least two levels for a given sample category in your metadata file are required.')
    if( length(group)!=nrow(dm))
    stop('The number of rows in metadata and distance matrix are not equal')
    if(nlevels(group)>length(group)*0.9)
    stop('The number of levels in a certain category can not exceed 90% of total number of samples')
    #--------------------------------
    dm<-dm[order(rownames(dm)),order(colnames(dm))]
    dm<-dm[order(group),order(group)]
    group_ordered<-group[order(group)]
    fac<-factor(group_ordered)
    names(fac)<-rownames(dm)
    
    if(!is.null(IndividualID)){
        Ind<-IndividualID[order(group)]
        names(Ind)<-rownames(dm)
    }
    #--------------------------------
    #install.packages('combinat')
    #require(combinat)
    require(plyr)
    require(pheatmap)
    require(ggplot2)
    #--------------------------------
    if(is.null(IndividualID)){
        colnames(dm)<-rownames(dm)<-paste(rownames(dm),fac,sep="____") }else{
        colnames(dm)<-rownames(dm)<-paste(rownames(dm),fac,Ind,sep="____") }
    
    dm[lower.tri(dm)]<-NA
    melt_dm<-melt(data.matrix(dm))
    melt_dm<-melt_dm[!is.na(melt_dm$value),]
    melt_dm<-melt_dm[which(melt_dm$X1!=melt_dm$X2),]
    
    Row_Info<-data.frame(do.call(rbind,strsplit(as.character(melt_dm$X1),"____",fixed=TRUE)))
    Col_Info<-data.frame(do.call(rbind,strsplit(as.character(melt_dm$X2),"____",fixed=TRUE)))
    VS<-paste(Row_Info[,2],"_VS._",Col_Info[,2],sep="")
    dm_value<-data.frame(VS,Row_Info,Col_Info,d=melt_dm$value)
    
    if(is.null(IndividualID)){
    colnames(dm_value)<-c("GroupPair","Sample_1","Group_1","Sample_2","Group_2","Dist")
    DistType<-as.factor(dm_value$Group_1==dm_value$Group_2)
    DistType<-factor(DistType,levels=levels(DistType),labels=c("AllBetween","AllWithin"))
    dm_value<-data.frame(DistType,dm_value)
    }else{
    colnames(dm_value)<-c("GroupPair","Sample_1","Group_1","Subject_1","Sample_2","Group_2","Subject_2","Dist")
    Ind_dm_value<-dm_value[which(dm_value$Subject_1==dm_value$Subject_2),]
    }

    #--------------------------------Output distance table and boxplot
    if(!is.null(IndividualID)){
        group_name<-paste(group_name,"IndividualID",sep="4")
        filepath<-sprintf('%s%s%s%s%s',outpath,dm_name,'.',group_name,'.Ind_dm_values.xls')
        sink(filepath);write.table(Ind_dm_value,quote=FALSE,sep='\t',row.names = FALSE);sink()
        
        #-----Output distance boxplot
        
        plot<-qplot(x=GroupPair, y=Dist,  data=Ind_dm_value, geom='boxplot',main='',xlab="Group pair", ylab=paste(dm_name,'_Distance',sep='')) + coord_flip() + theme_bw()
     suppressMessages(ggsave(filename=paste(outpath,dm_name,'.',group_name,'.boxplot.ggplot.pdf',sep=''),plot=plot, height=ifelse(nlevels(fac)>2,nlevels(fac),2)))
    
    invisible(Ind_dm_value)
        
    }else{
        
        #-----Objects to return
        if(length(dm_value$Dist)>4){
            p_t<-with(dm_value,t.test(Dist~DistType))$p.value
            p_w<-with(dm_value,wilcox.test(Dist~DistType))$p.value}else{
                p_t<-NA
                p_w<-NA}
            
            #-----Output distance-values table
            filepath<-sprintf('%s%s%s%s%s',outpath,dm_name,'.',group_name,'.dm_values.xls')
            sink(filepath);write.table(dm_value,quote=FALSE,sep='\t',row.names=FALSE);sink()
            
            #-----Output distance boxplot
            if(nlevels(group)<30){
            plot<-qplot(x=GroupPair, y=Dist, data=dm_value, geom='boxplot',position='dodge',main='',xlab="Group pair",ylab=paste(dm_name,'_Distance',sep='')) + coord_flip() +  theme_bw()
            suppressMessages(ggsave(filename=paste(outpath,dm_name,'.',group_name,'.boxplot.ggplot.pdf',sep=''),plot=plot))
            #-----Output statistical results
            p<-pairwise.wilcox.test(dm_value$Dist,factor(dm_value$GroupPair))$p.value
            sink(paste(outpath,dm_name,'.',group_name,'.dm_stats_P_values(Wilcoxon-test).xls',sep=''));cat('\t');write.table(p,quote=FALSE,sep='\t');sink()
            if(length(unique(as.vector(p)[!is.na(p)]))>1)
            pheatmap(p,cluster_rows = FALSE, cluster_cols = FALSE,display_numbers = T,main=group_name,filename=paste(outpath,dm_name,'.',group_name,'.dm_stats_P_values(Wilcoxon-test).pdf',sep=''))
            }
            
            objectList      <- list()
            objectList$dm_value     <- dm_value
            objectList$p_t    <- p_t
            objectList$p_w    <- p_w
            
            invisible(objectList)
    }
}

#--------------------------------------------------
BetweenGroup.test <-function(data, group, p.adj.method="bonferroni",paired=FALSE){
# p.adjust.methods
# c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none")

n_group<-nlevels(group)
        if(!is.numeric(n_group) | n_group==1)
        stop("group must be a numeric and up to two levels\n")
if(n_group==2){
               output1<-matrix(NA,ncol=9,nrow=ncol(data))
               rownames(output1)<-colnames(data)
               colnames(output1)<-c(paste("mean_",levels(group)[1],sep=""),paste("mean_",levels(group)[2],sep=""),
                                   paste("sd_",levels(group)[1],sep=""),paste("sd_",levels(group)[2],sep=""),"Var.test","T-test","Wilcoxon.test",
                                   paste("T-test_",p.adj.method,sep=""),paste("Wilcoxon.test_",p.adj.method,sep=""))
               for(i in 1:ncol(data))
               {
               output1[i,1]<-mean(data[which(group==levels(group)[1]),i])
               output1[i,2]<-mean(data[which(group==levels(group)[2]),i])
               output1[i,3]<-sd(data[which(group==levels(group)[1]),i])
               output1[i,4]<-sd(data[which(group==levels(group)[2]),i])
               output1[i,5]<-var.test(data[,i]~group)$p.value
               if(output1[i,5]<0.01)
               output1[i,6]<-t.test(data[,i]~group,paired=paired)$p.value
               else
               output1[i,6]<-t.test(data[,i]~group, var.equal=T,paired=paired)$p.value
               output1[i,7]<-wilcox.test(data[,i]~group, paired=paired, conf.int=TRUE, exact=FALSE, correct=FALSE)$p.value
               output1[i,8]<-NA
               output1[i,9]<-NA
               }
               output1[,8]<-p.adjust(output1[,6], method = p.adj.method, n = ncol(data))
               output1[,9]<-p.adjust(output1[,7], method = p.adj.method, n = ncol(data))
               
               return(data.frame(output1))
}else{
      output2<-matrix(NA,ncol=n_group+5,nrow=ncol(data))
      rownames(output2)<-colnames(data)
      colnames.output2<-array(NA)
      for(j in 1:ncol(output2)){
      if(j<=n_group){
      colnames.output2[j]<-c(paste("mean_",levels(group)[j],sep=""))
      }else{
      colnames.output2[(n_group+1):(n_group+5)]<-c("Var.test","Oneway-test","Kruskal.test",
                                                    paste("Oneway-test_",p.adj.method,sep=""),paste("Kruskal.test_",p.adj.method,sep=""))
                                                    }
      }
      colnames(output2)<-colnames.output2
      for(i in 1:ncol(data))
      {
      for(j in 1:n_group)
      {
      output2[i,j]<-mean(data[which(group==levels(group)[j]),i])
      }
      output2[i,(n_group+1)]<-bartlett.test(data[,i]~group)$p.value
      if(output2[i,(n_group+1)]<0.01)
      output2[i,(n_group+2)]<-oneway.test(data[,i]~group)$p.value
      else
      output2[i,(n_group+2)]<-oneway.test(data[,i]~group, var.equal=T)$p.value
      output2[i,(n_group+3)]<-kruskal.test(data[,i]~group)$p.value
      output2[i,(n_group+4)]<-NA
      output2[i,(n_group+5)]<-NA
      }
      output2[ ,(n_group+4)]<-p.adjust(output2[,(n_group+2)], method = p.adj.method, n = ncol(data))
      output2[ ,(n_group+5)]<-p.adjust(output2[,(n_group+3)], method = p.adj.method, n = ncol(data))
      return(data.frame(output2))
      }
      
      
}
#--------------------------------------------------
