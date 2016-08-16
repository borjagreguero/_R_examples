library(sp) 

# https://cran.r-project.org/web/packages/sp/vignettes/over.pdf

# A %over% B
# over(A, B)

# Selecting points of A inside or on some geometry B (e.g. a set of polygons) B is done by 
# A[B,]
# A[!is.na(over(A,B)),]

# 2) OVERLAY GEOMETRIES 

x = c(0.5, 0.5, 1.2, 1.5)
y = c(1.5, 0.5, 0.5, 0.5)
xy = cbind(x,y)
dimnames(xy)[[1]] = c("a", "b", "c", "d")
xy
pts = SpatialPoints(xy)
xpol = c(0,1,1,0,0)
ypol = c(0,0,1,1,0)
pol = SpatialPolygons(list(
           Polygons(list(Polygon(cbind(xpol-1.05,ypol))), ID="x1"),
           Polygons(list(Polygon(cbind(xpol,ypol))), ID="x2"),
           Polygons(list(Polygon(cbind(xpol,ypol-1.05))), ID="x3"),
           Polygons(list(Polygon(cbind(xpol+1.05,ypol))), ID="x4"),
           Polygons(list(Polygon(cbind(xpol+.4, ypol+.1))), ID="x5")
           ))
pol
par(mfrow=c(1,1))
plot(pol,group_by="feature")
plot(pts,col = "red",add = T,pch = "o")

over(pts,pol)
overlaps <- over(pts,pol,returnList = TRUE)
overlaps

# polygons overly each other 
over(pol, pol, returnList = TRUE)

# points falling inside 
pts[pol]
pol[pts,]

pol[2]
pol[5]

par(mfrow=c(1,1))
plot(pol[5])
plot(pol[2],add = T)

row.names(pol[pts])

# 3) USING OVER TO EXTRACT ATTRIBUTES 
zdf = data.frame(z1 = 1:4, z2=4:1, f = c("a", "a", "b", "b"),
                          row.names = c("a", "b", "c", "d"))
zdf
ptsdf  <- SpatialPointsDataFrame(pts,zdf)
xy
zdf

zpl = data.frame(z = c(10, 15, 25, 3, 0), zz=1:5,
         f = c("z", "q", "r", "z", "q"), row.names = c("x1", "x2", "x3", "x4", "x5"))
zpl
poldf = SpatialPolygonsDataFrame(pol, zpl)
poldf

over(pts, poldf) # only the first element 

overlaps.attr <- over(pts,poldf,returnList = T)
overlaps.attr
length(overlaps.attr)

# pass a user defined function 
over(pts, poldf[1:2], fn = mean)

over(poldf, pts,returnList = T)
over(poldf, ptsdf,returnList = T)

over(pol, ptsdf[1:2], fn = mean)

# 4) LINES AND POLYGON-POLYGON 
library(rgeos)

l1 = Lines(Line(coordinates(pts)), "L1")
l2 = Lines(Line(rbind(c(1,1.5), c(1.5,1.5))), "L2")
L = SpatialLines(list(l1,l2))

over(pol, pol)
over(pol, pol,returnList = TRUE)
over(pol, L)
over(L, pol)
over(L, L)

data(meuse.grid)
gridded(meuse.grid) = ~x+y
Pt = list(x = c(178274.9,181639.6), y = c(329760.4,333343.7))
sl = SpatialLines(list(Lines(Line(cbind(Pt$x,Pt$y)), "L1")))
image(meuse.grid)
lines(sl)
xo = over(sl, geometry(meuse.grid), returnList = TRUE)
xo
image(meuse.grid[xo[[1]], ],col=grey(0.5),add=T)
lines(sl)

# 5) ORDERING AND CONSTRAINING INTERSECTS 
g = SpatialGrid(GridTopology(c(0,0), c(1,1), c(3,3)))
p = as(g, "SpatialPolygons")
px = as(g, "SpatialPixels")
plot(g)
text(coordinates(g), labels = 1:9)

over(g,g)
over(p,g)
over(g,p)

over(px[5], g, returnList = TRUE)
over(p[c(1,5)], p, returnList = TRUE)

# 6) AGGREGATION 
data(meuse.grid)
gridded(meuse.grid) = ~x+y
off = gridparameters(meuse.grid)$cellcentre.offset + 20
gt = GridTopology(off, c(400,400), c(8,11))
SG = SpatialGrid(gt)
agg = aggregate(meuse.grid[3], SG, mean)

sl.agg = aggregate(meuse.grid[,1:3], sl, mean)
class(sl.agg)

g = SpatialGrid(GridTopology(c(5,5), c(10,10), c(3,3)))
p = as(g, "SpatialPolygons")
p$z = c(1,0,1,0,1,0,1,0,1)
cc = coordinates(g)

p$ag1 = aggregate(p, p, mean)[[1]]
p$ag4 = aggregate(p, p, mean, areaWeighted=TRUE)[[1]]

#aggregates <- data.frame(id=1:length(overlaps.attr),sums=NULL)
aggregates <- data.frame(id=integer(),sums=double())
names(aggregates)=c("id","sums")#aggregates <- data.frame(row.names = c("id","sums"))
aggregates
for (ii in 1:length(overlaps.attr)){
  vec <- overlaps.attr[[ii]][,2]
  aggregates <- rbind(aggregates,c(ii,sum(vec)))
  #aggregates$id <- append(aggregates$id,ii)
  #aggregates$sums <- append(aggregates$sums,values = sum(vec))  
}
aggregates
