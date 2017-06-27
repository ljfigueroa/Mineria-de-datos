library(MASS)
library(e1071)

getTable <- function(clustering, attribute,ds_number, position, tableResults) {
  contingency_table = table(clustering, attribute)
  class_match = matchClasses(as.matrix(contingency_table), method = "exact")
  table = contingency_table[, class_match]
  print(table)
  columnNames <- colnames(table)
  print(columnNames)
  if (columnNames[1] == "O" || columnNames[1] == "B") {
    table <- table[,c("B", "O")]
  } else {
    table <- table[,c("F", "M")]
  }
  print(table)
  tableResults[as.numeric(ds_number), position] = as.vector(table)
  print(tableResults)
  return(tableResults)
}

applyMethods <- function(ds, ds_number,tableResults)
{
  ## KMEAN and HCLUST
  kmean = kmeans(ds, 2, 30)
  hclust_single = hclust(dist(ds), method = "single")
  hclust_average = hclust(dist(ds), method = "average")
  hclust_complete = hclust(dist(ds), method = "complete")

  ## Species's comparison table
  tableResults = getTable(kmean$cluster, species, ds_number, 1:4, tableResults)
  # species + method single
  tableResults = getTable(cutree(hclust_single, 2), species, ds_number, 5:8, tableResults)
  # species + method average
  tableResults = getTable(cutree(hclust_average, 2), species, ds_number, 9:12, tableResults)
  # species + method complete
  tableResults = getTable(cutree(hclust_complete, 2), species, ds_number, 13:16, tableResults)

  ## Sex's comparison table
  tableResults = getTable(kmean$cluster, sex, ds_number, 17:20, tableResults)
  # sex + method
  tableResults = getTable(cutree(hclust_single, 2), sex, ds_number, 21:24, tableResults)
  # sex + average
  tableResults = getTable(cutree(hclust_average, 2), sex, ds_number, 25:28, tableResults)
  # sex + complete
  tableResults = getTable(cutree(hclust_complete, 2), sex, ds_number, 29:32, tableResults)
  # Plot dataset + ds_number + species
  jpeg(paste("crabs_DS",ds_number,"species.jpeg",sep="_"))
  plot(ds,col= as.numeric(species)+1, main = paste0("Dataset ", ds_number," - Species"))
  dev.off()
  # Plot dataset + ds_number + sex
  jpeg(paste("crabs_DS",ds_number,"sex.jpeg",sep="_"))
  plot(ds,col= as.numeric(sex)+1,main = paste0("Dataset ",ds_number," - Sex"))
  dev.off()
  #x = list[tableResults,tableSex]
  return(tableResults);
}


# The crabs data frame has 200 rows and 8 columns, describing 5 morphological
# measurements on 50 crabs each of two colour forms and both sexes, of the
# species Leptograpsus variegatus collected at Fremantle, W. Australia.
data(crabs)

# Crabs's species
species = crabs[, 1]
# Crabs's sex
sex = crabs[, 2]

# Original dataset
ds1 = crabs[, 4:8]

# Original dataset + logarithmic transformation
ds2 = log(ds1)

# Original dataset + logarithmic transformation + pca with scale
ds3 = data.frame(prcomp(ds2, retx = TRUE, scale = TRUE)$x)

# Original dataset + logarithmic transformation + center and scale data
ds4 = data.frame(scale(ds2))

# Original dataset + logarithmic transformation + pca with no scale
ds5 = data.frame(prcomp(ds2, retx = TRUE, scale = FALSE)$x)

# Original dataset + logarithmic transformation + pca with no scale + center and scale data
ds6 = data.frame(scale(prcomp(ds2, retx = TRUE, scale = FALSE)$x))

# Matrix of results
tableResults <- matrix(rep(0,6*32), nrow = 6, ncol = 32)
tableSex <- matrix(rep(0,6*16), nrow = 6, ncol = 16)
a =  c(1,1)
b = c(2,2)
tableResults[1,] = applyMethods(ds1,"1",tableResults)[1,]
tableResults[2,] = applyMethods(ds2,"2",tableResults)[2,]
tableResults[3,] = applyMethods(ds3,"3",tableResults)[3,]
tableResults[4,] = applyMethods(ds4,"4",tableResults)[4,]
tableResults[5,] = applyMethods(ds5,"5",tableResults)[5,]
tableResults[6,] = applyMethods(ds6,"6",tableResults)[6,]
#write.table(tableResults, file="tableResults", sep=",")
write.table(tableResults[,1:16], file="tableSpecies", sep=",",row.names=FALSE, col.names=FALSE)
write.table(tableResults[,17:32], file="tableSex", sep=",",row.names=FALSE, col.names=FALSE)
