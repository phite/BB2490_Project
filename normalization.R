setwd("/home/yunzhang/CAGE_project/out/counts/")

# Load data
yeast = read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_r64_counts.bed",stringsAsFactors=FALSE,row.names=1)
human = read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_hg19_counts.bed",stringsAsFactors=FALSE,row.names=1)
colnames(yeast) = c("CAGE01","CAGE1")
colnames(human) = c("CAGE01","CAGE1")

# TPM normalization

TPM_normalization <- function(data){
	result_data <- apply(data,2,function(x){
		y <- x*10^6/sum(x)
		return(y)
	})
	result_data <- as.data.frame(result_data)
return(result_data)
}

result_human <- TPM_normalization(human)
write.table(result_human,"normalized_TPM_human.bed",sep = "\t",col.names = NA)
result_yeast <- TPM_normalization(yeast)
write.table(result_yeast,"normalized_TPM_yeast.bed",sep = "\t",col.names = NA)

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

result <- CAGE_normalization(result_yeast,result_human)
write.table(result,"normalized_human.bed")