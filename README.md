<p align="center">
  <img src="https://i.ibb.co/1tc1JGc2/PONTIFICIA-UNIVERSIDAD-CAT-LICA-DE-CHILE-FACULTAD-DE-MATEM-TICAS-DEPARTAMENTO-DE-ESTAD-STICA.png" alt="Centered Image" width="300">
</p>
# Datos utilizados

## Datos de Sistema de Información Nacional de Calidad del Aire

En nuestra investigación vamos a ocupar principalmente los registros del [Sistema de Información Nacional de Calidad del Aire](https://sinca.mma.gob.cl/index.php/) (SINCA). Esta página expone información de calidad de aire de todo Chile, presentando esta información dividida en regiones y estaciones de monitoreo de la calidad del aire. Los datos que vamos a ocupar son recuperados de la estación Coyaique II, con el fin de ser modelar los resultados respecto a esta ciudad puntual.

Los datos tuvieron que ser limpiados porque SINCA reporta de manera por hora y una suma diaria los niveles de MP2.5,los niveles de CO, la temperatura, humedad relativa y velocidad del viento. Decidimos recuperar los registros desde el 01 de Enero, 2016 hasta el 31 de diciembre, 2025. Estas fechas fueron seleccionadas para no tener sobrerepresentación de las estaciones del año.

Decidimos dejar los tres tipos de registros, la variable mes(porque puede ser relevante al momento en que sube o baja la contaminación), la columna fecha se usará como nuestro id.

#### Concentración de MP2,5

El data set con la concentración de MP2.5 presentan 5 variables, 3 de ellas representan el registro de PM2.5 (μg/m³) en el aire: los Registros Validos, Registros preliminares y Registros no validos. Estos datos estan representados en una tabla con los siguientes valores: 

* FECHA (YYMMDD): Fecha en la que fue tomada la muestra.
* HORA (HHMM): Hora en la que fue tomada la muestra. 
* Registros validados (μg/m³): Valores que representan los niveles de PM2.5 que han pasado por un procedimiento de validación.
* Registros preliminares (μg/m³): Valores que representan los niveles de PM2.5 que se aproximan pero aún no han pasado por un procedimiento de validación.
* Registros no validados (μg/m³): Valores que representan los niveles de PM2.5 que no han pasado por un procedimiento de validación.

La base de datos se puede encontrar [aquí](https://github.com/mcatalina8/Proyecto-Metodos-Bayesianos/blob/main/MP25.xlsx)

#### Concentración de CO

El data set con la concentración de CO presentan 5 variables, 3 de ellas representan el registro de CO (μg/m³) en el aire: los Registros Validos, Registros preliminares y Registros no validos. Estos datos estan representados en una tabla con los siguientes valores: 

* FECHA (YYMMDD): Fecha en la que fue tomada la muestra.
* HORA (HHMM): Hora en la que fue tomada la muestra. 
* Registros validados (mg/m³): Valores que representan los niveles de PM2.5 que han pasado por un procedimiento de validación.
* Registros preliminares (mg/m³): Valores que representan los niveles de PM2.5 que se aproximan pero aún no han pasado por un procedimiento de validación.
* Registros no validados (mg/m³): Valores que representan los niveles de PM2.5 que no han pasado por un procedimiento de validación.

La base de datos se puede encontrar [aquí](https://github.com/mcatalina8/Proyecto-Metodos-Bayesianos/blob/main/CO.csv)


#### Temperatura 

Los datos de la temperatura fueron recuperados del SINCA, estos los presentamos en un dataset con las siguientes variables:

* Fecha (YYMMDD): Fecha en la que fue tomada la muestra.	
* Hora (HHMM): Hora en la que fue tomada la muestra.
* Datos originales (°C):	Temperatura medida.
* Fecha unica (YYMMDD): Fecha representativa que solo se repite una vez.
* Promedio (°C): Temperatura medida promedio en el dia.
* Máximo	(°C): Temperatura máxima.
* Mínimo (°C): Temperatura minima.

La base de datos se puede encontrar [aquí](https://github.com/mcatalina8/Proyecto-Metodos-Bayesianos/blob/main/Temperatura.xlsx)

#### Humedad relativa

Los datos de la humedad relativa fueron recuperados del SINCA, estos los presentamos en un dataset con las siguientes variables:

* Fecha (YYMMDD): Fecha en la que fue tomada la muestra.	
* Hora (HHMM): Hora en la que fue tomada la muestra.
* Datos originales (%):	Humedad medida.
* Fecha unica (YYMMDD): Fecha representativa que solo se repite una vez.
* Promedio (%): Humedad medida promedio en el dia.
* Máximo	(%): Humedad máxima.
* Mínimo (%): Humedad minima.

La base de datos se puede encontrar [aquí](https://github.com/mcatalina8/Proyecto-Metodos-Bayesianos/blob/main/Humedad%20relativa.xlsx)

#### Velocidad del viento

Los datos de la velocidad del viento recuperados del SINCA, estos los presentamos en un dataset con las siguientes variables:

* Fecha (YYMMDD): Fecha en la que fue tomada la muestra.	
* Hora (HHMM): Hora en la que fue tomada la muestra.
* Datos originales (km/h):	Humedad medida.
* Fecha unica (YYMMDD): Fecha representativa que solo se repite una vez.
* Promedio (km/h): Humedad medida promedio en el dia.
* Máximo	(km/h): Humedad máxima.
* Mínimo (km/h): Humedad minima.

La base de datos se puede encontrar [aquí](https://github.com/mcatalina8/Proyecto-Metodos-Bayesianos/blob/main/Velocidad%20del%20viento.xlsx)


## Datos de la dirección meteorologica de Chile

Para complementar los datos decidimos recuperar los datos de la [DIRECCIÓN METEOROLÓGICA DE CHILE](https://explorador.cr2.cl/) esta pagina presenta lo captado poe una red de estaciones automáticas que entregan los militros de lluvia diarios. Estos datos estan representados en una tabla con los siguientes valores: 

* Año (entero positivo): Año en la que fue tomada la muestra.	
* Mes (entero positivo): Mes en la que fue tomada la muestra.
* Dia (entero positivo): Día en la que fue tomada la muestra.
* datos (mm):	mililitros de lluvia diarios.

## Datos del Departamento de Estadísticas e Información de Salud

Por último recuperamos un dataset que registra el número promedio de consultas de urgencia respiratoria semanales. Este dataset se encuentra disponible en la base de datos del [Departamento de Estadísticas e Información de Salud](https://deis.minsal.cl/) (DEIS). En este dataset cubre los registros de consultas entre el 2015 y el 2025. Estos datos estan representados en una tabla con los siguientes valores: 


* Fecha (Año-Mes-Día): Fecha en que se recupero la muestra.	
* Anio (entero positivo): Año en que se recupero la muestra.
* Semana estadistica (semana): Semana correspondiente en el informe.
* Total Semana (consultas): Total de consultas.
* Promedio diario (consultas): Número promedio diario de consultas. 

La base de datos se puede encontrar [aquí](https://github.com/mcatalina8/Proyecto-Metodos-Bayesianos/blob/main/Coyhaique_2015_2025%20urgencias%20respiratorias.xlsx)

## Formato final

Los datos fueron unidos por fecha (Año-Mes-Día) en un dataset masivo que contiene los registros unidos en una fecha en particular.

* Fecha/ID (Año-Mes-Día): Fecha en que se recupero la muestra.
* Mes	(Mes): Mes correspondiente a la fecha. 
* CO: La concentración de Monóxido de carbono entre registros validos, preliminares y no validos.
* MP25: La concentración de MP2.5 entre registros validos, preliminares y no validos.
* Humedad_relativa (%):	Humedad promedio durante el día.
* Temperatura (°C): Temperatura  promedio durante el día.
* Precipitaciones (mm): Militmetros de lluvia registradas durante el día.
* Velocidad_viento (km/h): Velocidad del viento promedio durante el día.
* Urgencias_respiratorias (entero positivo): Número promedio de urgencias respiratorias registradas en el día.

La base de datos se puede encontrar [aquí](https://github.com/mcatalina8/Proyecto-Metodos-Bayesianos/blob/main/Data%20set%20MB.xlsx)
