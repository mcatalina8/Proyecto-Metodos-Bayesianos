-> Los datos fueron extraidos desde la página del sinca de la estación Coyaique II, el fin debe ser modelar los datos respecto a esa ciudad puntual.

-> Para los datos de MP2,5 son los datos que entrega el sinca de manera diaria, la fecha corresponde desde 2016-01-01 hasta 2025-12-31 lo elegí de esta forma para no
tener sobrerepresentación de ciertas estaciones (que me imagino que será un dato relevante) los datos de MP2,5 presentan 3 opciones 1-Registros Validos 2- Registros
preliminares 3- Registros no validos, para formar la variable respuesta ocupe todos los datos, ya que solo hay una opción por día, para mejor entendimiento pueden 
revisar el excel MP2,5.

-> Los datos de CO pasa igual qu el mp2,5 tienen tres  tipos de registros y yo mezcle todos para tener menos valores vacios.

-> Deje la variable mes, porque siento que puede tener incidencia de que en invierno hace más frio, etc.

-> la columna fecha es el id, por lo que no hay que incluirlo en el modelo, sino generaria ruido.

-> Los datos de temperatura, humedad relativa y velocidad del viento pueden sacarlos desde la página del sinca para su descripción
también adjunte todos los excel de cada uno para un mayor entendimiento.

-> El tema debe ser algo como ¿qué factores climaticos inciden en urgencias respiratorias? 

-> Dejar en el data set comas para decimales y puntos para miles, para no tener problemas en el r

-> Urgencias respiratorias es el promedio semanal

-> Precipitaciones dato diario sacado de https://explorador.cr2.cl/ que son datos oficiales de la dIRECCIÓN METEOROLÓGICA DE CHILE.
