source("codigo_practico_2.R")

#datos A
class<-dim(datosA)[2]

x <- datosA[,-class]
y <- datosA[,class]


backward_rf  <- backward.ranking(x,y,method="rf.est",tot.trees=100,equalize.classes=F)
backward_svm <- backward.ranking(x,y,method="svm.est")
backward_lda <- backward.ranking(x,y,method="lda.est")

kruskal <- kruskal.filter(x,y)

rfe_svm <- rfe.ranking(x,y,"imp.linsvm")
rfe_rf  <- rfe.ranking(x,y,"imp.rf")

forward_rf  <- forward.ranking(x,y,"rf.est",tot.trees=100,equalize.classes=F)$ordered.features.list
forward_svm <- forward.ranking(x,y,"svm.est")$ordered.features.list
forward_lda <- forward.ranking(x,y,"lda.est")$ordered.features.list

cat("Dataset DatosA\n")
cat("Backward - RF: ",backward_rf,"\n")
cat("Backward - SVM: ",backward_svm,"\n")
cat("Backward - LDA: ",backward_lda,"\n")
cat("Kruskal: ",kruskal,"\n")
cat("RFE - SVM: ",rfe_svm,"\n")
cat("RFE - RF: ",rfe_rf,"\n")
cat("Forward - RF: ",forward_rf,"\n")
cat("Forward - SVM: ",forward_svm,"\n")
cat("Forward - LDA: ",forward_lda,"\n")

#datos B
class<-dim(datosB)[2]

x <- datosB[,-class]
y <- datosB[,class]

backward_rf  <- backward.ranking(x,y,method="rf.est",tot.trees=100,equalize.classes=F)
backward_svm <- backward.ranking(x,y,method="svm.est")
backward_lda <- backward.ranking(x,y,method="lda.est")

kruskal <- kruskal.filter(x,y)

rfe_svm <- rfe.ranking(x,y,"imp.linsvm")
rfe_rf  <- rfe.ranking(x,y,"imp.rf")

forward_rf <- forward.ranking(x,y,"rf.est",tot.trees=100,equalize.classes=F)$ordered.features.list
forward_svm <- forward.ranking(x,y,"svm.est")$ordered.features.list
forward_lda <- forward.ranking(x,y,"lda.est")$ordered.features.list


cat("Dataset DatosB\n")
cat("Backward - RF: ",backward_rf,"\n")
cat("Backward - SVM: ",backward_svm,"\n")
cat("Backward - LDA: ",backward_lda,"\n")
cat("Kruskal: ",kruskal,"\n")
cat("RFE - SVM: ",rfe_svm,"\n")
cat("RFE - RF: ",rfe_rf,"\n")
cat("Forward - RF: ",forward_rf,"\n")
cat("Forward - SVM: ",forward_svm,"\n")
cat("Forward - LDA: ",forward_lda,"\n")
