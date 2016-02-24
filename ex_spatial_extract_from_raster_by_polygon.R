library(raster)
library(rgdal)

alt <- getData('alt', country = "AT") # RASTER 
gadm <- getData('GADM', country = "AT", level = 2) # SPATIAL POLYGON 
gadm_sub <- gadm[1:3, ]

alt@data

plot(alt); plot(gadm_sub, add=T)

extract(alt, gadm_sub, fun = max, na.rm = T, small = T, df = T)
extract(alt, gadm_sub, fun = sum, na.rm = T, small = T, df = T)

asp <- terrain(alt, opt = "aspect", unit = "degrees", df = F)
slo <- terrain(alt, opt = "slope", unit = "degrees", df = F)

plot(asp)
plot(slo)

extract(slo, gadm_sub, fun = mean, na.rm = T, small = T, df = T)
extract(asp, gadm_sub, fun = mean, na.rm = T, small = T, df = T)
