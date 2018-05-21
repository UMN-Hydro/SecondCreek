#Jack Lange
#spring 2018
# This script is used to create the sensitivity analysis plots that were used in my GSA poster and senior thesis. 



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

Dispersivity <- read.csv(file = "C:\\SecondCreekGit\\Presentations and figures\\North Central GSA poster\\Data\\Dispersivity.csv")
Dispersivity$X = NULL
Disp_plot =ggplot(data = Dispersivity, aes (x= dispersivity, y= value, colour = variable, group = variable, size = error))+geom_point()+ ylab("Hydraulic conductivity, m/d") + geom_line(size =1) +scale_colour_discrete(name="Location") + xlab("Dispersivity, m")
Disp_plot = Disp_plot +theme(axis.text=element_text(size=20),  axis.title=element_text(size=45))
Disp_plot = Disp_plot+ scale_radius(range=c(1, 15)) 
Disp_plot = Disp_plot+ ylim(low = 0, high = .18)
Disp_plot= Disp_plot+ theme(legend.position="none")

ggsave('C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\Disp_plot.png', units = 'in', width = 10, height = 10)



ThermalConductivity <- read.csv( file = "C:\\SecondCreekGit\\Presentations and figures\\North Central GSA poster\\Data\\ThermalConductivity.csv")
ThermalConductivity$X = NULL

TC_plot = ggplot(data = ThermalConductivity, aes (x= thermal.conductivity, y= value, size = error,colour = variable, group = variable))+geom_point()+ geom_line(size = 2) +scale_colour_discrete(name="Location") +ylab('')+ xlab("Sediment thermal conductivity, W/m*C")
TC_plot = TC_plot +theme(axis.text=element_text(size=20),  axis.title=element_text(size=30))
TC_plot =TC_plot+scale_radius(range=c(1, 15))
TC_plot =TC_plot+ylim(low = 0, high = .18)
TC_plot= TC_plot+ theme(legend.position="none")

ggsave('C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\TC_plot.png', units = 'in', width = 10, height = 10)



HeatCapacity <- read.csv(file = "C:\\SecondCreekGit\\Presentations and figures\\North Central GSA poster\\Data\\HeatCapacity.csv")
HeatCapacity$X=NULL 
HC_plot = ggplot(data = HeatCapacity, aes (x= Saturated.heat.capacity, y= value, colour = variable, group = variable, size = error))+geom_point()+ xlab("Saturated medium heat capacity, J/(m^3 *C)") +geom_line(size = 2)+ylab('')

HC_plot = HC_plot +theme(axis.text=element_text(size=20),  axis.title=element_text(size=30))
HC_plot= HC_plot+ scale_radius(range=c(1, 15))
HC_plot= HC_plot+ ylim(low = 0, high = .18)
HC_plot= HC_plot+ theme(legend.position="none")
ggsave('C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\HC_plot.png', units = 'in', width = 10, height = 10)


print(Disp_plot)
print (TC_plot)
print (HC_plot)