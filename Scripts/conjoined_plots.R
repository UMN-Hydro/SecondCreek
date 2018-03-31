library(ggplot2)
library(grid)
library(dplyr)
require(tidyverse)


 load(file = "C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\conjoined_q_gapsFilled.Rda")


x_min =  as.POSIXct("2016-06-04 00:00:00", format = "%Y-%m-%d %H:%M:%S")
x_max = as.POSIXct("2016-10-01 01:30:00", format = "%Y-%m-%d %H:%M:%S")


plot1 <-ggplot(data = test, aes(x= Date, y = value, color = variable, na.rm = FALSE)) + geom_line(aes(y= stream_center, col = "stream_center"), size = 2)+geom_line(aes(y= stream_west, col = "stream_west"), size = 2)+geom_line(aes(y= west_wetland, col = "west_wetland"), size =2 )+theme_gray()+ theme(legend.position="none")
plot2 <-ggplot(data = test, aes(x= Date, y=value, na.rm = FALSE))+geom_line(aes(y=PRCP, col ="PRCP"), size = 2, color='black') + ylab('Precip, in.') +theme_gray()

plot1 <- plot1 + scale_x_datetime(limits=c(x_min, x_max))
plot2 <- plot2 + scale_x_datetime(limits=c(x_min, x_max))

plot1 = plot1 +ylab("Flux, m/d. Positive is upwards flux.") + labs(title = 'Daily hyporheic flux, 2016')

plot2 = plot2  + labs(title = 'Precipitation at Embarass, MN weather station')



plot1 <- plot1 +theme(plot.title = element_text(size=28, face = "bold"),axis.text=element_text(size=14),  axis.title=element_text(size=24))
plot2 <- plot2 + theme(plot.title = element_text(size=28, face = "bold"),axis.text=element_text(size=14), axis.title=element_text(size=24))

grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 1)))
print(plot2, vp = viewport(layout.pos.row = 2, layout.pos.col=1))
print(plot1, vp = viewport(layout.pos.row = 1, layout.pos.col=1))
