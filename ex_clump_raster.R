# http://stackoverflow.com/questions/24465627/clump-raster-values-depending-on-class-attribute
#
# GOAL: IDENTIFY AREAS OF MORE THAN 1 PIXEL, CONNECTED IN 4 DIRECTIONS 
# EX. OF APPLICATION: FLOOD!!!! 
#

library("raster")
r <- raster(ncols=5, nrows=5)
values(r)<-c(2,1,0,0,1,
             1,1,1,0,0,
             1,0,1,0,0,
             2,1,0,1,0,
             2,2,0,0,2)

# extend raster, otherwise left and right edges are 'touching'
r <- extend(r, c(1,1))
plot(r) 

# get al unique class values in the raster
clVal <- unique(r)

# remove '0' (background)
clVal <- clVal[!clVal==0]

# create a 1-value raster, to be filled in with NA's
r.NA <- setValues(raster(r), 1)
as.data.frame(values(r.NA))

# set background values to NA
r.NA[r==0]<- NA

# loop over all unique class values
for (i in clVal) {
  
  # create & fill in class raster
  r.class <- setValues(raster(r), NA)
  r.class[r == i]<- 1
  
  # clump class raster
  clp <- clump(r.class,directions=4)
  
  # calculate frequency of each clump/patch
  cl.freq <- as.data.frame(freq(clp))
  
  # store clump ID's with frequency 1
  rmID <- cl.freq$value[which(cl.freq$count == 1)]
  
  # assign NA to all clumps whose ID's have frequency 1
  r.NA[clp %in% rmID] <- NA
} 

# multiply original raster by the NA raster
r2 <- r * r.NA

# crop the originally extended raster ((row 2-6 and column 2-6))
r2 <- crop(r2, extent(r2, 2, 6, 2, 6 ))

getValues(r2)
#  [1] NA  1 NA NA NA
#       1  1  1 NA NA  
#       1 NA  1 NA NA  
#       2  1 NA  1 NA  
#       2  2 NA NA NA
plot(r) 
plot(r2)
getValues(r2)

