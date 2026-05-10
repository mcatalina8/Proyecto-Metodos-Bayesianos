library(corrplot)
library(rio)
library(dplyr)
library(qpcR)
### importar datos
datos <- import(file.choose())

### Resumen
summary(datos)

### Histogramas ###

### Urgencias respiratorias
hist(datos$Urgencias_respiratorias,freq=FALSE,
     xlab = "Casos diarios",
     ylab="Densidad",
     main="Distribución de Urgencias Respiratorias en Coyhaique",
     col="coral3")
### MP2.5
hist(datos$MP25,freq=FALSE,
     xlab = expression("MP 2.5 diario ("*mu*"g/m"^3*")"),
     ylab="Densidad",
     main=expression("Distribución de MP 2.5 diario("*mu*"g/m"^3*")"),
     col="darkred")

### Matriz de correlación ###

vars <- datos[,c("MP25","Humedad_relativa","Precipitaciones","Velocidad_viento","Temperatura","Urgencias_respiratorias","CO")]
matriz <- cor(vars,use="pairwise.complete.obs")
corrplot(matriz,addCoef.col="black")
### mayor correlación con casos respiratorios: temp>c0>mp2.5

### Diagramas de dispersión ###

### MP2.5 vs Casos
plot(datos$MP25, datos$Urgencias_respiratorias,
     xlab = expression("MP 2.5("*mu*"g/m"^3*")"),
     ylab = "Casos de urgencia",
     main = "MP2.5 vs Urgencias Respiratorias",
     pch = 19,
     col = "darkcyan")

### CO vs Casos
plot(datos$CO, datos$Urgencias_respiratorias,
     xlab ="CO(ppm)",
     ylab = "Casos de urgencia",
     main = "Concentraciones de CO vs Urgencias Respiratorias",
     pch = 19,
     col = "darkgreen")

### Temperatura vs Casos
plot(datos$Temperatura,datos$Urgencias_respiratorias,
     xlab="Temperatura(°C)",
     ylab="Casos de urgencia",
     main="Temperaura vs Urgencias Respiratorias",
     pch=19,
     col="brown")

### Boxplot de Urgencias por Estacionalidad
datos$estacion <- ifelse(datos$Mes %in% c("Diciembre","Enero","Febrero"), "Verano",
                         ifelse(datos$Mes %in% c("Marzo","Abril","Mayo"), "Otoño",
                                ifelse(datos$Mes %in% c("Junio","Julio","Agosto"),
                                       "Invierno",
                                       "Primavera")))

boxplot(Urgencias_respiratorias ~ estacion,
        data = datos,
        col = c("darkcyan","darkgoldenrod2",
                "coral1","chartreuse3"),
        xlab = "Estación del año",
        ylab = "Urgencias respiratorias",
        main = "Casos respiratorios según estacionalidad")

### Series de tiempo ###
datos$`Fecha/ID` <- as.Date(as.character(datos$`Fecha/ID`),
                       format = "%y%m%d")
datos$mes <- format(datos$`Fecha/ID`, "%m")
### Urgencias Respiratorias
plot(datos$`Fecha/ID`,datos$Urgencias_respiratorias,
     type = "l",
     col = "red",
     xlab = "Fecha",
     ylab = "Casos diarios",
     main = "Evolución temporal urgencias respiratorias")
### MP2.5
plot(datos$`Fecha/ID`,datos$MP25,
     type="l",
     col="coral3",
     xlab="Fecha",
     ylab="Concentración de MP2.5",
     main="Evolución temporal MP2.5")
### CO
plot(datos$`Fecha/ID`,datos$CO,
     type="l",
     col="coral1",
     xlab="Fecha",
     ylab="Concentración de MP2.5",
     main="Evolución temporal MP2.5")

### Autocorrelación ###
acf(datos$Urgencias_respiratorias,
    main = "Autocorrelación de urgencias respiratorias",
    col = "darkblue",
    lwd = 2)
### se observa una dependencia temporal(las urgencias de hoy dependen de las de ayer)
