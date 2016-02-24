library(hflights)
library(data.table); library(dplyr) 

hflights  <- tbl_df(hflights)
hflights 
data.table(hflights) 
carriers <- hflights$UniqueCarrier
carriers 

glimpse(hflights)
as.data.frame(hflights)

# changing labels - example 
two <- c("AA", "AS")
lut <- c("AA" = "American", 
         "AS" = "Alaska", 
         "B6" = "JetBlue")
two <- lut[two]
two

lut <- c("AA" = "American", "AS" = "Alaska", "B6" = "JetBlue", "CO" = "Continental", 
         "DL" = "Delta", "OO" = "SkyWest", "UA" = "United", "US" = "US_Airways", 
         "WN" = "Southwest", "EV" = "Atlantic_Southeast", "F9" = "Frontier", 
         "FL" = "AirTran", "MQ" = "American_Eagle", "XE" = "ExpressJet", "YV" = "Mesa")

# Use lut to translate the UniqueCarrier column of hflights
hflights$UniqueCarrier <- lut[hflights$UniqueCarrier]

# Inspect the resulting raw values of your variables
glimpse(hflights)

unique(hflights$CancellationCode)
# Build the lookup table: lut
lut  <- c("A"="carrier", "B"="weather",
          "C"="FFA","D"="security",""="not cancelled")

# Use the lookup table to create a vector of code labels. Assign the vector to the CancellationCode column of hflights
labels  <- lut[hflights$CancellationCode]
hflights$CancellationCode <- labels

# Inspect the resulting raw values of your variables
glimpse(labels)
glimpse(hflights)

#-------------------  DATA.TABLE
# DT [ i, j, by]
# "take DT, subset rows using i, then calculate j, group by by"
library(data.table)
DT  <- data.table(A=1:6,B=c("a","b","c"),C=rnorm(6),D=TRUE)
DT
DT[3:5,]
DT[3:5]
class(DT)
DT$A
