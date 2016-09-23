library(parallel)
library(class)
library(rpart)
source("ej1.r")

# Calcula la precisión de knn sobre los siguientes datos:
#  x		vecinos a visitar
#  train	datos de entramiento
#  test		datos para testear
#  class_index	índice de la columna de las clases
knnGetAcurracy <- function(x, train,test,class_index) {

	pred <- knn(train[,-class_index], test[,-class_index], cl=train[,class_index], k=x)
	return(sum(test[,class_index] == pred))
}

# Calcula la precisión de rpart/arboles de deicisión sobre los siguientes datos:
#  train	datos de entramiento
#  test		datos para testear
#  class_index	índice de la columna de las clases
dtAcurracy <- function(train,test,class_index) {

	model <- rpart(class ~., train, method="class")
	pred <- predict(model, test[,-class_index], type="class")
	return(sum(test[,class_index] == pred))

}

# Genera los datos de entrenamiento para luego ejecutar dtAcurracy sobre
# los mismos.
#  dataset	tipo de dataset a generar
#  args		argumentos necesarios para la creación del dataset
#  test		datos para testear
dtGetAcurracy <- function(dataset, args, test) {

	if(dataset=="ej1a") {
		b <- args[3]
		c <- args[4]
		ntrain <- args[1]
		train <- ej1a(ntrain,d,c)
		class_index = d+1
		cl = train[,class_index]
	}

	if(dataset=="ej1b"){
		ntrain <- args[1]
		train <- ej1b(ntrain)
		cl = train[,3]
		class_index = 3 # número fijo
	}

	return(dtAcurracy(train,test,class_index))
}


# Devuelve el número de vencinos que maximiza la precisión del algoritmo knn
#  dataset	tipo de dataset a generar para el entremiento
#  args		argumentos necesarios para la creación del dataset
#  test		datos para testear
#  kmax		máxmimo número de vecinos a visitar
getK <- function(dataset, kmax, args, test) {

	if(dataset=="ej1a") {
		b <- args[3]
		c <- args[4]
		ntrain <- args[1]
		train <- ej1a(ntrain,d,c)
		class_index = d+1
		cl = train[,class_index]
	}

	if(dataset=="ej1b"){
		ntrain <- args[1]
		train <- ej1b(ntrain)
		cl = train[,3]
		class_index = 3 # número fijo
	}

	acurracy <- sapply(1:kmax, function(x) {knnGetAcurracy(x,train,test,class_index)})
	best_k <- which.max(acurracy)
	return(c(best_k,acurracy[best_k]))
}

# Devuelve la mediana de las precisiónes obtenidas tras optimizar el número
# de vecinos. La precisión obtenida es la más representativa de las ejecuciones
# de knn sobre del dataset dado.
#  dataset	tipo de dataset a generar para el test
#  args		argumentos necesarios para la creación del dataset
#  iter		número de iteraciones a realizar sobre getK
#  max_k	máxmimo número de vecinos a visitar
knnGetMedian <- function(dataset, args, iter, max_k) {
	# Como esta ejecución es muy costosa se la va paralelizar
	# Calcular la cantidad de nucleos a utilizar
	no_cores <- detectCores() - 1

	# Inicializar el cluster de trabajo
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

	# Getk se ejecuta en paralelo
	v <- parSapply(cluster, 1:iter, function(z){getK(dataset, max_k, args, test)})
	# Libero los recursos
	stopCluster(cluster)

	ac <- matrix(v ,iter, 2, byrow=T) # uso una matriz para simplificar el calculo
					  # de la mediana
	# Calculo la precisión media
	mean_ac <- median(ac[,2])
	mean_ac_index <- which(ac[,2] == mean_ac)
	return(ac[mean_ac_index[1],])
}

# Devuelve la mediana de las precisiónes obtenidas tras la ejecución de
# iter veces dtGetAcurracy. La precisión obtenida es la más representativa
# de las ejecuciones de arboles de decisión sobre del dataset dado.
#  dataset	tipo de dataset a generar para el test
#  args		argumentos necesarios para la creación del dataset
#  iter		número de iteraciones a realizar sobre getK
dtGetMedian <- function(dataset, args, iter) {
	# Como esta ejecución es muy costosa se la va paralelizar
	# Calcular la cantidad de nucleos a utilizar
	no_cores <- detectCores() - 1

	# Inicializar el cluster de trabajo
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

	# dtGetAcurracy se ejecuta en paralelo
	v <- parSapply(cluster, 1:iter, function(z){dtGetAcurracy(dataset, args, test)})
	# Libero los recursos
	stopCluster(cluster)

	ac <- matrix(v ,iter, 2, byrow=T) # uso una matriz para simplificar el calculo
					  # de la mediana

	# Calculo la precisión media
	mean_ac <- median(ac[,2])
	mean_ac_index <- which(ac[,2] == mean_ac)
	return(ac[mean_ac_index[1],])
}

# Devuelve el k y la precisión tras ejecutar cross-validación con n_set particiones.
knnCrossValidation <- function(train,n_set,kmax) {
	ntrain <- nrow(train)		# Cantidad de datos disponibles para particionar
	N <- ntrain / n_set		# Tamaño de cada sub-dataset
	class_index <- dim(train)[2]    # Pocisión de la columna de las clases
	# Indices tomados de forma aleatorea
	indexes <- sample(cut(seq(1,ntrain),breaks=n_set,labels=FALSE))
	# best es donde se guardan los resultados de las ejecuciones del for
	best <- rep(0,n_set*2)
	dim(best) <- c(n_set,2)
	for(i in 1:n_set) {
		index <- which(indexes==i,arr.ind=TRUE)
		totest <- train[index,]
		totrain <- train[-index,]
		acurracy <- sapply(1:kmax, function(x) {knnGetAcurracy(x,totrain,totest,class_index)})
		best_k <- which.max(acurracy)
		best[i,1] <- best_k
		best[i,2] <- acurracy[best_k]
	}
	mean_ac <- median(best[,2])
	mean_ac_index <- which(best[,2] == mean_ac)
	return(best[mean_ac_index[1],])
}

# Devuelve la precisión tras ejecutar cross-validación con n_set particiones.
dtCrossValidation <- function(train,n_set) {
	ntrain <- nrow(train)		# Cantidad de datos disponibles para pa
	N <- ntrain / n_set		# Tamaño de cada sub-dataset
	class_index <- dim(train)[2]	# Pocisión de la columna de las clases
	indexes <- sample(cut(seq(1,ntrain),breaks=n_set,labels=FALSE))
	best <- rep(0,n_set*2)
	dim(best) <- c(n_set,2)
	for(i in 1:n_set) {
		index <- which(indexes==i,arr.ind=TRUE)
		totest <- train[index,]
		totrain <- train[-index,]
		acurracy <- sapply(1:1, function(x) {dtAcurracy(totrain,totest,class_index)})
		best_k <- which.max(acurracy)
		best[i,1] <- best_k
		best[i,2] <- acurracy[best_k]
	}
	mean_ac <- median(best[,2])
	mean_ac_index <- which(best[,2] == mean_ac)
	return(best[mean_ac_index[1],])
}

d <- 2				# Número de dimenciones del dataset
c <- 0.75
k_max <- 20			# Cantidad y número máximo de vecinos a visitar
ntrain <- 200			# Cantidad de datos de entrenamiento
ntest  <- 2000			# Cantidad de datos de test
args <- c(ntrain,ntest,d,c)	# Argumentos para generar los datasets
nset <- 5			# Número de subconjuntos a dividir el train
				# para cross-validation
N <- ntrain / nset		# Tamaño resultante de los conjuntos de
				# cross-validation
iteraciones <- 21		# Cantidad de interaciones necesarias para
				# calcular la mediana. Debe ser un número impar


####### Script

#### Dataset generado por ej1a

best <- knnGetMedian("ej1a", args, iteraciones, k_max)
cat(paste0("Datos ej1a - knn: El mejor k es ", best[1]," y su precisión es ",best[2],"/",ntest," (",best[2]/ntest, ")\n"))

train <- ej1a(ntrain,d,c)
best <- knnCrossValidation(train,nset,k_max)
cat(paste0("Datos ej1a - knn - cross-validation: El mejor k es ", best[1], " y su precisión es ",best[2], "/",N," (",best[2]/N, ")\n"))

best <- dtGetMedian("ej1a", args, iteraciones)
cat(paste0("Datos ej1a - DT: su precisión es ",best[2], "/",ntest," (",best[2]/ntest, ")\n"))

best <- dtCrossValidation(train,nset)
cat(paste0("Datos ej1a - DT - cross-validation: su precisión es ",best[2], "/",N," (",best[2]/N, ")\n"))


#### Dataset generado por ej1b
best <- knnGetMedian("ej1b", args, iteraciones, k_max)
cat(paste0("Datos ej1b - knn: El mejor k es ", best[1]," y su precisión es ",best[2], "/",ntest," (",best[2]/ntest, ")\n"))

train <- ej1b(ntrain)
best <- knnCrossValidation(train,nset,k_max)
cat(paste0("Datos ej1b - knn - cross-validation: El mejor k es ", best[1], " y su precisión es ",best[2], "/",N," (",best[2]/N, ")\n"))

best <- dtGetMedian("ej1b", args, iteraciones)
cat(paste0("Datos ej1b - DT: su precisión es ",best[2], "/",ntest," (",best[2]/ntest, ")\n"))

best <- dtCrossValidation(train,nset)
cat(paste0("Datos ej1b - DT - cross-validation: su precisión es ",best[2], "/",N," (",best[2]/N, ")\n"))
