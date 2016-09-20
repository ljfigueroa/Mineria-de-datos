library(parallel)
library(class)
library(rpart)
source("ej1.r")

knnGetAcurracy <- function(x, dataset, args, test) {

	if(dataset=="ej1a") {
		b <- args[3]
		c <- args[4]
		ntrain <- args[1]
		train <- ej1a(ntrain,d,c)
		#cl = factor(c(rep(1,ntrain/2),rep(0,ntrain/2)))
		class_index = d+1 # VER
		cl = train[,class_index]
	}

	if(dataset=="ej1b"){
		ntrain <- args[1]
		train <- ej1b(ntrain)
		#cl = factor(c(rep(0,ntrain/2),rep(1,ntrain/2)))
		cl = train[,3]
		class_index = 3 # número fijo
	}

	pred <- knn(train, test, cl,k=x)
	return(sum(test[,class_index] == pred))
}

getK <- function(dataset, kmax, args, test){

	acurracy <- sapply(1:kmax, function(x) {knnGetAcurracy(x,dataset,args,test)})
	#acurracy <- acurracy / ntest # Porcentaje de aciertos
	best_k <- which.max(acurracy)
	return(c(best_k,acurracy[best_k]))
}

knnGetMedian <- function(dataset, args, iter, max_k) {
	# Calculate the number of cores
	no_cores <- detectCores() - 1

	# Initiate cluster
	cluster <- makeCluster(no_cores,type="FORK")

	if(dataset=="ej1a") {
		d <- args[3]
		c <- args[4]
		ntest <- args[2]
		test  <- ej1a(ntest,d,c)
	}
	if(dataset=="ej1b") {
		ntest <- args[2]
		test  <- ej1b(ntest)
	}

	v <- parSapply(cluster, 1:iter, function(z){getK(dataset, max_k, args, test)})
	stopCluster(cluster)

	ac <- matrix(v ,iter, 2, byrow=T)
	print(ac)
	mean_ac <- median(ac[,2])
	mean_ac_index <- which(ac[,2] == mean_ac)
	print(mean_ac_index)
	return(ac[mean_ac_index[1],])
}

d <- 2
c <- 0.75
ntrain <- 200
ntest  <- 2000
args <- c(ntrain,ntest,d,c)
# Cantidad de interaciones impar
best <- knnGetMedian("ej1a", args, 21, 50)
cat(paste0("Datos ej1a - knn: El mejor k es ", best[1]," y su precisión es ",best[2], "\n"))
#best <- knnGetMedian("dt", "ej1a", args, 21, 50)
#cat(paste0("Datos ej1a - DT: su precisión es ",best[2], "\n"))
args <- c(ntrain,ntest)
best <- knnGetMedian("ej1b", args, 21, 50)
cat(paste0("Datos ej1b - knn: El mejor k es ", best[1]," y su precisión es ",best[2], "\n"))
#best <- knnGetMedian("dt", "ej1b", args, 21, 50)
#cat(paste0("Datos ej1b - DT: su precisión es ",best[2], "\n"))



#	if(mtd == "dt") {
#		model <- rpart(class ~., train, method="class")
#		pred <- predict(model, test, type="class")
#	}



#acurracy <- rep(c(0,0),ksize)
#dim(acurracy) <- c(ksize,2)
## Busco el k
#for (k in 1:ksize) {
#	mod.knn <- knn(eja_train, eja_test, cl, k)
#	acurracy[k,1] <-sum(mod.knn == eja_test[,3]) / ntest
#	acurracy[k,2] <-	k
#	#print(acurracy[k])
#}
#
#m <- print(max(acurracy[,1]))
#print(acurracy[acurracy[,1]==m,2])
#dim(acurracy) <- c(ksize,1) # Necesario para apply
#acurracy <- apply(acurracy, 1, function(x){sum(eja_test[,3] == knn(eja_train, eja_test, cl,x))}) / ntest
# Cantidad de prediciones correctas
#acurracy <- apply(acurracy, 1, function(x) {knnGetAcurracy(x,eja_train,eja_test,cl,3)})
