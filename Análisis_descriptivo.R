library(ggplot2)
library(corrplot)
library(rio)
library(dplyr)
library(qpcR)
### importar datos
mp25 <- import(file.choose())
viento <- import(file.choose())
hum <- import(file.choose())
temp <- import(file.choose())
presion <- import(file.choose())
casos <- import(file.choose())
co <- import(file.choose())
### promedios diarios como variables diarias
mp25_diarios <- mp25[!duplicated(mp25$`Fecha única`),]
viento_diarios <- viento[!duplicated(viento$`Fecha única`),]
hum_diarios <- hum[!duplicated(hum$`Fecha unica`),]
temp_diarios <- temp[!duplicated(temp$`Fecha unica`),]
presion_diarios <- presion[!duplicated(presion$`Fecha unica`),]
casos_diarios <- casos$Promedio_Diario
### ver que tengan igual tamaño
dim(mp25_diarios)
dim(viento_diarios)
dim(hum_diarios)
dim(temp_diarios)
dim(presion_diarios)
length(casos_diarios[367:4020]) ### quitar año 2015
co <- co[1:3654] ##hacer que co tenga igual cant. de filas
dim(co) 
str(co) ### cambiamos chr a num
co <- co %>% mutate(across(c(`Registros validados`,
                             `Registros preliminares`,
                             `Registros no validados`),~ as.numeric(gsub(",", ".", .))))
str(co)
### usamos "preliminares" y "no validados" como "validados" en lugar de NA
co <- co%>%mutate(`Registros validados`=coalesce(`Registros validados`,
                                                 `Registros preliminares`,
                                               `Registros no validados`))

### armar dataframe
datos <- data.frame(
  fecha = mp25_diarios$`Fecha única`,
  mp25 = mp25_diarios$Promedio,
  viento = viento_diarios$Promedio,
  hum = hum_diarios$Promedio,
  temp = temp_diarios$Promedio,
  presion = presion_diarios$Promedio,
  casos = casos_diarios[367:4020], 
  co = co$`Registros validados`
)

datos <- na.omit(datos) ### quitamos NA
dim(datos)

### resumen de estadísticas
summary(datos)
### histogramas
### Urgencias respiratorias
hist(datos$casos,freq=FALSE,
     xlab = "Casos diarios",
     ylab="Densidad",
     main="Distribución de Urgencias Respiratorias en Coyhaique",
     col="coral3")
### MP2.5
hist(datos$mp25,freq=FALSE,
     xlab = expression("MP 2.5 diario ("*mu*"g/m"^3*")"),
     ylab="Densidad",
     main=expression("Distribución de MP 2.5 diario("*mu*"g/m"^3*")"),
     col="darkred")
### Matriz de correlación
vars <- datos[,c("mp25","hum","presion","viento","temp","casos","co")]
matriz <- cor(vars,use="pairwise.complete.obs")
corrplot(matriz,addCoef.col="black")
### mayor correlación con casos respiratorios: temp>c0>mp2.5
### diagrama de dispersión
plot(datos$mp25, datos$casos,
     xlab = expression("MP 2.5 diario ("*mu*"g/m"^3*")"),
     ylab = "Casos de urgencia",
     main = "MP2.5 vs Urgencias Respiratorias",
     pch = 19,
     col = "darkcyan")
plot(datos$co, datos$casos,
     xlab = expression("MP 2.5 diario ("*mu*"g/m"^3*")"),
     ylab = "Casos de urgencia",
     main = "MP2.5 vs Urgencias Respiratorias",
     pch = 19,
     col = "darkgreen")
plot(datos$temp,datos$casos,
     xlab="Temperatura(°C)",
     ylab="Casos de urgencia",
     main="Temperaura vs Urgencias Respiratorias",
     pch=19,
     col="brown")
### boxplot de urgencias por estacionalidad
datos$fecha <- as.Date(as.character(datos$fecha),
                       format = "%y%m%d")
datos$mes <- format(datos$fecha, "%m")
datos$estacion <- ifelse(datos$mes %in% c("12","01","02"), "Verano",
                         ifelse(datos$mes %in% c("03","04","05"), "Otoño",
                                ifelse(datos$mes %in% c("06","07","08"), "Invierno","Primavera")))
boxplot(casos~estacion,data=datos,
        col=c("darkcyan","darkgoldenrod2","coral1","chartreuse3"),
        xlab="Estación del año",
        ylab="Urgencias respiratorias",
        main="Casos respiratorios según estacionalidad")
### series de tiempo
plot(datos$fecha,datos$casos,
     type = "l",
     col = "red",
     xlab = "Fecha",
     ylab = "Casos diarios",
     main = "Evolución temporal urgencias respiratorias")
plot(datos$fecha,datos$mp25,
     type="l",
     col="coral3",
     xlab="Fecha",
     ylab="Concentración de MP2.5",
     main="Evolución temporal MP2.5")
acf(datos$casos,
    main = "Autocorrelación de urgencias respiratorias",
    col = "darkblue",
    lwd = 2)
### se observa una dependencia temporal
