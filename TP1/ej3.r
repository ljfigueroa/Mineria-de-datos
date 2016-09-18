library(parallel)
library(class)
library(rpart)
source("ej1.r")

getAcurracy <- function(x, mtd, train, test, cl, class_index) {
	if(mtd == "knn") {
		pred <- knn(train, test, cl,k=x)
	}
	if(mtd == "dt") {
		model <- rpart(class ~., train, method="class")
		pred <- predict(model, test, type="class")
	}
	return(sum(test[,class_index] == pred))
}

getK <- function(dataset, method, kmax, ntrain, ntest){
	if(dataset=="ej1a") {
		train <- ej1a(ntrain,2,0.75)
		test  <- ej1a(ntest,2,0.75)
		#cl = factor(c(rep(1,ntrain/2),rep(0,ntrain/2)))
		cl = train[,3]
		class_index = 3 # VER
	}

	if(dataset=="ej1b") {
		train <- ej1b(ntrain)
		test  <- ej1b(ntest)
		#cl = factor(c(rep(0,ntrain/2),rep(1,ntrain/2)))
		cl = train[,3]
		class_index = 3 # número fijo
	}

	acurracy <- sapply(1:kmax, function(x) {getAcurracy(x,method,train,test,cl,class_index)})
	#acurracy <- acurracy / ntest # Porcentaje de aciertos
	best_k <- which.max(acurracy)
	return(c(best_k,acurracy[best_k]))
}

getBestk <- function(dataset, method, ntrain, ntest, iter, max_k) {
	# Calculate the number of cores
	no_cores <- detectCores() - 1

	# Initiate cluster
	cluster <- makeCluster(no_cores,type="FORK")

	v <- parSapply(cluster, 1:iter, function(z){getK(dataset, method, max_k, ntrain, ntest)})

	stopCluster(cluster)

	ac <- matrix(v ,iter, 2, byrow=T)
	print(ac)
	mean_ac <- median(ac[,2])
	mean_ac_index <- which(ac[,2] == mean_ac)
	print(mean_ac_index)
	return(ac[mean_ac_index[1],])
}

ntrain <- 200
ntest  <- 2000

# Cantidad de interaciones impar
best <- getBestk("ej1a", "knn", ntrain, ntest, 21, 50)
cat(paste0("Datos ej1a - knn: El mejor k es ", best[1]," y su precisión es ",best[2], "\n"))
best <- getBestk("ej1b", "knn", ntrain, ntest, 21, 50)
cat(paste0("Datos ej1b - knn: El mejor k es ", best[1]," y su precisión es ",best[2], "\n"))
best <- getBestk("ej1a", "dt", ntrain, ntest, 21, 50)
cat(paste0("Datos ej1a - DT: El mejor k es ", best[1]," y su precisión es ",best[2], "\n"))
best <- getBestk("ej1b", "dt", ntrain, ntest, 21, 50)
cat(paste0("Datos ej1b - DT: El mejor k es ", best[1]," y su precisión es ",best[2], "\n"))






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
#acurracy <- apply(acurracy, 1, function(x) {getAcurracy(x,eja_train,eja_test,cl,3)})
