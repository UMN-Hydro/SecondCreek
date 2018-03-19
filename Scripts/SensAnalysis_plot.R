library(dplyr)
library(ggplot2)
library(reshape2)
require(tidyverse)
require(signal)
require(multitaper)
require(TSAUMN)
require (tidyr)

library(lubridate)

require(zoo)

require(TSAUMN)
require(lubridate)
require(tidyselect)

Dispersivity <- read.csv(file = 'C:\\SecondCreekGit\\dispersivity_sensitivity.csv')

Dispersivity = melt(Dispersivity, id.vars = "dispersivity", measure.vars =c("west_wetland", "stream_west", "stream_center"))

ggplot(data = Dispersivity, aes (x= dispersivity, y= value, colour = variable, group = variable))+geom_point()+labs(title = "Dispersivity sensitivity analysis") + ylab("Hydraulic conductivity, m/d") + geom_line() +scale_colour_discrete(name="Location") + xlab("Dispersivity, m")


ThermalConductivity <- read.csv(file = 'C:\\SecondCreekGit\\thermalconductivity_sensanalysis.csv')
ThermalConductivity = melt(ThermalConductivity, id.vars = "thermal.conductivity", measure.vars =c("west_wetland", "stream_west", "stream_center"))
ggplot(data = ThermalConductivity, aes (x= thermal.conductivity, y= value, colour = variable, group = variable))+geom_point()+labs(title = "Sediment thermal conductivity sensitivity analysis") + ylab("Hydraulic conductivity, m/d") + geom_line() +scale_colour_discrete(name="Location") + xlab("Thermal conductivity, W/m*C")



ThermalConductivity <- read.csv(file = 'C:\\SecondCreekGit\\thermalconductivity_sensanalysis.csv')
ThermalConductivity = melt(ThermalConductivity, id.vars = "thermal.conductivity", measure.vars =c("west_wetland", "stream_west", "stream_center"))
ggplot(data = ThermalConductivity, aes (x= thermal.conductivity, y= value, colour = variable, group = variable))+geom_point()+labs(title = "Sediment thermal conductivity sensitivity analysis") + ylab("Hydraulic conductivity, m/d") + geom_line() +scale_colour_discrete(name="Location") + xlab("Thermal conductivity, W/m*C")
