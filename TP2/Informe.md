Minería de datos  - Trabajo Práctico 2 (2016)
=============================================

Implementaciones:
----------------

* [**codigo_practico_2.R**][ej1] implementa los algoritmos pedidos en
  el ejercicio 1.
* [**ej2.r**][ej2] es un script que aplica los algoritmos sobre sobre
  los datasets A y B definidos en [**codigo_practico_2.R**][ej1]
* [**ej3.r**][ej3] es un script que aplica los algoritmos sobre sobre
  el dataset diagonal del [TP1/ej1.r][tp1_ej1a].

Ejercicio 2
===========

Propiedades de DatosA
---------------------
 - 1000 datos con 10 variables.
 - El 50% de los datos tiene la clase del signo de la octava variable.
 - El 20% de los datos tiene la clase del signo de la sexta variable.
 - El 10% de los datos tiene la clase del signo de la cuarta variable.
 - El 20% de los datos tiene la clase del signo de la segunda
   variable.  

Cabe notar que el dataset es univariado, pues no existe correlación
alguna entre las variables.

El resultado óptimo de los algoritmos de mayor a menor importancia es
8 6 4 2 y después el resto de las variables en cualquier orden.  
La ejecución del script [ej2.r][ej2] sobre el dataset genera los
siguientes resultados:

> Dataset DatosA  
> Backward - RF:  8 5 1 3 2 10 7 6 9 4  
> Backward - SVM:  8 10 5 7 3 9 1 4 6 2  
> Backward - LDA:  8 10 7 5 3 9 1 2 6 4  
> Kruskal:  8 6 4 2 1 9 3 10 5 7  
> RFE - SVM:  8 6 4 2 1 10 5 9 3 7  
> RFE - RF:  8 6 4 10 2 3 9 5 7 1  
> Forward - RF:  8 6 10 3 1 2 7 9 5 4  
> Forward - SVM:  8 5 3 7 10 9 1 4 6 2  
> Forward - LDA:  8 10 5 7 3 9 1 2 6 4

El algoritmo de Kruskal acertó el orden de importancia de las
variables pues es un método de filtro, los cuales son buenos para
analizar variables independientes como la de este dataset.

El algoritmo RFE *Recursive Feature Elimination* en ambos métodos
realiza una buena elección de las variables importantes pues una de
sus desventajas, variables correlacionadas, no existe en este dataset.

Los algoritmos Backward y Forward acertaron que la variable de mayor
importancia es la octava pero se equivocaron en la "clasificación" del
resto de las variables como se puede ver. Esto se debe a la naturaleza
de ambos algoritmos para encontrar las variables correlacionadas, pero
este dataset no es multivariado sino univariado.


Propiedades de DatosB
---------------------
 - 1000 datos con 8 variables
 - La clase de los datos es del xor de las 2 primeras variables.
 - Las variables tres y cuatro tienen un 50% de correlación con la clase.

Cabe notar que el dataset es multivariado, pues existe una correlación
entre las variables uno y dos, mientras que las variables tres y cuatro son independientes.

La ejecución del script [ej2.r][ej2] sobre el dataset genera los
siguientes resultados:

> Dataset DatosB  
> Backward - RF: 1 2 8 7 6 5 4 3  
> Backward - SVM: 4 3 6 7 8 5 1 2  
> Backward - LDA: 4 3 7 1 6 8 5 2  
> Kruskal: 4 3 6 5 2 7 1 8  
> RFE - SVM: 4 3 6 5 7 8 2 1  
> RFE - RF: 2 1 4 3 6 7 8 5  
> Forward - RF: 4 3 7 2 1 6 5 8  
> Forward - SVM: 4 3 7 8 1 2 5 6  
> Forward - LDA: 4 3 7 5 8 6 1 2


El algoritmo Backward usando el método de *Random Forest* encuentra la
relación entre la variable uno y dos pero no la importancia de tres y
cuatro.

Usando el método SVM se observa algo diferente, como se usa un kernel
lineal para clasificar, no puede interpretar la relación del XOR entre
la variables uno y dos (es necesario un kernel no lineal para ello)
entonces la siguientes variables con mayor importancia son las
variables independientes tres y cuatro respectivamente.  Ocurre lo
mismo con el método LDA.

El algoritmo de Kruskal analiza las variables de forma independiente,
es claro que elije las variables tres y cuatro como las primeras dos y
luego el resto dado a que son las únicas dos que son independientes.

El análisis del algoritmo RFE con SVM es el mismo que el dado para
Backward con SVM. El algoritmo RFE con RF es el mejor de dos mundos,
pues utilizando el método de Random Forest puede encontrar la relación
multivariable entre uno y dos y luego continua agregando las variables
independientes tres y cuatro que son las restantes variables que
poseen información.

El algoritmo Forward es incapaz de capturar la relación entre uno y
dos, pues como funciona, toma de a una variable y analiza el resto,
limitando a que elija la variable uno o dos como primera variables si
y solo si de forma independiente aportaran más que la variable tres o
cuatro pero esto no sucede. Luego siempre las dos primeras
variables son cuatro y tres.  
Notar que siempre que se elija la variable uno(dos) se elije dos(uno)
como la siente variable, pues habiendo elegido uno(dos) y luego
considerando la variable dos(uno) se predice por completo la clase.



Ejercicio 3
===========

La ejecución del script ej3.r sobre el dataset genera los siguientes
resultados:

> Promedio de aciertos: 0.39 0.48 0.31 0.96 0.6 0.92 0.4 0.42 0.47

El resultado es el porcentaje promedio de precisión de cada método. Se
interpretan de la siguiente forma:


Backward RF: 0.39  
Backward SVM: 0.48  
Backward LDA: 0.31  
Kruscal: 0.96  
RFE SVM: 0.6  
RFE RF: 0.92  
Forward RF: 0.4  
Forward SVM: 0.42  
Forward LDA: 0.47

La mejor selección de variables la produjo Kruscal con un 96% de
precisión promedio seguido de Recursive Feature Elimination utilizando
el método Random Forest con 92% de precisión.

Kruscal produce una selección de variable muy buena debido a que
analiza las variables de forma independiente para el dataset del
ejercicio 1-a que posee variables todas sus variables independientes.

Recursive Feature Elimination con Random Forest también se beneficia
dela independencia de las variables. Mientras que utilizando el método
SVM se nota un descenso en la capacidad de predicción del algoritmo,
aunque no tan baja como las de Backward y Forward.

Tanto Backward y Foward son malos algoritmos para la selección de
variables para este dataset, siendo en ambos casos muy lentos y con
una precisión muy baja comparada con Kruscal y RFE RF.


[ej1]: codigo_practico_2.R
[ej2]: ej2.r
[ej3]: ej3.r
[tp1_ej1a]:../TP1/ej1.r
