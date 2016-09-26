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

# attach RQGIS
library("RQGIS")

# set the environment, i.e. specify all the paths necessary to run QGIS from 
# within R
my_env <- set_env()
# under Windows set_env would be much faster if you specify the root path:
# my_env <- set_env("C:/OSGeo4W~1")
# have a look at the paths necessary to run QGIS from within R
my_env

# look for a function that contains the words "polygon" and "centroid"
find_algorithms(search_term = "polygon centroid", 
                qgis_env = my_env)

# we'll choose the QGIS function named qgis:polygoncentroids
get_usage(alg = "qgis:polygoncentroids",
          qgis_env = my_env,
          intern = TRUE)

# get parameters for the function 
params <- get_args_man(alg = "qgis:polygoncentroids", 
                       qgis_env = my_env)
params

# specify input layer
params$INPUT_LAYER  <- ger
# path to the output shapefile
params$OUTPUT_LAYER <- file.path(dir_tmp, "ger_coords.shp")

# Finally, run_qgis calls the QGIS API to run the specified geoalgorithm with the corresponding function arguments
out <- run_qgis(alg = "qgis:polygoncentroids",
                params = params,
                load_output = params$OUTPUT_LAYER,
                qgis_env = my_env)

# first, plot the federal states of Germany
plot(ger)
# next plot the centroids created by QGIS
plot(out, pch = 21, add = TRUE, bg = "lightblue", col = "black")





