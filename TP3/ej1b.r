library(MASS)
library(e1071)
load("lampone.Rdata")

getTable <- function(clust, attribute,ds_number, position, tableResults) {
  contingency_table = table(clust,attribute)
  class_match = matchClasses(as.matrix(contingency_table),method="exact")
  table = contingency_table[,class_match]
  print(table)
  columnNames <- colnames(table)
  print(columnNames)
  if (columnNames[1] == "2007" || columnNames[1] == "2006") {
    table <- table[,c("2006", "2007")]
  } else {
    table <- table[,c("10", "2")]
  }
  print(table)
  tableResults[as.numeric(ds_number), position] = as.vector(table)
  print(tableResults)
  return(tableResults)
}

applyMethods <- function(ds,ds_number,tableResults) {
    # KMEAN
    kmean = kmeans(ds,2,30)
    # HCLUST
    hclust_single = hclust(dist(ds),method="single")
    hclust_average = hclust(dist(ds),method="average")
    hclust_complete = hclust(dist(ds),method="complete")

    ## Year of measurement's comparison table
    tableResults = getTable(kmean$cluster, yearOfMeasurement, ds_number, 1:4, tableResults)
    # year of measurement + method single
    tableResults = getTable(cutree(hclust_single,2), yearOfMeasurement, ds_number, 5:8, tableResults)
    # year of measurement + method average
    tableResults = getTable(cutree(hclust_average,2), yearOfMeasurement, ds_number, 9:12, tableResults)
    # year of measurement + method complete
    tableResults = getTable(cutree(hclust_complete,2), yearOfMeasurement, ds_number, 13:16, tableResults)

    ## Blueberry species's comparison table
    tableResults = getTable(kmean$cluster, blueberrySpecie, ds_number, 17:20, tableResults)
    # Blueberry + method single
    tableResults = getTable(cutree(hclust_single,2), blueberrySpecie, ds_number, 21:24, tableResults)
    # Blueberry + method average
    tableResults = getTable(cutree(hclust_average,2), blueberrySpecie, ds_number, 25:28, tableResults)
    # Blueberry + method complete
    tableResults = getTable(cutree(hclust_complete,2), blueberrySpecie, ds_number, 29:32, tableResults)

    #
    if (ds_number != 1 && ds_number != 3) {
        # Plot dataset + ds_number + year of measurement
        jpeg(paste("lampone_DS",ds_number,"year_of_measurement.jpeg",sep="_"))
        plot(ds,col= as.numeric(yearOfMeasurement)+1, main = paste0("Dataset ", ds_number," - year of measurement"))
        dev.off()

        # Plot dataset + ds_number + blueberry specie
        jpeg(paste("lampone_DS",ds_number,"blueberry_specie.jpeg",sep="_"))
        plot(ds,col= as.numeric(blueberrySpecie)+1,main = paste0("Dataset ",ds_number," - blueberry specie"))
        dev.off()
    }
    return(tableResults)
}


# Hago un filtro pues existen algunas columnas que son no numericas y no puedo aplicar scale ni prcomp

filter <- c(T,(apply(lampone[,2:142],2,max)>0),T,T)
# Original dataset
originalDs <- lampone[,filter]
originalDsWithFilter <- as.matrix(originalDs[,2:127])

# Original dataset + filter
ds1 = data.frame(originalDsWithFilter)

# Original dataset + filter + pca with scale
ds2 = data.frame(prcomp (ds1, retx = TRUE, scale = TRUE)$x[,1:7])

# Original dataset + center and scale data
ds3 = data.frame(scale (ds1))

# Original dataset + filter + pca with no scale
ds4 = data.frame(prcomp (ds1, retx = TRUE, scale = FALSE)$x[,1:7])

# Original dataset + pca with no scale + center and scale data
ds5 = data.frame(scale(prcomp (ds1, retx = TRUE, scale = FALSE)$x[,1:7]))

# Lampone's year of measurements
yearOfMeasurement = lampone[,1]
# Lampone's blueberry species
blueberrySpecie = lampone[,143]

tableResults <- matrix(rep(0,5*32), nrow = 5, ncol = 32)
tableResults[1,] = applyMethods(ds1,"1",tableResults)[1,]
tableResults[2,] = applyMethods(ds2,"2",tableResults)[2,]
tableResults[3,] = applyMethods(ds3,"3",tableResults)[3,]
tableResults[4,] = applyMethods(ds4,"4",tableResults)[4,]
tableResults[5,] = applyMethods(ds5,"5",tableResults)[5,]
#write.table(tableResults, file="tableResults", sep=",")
write.table(tableResults[,1:16], file="tableYear", sep=",",row.names=FALSE, col.names=FALSE)
write.table(tableResults[,17:32], file="tableBlueberry", sep=",",row.names=FALSE, col.names=FALSE)
