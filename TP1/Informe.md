# Minería de datos  - Trabajo Práctico 1 (2016)

#### Implementaciones y librerías usadas:

* [**ej1.r**][ej1] implementa los datasets pedidos y una función
  `ej1_test` que realiza un gráfico de prueba.
* [**ej3.r**][ej3] es un script que calcula los métodos de Arboles de
  decisión y K-vecinos sobre dataframes.  
* **class**, **rpart** y **parallel** librerías de R requeridas para la funciones de
    entrenamiento y predicción `knn`, `rpart` y para ejecutar parte del código en
    paralelo.

Ejercicio 3
===========

Tras una ejecución del script [`ej3.r`][ej3] sobre los datasets:

* ej1a: generado por ej1a
* ej1b: generado por ej1b

Con 200 datos de entrenamiento y 2000 para la testear en ambos casos
se obtienen los siguientes resultados:

> Datos ej1a - knn: El mejor k es 18 y su precisión es 1802/2000 (0.901)  
> Datos ej1a - knn - cross-validation: El mejor k es 11 y su precisión
  es 37/40 (0.925)  
> Datos ej1a - DT: su precisión es 1753/2000 (0.8765)  
> Datos ej1a - DT - cross-validation: su precisión es 36/40 (0.9)  
> Datos ej1b - knn: El mejor k es 1 y su precisión es 1664/2000 (0.832)  
> Datos ej1b - knn - cross-validation: El mejor k es 2 y su precisión
  es 34/40 (0.85)  
> Datos ej1b - DT: su precisión es 1422/2000 (0.711)  
> Datos ej1b - DT - cross-validation: su precisión es 29/40 (0.725)


Se puede observar que el método K-vecinos sobre los datasets generados tiene
una precisión superior a la arboles de decisión.

Por último se puede ver que cross-validation obtiene una precisión
similar a los el resultado de entrenar con el conjunto completo de
entrenamiento y testear con un conjunto diez veces más grande.

[ej1]: ej1.r
[ej3]: ej3.r
