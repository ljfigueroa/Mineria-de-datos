library(MASS)
source("ej2.r")
load("lampone.Rdata")

getImage <- function (ds, column, name) {
  jpeg(paste0(name,"_",column,".jpeg"))
  hist(ds[column,])
  dev.off()
}

### Gausianas ###

# Copy-paste slides
gauss_size<-100
gap=2

x<-rnorm(gauss_size,mean=-gap)
y<-rnorm(gauss_size,mean=-gap)
gausianas<-cbind(x,y,rep(1,gauss_size))

x<-rnorm(gauss_size,mean=2*gap)
y<-rnorm(gauss_size,mean=0)
gausianas<-rbind(gausianas,cbind(x,y,rep(2,gauss_size)))

x<-rnorm(gauss_size,mean=0.7*gap,sd=0.5)
y<-rnorm(gauss_size,mean=2.5*gap,sd=0.5)
gausianas<-rbind(gausianas,cbind(x,y,rep(3,gauss_size)))

x<-rnorm(gauss_size,mean=-gap,sd=0.5)
y<-rnorm(gauss_size,mean=gap,sd=0.5)
gausianas<-rbind(gausianas,cbind(x,y,rep(4,gauss_size)))


est_gaus <- est(gausianas[,-3],7,100)
for (i in 2:7){
  getImage(est_gaus,i,"GAUSS")
}

# jpeg("Gaus2.jpeg")
# hist(est_gaus[2,])
# dev.off()
#
# jpeg("Gaus3.jpeg")
# hist(est_gaus[3,])
# dev.off()
#
# jpeg("Gaus4.jpeg")
# hist(est_gaus[4,])
# dev.off()
#
# jpeg("Gaus5.jpeg")
# hist(est_gaus[5,])
# dev.off()
#
# jpeg("Gaus6.jpeg")
# hist(est_gaus[6,])
# dev.off()
#
# jpeg("Gaus7.jpeg")
# hist(est_gaus[7,])
# dev.off()

### Iris ###
data(iris)
est_iris <- est(iris[,-5],7,100)
for (i in 2:7){
  getImage(est_iris,i,"IRIS")
}

#
# jpeg("Iris2.jpeg")
# hist(est_iris[2,])
# dev.off()
#
# jpeg("Iris3.jpeg")
# hist(est_iris[3,])
# dev.off()
#
# jpeg("Iris4.jpeg")
# hist(est_iris[4,])
# dev.off()
#
# jpeg("Iris5.jpeg")
# hist(est_iris[5,])
# dev.off()
#
# jpeg("Iris6.jpeg")
# hist(est_iris[6,])
# dev.off()
# getImage(est_iris,6,"IRIS")
#
# jpeg("Iris7.jpeg")
# hist(est_iris[7,])
# dev.off()

### Crabs ###
data(crabs)
est_crabs <- est(crabs[,4:8],7,100)
for (i in 2:7){
  getImage(est_crabs,i,"CRABS")
}

# jpeg("Crabs2.jpeg")
# hist(est_crabs[2,])
# dev.off()
#
# jpeg("Crabs3.jpeg")
# hist(est_crabs[3,])
# dev.off()
#
# jpeg("Crabs4.jpeg")
# hist(est_crabs[4,])
# dev.off()
#
# jpeg("Crabs5.jpeg")
# hist(est_crabs[5,])
# dev.off()
#
# jpeg("Crabs6.jpeg")
# hist(est_crabs[6,])
# dev.off()
#
# jpeg("Crabs7.jpeg")
# hist(est_crabs[7,])
# dev.off()

### Lampone ###


#tenemos que sacar la columna 144 sino falla.

lampone0 <- est(lampone[,c(-1,-143,-144)],7,100)
for (i in 2:7){
  getImage(lampone0,i,"LAMPONE")
}

# jpeg("Lamp2.jpeg")
# hist(lampone0[2,])
# dev.off()
#
# jpeg("Lamp3.jpeg")
# hist(lampone0[3,])
# dev.off()
#
# jpeg("Lamp4.jpeg")
# hist(lampone0[4,])
# dev.off()
#
# jpeg("Lamp5.jpeg")
# hist(lampone0[5,])
# dev.off()
#
# jpeg("Lamp6.jpeg")
# hist(lampone0[6,])
# dev.off()
#
# jpeg("Lamp7.jpeg")
# hist(lampone0[7,])
# dev.off()
