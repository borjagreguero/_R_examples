#  install.packages("RQGIS")
# https://github.com/jannes-m/RQGIS 

# attach packages
library("raster")
library("rgdal")

# define path to a temporary folder
dir_tmp <- tempdir()
# download German administrative areas 
ger <- getData(name = "GADM", country = "DEU", level = 1)
# ger is of class "SpatialPolygonsDataFrame"
