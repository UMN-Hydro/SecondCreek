library(ggplot2)
library(grid)
library(dplyr)

#' Create some data to play with. Two time series with the same timestamp.
load(file = "C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\conjoined_q_gapsFilled.Rda")
#' Create the two plots.

x_min =  as.POSIXct("2016-06-04 00:00:00", format = "%Y-%m-%d %H:%M:%S")
x_max = as.POSIXct("2016-10-01 01:30:00", format = "%Y-%m-%d %H:%M:%S")

#seq = seq.POSIXt(x_min, x_max, by = "15 min")
#seq = data.frame(list(Date = seq))
#seq$Date = seq$time
#seq$time = NULL



#test = merge(test, seq, all = TRUE)
#test$PRCP[is.na(test$PRCP)] =0
plot1 <-ggplot(data = test, aes(x= Date, y = value, color = variable)) + geom_line(aes(y= stream_center, col = "stream_center"))+geom_line(aes(y= stream_west, col = "stream_west"))+geom_line(aes(y= west_wetland, col = "west_wetland"))+theme_gray()
plot2 <-ggplot(data = test, aes(x= Date, y=value, na.rm = FALSE))+geom_line(aes(y=PRCP, col ="PRCP")) + ylab('Precip, in.') +theme_gray()

#plot1 <- plot1 + scale_x_datetime(limits=c(x_min, x_max))
#plot2 <- plot2 + scale_x_datetime(limits=c(x_min, x_max))

plot1 = plot1 +ylab("Flux, m/d. Positive is upwards flux.") + labs(title = 'Ground water - surface water exchange, summer 2016 (smoothed)')

plot2 = plot2  + labs(title = 'Precipitation at Embarass, MN weather station')
grid.newpage()
grid.draw(rbind(ggplotGrob(plot1), ggplotGrob(plot2), size = "last"))
