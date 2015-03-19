setwd("/home/enrichetta/Dropbox/CAGE_project/final_counts/")
yeast = read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_r64_counts.bed",stringsAsFactors=FALSE, header=FALSE)
human = read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_hg19_counts.bed",stringsAsFactors=FALSE)
colnames(yeast) = c("Tag","CAGE01","CAGE1")
colnames(human) = c("Tag","CAGE01","CAGE1")
yeast_sub=subset(yeast,select=-Tag)
human_sub=subset(human,select=-Tag)

CAGE_normalization_human <- function(human_sub,human){
  TPM_H=t(t(human_sub)*10^6/rowSums(t(human_sub))) 
  human_TPM=(cbind(human$Tag,TPM_H))
  human_TPM=as.data.frame(human_TPM)
  colnames(human_TPM) = c("Tag","CAGE01","CAGE1")
  human_TPM$CAGE01<-as.numeric(as.character(human_TPM$CAGE01))
  human_TPM$CAGE1<-as.numeric(as.character(human_TPM$CAGE1))
  return(human_TPM)
}

CAGE_normalization_yeast <- function(yeast_sub,yeast){
  TPM_Y=t(t(yeast_sub)*10^6/rowSums(t(yeast_sub)))
  yeast_TPM=(cbind(yeast$Tag,TPM_Y))
  yeast_TPM=as.data.frame(yeast_TPM)
  colnames(yeast_TPM) = c("Tag","CAGE01","CAGE1")
  yeast_TPM$CAGE01<-as.numeric(as.character(yeast_TPM$CAGE01))
  yeast_TPM$CAGE1<-as.numeric(as.character(yeast_TPM$CAGE1))
  return(yeast_TPM)
}
result_human <- CAGE_normalization_human(human_sub,human)
write.table(result_human,"normalized_TPM_human.bed",sep = "\t")
result_yeast <- CAGE_normalization_yeast(yeast_sub,yeast)
write.table(result_yeast,"normalized_TPM_yeast.bed",sep = "\t")

