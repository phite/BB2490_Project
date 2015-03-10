setwd("/home/yunzhang/CAGE_project/out/counts/")

# Load data
yeast = read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_r64_counts.bed",stringsAsFactors=FALSE)
human = read.table(file = "CAGE_VRSY_HELA_SPIKE_01P_1P_hg19_counts.bed",stringsAsFactors=FALSE)
colnames(yeast) = c("Tag","CAGE01","CAGE1")
colnames(human) = c("Tag","CAGE01","CAGE1")

summary(human)

       Tag                CAGE01             CAGE1
 Length:37925       Min.   :     0.0   Min.   :     0.0
 Class :character   1st Qu.:    29.0   1st Qu.:    31.0
 Mode  :character   Median :    71.0   Median :    69.0
                    Mean   :   577.1   Mean   :   546.2
                    3rd Qu.:   283.0   3rd Qu.:   266.0
                    Max.   :260101.0   Max.   :290616.0


summary(yeast)
     Tag                CAGE01            CAGE1
 Length:1089        Min.   :   0.00   Min.   :   1.0
 Class :character   1st Qu.:   4.00   1st Qu.:  34.0
 Mode  :character   Median :   7.00   Median :  55.0
                    Mean   :  45.51   Mean   : 154.8
                    3rd Qu.:  17.00   3rd Qu.: 110.0
                    Max.   :5559.00   Max.   :8226.0


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

result <- CAGE_normalization(yeast,human)
write.table(result,"normalized_human.bed")