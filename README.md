**Universidad Peruana de Ciencias Aplicadas**

![Upc Logo](https://upload.wikimedia.org/wikipedia/commons/f/fc/UPC_logo_transparente.png)

**Trabajo Parcial**

**Fundamentos de Data Science - CC216**

**Sección: CC52**

**Docente: Nérida Manrique**

**Grupo: 4**

**Integrantes**
- Eduardo José Rivas Siesquén		U202216407
- Rodrigo Alonso Ramírez Cesti	U202210690
- Joe Maicol Turpo Queque		U202124254
- Guido Yair Abel Jeri Saldaña		U202219322

**1. Introducción del proyecto**

**Descripción y alcance del problema**
* En la industria de hotelería, es necesario recolectar y analizar datos de todo tipo. Desde información de los clientes, registro de servicios de terceros, la logística del transporte de comida, utensilios, etc.
* Se requiere realizar esto constantemente, para encontrar anomalías, concentrar el marketing a ciertos públicos objetivos, captar más clientes, etc. Si estos datos no son bien filtrados ni analizados, cualquier empresa puede quedar en la bancarrota por la toma de decisiones mal informadas.
* En el presente informe, realizaremos un análisis exploratorio de datos (EDA) de un caso de esta naturaleza, en el cual están involucrados dos tipos de hoteles, los cuales manejan diferente información en base a sus inquilinos y sus características, además de las propiedades que cada reserva tiene, como las habitaciones, cancelaciones, servicios brindados, etc.

**Objetivos**
* Realizar un análisis exploratorio de un conjunto de datos (EDA), creando visualizaciones, preparando los datos y obteniendo inferencias básicas utilizando R/RStudio como herramienta de software.
* Entender cómo ha ido evolucionando el caso de cada uno de los hoteles e identificar tendencias que se han ido dando a lo largo de los diferentes registros, empleando sólamente para el análisis data relevante o que no interfiera de forma inoportuna la obtención de información.
* Manejar una gran cantidad de datos, y a partir de estos resolver dudas en cuanto a necesidades del caso de estudio en cuestión, además de generar nueva información y conceptos de investigación a partir de los resultados.

**2. Descripción del dataset**

* El dataset "hotel_booking.csv" es una recopilación de datos sobre las reservas realizadas en dos tipos de hoteles (Resort Hotel y City Hotel). Esta data es muy variada, donde se incluyen aspectos como tiempo de llegada del usuario, servicios con los que cuenta la reserva, estado de esta misma, etc. Tiene datos almacenados desde el año 2015 hasta el 2017, con 119390 registros en su totalidad, con información de 32 diferentes atributos tomados en cuenta del caso.

* En general, las diferentes características de cada atributo las hemos interpretado en el siguiente cuadro:

| Variables                    | Tipo       | Descripción                                                                                                                                         |
|------------------------------|------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| ADR                          | Numeric    | Average Daily Rate / Tarifa Diaria Promedio.                                                                                                         |
| Adults                       | Integer    | Cantidad de adultos.                                                                                                                                 |
| Agent                        | Categorical| ID de la agencia de viajes que realizó la reserva.                                                                                                    |
| ArrivalDateDayOfMonth        | Integer    | Día del mes de la fecha de llegada.                                                                                                                  |
| ArrivalDateMonth             | Categorical| Mes de la fecha de llegada con 12 categorías desde “Enero” a “Diciembre”.                                                                           |
| ArrivalDateWeekNumber        | Integer    | Número de semana de la fecha de llegada.                                                                                                              |
| ArrivalDateYear              | Integer    | Año de la fecha de llegada.                                                                                                                          |
| AssignedRoomType             | Categorical| Código del tipo de habitación asignada a la reserva. En ocasiones, el tipo de habitación asignada difiere del tipo de habitación reservada.           |
| Babies                       | Integer    | Cantidad de bebés.                                                                                                                                   |
| BookingChanges               | Integer    | Cantidad de cambios/modificaciones realizadas en la reserva desde el momento en que se introdujo la reserva en el PMS hasta el momento del check-in. |
| Children                     | Integer    | Cantidad de niños.                                                                                                                                    |
| Company                      | Categorical| ID de la empresa/entidad que realizó la reserva o responsable del pago de la misma.                                                                 |
| Country                      | Categorical| País de origen. Las categorías están representadas en el formato ISO 3155–3:2013                                                                    |
| CustomerType                 | Categorical| Tipo de reserva, asumiendo una de cuatro categorías.                                                                                                  |
| DaysInWaitingList            | Integer    | Cantidad de días que la reserva estuvo en lista de espera antes de ser confirmada al cliente.                                                        |
| DepositType                  | Categorical| Indicación de si el cliente realizó un depósito para garantizar la reserva.                                                                          |
| DistributionChannel          | Categorical| Canal de distribución de reservas.                                                                                                                    |
| Hotel                        | Categorical| Tipo de hotel al que pertenece.                                                                                                                       |
| IsCanceled                   | Categorical| Valor que indica si la reserva fue cancelada (1) o no (0).                                                                                            |
| IsRepeatedGuest              | Categorical| Valor que indica si el nombre de la reserva era de un huésped repetido (1) o no (0).                                                                  |
| LeadTime                     | Integer    | Número de días que transcurrieron entre la fecha de entrada de la reserva en el PMS y la fecha de llegada.                                            |
| MarketSegment                | Categorical| Designación del segmento de mercado.                                                                                                                  |
| Meal                         | Categorical| Tipo de comida reservada.                                                                                                                             |
| PreviousBookingsNotCanceled | Integer    | Cantidad de reservas anteriores no canceladas por el cliente antes de la reserva actual.                                                             |
| PreviousCancellations        | Integer    | Cantidad de reservas anteriores que fueron canceladas por el cliente antes de la reserva actual.                                                      |
| RequiredCardParkingSpaces    | Integer    | Cantidad de plazas de aparcamiento solicitadas por el cliente.                                                                                         |
| ReservationStatus            | Categorical| Último estado de reserva.                                                                                                                             |
| ReservationStatusDate        | Date       | Fecha en la que se fijó el último estado.                                                                                                             |
| ReservedRoomType             | Categorical| Código del tipo de habitación reservada.                                                                                                              |
| StaysInWeekendNights         | Integer    | Cantidad de noches de fin de semana que el huésped se alojó o reservó para alojarse en el hotel.                                                     |
| StaysInWeekNights            | Integer    | Cantidad de noches entre semana que el huésped se alojó o reservó para alojarse en el hotel.                                                         |
| TotalOfSpecialRequests       | Integer    | Cantidad de solicitudes especiales realizadas por el cliente.                                                                                         |


**3. Conclusiones**

A partir de la información hallada gracias al tratado y limpieza de datos, para posteriormente llevar a cabo diferentes investigaciones y análisis en base a esta, se pudo llegar a las siguiente conclusiones sobre el caso estudiado:
* Para el negocio, resultan desfavorables las épocas de fin y comienzo de año, donde están involucrados los meses de noviembre, diciembre, enero y febrero. De acuerdo a la data involucrada, para el público objetivo esta temporada no representa una época próspera para su estadía, donde en ninguno de los meses involucrados se llega al menos a las 10000 reservas por mes a comparación de los demás, a excepción del mes de marzo, donde si bien no llega a este umbral, se puede denotar una mejoría en los números a medida que la fecha se va acercando a mediados de año.
* Si bien es conocido que este periodo de tiempo (desde el mes de noviembre hasta el mes de febrero) no es el indicado a la hora de denotar un mayor interés del público en hacer uso de los servicios de los hoteles, resulta interesante el hallazgo que justo en casi todos estos meses (a excepción de noviembre) los usuarios deciden cancelar su estadía para esos días, donde en diciembre se presentan 3445 reservas canceladas, enero con 5986 y febrero con 4129. En todos estos casos, el número de reservas canceladas equivale a más del 80% de reservas que no lo fueron. Esto nos puede servir para poder analizar e investigar en otros aspectos las razones de este fenómeno, donde datos sobre el origen de la data, como que ambos hoteles están localizados en Portugal, pueda tener relevancia para explicar ello, como la llegada de la temporada de invierno por su ubicación geográfica.
* Si bien es cierto que analizar la data segmentando por días, meses y años nos ayuda a entender y manejar números más grandes e interesantes en el periodo de tiempo que se elija, no resulta lo favorable a la hora de poder representar cómo es que ha evolucionado el negocio con el pasar del tiempo de forma natural. Para poder visualizar ello, se debe crear una nueva variable que nos especifique un cierto día, en un cierto mes y en un cierto año, como se logró gracias a la implementación del atributo “Arrival_date”, y gracias a ello se pudo comprobar aspectos interesantes. 
* A pesar que el mayor incremento de reservas se dio entre el 2015 y el 2016, pasando de 21996 reservas a 56707, para el año siguiente la tendencia fue hacia la reducción de este número, siendo ahora de 40687. Sin embargo, si consideramos el atributo “Arrival_date” creado, podemos observar que en el año 2017 hubieron diferentes picos altos del número de reservas, llegando a sobrepasar los números en ciertos periodos a comparación de la supuesta “época más próspera”, que era del año 2016. En ambos casos, a finales de año hubo una gran caída en las reservas, que se agudizó más en el 2017, lo cual puede influir en la interpretación que se tuvo de este periodo si solo se analizaba por año.
* En la mayoría de casos, las personas que solicitan los servicios de los hoteles no requieren del uso de servicios especiales, como podrían ser las plazas de estacionamiento, donde aproximadamente en el 93.79% de los casos totales los usuarios declararon que no requerían de alguna plaza. Caso similar al de las personas que realizaron una reserva sin presentar la estadía de infantes, representando un 92.18%. En general, a partir de esto, se puede determinar que los hoteles pueden priorizar el ofrecer habitaciones con un acondicionamiento más general (para todo público) y reducir el número de plazas de estacionamiento que poseen, al no representar una necesidad urgente en sus usuarios con el paso del tiempo.


**4. Licencia**

MIT License

Copyright (c) 2024 Eduardo J. Rivas Siesquén

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
