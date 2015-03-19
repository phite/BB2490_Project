library(DESeq)
setwd("~/Dropbox/CAGE_project/final_counts")

countsTable = read.delim(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_r64_counts.bed",stringsAsFactors=FALSE,header = FALSE)
head(countsTable)
colnames(countsTable) <- c("TC","CAGE01","CAGE1")
head(countsTable)
conds = c("CAGE01","CAGE1")
countsTable <- countsTable[,-1]
head( countsTable)
spikeincds <- newCountDataSet( countsTable, conds )
spikeincds <- estimateSizeFactors( spikeincds )
sizeFactors( spikeincds )
countsTable = read.delim(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_hg19_counts.bed",stringsAsFactors=FALSE,header = FALSE)
colnames(countsTable) <- c("TC","CAGE01","CAGE1")
conds <- c("CAGE01","CAGE1")
ids<-countsTable$TC
ids
countsTable <- countsTable[,-1]
head( countsTable)
cds <- newCountDataSet( countsTable, conds )
sizeFactors( cds ) = sizeFactors( spikeincds )
sizeFactors( cds )
human <-counts(cds,normalized=TRUE)
head(human)
human<-cbind(ids,human)
head(human)
write.table((human),file="outputFile_SpikeIn_Normalized.txt",sep="\t")

''''
cds <- estimateSizeFactors( cds)
cds 
cds <- estimateDispersions( cds, method = "blind",sharingMode="fit-only") # WE MADE THIS CHANGE BECAUSE WE DO NOT HAVE OUTLIERS 
res = nbinomTest( cds, "CAGE01", "CAGE1" )
res$id<-ids
head(res)
write.table((res),file="outputFile_SpikeIn_Normolized.txt",sep="\t")
plotMA( res )
hist(res$pval, breaks=100, col="skyblue", border="slateblue", main="")
#fileter the significant genes accprding to the FDR rate that I chosen
resSig = res[ res$padj < 0.1, ] 
# the most significantly differentially expressed genes
head( resSig[ order(resSig$pval), ] ) 
# the most strongly down regulated
head( resSig[ order( resSig$foldChange, -resSig$baseMean ), ] ) 
# the most strongly up regulated
head( resSig[ order( -resSig$foldChange, -resSig$baseMean ), ] ) 
write.csv( res, file="normalization_results.csv" )
addmargins( table( res_sig = res$padj < .1 ))
''''
