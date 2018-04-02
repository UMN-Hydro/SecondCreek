library(ggplot2)
library(grid)
library(dplyr)
require(tidyverse)


 load(file = "C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\conjoined_q_gapsFilled.Rda")


x_min =  as.POSIXct("2016-06-04 00:00:00", format = "%Y-%m-%d %H:%M:%S")
x_max = as.POSIXct("2016-10-01 01:30:00", format = "%Y-%m-%d %H:%M:%S")


plot1 <-ggplot(data = test, aes(x= Date, y = value, color = variable, na.rm = FALSE)) +xlab('')+ geom_line(aes(y= stream_center, col = "stream_center"), size = 2)+geom_line(aes(y= stream_west, col = "stream_west"), size = 2)+geom_line(aes(y= west_wetland, col = "west_wetland"), size =2 )+theme_gray()+ theme(legend.position="none")
plot2 <-ggplot(data = test, aes(x= Date, y=value, na.rm = FALSE))+geom_line(aes(y=PRCP, col ="PRCP"), size = 2, color='black') + ylab('Precip, in.') +theme_gray()+xlab('')

plot1 <- plot1 + scale_x_datetime(limits=c(x_min, x_max))
plot2 <- plot2 + scale_x_datetime(limits=c(x_min, x_max))

plot1 = plot1 +ylab("Hyporheic flux, m/d.") 





plot1 <- plot1 +theme(axis.text=element_text(size=20),  axis.title=element_text(size=28))
plot2 <- plot2 + theme(axis.text=element_text(size=20), axis.title=element_text(size=28))

jpeg('C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\Combo_plot.jpg', width = 2000, height = 1700,res = 150 )



grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 1)))
#jpeg('C:\\SecondCreekGit\\Presentations and figures\\GSA NC poster\\Combo_plot.jpg', units = 'in', width = 12, height = 12 )

print(plot2, vp = viewport(layout.pos.row = 2, layout.pos.col=1))
print(plot1, vp = viewport(layout.pos.row = 1, layout.pos.col=1))
dev.off()
