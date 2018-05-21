#Jack Lange
#spring 2018
#creates plots of q over time and precip over time, more usefule is the 'conjoined precip and q plot.R' script
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




TPA = plyr::rename(TPA_q_TS_1_, c(X1 = 'Date', X2 ='qA'))
TPB = plyr::rename(TPB_q_TS, c(X1 = 'Date', X2 ='qB'))
TPC = plyr::rename(TPC_q_TS, c(X1 = 'Date', X2 ='qC'))

TPA$Date = as.POSIXct(TPA$Date, format = "%m/%d/%Y %H:%M")

TPB$Date = as.POSIXct(TPB$Date, format = "%m/%d/%Y %H:%M")
TPC$Date = as.POSIXct(TPC$Date, format = "%m/%d/%Y %H:%M")



TPA$`qA` = as.numeric(TPA$`qA`)
TPB$`qB` = as.numeric(TPB$`qB`)
TPC$`qC` = as.numeric(TPC$`qC`)

TPA$'qA'=TPA$'qA' * (0.042949)/(0.035916)
TPB$'qB'=TPA$'qB' * (0.17529)/(0.17065)
TPC$'qC'=TPA$'qC' * (0.07024)/(0.11022)

TPA =TPA %>% mutate(qAsmooth = rollmean(qA, k = 100, fill = NA))
TPB =TPB %>% mutate(qBsmooth = rollmean(qB, k = 100, fill = NA))
TPC =TPC %>% mutate(qCsmooth = rollmean(qC, k = 100, fill = NA))

TPC$west_wetland = TPC$qCsmooth
TPB$stream_center = TPB$qBsmooth
TPA$stream_west = TPA$qAsmooth


#TPC$west_wetland = TPC$qC
#TPB$stream_center = TPB$qB
#TPA$stream_west = TPA$qA

TPA$qA = NULL
TPB$qB = NULL
TPC$qC = NULL


TPA$qAsmooth = NULL
TPB$qBsmooth = NULL
TPC$qCsmooth = NULL

mergedTP = merge(TPC, TPA, all =FALSE)
mergedTP = merge(mergedTP, TPB,  all = FALSE)
meltMerge = melt(mergedTP, id= 'Date', na.rm = FALSE)


ggplot(data = meltMerge, aes (x= Date, y= value, colour = variable, group = variable, na.rm = TRUE))+labs(title = "2016 hyporheic flux at Second Cr") + ylab("q, m/d. Positive is upwards flux") + geom_line() +scale_colour_discrete(name="Location")

ggplot(data = test, aes(x= Date, y = value, color = variable)) + geom_line(aes(y= stream_center, col = "stream_center"))+geom_line(aes(y= stream_west, col = "stream_west"))+geom_line(aes(y= west_wetland, col = "west_wetland"))

#rain 


weather_embarrass = read.csv(file ='C:\\SecondCreekGit\\DATA\\WEATHER\\precip.csv' )
weather_embarrass$Date = as.POSIXct(weather_embarrass$Date, format = "%m/%d/%Y")
weather_embarrass$PRCP = as.numeric(as.character(weather_embarrass$PRCP))
weather_embarrass$PRCP[is.na(weather_embarrass$PRCP)] = 0
weather_embarrass$SNOW=NULL
weather_embarrass$SNWD=NULL
weather_embarrass$TMIN=NULL
weather_embarrass$TMAX=NULL


#mergePrecip = merge(weather_embarrass, mergedTP , id = 'Date', all = TRUE)
#meltPrecip = melt(mergedTP, id= 'Date')

ggplot(data = weather_embarrass, aes(x= Date, y=PRCP))+geom_line() + labs(title = 'Precipitation at Embarass, MN weather station') + ylab('Precip, in.') +theme_gray()


 