# BASIC MAPPINT AND ATTRIBUTE JOIN 
# http://robinlovelace.net/r/2014/11/10/attribute-joins.html 
# 

# load the packages we'll be using for this tutorial
x <- c("rgdal", "dplyr", "ggmap", "RColorBrewer")
lapply(x, library, character.only = TRUE)

# download the repository:
download.file("https://github.com/Robinlovelace/Creating-maps-in-R/archive/master.zip", destfile = "rmaps.zip")
unzip("rmaps.zip") # unzip the files

setwd("~/bgr/MOOC/_R/_R_examples")
london <- readOGR("data/", layer = "london_sport")
plot(london)

mean(as.Date(c("01/01/2014", "31/12/2014"), format = "%d/%m/%Y"))
summary(london)
nrow(london) 
str(london[1,])

#' @data, which contains the the attribute data for the zones
#' @polygons, the geographic data associated with each polygon (this confusingly contains the @Polygons slot: each polygon feature can contain multiple Polygons, e.g. if an administrative zone is non-contiguous)
#' @plotOrder is simply the order in which the polygons are plotted
#' @bbox is a slot associated with all spatial objects, representing its spatial extent
#' @proj4string the CRS associated with the object

head(london@data)
mean(london@data$Pop_2001)
mean(london$Pop_2001)

# plot on a map 
cols <- brewer.pal(n = 4, name = "Greys")
lcols <- cut(london$Pop_2001,
             breaks = quantile(london$Pop_2001),
             labels = cols)
plot(london, col = as.character(lcols))

#how about joining additional variables to the spatial object?
# using join from dplyr 
ldat <- read.csv("data/london-borough-profiles-2014.csv")
dat <- select(ldat, Code, contains("Anxiety")) # select two fields
dat <- rename(dat, ons_label = Code, Anxiety = Anxiety.score.2012.13..out.of.10.) # rename
dat$Anxiety <- as.numeric(as.character(dat$Anxiety)) # correct with nams 

# join the two tables by ons_labels
london@data <- left_join(london@data, dat)
head(london@data)

#--------------------------------------- 
# Plotting maps with ggplot
library(broom)
library(maptools)

# first, convert to dataframe

# lf <- fortify(london, region = "ons_label")
lf <- tidy(london, region = "ons_label")
head(lf) 
lf <- rename(lf, ons_label = id)
head(lf) 

lf <- left_join(lf, london@data) # join by the common variable 

# plot
# create a blank ggplot theme
theme_opts <- list(theme(panel.grid.minor = element_blank(),
                         panel.grid.major = element_blank(),
                         panel.background = element_blank(),
                         plot.background = element_rect(fill="#e6e8ed"),
                         panel.border = element_blank(),
                         axis.line = element_blank(),
                         axis.text.x = text("East"),
                         axis.text.y = text("West"),
                         axis.ticks = element_blank(),
                         axis.title.x = element_blank(),
                         axis.title.y = element_blank(),
                         plot.title = element_text(size=22)))

ggplot(lf) + geom_polygon(aes(long, lat, group = group, fill = Anxiety)) +
        theme_opts + 
        xlab("Easting (m)") + ylab("Northing (m)") 

