library(readxl)
library(lubridate)
library(dplyr)
library(corrplot)
datos <- read_xlsx(file.choose())
head(datos)

########################
#### Preparar datos ####
########################

datos$`Fecha/ID` <- as.Date(as.character(datos$`Fecha/ID`),format = "%y%m%d")
str(datos)
# crear la variable de "semana" 
datos <- datos %>%
  mutate(
    año = isoyear(`Fecha/ID`),
    semana = isoweek(`Fecha/ID`)
  )
# agrupar por semana
datos_semanales <- datos %>%
  group_by(año,semana) %>%
  summarise(
    Fecha_inicio = min(`Fecha/ID`),
    Mes = first(Mes),  
    CO = max(CO, na.rm=TRUE), #max CO de la semana
    MP25 = max(MP25, na.rm=TRUE), #max MP2.5 de la semana
    Humedad_relativa = mean(Humedad_relativa, na.rm=TRUE), #promedio de hum
    Temperatura = mean(Temperatura, na.rm=TRUE), #promedio de temp 
    Precipitaciones = sum(Precipitaciones, na.rm=TRUE), #total de precipitacion en la semana
    Velocidad_viento = mean(Velocidad_viento, na.rm=TRUE), #promedio de vv 
    Urgencias_respiratorias = sum(Urgencias_respiratorias, na.rm=TRUE), #total de urgencias semanal  
    .groups = "drop"
  )
sapply(datos_semanales, function(x) sum(is.infinite(x)))
# hay unas filas en CO que se vuelven Inf 

which(is.infinite(datos_semanales$CO)) 
datos_semanales <- datos_semanales %>% filter(is.finite(CO)) #quitamos esas filas

# crear variable estacional
datos_semanales <- datos_semanales %>%
  mutate(
    Estacion = case_when(
    Mes %in% c("Diciembre","Enero","Febrero") ~ "Verano",
    Mes %in% c("Marzo","Abril","Mayo") ~ "Otoño",
    Mes %in% c("Junio","Julio","Agosto") ~ "Invierno",
    Mes %in% c("Septiembre","Octubre","Noviembre") ~ "Primavera"),
  Estacion = factor(Estacion, levels=c("Verano","Otoño","Invierno","Primavera")))


# crear dummies para la estación
Datos <- datos_semanales %>%
  mutate(
    Verano = ifelse(Estacion=="Verano",1,0),
    Otoño = ifelse(Estacion=="Otoño",1,0),
    Primavera = ifelse(Estacion=="Primavera",1,0)
    #invierno como referencia
  ) %>%
  select(Urgencias_respiratorias,CO,MP25,Humedad_relativa,Temperatura,Precipitaciones,
         Velocidad_viento,Verano,Otoño,Primavera) %>%
  na.omit()

head(Datos)

##########################
## Análisis Descriptivo ##
##########################
summary(Datos)

### Histogramas ###
par(mfrow = c(1, 2))
### Urgencias respiratorias
hist(Datos$Urgencias_respiratorias,freq=FALSE,
     xlab = "Casos semanales",
     ylab="Densidad",
     main=expression("Distribución de Urgencias Respiratorias en Coyhaique"),
     col="coral3")
### MP2.5
hist(Datos$MP25,freq=FALSE,
     xlab = expression("MP 2.5 ("*mu*"g/m"^3*")"),
     ylab="Densidad",
     main=expression("Distribución de MP 2.5 semanal ("*mu*"g/m"^3*")"),
     col="darkred")

### Matriz de correlación ###
par(mfrow = c(1, 1))
vars <- Datos[,c("MP25","Humedad_relativa","Precipitaciones","Velocidad_viento","Temperatura","Urgencias_respiratorias","CO")]
matriz <- cor(vars,use="pairwise.complete.obs")
# Matriz de correlación 
corrplot(matriz, 
         addCoef.col = "black",
         method = "color",
         type = "upper",
         tl.cex = 0.9,        # Etiquetas más pequeñas
         number.cex = 0.75,   # Coeficientes más pequeños
         cl.cex = 0.9,        # Leyenda más pequeña
         diag = FALSE)        # Ocultar diagonal (opcional)

### Diagramas de dispersión ###

par(mfrow = c(1, 3))

plot(Datos$MP25, Datos$Urgencias_respiratorias,
     xlab = expression("MP 2.5 ("*mu*"g/m"^3*")"),
     ylab = "Casos de urgencia semanales",
     main = "MP2.5 vs Urgencias",
     pch = 19, col = "darkcyan")


plot(Datos$CO, Datos$Urgencias_respiratorias,
     xlab = "CO (ppm)",
     ylab = "Casos de urgencia semanales",
     main = "CO vs Urgencias",
     pch = 19, col = "darkgreen")


plot(Datos$Temperatura, Datos$Urgencias_respiratorias,
     xlab = "Temperatura (°C)",
     ylab = "Casos de urgencia semanales",
     main = "Temperatura vs Urgencias",
     pch = 19, col = "brown")

### Boxplot de Urgencias por Estacionalidad con datos_semanales ###
### (misma info. que Datos pero con la variable Estacion)
par(mfrow = c(1, 1))
boxplot(Urgencias_respiratorias ~ Estacion,
        data = datos_semanales,
        col = c("darkcyan","darkgoldenrod2",
                "coral1","chartreuse3"),
        xlab = "Estación del año",
        ylab = "Urgencias respiratorias",
        main = "Casos respiratorios semanales según estacionalidad")

### Series de tiempo con datos_semanales###
### (misma info. que Datos pero con la variable Fecha)
par(mfrow = c(3,1))
### Urgencias Respiratorias

plot(datos_semanales$Fecha_inicio,datos_semanales$Urgencias_respiratorias,
     type = "l",
     col = "red",
     xlab = "Fecha",
     ylab = "Casos diarios",
     main = "Evolución temporal urgencias respiratorias")
### MP2.5
plot(datos_semanales$Fecha_inicio,datos_semanales$MP25,
     type="l",
     col="coral3",
     xlab="Fecha",
     ylab="Concentración de MP2.5",
     main="Evolución temporal MP2.5")
### CO
plot(datos_semanales$Fecha_inicio,datos_semanales$CO,
     type="l",
     col="coral1",
     xlab="Fecha",
     ylab="Concentración de MP2.5",
     main="Evolución temporal MP2.5")

### Autocorrelación ###
par(mfrow=c(1,1))
acf(Datos$Urgencias_respiratorias,
    main = "Autocorrelación de urgencias respiratorias",
    col = "darkblue",
    lwd = 2)
### se observa una dependencia temporal(las urgencias de la semana actual dependen de la anterior)


########################
###### Regresión #######
########################

library(BMS)
n <- nrow(Datos)
n

# algoritmo para elegir variables segun logBF
elegir_regresion_logBF <- function(dataset,g) {
 
  # variables predictoras
  variables_utilizadas <- setdiff(colnames(dataset),"Urgencias_respiratorias")
  # modelo completo inicial
  formula_completa <- as.formula(paste("Urgencias_respiratorias", "~", paste(variables_utilizadas, collapse = " + ")))
  modelo_actual <- zlm(formula_completa, data=dataset,g=g)
  seguimos <- TRUE
  while (seguimos) {
    mejor_variable <- NULL
    mejor_log10_BF <- 0.5  # umbral: se elimina la variable si BF>0.5(evidencia sustancial
    # a favor del modelo reducido)
    mejor_modelo <- NULL
    
    # eliminar una variable a la vez
    for (variable_actual in variables_utilizadas) {
      variables_temporales <- setdiff(variables_utilizadas, variable_actual)
      
      # si no quedan variables predictoras, usamos el modelo nulo 
      if (length(variables_temporales) == 0) {
        formula_reducida <- as.formula(paste("Urgencias_respiratorias", "~ 1"))
      } else {
        formula_reducida <- as.formula(paste("Urgencias_respiratorias", "~", paste(variables_temporales, collapse = " + ")))
      }
      
      modelo_reducido <- zlm(formula_reducida, data=dataset,g=g)
      
      # log10(BF) del modelo reducido  vs el actual (evidencia a favor de quitar la variable)
      log10_BF <- (modelo_reducido$marg.lik - modelo_actual$marg.lik) / log(10)
      
      # si el modelo reducido tiene más evidencia,dejamos el modelo como candidato a eliminar
      if (!is.na(log10_BF) && log10_BF > mejor_log10_BF) {
        mejor_variable <- variable_actual #(mejor variable a eliminar)
        mejor_log10_BF <- log10_BF 
        mejor_modelo <- modelo_reducido
      }
    }
    
    # si ninguna eliminación mejora la evidencia, detenemos el proceso
    if (is.null(mejor_variable)) {
      seguimos <- FALSE
    } else {#eliminamos la variable 
      cat("Se elimina:",mejor_variable,"; log10(BF) a favor de quitarla =",round(mejor_log10_BF,2),"\n")
      variables_utilizadas <- setdiff(variables_utilizadas, mejor_variable)
      modelo_actual <- mejor_modelo
    }
  }
  
  return(variables_utilizadas)
}
variables_finales <- elegir_regresion_logBF(dataset=Datos,n)
print(variables_finales)
# comparamos modelo sin variable vs modelo con variables escogidas
modelo_final <- zlm(Urgencias_respiratorias~CO+MP25+Temperatura+Velocidad_viento+Primavera,data=Datos,g=n)
modelo_nulo <- zlm(Urgencias_respiratorias ~ 1, data=Datos,g=n)
log10_BF_final <- (modelo_final$marg.lik - modelo_nulo$marg.lik) / log(10)
log10_BF_final
# la evidencia a favor del modelo con las variables escogidas es decisiva

# Efecto de las variables en los casos semanales de urgencias respiratorias
coefficients(modelo_final)


