# 5 data visualizations in 5 minutes, less than 5 lines of code 
# 
# http://www.computerworld.com/article/2893271/business-intelligence/5-data-visualizations-in-5-minutes-each-in-5-lines-or-less-of-r.html
# 

# 1) Map of Starbucks

download.file("https://opendata.socrata.com/api/views/ddym-zvjk/rows.csv?accessType=DOWNLOAD", "starbucks.csv", method = "curl")
starbucks <- read.csv("starbucks.csv") 
library("leaflet") 
leaflet() %>% addTiles() %>% setView(-84.3847, 33.7613, zoom = 16) %>% 
        addMarkers(data = starbucks, lat = ~ Latitude, lng = ~ Longitude, popup = starbucks$Name)

# 2) Graph Anthem stock price

library("quantmod") 
getSymbols("ANTM") 
barChart(ANTM, subset='last 6 months')

# 3) Graph Atlanta-area unemployment

getSymbols("ATLA013URN", src="FRED") 
names(ATLA013URN) = "rate" 
library("dygraphs") 
dygraph(ATLA013URN, main="Atlanta area unemployment")

# 4) Correlations (adds line to download data)
download.file(destfile = "data/testscores.csv", method = "curl", url="https://raw.githubusercontent.com/smach/NICAR15/master/data/testscores.csv")
testdata <- read.csv("data/testscores.csv", stringsAsFactors = FALSE) 
library(ggvis) 
ggvis(testdata, ~pctpoor, ~score) %>% 
        layer_points(size := input_slider(10, 310, label="Point size"), opacity := input_slider(0, 1, label="Point opacity")) %>% 
        layer_model_predictions(model = "lm", stroke := "red", fill := "red") 

# and for a correlation matrix 
mycorr <- cor(na.omit(testdata[3:6]))
library(corrplot)
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(mycorr, method="shade", shade.col=NA, tl.col="black", tl.srt=45, col=col(200), addCoef.col="black")

# 5) Latest versions of these packages can be installed with
install.packages("devtools") 
devtools::install_github("rstudio/leaflet") 
install.packages("quantmod") 
install.packages("dygraphs") 
install.packages("ggvis")
install.packages("corrplot")
