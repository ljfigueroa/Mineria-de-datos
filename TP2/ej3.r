source("codigo_practico_2.R")
source("../TP1/ej1.r")
library(parallel)

mfor <- function(asd)
{
	cat("Entradno a mfor\n")
	ranking<-rep(0,9)
	# Genero el dataset
	n <- 100
	d <- 10
	c = 2/sqrt(d)
	dataSet <- ej1a(n,d,c)
	class <- dim(dataSet)[2]
	ruido <- crea.ruido.unif(n=50,d=90)[,-91]
	dataSet <- cbind(dataSet[,-class],ruido,dataSet[,class])
	class <- dim(dataSet)[2]
	x <- dataSet[,-class]
	y <- factor(dataSet[,class])

	# Aplico todos los métodos
	backward_rf  <- backward.ranking(x,y,method="rf.est",tot.trees=100,equalize.classes=F)[1:10]
	ranking[1]   <- sum(backward_rf<11)
	backward_svm <- backward.ranking(x,y,method="svm.est")[1:10]
	ranking[2]   <- sum(backward_svm<11)
	backward_lda <- backward.ranking(x,y,method="lda.est")[1:10]
	ranking[3]   <- sum(backward_lda<11)

	kruscal    <- kruskal.filter(x,y)[1:10]
	ranking[4] <- sum(kruscal<11)
	
	rfe_svm    <- rfe.ranking(x,y,"imp.linsvm")[1:10]
	ranking[5] <- sum(rfe_svm<11)
	rfe_rf     <- rfe.ranking(x,y,"imp.rf")[1:10]
	ranking[6] <- sum(rfe_rf<11)

	forward_rf  <- forward.ranking(x,y,"rf.est",tot.trees=100,equalize.classes=F)$ordered.features.list[1:10]
	ranking[7]  <- sum(forward_rf<11)
	forward_svm <- forward.ranking(x,y,"svm.est")$ordered.features.list[1:10]
	ranking[8]  <- sum(forward_svm<11)
	forward_lda <- forward.ranking(x,y,"lda.est")$ordered.features.list[1:10]
	ranking[9]  <- sum(forward_lda<11)
	
	cat("Saliendo de mfor\n")
	return(ranking)
}

# Como esta ejecución es muy costosa se la va paralelizar
# Calcular la cantidad de nucleos a utilizar
no_cores <- detectCores() -1

# Inicializar el cluster de trabajo
cluster <- makeCluster(no_cores,type="FORK")
kmax <- 30
acurracy <- parSapply(cluster,1:kmax, function(x) {mfor(x)})
stopCluster(cluster)

d <- 10
ranking<-rep(0,d-1)

for(i in 1:9){
	ranking[i] <- sum(acurracy[i,]) / (d*kmax)
}

cat("Promedio de aciertos: ",ranking,"\n")
