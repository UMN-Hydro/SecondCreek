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
#to vary dot size, add a erro column to each input, do size = eroor

Dispersivity <- read.csv(file = "C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\Data\\Dispersivity.csv")
Dispersivity$X = NULL
#Dispersivity$error = Dispersivity$error *1000
Disp_plot =ggplot(data = Dispersivity, aes (x= dispersivity, y= value, colour = variable, group = variable, size = error))+geom_point()+labs(title = "Dispersivity sensitivity analysis") + ylab("Hydraulic conductivity, m/d") + geom_line(size =1) +scale_colour_discrete(name="Location") + xlab("Dispersivity, m")
Disp_plot = Disp_plot +theme(plot.title = element_text(size=28, face = "bold"),axis.text=element_text(size=14),  axis.title=element_text(size=24))
Disp_plot = Disp_plot+ scale_radius(range=c(1, 20)) #issues because of the zero value




ThermalConductivity <- read.csv( file = "C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\Data\\ThermalConductivity.csv")
ThermalConductivity$X = NULL
#ThermalConductivity$error


TC_plot = ggplot(data = ThermalConductivity, aes (x= thermal.conductivity, y= value, size = error,colour = variable, group = variable))+geom_point()+labs(title = "Sediment thermal conductivity sensitivity analysis") + ylab("Hydraulic conductivity, m/d") + geom_line(size = 2) +scale_colour_discrete(name="Location") + xlab("Thermal conductivity, W/m*C")
TC_plot = TC_plot +theme(plot.title = element_text(size=28, face = "bold"),axis.text=element_text(size=14),  axis.title=element_text(size=24))
TC_plot =TC_plot+scale_radius(range=c(1, 20))



HeatCapacity <- read.csv(file = "C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\Data\\HeatCapacity.csv")
HeatCapacity$X=NULL 
HC_plot = ggplot(data = HeatCapacity, aes (x= Saturated.heat.capacity, y= value, colour = variable, group = variable, size = error))+geom_point()+labs(title = "Saturated medium heat capacity sensitivity analysis") + ylab("Saturated medium heat capacity, J/(m^3 *C)") + geom_line(size = 2)

HC_plot = HC_plot +theme(plot.title = element_text(size=28, face = "bold"),axis.text=element_text(size=14),  axis.title=element_text(size=24))
HC_plot= HC_plot+ scale_radius(range=c(1, 20))

print(Disp_plot)
print (TC_plot)
print (HC_plot)