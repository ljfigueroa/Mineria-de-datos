generateUniformMatrix = function(ds) {
    min = apply(ds, 2, min)
    max = apply(ds, 2, max)

    nfilas = dim(ds)[1]
    ncols = dim(ds)[2]

    new = runif(ncols * nfilas, min, max)
    dim(new) = c(ncols, nfilas)
    return(t(new))
}

gapStatistic = function(ds, maxClusters, numberOfDs) {
    original_dispersion = rep(0, maxClusters)
    reference_dispersion = matrix(nrow = maxClusters, ncol = numberOfDs)
    for (k in 1:maxClusters) {
        original_dispersion[k] = log(kmeans(ds, k, nstart = 10)$tot.withinss)
        for (b in 1:numberOfDs) {
            reference_dispersion[k, b] = log(kmeans(generateUniformMatrix(ds), k, nstart = 10)$tot.withinss)
        }
    }

    gap = rep(0, maxClusters)
    cluster_mean = rep(0, maxClusters)
    sd = rep(0, maxClusters)
    s = rep(0, maxClusters)

    for (k in 1:maxClusters) {
        gap[k] = (1/numberOfDs) * (sum(reference_dispersion[k, ] - original_dispersion[k]))
        cluster_mean[k] = (1/numberOfDs) * (sum(reference_dispersion[k, ]))
        sd[k] = sqrt((1/numberOfDs) * sum((reference_dispersion[k, ] - cluster_mean[k])^2))
        s[k] = sd[k] * sqrt(1 + (1/numberOfDs))
        # print(gap[k])
    }
    ret = 1
    #print(gap-s)
    for(k in 1:(maxClusters-1)){
        if (gap[k] >= gap[k+1]- s[k+1] && k>1 ) {
            ret = k
            break
        }
    }
    #return(which.max(gap-s)) ## first position it's a little fishy
    return(ret)
}

est = function(ds, numberOfClusters, numberOfScores) {

    n = dim(ds)[1]
    score = matrix(nrow = numberOfClusters, ncol = numberOfScores)

    for (s in 1:numberOfScores) {
        for (k in 1:numberOfClusters) {

            # creo dos indices al azar y hago los clusters
            ind1 = sample(n, 0.9 * n)
            cc1 = kmeans(ds[ind1, ], k, nstart = 10)$cluster

            ind2 = sample(n, 0.9 * n)
            cc2 = kmeans(ds[ind2, ], k, nstart = 10)$cluster

            # pongo los clusters de nuevo en longitud n - quedan 0 los puntos fuera del
            v1 = v2 = rep(0, n)
            v1[ind1] = cc1
            v2[ind2] = cc2

            # creo una matriz m con 1 donde los dos puntos estan en el mismo cluster, -1 en
            # distinto cluster y 0 si alguno no esta, para cada clustering
            a = sqrt(v1 %*% t(v1))
            m1 = a/-a + 2 * (a == round(a))
            m1[is.nan(m1)] = 0

            a = sqrt(v2 %*% t(v2))
            m2 = a/-a + 2 * (a == round(a))
            m2[is.nan(m2)] = 0

            # calculo el score, los pares de puntos que estan en la misma situacion en los
            # dos clustering dividido el total de pares validos.
            validos = sum(v1 * v2 > 0)
            score[k, s] = sum((m1 * m2)[upper.tri(m1)] > 0)/(validos * (validos -
                1)/2)
        }
    }
    return(score)
}
