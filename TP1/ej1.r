ej1a <- function(n,d,c) {
	sd <- c*sqrt(d) # Desviación estandar

	# Calculos los datos de cada clase
	class1_mean <-  1
	class0_mean <- -1
	class1_data <- replicate(d,rnorm(n/2, class1_mean, sd))
	class0_data <- replicate(d,rnorm(n/2, class0_mean, sd))

	# Asigno la clase correspondiente a cada dato
	ones  <- rep(0,n/2)+1
	zeros <- rep(0,n/2)
	class1 <- cbind(class1_data, ones)
	class0 <- cbind(class0_data, zeros)
	dataset <- rbind(class1,class0)

	# Renombro la útima columna
	colnames(dataset)[d+1] <- "class"
	return(data.frame(dataset))
}

# Escribo la tabla csv correspondiente al dataset
#write.table(dataset, file="dataset1.csv", col.names=FALSE, row.names=F, sep=",")

ro1 <- function(angulo) {
	return(angulo / (4 * pi))
}

ro2 <- function(angulo) {
	return((angulo + pi) / (4 * pi))
}

# Esta función devuelve un punto de la clase pasada como argumento, el mismo es
# tomado de forma aleatorea
getPoint <- function(class) {
	while(TRUE) {
		r <- 2
		while(r > 1) {
			x <- runif(1,-1,1)
			y <- runif(1,-1,1)
			r <- sqrt(x**2 + y**2)
			theta <- atan2(y,x)
		}
		if (class == 0) {
			for(i in 0:2) {
				phi <- theta + pi*(2*i)
				r1 <- ro1(phi)
				r2 <- ro2(phi)
				if(r1 < r & r < r2) {
					return(c(x,y,class))
				}
			}
		} else {
			for(i in 0:2) {
				phi1 <- theta + pi*(2*i)
				phi2 <- phi1 + pi*2
				r1 <- ro1(phi2)
				r2 <- ro2(phi1)
				if(r1 > r & r > r2) {
					return(c(x,y,class))
				} else {
					r1 <- ro1(theta)
					if (r1 > r)
						return(c(x,y,class))
				}
			}

		}
	}
}


ej1b <- function(n) {
	# Calculos los datos de cada clase
	class0_data <- t(replicate(n/2,getPoint(0)))
	class1_data <- t(replicate(n/2,getPoint(1)))
	dataset <- rbind(class0_data,class1_data)

	# Renombro la última columna
	colnames(dataset)[3] <- "class"
	return(data.frame(dataset))
}

ej1_test <- function() {
	dfa <- ej1a(3000,2,0.75)
	dfb <- ej1b(3000)
	pdf("Ej1 - a Ejemplo")
	plot(dfa[,1], dfa[,2], col=dfa[,3]+2, main="n = 3000, d = 2 y c = 0.75", xlab="input 1", ylab="input 2")
	dev.off()
	pdf("Ej1 - b Ejemplo")
	plot(dfb[,1],dfb[,2],col=dfb[,3]+2, main="n=3000", xlab="input 1", ylab="input 2")
	dev.off()
}
