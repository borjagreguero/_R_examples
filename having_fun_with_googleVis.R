# Having Fun with googleVis
# https://www.datacamp.com/community/open-courses/having-fun-with-googlevis#gs.Gj6svLc

####### Loading in your data

# Load rdatamarket and initialize client
library("rdatamarket")
dminit(NULL)

# Pull in life expectancy and population data
life_expectancy <- dmlist("15r2!hrp")
population <- dmlist("1cfl!r3d")

# Inspect life_expectancy and population with head() or tail()
head(life_expectancy)
tail(life_expectancy)
head(population)
tail(popopulation)

# Load in the yearly GDP data frame for each country as gdp
gdp = dmlist("15c9!hd1")

# Inspect gdp with tail()
tail(gdp)


######## Preparing the data 

# Load in the plyr package
library("plyr")

# Rename the Value for each dataset
tail(gdp) 
names(gdp)[3] <- "GDP"

names(life_expectancy)[3] <- "LifeExpectancy"
names(population)[3] <- "Population"

# Use plyr to join your three data frames into one: development 
?join 
gdp_life_exp <- join(gdp, life_expectancy)
development <- join(gdp_life_exp, population)

### last data preps 
# Take out data for years you know that have incomplete observations. In this case, the data is only complete up until 2008.
# Trim down the data set to include fewer countries. 

# For example, if you want to see only observations from 2005:
# dev_2005 <- subset(development, Year == 2005)
# Then if you want to see only countries that had a gdp of over 30,000 in 2005:
# dev_2005_big <- subset(dev_2005, GDP >= 30000)

# Subset development with Year on or before 2008
development_complete <- subset(development, Year<=2008)

# Print out tail of development_complete
tail(development_complete)

# Subset development_complete: keep only countries in selection
selection =c("France")
development_motion <- subset(development_complete, Country %in% selection)

###### GOOGLEVIS / PRELUDE 
# the googleVis package. This package provides an interface between R and the Google Chart Tools
library(googleVis)

# Create the interactive motion chart
motion_graph <-gvisMotionChart(development_motion,
                                idvar = "Country",timevar = "Year")

# Plot motion_graph
plot(motion_graph)

####### GOOGLEVIS / INTERLUDE 

###### GOOGLEVIS / FINAL OUTPUT 

####### GOOGLEVIS / RECESSIONAL 

