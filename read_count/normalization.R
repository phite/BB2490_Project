setwd("~/Dropbox/CAGE_project/final_counts/")
require(AgiMicroRna)
require(DESeq)

# Load data
yeast <- read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_r64_counts.bed",stringsAsFactors=FALSE,row.names=1)
human <- read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_hg19_counts.bed",stringsAsFactors=FALSE,row.names=1)

RLE_human <- read.table(file = "outputFile_human_RLE_normalized.txt",stringsAsFactors=FALSE,row.names="ids")
RLE_yeast <- read.table(file = "outputFile_yeast_RLE_normalized.txt",stringsAsFactors=FALSE,row.names="ids")
RLE_human$row.names = RLE_yeast$row.names = NULL

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

# foo <- cbind(human,res$baseMeanA,res$baseMeanB)

# foo <- rm_inf(log2(rm_out(foo,1000)))
# RleMicroRna(foo)


# foo <- rm_inf(log2(rm_out(human,1000)))
# hist(foo$CAGE01,breaks = seq(from = 0,to = 10,by = 0.1))

# plot(density(foo$CAGE01)) # returns the density data 
# plot(d)

# normalization
CAGE_normalization <- function(yeast,human){
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

YZ_human <- CAGE_normalization(yeast,human)
YZ_human$CAGE01 = YZ_human$CAGE1 = NULL

write.table(result,"normalized_human.bed",col.names = NA)


colnames(TPM_human) <- c("TPM_01","TPM_1")
colnames(RLE_human) <- c("RLE_01","RLE_1")

# plot no yeast normalization
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
RleMicroRna(foo,colorfill="orange")

foo <- rm_inf(log2(YZ_human))
RleMicroRna(foo,colorfill="green")
dev.off()



##############################################################


> t.test(human[,1],human[,2])

        Welch Two Sample t-test

data:  human[, 1] and human[, 2]
t = 1.2257, df = 75785.91, p-value = 0.2203
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -18.49834  80.26018
sample estimates:
mean of x mean of y
 577.1233  546.2423

> t.test(TPM_human[,1],TPM_human[,2])

        Welch Two Sample t-test

data:  TPM_human[, 1] and TPM_human[, 2]
t = 0, df = 75323.7, p-value = 1
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -2.322531  2.322531
sample estimates:
mean of x mean of y
 26.36783  26.36783

> t.test(RLE_human[,1],RLE_human[,2])

        Welch Two Sample t-test

data:  RLE_human[, 1] and RLE_human[, 2]
t = 0.7009, df = 75642.56, p-value = 0.4834
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -31.73664  67.06880
sample estimates:
mean of x mean of y
 570.3731  552.7070


> t.test(spikein[,1],spikein[,2])

        Welch Two Sample t-test

data:  spikein[, 1] and spikein[, 2]
t = -2.809, df = 72706.12, p-value = 0.004971
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -384.08035  -68.37489
sample estimates:
mean of x mean of y
 1666.011  1892.239

t.test(YZ_human[,1],YZ_human[,2])

        Welch Two Sample t-test

data:  YZ_human[, 1] and YZ_human[, 2]
t = -5.3087, df = 68949.69, p-value = 1.107e-07
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -236.7340 -109.0638
sample estimates:
mean of x mean of y
 625.9221  798.8210

#################################################

log2human <- rm_inf(log2(human))
t.test(log2human[,1],log2human[,2])

        Welch Two Sample t-test

data:  log2human[, 1] and log2human[, 2]
t = -0.5506, df = 75435.01, p-value = 0.5819
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.04275003  0.02399773
sample estimates:
mean of x mean of y
 6.640545  6.649921

log2humanTPM <- rm_inf(log2(TPM_human))
t.test(log2humanTPM[,1],log2humanTPM[,2])

        Welch Two Sample t-test

data:  log2humanTPM[, 1] and log2humanTPM[, 2]
t = -5.2101, df = 75435.01, p-value = 1.893e-07
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.12208837 -0.05534061
sample estimates:
mean of x mean of y
 2.188516  2.277231

log2humanRLE <- rm_inf(log2(RLE_human))
t.test(log2humanRLE[,1],log2humanRLE[,2])


        Welch Two Sample t-test

data:  log2humanRLE[, 1] and log2humanRLE[, 2]
t = -2.5443, df = 75435.01, p-value = 0.01095
alternative hypothesis: true difference in means is not equal to 0
95 percent confidence interval:
 -0.076697367 -0.009949602
sample estimates:
mean of x mean of y
 6.623571  6.666895

log2spikein <- rm_inf(log2(spikein))
 t.test(log2spikein[,1],log2spikein[,2])



