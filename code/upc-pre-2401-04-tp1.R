# Script del Trabajo Parcial


rm(list=ls(all=TRUE))
cat("\014")

dataHotelBookings <-read.csv("hotel_bookings.csv", header =TRUE, sep = ",")
str(dataHotelBookings)

colores_suaves <- c("#92c5de", "#a6bddb", "#bdc9e1", "#f4cae4", "#e6f5c9", "#c7e9b4", "#7fcdbb", "#41b6c4", "#1d91c0", "#225ea8")

library(mlr)
library(ggplot2)
library(agricolae)
library(DescTools)
library(lubridate)

colSums(dataHotelBookings == "NULL")
colSums(dataHotelBookings == "Undefined")

#Modificar los NULL que son NA, con los que son de tipo categorico
dataHotelBookings[dataHotelBookings == ""] <- NA
dataHotelBookings$agent <- ifelse(dataHotelBookings$agent == 'NULL', 'Sin agente', dataHotelBookings$agent)
dataHotelBookings$company <- ifelse(dataHotelBookings$company == 'NULL', 'Sin empresa', dataHotelBookings$company)
dataHotelBookings$meal <- ifelse(dataHotelBookings$meal == 'Undefined', 'SC', dataHotelBookings$meal)
dataHotelBookings$country <- ifelse(dataHotelBookings$country == 'NULL', NA, dataHotelBookings$country)
dataHotelBookings$market_segment <- ifelse(dataHotelBookings$market_segment == 'Undefined', NA, dataHotelBookings$market_segment)
dataHotelBookings$distribution_channel <- ifelse(dataHotelBookings$distribution_channel == 'Undefined', NA, dataHotelBookings$distribution_channel)

#Cambiar los tipos de dato
dataHotelBookings$hotel <- as.factor(dataHotelBookings$hotel)
dataHotelBookings$is_canceled <- as.factor(dataHotelBookings$is_canceled)
dataHotelBookings$arrival_date_month <- as.factor(dataHotelBookings$arrival_date_month)
dataHotelBookings$meal <- as.factor(dataHotelBookings$meal);
dataHotelBookings$country <- as.factor(dataHotelBookings$country)
dataHotelBookings$market_segment <- as.factor(dataHotelBookings$market_segment)
dataHotelBookings$distribution_channel <- as.factor(dataHotelBookings$distribution_channel)
dataHotelBookings$is_repeated_guest <- as.factor(dataHotelBookings$is_repeated_guest)
dataHotelBookings$previous_bookings_not_canceled <- as.factor(dataHotelBookings$previous_bookings_not_canceled)
dataHotelBookings$reserved_room_type <- as.factor(dataHotelBookings$reserved_room_type)
dataHotelBookings$assigned_room_type <- as.factor(dataHotelBookings$assigned_room_type)
dataHotelBookings$deposit_type <- as.factor(dataHotelBookings$deposit_type)
dataHotelBookings$agent <- as.factor(dataHotelBookings$agent)
dataHotelBookings$company <- as.factor(dataHotelBookings$company)
dataHotelBookings$customer_type <- as.factor(dataHotelBookings$customer_type)
dataHotelBookings$adr <- as.numeric(dataHotelBookings$adr)
dataHotelBookings$reservation_status <- as.factor(dataHotelBookings$reservation_status)
dataHotelBookings$reservation_status_date <-as.Date(dataHotelBookings$reservation_status_date)

#Buscar los NA
colSums(is.na(dataHotelBookings))
summary(dataHotelBookings)

summary(dataHotelBookings$children)

### Rellenar valores faltantes de children #################

dataHotelBookings$children <- ifelse(is.na(dataHotelBookings$children), 0, dataHotelBookings$children)


#emplear la moda para rellenar los datos categoricos
moda <- function(x) {
  tabla_frec <- table(x)  # Calcular la tabla de frecuencias
  moda <- names(tabla_frec)[which.max(tabla_frec)]  # Encontrar la moda
  return(moda)
}

dataHotelBookings$country[is.na(dataHotelBookings$country)] <- moda(dataHotelBookings$country)
dataHotelBookings$market_segment[is.na(dataHotelBookings$market_segment)] <- moda(dataHotelBookings$market_segment)
dataHotelBookings$distribution_channel[is.na(dataHotelBookings$distribution_channel)] <- moda(dataHotelBookings$distribution_channel)

###################################################
################## outliers #######################
###################################################

boxplot(dataHotelBookings$lead_time, main="Lead Time")
boxplot(dataHotelBookings$adults, main="Adults")
boxplot(dataHotelBookings$children, main="children")
boxplot(dataHotelBookings$babies, main="babies")
boxplot(dataHotelBookings$previous_cancellations, main="previous_cancellations")
boxplot(dataHotelBookings$booking_changes, main="booking_changes")
boxplot(dataHotelBookings$days_in_waiting_list, main="days_in_waiting_list")
boxplot(dataHotelBookings$adr, main="adr")
boxplot(dataHotelBookings$required_car_parking_spaces, main="required_car_parking_spaces")
boxplot(dataHotelBookings$total_of_special_requests, main="total_of_special_requests")




impute_outliers<- function(x){
  quantiles<-quantile(x, c(.95))
  x[x>quantiles]<-median(x)
  x
}
dataHotelBookings$lead_time<-impute_outliers(dataHotelBookings$lead_time)

dataHotelBookings$adr <- abs(dataHotelBookings$adr)

dataHotelBookings$adr<-impute_outliers(dataHotelBookings$adr)

############# visualizacion ######################

##############
# Pregunta 1 #
##############

# Estudio de los hoteles
Desc(dataHotelBookings$hotel, main = "Gráfico Hoteles")


# Calcular el Arrival Date
meses <- c("January", "February", "March", "April", "May", "June",
           "July", "August", "September", "October", "November", "December")

dataHotelBookings$arrival_date <- as.Date(paste(dataHotelBookings$arrival_date_year, 
              match(dataHotelBookings$arrival_date_month, meses),
              dataHotelBookings$arrival_date_day_of_month, 
              sep = "-"))

dataHotelBookings$booking_date <- dataHotelBookings$arrival_date - dataHotelBookings$lead_time

##############
# Pregunta 2 #
##############

# Descripcion del Arrival Date
Desc(dataHotelBookings$booking_date, main = "Grafico de Reservas por fecha de registro")

reservas_por_mes <- table(format(dataHotelBookings$booking_date, "%Y-%m"))

# Convertir las fechas de llegada a objetos de fecha
fechas <- as.Date(paste(names(reservas_por_mes),"-01"), format = "%Y-%m -%d")

# Convertir la cantidad de reservas a un vector numérico
cantidad_reservas <- as.numeric(reservas_por_mes)

# Crear el gráfico de tendencias por mes
plot(fechas, cantidad_reservas, type = "l", 
     main = "Tendencia de reservas por mes",
     xlab = "Fecha de llegada",
     ylab = "Cantidad de reservas",
     col = "blue", lwd = 2)

rm(cantidad_reservas)
rm(fechas)
rm(reservas_por_mes)
##############
# Pregunta 3 #
##############

temporadas <- ifelse(format(dataHotelBookings$arrival_date, "%m") %in% c("12", "01", "02"), "Invierno",
                     ifelse(format(dataHotelBookings$arrival_date, "%m") %in% c("03", "04", "05"), "Primavera",
                            ifelse(format(dataHotelBookings$arrival_date, "%m") %in% c("06", "07", "08"), "Verano", "Otoño")))

reservas_por_temporada <- table(temporadas)

Desc(reservas_por_temporada, main = "Temporadas de reserva")

rm(reservas_por_temporada)

##############
# Pregunta 4 #
##############

#Cantidad de reservas por año

barplot(table(dataHotelBookings$arrival_date_year), main="Distribucion de reservas segun el año", ylim=c(0,60000), xlab="Años", ylab="Frecuencia")
table(dataHotelBookings$arrival_date_year)  


#Cantidad de reservas por mes
barplot(table(dataHotelBookings$arrival_date_month), main="Distribucion de reservas segun el mes", ylim=c(0,14000), xlab="Meses", ylab="Frecuencia")
table(dataHotelBookings$arrival_date_month)

##############
# Pregunta 5 #
##############

reservas_con_infantes <- function(data) {
  # Crear una nueva columna que indique si la reserva incluye niños o bebés
  incluye_nino_o_bebe <- ifelse( data$children > 0 | data$babies > 0, TRUE, FALSE)
  
  # Calcular el porcentaje de reservas que incluyen niños o bebés
  porcentaje_reservas_con_ninos_o_bebes <- sum(incluye_nino_o_bebe) / nrow(data) * 100
  porcentaje_reservas_solo_adultos <- sum(!incluye_nino_o_bebe) / nrow(data) * 100
  
  # Crear un data frame con los porcentajes
  temp <- data.frame(
    Categoria = c("Con infantes", "Sin infantes"),
    Porcentaje = c(porcentaje_reservas_con_ninos_o_bebes, porcentaje_reservas_solo_adultos)
  )
  
  # Crear el gráfico de barras
  p <- ggplot(temp, aes(x = Categoria, y = Porcentaje, fill = Categoria)) +
    geom_bar(stat = "identity") +
    labs(title = "Porcentaje de reservas con y sin infantes",
         x = "Categoría",
         y = "Porcentaje") +
    scale_fill_manual(values = c("Con infantes" = "#92c5de", "Sin infantes" = "#41b6c4")) +
    theme_minimal()
  
  print(p)
  
  return(list(porcentaje_reservas_con_ninos_o_bebes, porcentaje_reservas_solo_adultos))
}
reservas_con_infantes(dataHotelBookings)

##############
# Pregunta 6 #
##############

#Frecuencia de cantidad de solicitudes de espacios de estacionamiento

barplot(table(as.factor(dataHotelBookings$required_car_parking_spaces)), main="Distribucion de solicitudes por espacios de estacionamiento", ylim=c(0,120000), xlab="Espacios de estacionamiento solicitados", ylab="Frecuencia")
table(as.factor(dataHotelBookings$required_car_parking_spaces))

##############
# Pregunta 7 #
##############

dataHotelBookings$Month_reservation_status_date <- month(dataHotelBookings$reservation_status_date)
dataHotelBookings$Month_reservation_status_date<-month.name[dataHotelBookings$Month_reservation_status_date]

tabla_status_por_mes=table(dataHotelBookings$reservation_status, dataHotelBookings$Month_reservation_status_date)
tabla_status_por_mes
tabla_status_canceled_por_mes=table(dataHotelBookings$reservation_status=="Canceled", dataHotelBookings$Month_reservation_status_date)
tabla_status_canceled_por_mes
data_status_canceled_por_mes=data.frame(tabla_status_canceled_por_mes)
data_status_canceled_por_mes
levels(data_status_canceled_por_mes$Var1) <- c("No cancelados", "Cancelados")
colnames(data_status_canceled_por_mes)[colnames(data_status_canceled_por_mes) == "Var1"] <- "Estado"
colnames(data_status_canceled_por_mes)[colnames(data_status_canceled_por_mes) == "Freq"] <- "Frecuencia"
colnames(data_status_canceled_por_mes)[colnames(data_status_canceled_por_mes) == "Var2"] <- "Meses"
ggplot(data_status_canceled_por_mes, aes(x=Meses, y=Frecuencia, fill=Estado))+
  geom_bar(stat = "identity", position=position_dodge(), colour="black")
rm(data_status_canceled_por_mes, tabla_status_canceled_por_mes, tabla_status_por_mes)






write.csv(dataHotelBookings, file = "dataHotelBookingsLimpia.csv", row.names = TRUE)