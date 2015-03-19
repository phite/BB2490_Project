setwd("~/Dropbox/CAGE_project/final_counts/")
require(AgiMicroRna)
require(DESeq)

# Load data
yeast <- read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_r64_counts.bed",stringsAsFactors=FALSE,row.names=1)
human <- read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_hg19_counts.bed",stringsAsFactors=FALSE,row.names=1)

RLE_human <- read.table(file = "outputFile_human_RLE_normalized.txt",stringsAsFactors=FALSE,row.names="ids")
RLE_yeast <- read.table(file = "outputFile_yeast_RLE_normalized.txt",stringsAsFactors=FALSE,row.names="ids")
RLE_human$row.names = RLE_yeast$row.names = NULL
colnames(RLE_human) <- c("RLE_01","RLE_1")

spikein <- read.table(file = "outputFile_SpikeIn_Normalized.txt",stringsAsFactors=FALSE,row.names="ids")
spikein$row.names <- NULL
spikein$CAGE1 <- spikein$CAGE1*10
colnames(spikein) <- c("spikein_01","spikein_1")

conds <- c("CAGE01","CAGE1")
colnames(yeast) <- conds
colnames(human) <- conds

# DESeq

yeast_cds <- newCountDataSet(yeast,conds)
yeast_cds <- estimateSizeFactors(yeast_cds)

human_cds <- newCountDataSet(human,conds)
human_cds <- estimateSizeFactors(human_cds)

sf =  sizeFactors(yeast_cds)
sf[1]= sf[1]*10
sizeFactors(human_cds) <- sf
foo = counts(human_cds, normalized=T)
 foo = as.data.frame(foo,stringsAsFactors = F)


human_cds <- estimateSizeFactors(human_cds)
human_cds <- estimateDispersions( human_cds, method = "blind",sharingMode="fit-only") # WE MADE THIS CHANGE BECAUSE WE DO NOT HAVE OUTLIERS 
res <- nbinomTest( human_cds, "CAGE01", "CAGE1" )


# TPM normalization

TPM_normalization <- function(dat){
	result_data <- apply(dat,2,function(x){
		y <- x*10^6/sum(x)
		return(y)
	})
	result_data <- as.data.frame(result_data)
return(result_data)
}

TPM_human <- TPM_normalization(human)
colnames(TPM_human) <- c("TPM_01","TPM_1")
write.table(TPM_human,"normalized_TPM_human.bed",sep = "\t",col.names = NA)
TPM_yeast <- TPM_normalization(yeast)
write.table(TPM_yeast,"normalized_TPM_yeast.bed",sep = "\t",col.names = NA)

# remove outlayer

rm_out <- function(dat,num) {
	rmlist <- numeric()
	for(i in 1: nrow(dat)){
		if(any(dat[i,] > num))
		rmlist <- c(rmlist,i)
	}
	rm_dat <- dat[-rmlist,]
	
return(rm_dat)
}

# remove -Inf
rm_inf <- function(dat) {
	rmlist <- numeric()
	for(i in 1: nrow(dat)){
		if(any(dat[i,] == "-Inf"))
		rmlist <- c(rmlist,i)
	}
	rm_dat <- dat[-rmlist,]
	
return(rm_dat)
}


# YZ_normalization
YZ_normalization <- function(yeast,human){
	
	y01 <- sapply(yeast$CAGE01,log10)
	y01 <- y01[which(y01 != "-Inf")]
	a <- 1-mean(y01)

	y1 <- sapply(yeast$CAGE1,log10)
	y1 <- y1[which(y1 != "-Inf")]
	b <- 2-mean(y1)
	
	h01 <- sapply(human$CAGE01,log10)
	h1 <- sapply(human$CAGE1,log10)
	h01 <- h01+a
	h1 <- h1+b
	
	normalized_human <- human
	normalized_human$norm_01 <- 10^h01
	normalized_human$norm_1 <- 10^h1
	
return(normalized_human)
}

YZ_human <- YZ_normalization(yeast,human)
YZ_human$CAGE01 = YZ_human$CAGE1 = NULL

write.table(result,"normalized_human.bed",col.names = NA)



# plot normalization without yeast

pdf("no_yeast.pdf")
par(mfrow=c(1,3))
foo <- rm_inf(log2(human))
RleMicroRna(foo,colorfill="blue")

foo <- rm_inf(log2(TPM_human))
RleMicroRna(foo,colorfill="orange")

foo <- rm_inf(log2(RLE_human))
RleMicroRna(foo,colorfill="green")
dev.off()


# plot normalization with yeast
pdf("with_yeast.pdf")
par(mfrow=c(1,3))
foo <- rm_inf(log2(human))
RleMicroRna(foo,colorfill="blue")

foo <- rm_inf(log2(spikein))
RleMicroRna(foo,colorfill="green")

foo <- rm_inf(log2(YZ_human))
RleMicroRna(foo,colorfill="red")
dev.off()


