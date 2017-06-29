library(MASS)
source("ej2.r")
load("lampone.Rdata")
data(crabs)
data(iris)

getImage <- function (ds, row, name) {
  jpeg(paste0(name,"_",row,".jpeg"))
  hist(ds[row,],main = paste0(name," - K ",row))
  dev.off()
}

# Gausianas - copy-paste slides
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

est_crabs <- est(crabs[,4:8],7,100)
est_gauss <- est(gausianas[,-3],7,100)
est_iris <- est(iris[,-5],7,100)
lampone <- est(lampone[,c(-1,-143,-144)],7,100)
for (k in 2:7){
  getImage(est_crabs,k,"CRABS")
  getImage(est_gauss,k,"GAUSS")
  getImage(est_iris,k,"IRIS")
  getImage(lampone,k,"LAMPONE")
}
