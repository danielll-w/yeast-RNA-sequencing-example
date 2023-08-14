library("DESeq2")
library("pheatmap")
library("ggplot2")
setwd("")    # change this line as necessary

# load the data
yeast_count_table <- read.table("yeast_count_table.txt", header=TRUE, row.names=1)

# subset if desired
# yeast_count_table <- yeast_count_table[, c('SNF2_01', 'SNF2_22', 'SNF2_26', 
#                                            'WT_01', 'WT_31', 'WT_33')]

# use column names of the data table to 
# make a table of sample name and condition for DESeq2
samplename <- colnames(yeast_count_table)
samplematrix <- matrix(unlist(strsplit(samplename,'_')), ncol = 2, byrow=TRUE)
sample_condition <- samplematrix[,1]
exp_matrix <- data.frame("sample"=samplename,"condition"=sample_condition)

# convert condition to factor
exp_matrix$condition <- as.factor(exp_matrix$condition)

# set WT as the default condition 
exp_matrix$condition <- relevel(exp_matrix$condition, "WT")

# make DESeq data set (DDS), call DESeq, and create normed counts
DDS <- DESeqDataSetFromMatrix(countData=yeast_count_table, colData=exp_matrix,
                              design=~condition)
DDS <- DESeq(DDS)
DDS_normed <- counts(DDS, normalized=TRUE)

# get differential expression results
DDS_results <- results(DDS, lfcThreshold=0.5, alpha=0.05, 
                       altHypothesis="greaterAbs", contrast=c("condition","SNF2","WT"))

# merged results with normalized counts, order by adjusted p-value, and threshold 
DDS_merged <- merge(DDS_normed, DDS_results, by="row.names", sort=FALSE)
rownames(DDS_merged) <- DDS_merged$Row.names
DDS_merged$Row.names <- NULL
DDS_combined <- DDS_merged[order(DDS_merged$padj), ]
DDS_combined_thresholded <- subset(DDS_combined, DDS_combined$padj <= 0.05) 
write.csv(as.data.frame(DDS_combined_thresholded),
          file="yeast_combined_thresholded.csv")

# perform variance stabilizing transformation
vsd <- vst(DDS, blind=FALSE)

# select top number of genes with greatest mean expression
# and produce heat map
select <- order(rowVars(counts(DDS,normalized=TRUE)),
                decreasing=TRUE)[1:30]
df <- as.data.frame(colData(DDS)[,c("condition","sample")])
pheatmap(assay(vsd)[select,], cluster_rows=TRUE, show_rownames=TRUE,
         cluster_cols=TRUE, annotation_col=df)

# produce PCA plot using the 500 genes with greatest variance
pcaData <- plotPCA(vsd, intgroup=c("condition", "sample"), returnData=TRUE, ntop=500)
percentVar <- round(100 * attr(pcaData, "percentVar"))
ggplot(pcaData, aes(PC1, PC2, color = sample, shape = condition)) +
  coord_fixed(ratio = sqrt(percentVar[2] / percentVar[1])) +
  geom_point(size=3) +
  xlab(paste0("PC1: ",percentVar[1],"% variance")) +
  ylab(paste0("PC2: ",percentVar[2],"% variance")) 
