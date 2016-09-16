ej1 <- function(n,d,c) {
	sd <- c*sqrt(d)

	# Calculos los datos de cada clase
	class1_mean = 1
	class2_mean = -1
	class1_data = matrix(n*d, n/2, d)
	class2_data = matrix(n*d, n/2, d)

	for (i in 1:d) {
		class1_data[,i] = rnorm(n/2, class1_mean, sd)
		class2_data[,i] = rnorm(n/2, class2_mean, sd)
	}

	ones  <- rep(0,1500)+1
	zeros <- rep(0,1500)
	class1 <- cbind(class1_data, ones)
	class2 <- cbind(class2_data, zeros)
	dataset <- rbind(class1,class2)

	colnames(dataset)[d+1] <- "class"
	return(data.frame(dataset))
}
# Genero el .pdf
pdf("GraficoTest.pdf")
plot(dataset[,1],dataset[,2],col=dataset[,3]+2)
dev.off()

# Escribo la tabla csv correspondiente al dataset
write.table(dataset, file="dataset1.csv", col.names=FALSE, row.names=F, sep=",")
