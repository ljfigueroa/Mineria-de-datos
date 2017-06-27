library(MASS)
library(e1071)
source("ej2.r")
load("lampone.Rdata")
data(crabs)

## Gaussianas
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

clg1 = gapStatistic (gausianas[,-3],8,50)
clg2 = gapStatistic (prcomp(gausianas[,-3])$x,8,50)
clg3 = gapStatistic (prcomp(scale(gausianas[,-3]))$x,8,50)
print(paste0("Gauss - Original: ",clg1, " PCA: ",clg2, " Scale-PCA: ",clg3))

## Iris
cli1 = gapStatistic (iris[,-5],8,50)
cli2 = gapStatistic (prcomp(iris[,-5])$x,8,50)
cli3 = gapStatistic (prcomp(scale(iris[,-5]))$x,8,50)
print(paste0("Iris - Original: ",cli1, " PCA: ",cli2, " Scale-PCA: ",cli3))

## Crabs
clc1 = gapStatistic (crabs[,4:8],8,50)
clc2 = gapStatistic (prcomp(crabs[,4:8])$x,8,50)
clc3 = gapStatistic (prcomp(scale(crabs[,4:8]))$x,8,50)
print(paste0("Crabs - Original: ",clc1, " PCA: ",clc2, " Scale-PCA: ",clc3))

## Lampone
filtro <- c(T,(apply(lampone[,2:142],2,max)>0),T,T)
lamponeoriginal <- lampone[,filtro]
lamponefiltrado <- as.matrix(lamponeoriginal[,2:127])
ds1 = lamponefiltrado

cll1 = gapStatistic (ds1,8,50)
cll2 = gapStatistic (prcomp(ds1)$x,8,50)
cll3 = gapStatistic (prcomp(scale(ds1))$x,8,50)
print(paste0("Lampone - Original: ",cll1, " PCA: ",cll2, " Scale-PCA: ",cll3))
