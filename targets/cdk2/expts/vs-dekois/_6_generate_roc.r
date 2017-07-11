#load ROCR
library(ROCR);
 
#load ligands and decoys
lig <- unique(read.table("ligands.txt")[,1]);
#dec <- unique(read.table("decoys.txt")[,1]);
 
#load data file from docking
uniqRes <- read.table("rdock_dataforR_uq.txt",header=T);
 
#change colnames
colnames(uniqRes)[1]="LigandName";
 
#add column with ligand/decoy info
uniqRes$IsActive <- as.numeric(uniqRes$LigandName %in% lig)

#define ROC parameters 
#here INTER is selected to compare between ligands using rDock SCORE.INTER
#this could be changed for also running with other programs
predINTERuq <- prediction(uniqRes$INTER*-1, uniqRes$IsActive)
perfINTERuq <- performance(predINTERuq, 'tpr','fpr')

#plot in jpg format with a grey line with theoretical random results
jpeg("cdk2_rdock_ROC.jpg")
plot(perfINTERuq,main="hivpr - ROC Curves",col="blue")
abline(0,1,col="grey")
dev.off()

