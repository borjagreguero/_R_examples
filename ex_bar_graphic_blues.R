############ R GGPLOT
library(ggplot2)

#Load Data
#Make sure months stay ordered - first time I ever wanted a factor!
#Label x-axis with every fifth label
visits_visitors <- read.csv("visits_visitors.csv")
visits_visitors$Month <- factor(visits_visitors$Month, levels = visits_visitors$Month, ordered = TRUE)
visits_visitors$Month_ <- ifelse(as.numeric(row.names(visits_visitors)) %% 5 == 0, as.character(visits_visitors$Month), "")

#Build plot as a series of elements
ggplot() + 
        geom_bar(data=visits_visitors, aes(x= Month, y= Views, colour = "lightblue"), stat = "identity", fill = '#278DBC') +
        geom_bar(data=visits_visitors, aes(x= Month, y= Visitors, colour="navyblue"), stat="identity", fill = "navyblue", width = .6) +
        scale_y_continuous(breaks=c(0,2000,4000,6000,8000,10000)) +
        scale_x_discrete(labels=visits_visitors$Month_) +
        xlab("") + 
        ylab("") +
        scale_colour_manual(name = '', values =c('lightblue'='#278DBC','navyblue'='navyblue'), labels = c('Views','Visitors'))+
        scale_fill_manual(values =c('lightblue'='#278DBC','navyblue'='navyblue'))+
        theme(
                panel.grid.major.x = element_blank(),
                panel.grid.minor.y = element_blank(),
                panel.grid.major.y = element_line(size=.05, color="gray" ),
                panel.background = element_rect(fill='white', colour='white'),
                axis.ticks = element_blank(),
                legend.position = c(.9, 1),
                legend.direction = "horizontal"
        )


############ R BASE GRAPHICS 

#Load Data
#Make sure months stay ordered - first time I ever wanted a factor!
#Label x-axis with every fifth label...need to use character(0) in base graphics, not " "?
visits_visitors <- read.csv("visits_visitors.csv")
visits_visitors$Month <- factor(visits_visitors$Month, levels = visits_visitors$Month, ordered = TRUE)
visits_visitors$Month_ <- ifelse(as.numeric(row.names(visits_visitors)) %% 5 == 0, as.character(visits_visitors$Month), character(0))

#Set up plot space for plot & add horizontal lines 
barplot(visits_visitors$Views, ylim = c(0,10000), las=1, border = NA, col.axis = "darkgray", tick = FALSE)
abline(h=seq(2000,10000, 2000), col='lightgray')

#Make views barplot
barplot(visits_visitors$Views, names.arg=visits_visitors$Month_, col = "#278DBC", 
        border = NA, add = TRUE, yaxt='n', ann = FALSE, col.axis = "darkgray")

#Make visitors barplot
#Width & space parameters move bars from their "center points" on the x-axis?
barplot(visits_visitors$Visitors, col = "navyblue", 
        border = NA, add = TRUE, yaxt='n',  xaxt= 'n', ann = FALSE,
        legend.text = c("Views", "Visitors"),
        args.legend = list(x="topright", ncol = 2, fill = c("#278DBC", "navyblue"), bty='n', border=FALSE))


############ Python: matplotlib
import pandas as pd
import matplotlib.pyplot as plt
%matplotlib inline

#Read data into Python
dataset= pd.read_csv("visits_visitors.csv")

#Create every fifth month label
dataset["Month_"]= [value if (position+1) % 5 == 0 else "" for position, value in enumerate(dataset.Month)]

#Plot 1
plotviews= dataset.Views.plot(kind='bar', figsize=(17, 6), width = .9, color = '#278DBC', edgecolor= 'none', grid = False, clip_on=False)

#Plot 2 - All options here control the result plot
plotvisitors= dataset.Visitors.plot(kind='bar', figsize=(17, 6), width = .65, color =  '#000099',  edgecolor= 'none', grid = False, clip_on=False)
plotvisitors.set_xticklabels(dataset.Month_, rotation=0)

#Remove plot borders
for location in ['right', 'left', 'top', 'bottom']:
        plotvisitors.spines[location].set_visible(False)  

#Fix grid to be horizontal lines only and behind the plots
plotvisitors.yaxis.grid(color='gray', linestyle='solid')
plotvisitors.set_axisbelow(True)

#Turn off x-axis ticks
plotvisitors.tick_params(axis='x',which='both', bottom='off', top='off', labelbottom='on') 
plotvisitors.tick_params(axis='y',which='both', left='off', right='off', labelbottom='on') 

#Create proxy artist to generate legend
views= plt.Rectangle((0,0),1,1,fc="#278DBC", edgecolor = 'none')
visitors= plt.Rectangle((0,0),1,1,fc='#000099',  edgecolor = 'none')
l= plt.legend([views, visitors], ['Views', 'Visitors'], loc=1, ncol = 2)
l.draw_frame(False)



