#load ROCR
library(ROCR);
 
#load ligands and decoys
lig <- unique(read.table("actives.txt")[,1]);
 
#load data file from docking
uniqRes <- read.table("dataforR_uq.txt",header=T);
 
#change colnames
colnames(uniqRes)[1]="LigandName";
colnames(uniqRes)[2]="Score";
 
#add column with ligand/decoy info
uniqRes$IsActive <- as.numeric(uniqRes$LigandName %in% lig)

#define ROC parameters 
#this could be changed for also running with other programs
predScoreuq <- prediction(uniqRes$Score*-1, uniqRes$IsActive)
perfScoreuq <- performance(predScoreuq, 'tpr','fpr')

#plot in jpg format with a grey line with theoretical random results
jpeg("ROC.jpg")
plot(perfScoreuq,main="DHFR - ROC curve",col="blue")
abline(0,1,col="grey")
dev.off()

