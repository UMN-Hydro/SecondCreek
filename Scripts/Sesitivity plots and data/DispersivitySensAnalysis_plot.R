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

ggplot(data = Dispersivity, aes (x= dispersivity, y= value, colour = variable, group = variable))+labs(title = "Dispersivity sensitivity analysis") + ylab("Hydraulic conductivity, m/d") + geom_line() +scale_colour_discrete(name="Temperature Probe")

