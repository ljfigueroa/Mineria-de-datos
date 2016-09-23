library(parallel)
library(class)
library(rpart)
source("ej1.r")

knnGetAcurracy <- function(x, train,test,class_index) {

	pred <- knn(train[,-class_index], test[,-class_index], cl=train[,class_index], k=x)
	return(sum(test[,class_index] == pred))
}

dtAcurracy <- function(train,test,class_index) {

	model <- rpart(class ~., train, method="class")
	pred <- predict(model, test[,-class_index], type="class")
	return(sum(test[,class_index] == pred))

}
dtGetAcurracy <- function(dataset, args, test) {

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

	#model <- rpart(class ~., train, method="class")
	#pred <- predict(model, test[,-class_index], type="class")


	#return(sum(test[,class_index] == pred))
	return(dtAcurracy(train,test,class_index))
}


getK <- function(dataset, kmax, args, test) {

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

	acurracy <- sapply(1:kmax, function(x) {knnGetAcurracy(x,train,test,class_index)})
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
	#print(ac)
	mean_ac <- median(ac[,2])
	mean_ac_index <- which(ac[,2] == mean_ac)
	#print(mean_ac_index)
	return(ac[mean_ac_index[1],])
}

dtGetMedian <- function(dataset, args, iter) {
	# Calculate the number of cores
	no_cores <- detectCores() - 1

	# Initiate cluster
	cluster <- makeCluster(no_cores,type="FORK")

	if(dataset=="ej1a") {
		ntest <- args[2]
		d <- args[3]
		c <- args[4]
		test <- ej1a(ntest,d,c)
	}
	if(dataset=="ej1b") {
		ntest <- args[2]
		test  <- ej1b(ntest)
	}

	v <- parSapply(cluster, 1:iter, function(z){dtGetAcurracy(dataset, args, test)})
	stopCluster(cluster)

	ac <- matrix(v ,iter, 2, byrow=T)
	#print(ac)
	mean_ac <- median(ac[,2])
	mean_ac_index <- which(ac[,2] == mean_ac)
	#print(mean_ac_index)
	return(ac[mean_ac_index[1],])
}

knnCrossValidation <- function(train,n_set,kmax) {
	ntrain <- nrow(train)
	d <- dim(train)[2]
	N <- ntrain / n_set
	class_index <- d
	#set_list <- split(train, sample(1:n_set, ntrain, replace=T)) #Genero n_set subdatasets
	indexes <- sample(cut(seq(1,ntrain),breaks=n_set,labels=FALSE))
	best <- rep(0,n_set*2)
	dim(best) <- c(n_set,2)
	for(i in 1:n_set) {
		#test <- data.frame(set_list[i],  row.names = NULL, check.names = F)
		#train <- Reduce(function(...) merge(..., all=T),set_list[-i])
		index <- which(indexes==i,arr.ind=TRUE)
		totest <- train[index,]
		totrain <- train[-index,]
		acurracy <- sapply(1:kmax, function(x) {knnGetAcurracy(x,totrain,totest,class_index)})
		#acurracy <- acurracy / ntest # Porcentaje de aciertos
		best_k <- which.max(acurracy)
		best[i,1] <- best_k
		best[i,2] <- acurracy[best_k]
	}
	#print(best)
	index <-which.max(best[,2])
	return(best[index,])
	#best_k <- best[index,1]
	#ac <- best[index,2]
}

dtCrossValidation <- function(train,n_set) {
	ntrain <- nrow(train)
	d <- dim(train)[2]
	N <- ntrain / n_set
	class_index <- d
	#set_list <- split(train, sample(1:n_set, ntrain, replace=T)) #Genero n_set subdatasets
	indexes <- sample(cut(seq(1,ntrain),breaks=n_set,labels=FALSE))
	best <- rep(0,n_set*2)
	dim(best) <- c(n_set,2)
	for(i in 1:n_set) {
		#test <- data.frame(set_list[i],  row.names = NULL, check.names = F)
		#train <- Reduce(function(...) merge(..., all=T),set_list[-i])
		index <- which(indexes==i,arr.ind=TRUE)
		totest <- train[index,]
		totrain <- train[-index,]
		acurracy <- sapply(1:1, function(x) {dtAcurracy(totrain,totest,class_index)})
		#acurracy <- acurracy / ntest # Porcentaje de aciertos
		best_k <- which.max(acurracy)
		best[i,1] <- best_k
		best[i,2] <- acurracy[best_k]
	}
	#print(best)
	index <-which.max(best[,2])
	return(best[index,])
	#best_k <- best[index,1]
	#ac <- best[index,2]
}

d <- 2
c <- 0.75
k_max <- 20			#Cantidad y número máximo de k a probar
ntrain <- 200
ntest  <- 2000
args <- c(ntrain,ntest,d,c)
# Cantidad de interaciones impar
best <- knnGetMedian("ej1a", args, 21, k_max)
cat(paste0("Datos ej1a - knn: El mejor k es ", best[1]," y su precisión es ",best[2],"/",ntest," (",best[2]/ntest, ")\n"))
#args <- c(ntrain,ntest)
best <- knnGetMedian("ej1b", args, 21, k_max)
cat(paste0("Datos ej1b - knn: El mejor k es ", best[1]," y su precisión es ",best[2], "/",ntest," (",best[2]/ntest, ")\n"))
best <- dtGetMedian("ej1a", args, 21)
cat(paste0("Datos ej1a - DT: su precisión es ",best[2], "/",ntest," (",best[2]/ntest, ")\n"))
best <- dtGetMedian("ej1b", args, 21)
cat(paste0("Datos ej1b - DT: su precisión es ",best[2], "/",ntest," (",best[2]/ntest, ")\n"))

# Cross validation
nset <- 5			#Número de subconjuntos
N <- ntrain / nset
# Dataset ej1a
train <- ej1a(ntrain,d,c)
best <- knnCrossValidation(train,nset,k_max)
cat(paste0("Datos ej1a - knn - cross-validation: El mejor k es ", best[1], " y su precisión es ",best[2], "/",N," (",best[2]/N, ")\n"))
best <- dtCrossValidation(train,nset)
cat(paste0("Datos ej1a - dt - cross-validation: su precisión es ",best[2], "/",N," (",best[2]/N, ")\n"))

# Dataset ej1b
train <- ej1b(ntrain)
best <- knnCrossValidation(train,nset,k_max)
cat(paste0("Datos ej1b - knn - cross-validation: El mejor k es ", best[1], " y su precisión es ",best[2], "/",N," (",best[2]/N, ")\n"))
best <- dtCrossValidation(train,nset)
cat(paste0("Datos ej1b - dt - cross-validation: su precisión es ",best[2], "/",N," (",best[2]/N, ")\n"))
