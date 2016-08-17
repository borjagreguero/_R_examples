# animated hurricane data traccks 
setwd("~/R_work")
# https://gist.github.com/hrbrmstr/23bf06784e898871dd61#file-animatedhurricanetracks-r
#library(maps)
library(data.table)
library(dplyr)
library(ggplot2)
library(grid)
library(RColorBrewer)

# takes in a numeric vector and returns a sequence from low to high
rangeseq <- function(x, by=1) {
  rng <- range(x)
  seq(from=rng[1], to=rng[2], by=by)
}
x <-  c(1, 3,5); rangeseq(x)

# extract the months (as a factor of full month names) from
# a date+time "x" that can be converted to a POSIXct object,
extractMonth <- function(x) {
  months <- format(as.POSIXct(x), "%m")
  factor(months, labels=month.name[rangeseq(as.numeric(months))])
}

# extract the years (as a factor of full 4-charater-digit years) from
# a date+time "x" that can be converted to a POSIXct object,
extractYear <- function(x) {
  factor(as.numeric(format(as.POSIXct(x), "%Y")))
}

# get from: ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/all/csv/Allstorms.ibtracs_all.v03r06.csv.gz

#system("gzip ./data/Allstorms.ibtracs_all.v03r06.csv")

#storms_file <- "ftp://eclipse.ncdc.noaa.gov/pub/ibtracs/v03r06/all/csv/Allstorms.ibtracs_all.v03r06.csv.gz"
# y <- fread(storms_file)
storms_file <- "./data/Allstorms.ibtracs_all.v03r06.csv" 
####read.table(gzfile("/tmp/foo.csv.gz")) 
storms <-  fread(storms_file, skip=10, select=1:18)
# storms <-  read.table(gzfile(storms_file))

col_names <- c("Season", "Num", "Basin", "Sub_basin", "Name", "ISO_time", "Nature",
               "Latitude", "Longitude", "Wind.kt", "Pressure.mb", "Degrees_North", "Deegrees_East")
setnames(storms, paste0("V", c(2:12, 17, 18)), col_names)

# use dplyr idioms to filter & mutate the data

make.true.NA <- function(x) if(x %in% c(NA)){ "NA"} else {x}
storms$Basin <- unlist(lapply(storms$Basin, make.true.NA))

str(storms)
# storms2 <- storms[storms$Basin=="NA",]
storms <- storms %>%
  filter(Latitude > -999,                                  # remove missing data
         Longitude > -999,
         Wind.kt > 0,
         !(Name %in% c("UNNAMED", "NONAME:UNNAMED"))) %>%
  mutate(Basin=(gsub(" ", "", Basin)),                       # clean up fields
         ID=paste(Name, Season, sep="."),
         Month=extractMonth(ISO_time),
         Year=extractYear(ISO_time)) %>%
  filter(Season >= 1989, Basin %in% "NA")                  # limit to North Atlantic basin

season_range <- paste(range(storms$Season), collapse=" - ")
knots_range <- range(storms$Wind.kt)

library(data.table)  # faster fread() and better weekdays()
datatable(head(storms))

# setup base plotting parameters (these won't change)
# base <- base + geom_polygon(data=map_data("world"),
#                              aes(x=long, y=lat, group=group),
#                              fill="gray25", colour="gray25", size=0.2)
# base 
library(maps)       # Provides functions that let us plot the maps
library(mapdata)    # Contains the hi-resolution points that mark out the countries.

# worlmap <- data.frame(map('world2Hires',xlim=c(150, 360), ylim = c(0,60),fill=F)[c('x', 'y')])
# base <- ggplot()
# base <- base + geom_polygon(data=worlmap,
#                              aes(x=x, y=y) ,
#                              fill="gray25", colour="gray25", size=0.2)
library(PBSmapping) # SOLUTION FOR map_data with xlim and ylim 
# http://cameron.bracken.bz/finally-an-easy-way-to-fix-the-horizontal-lines-in-ggplot2-mapshttp://cameron.bracken.bz/finally-an-easy-way-to-fix-the-horizontal-lines-in-ggplot2-maps

# plot limits
xlims = c(-110, -20); ylims = c(0,50)

worldmap = map_data("world")
setnames(worldmap, c("X","Y","PID","POS","region","subregion"))
worldmap = clipPolys(worldmap, xlim=xlims,ylim=ylims, keepExtra=TRUE)

base <- ggplot() + geom_polygon(data=worldmap,
                        aes(x=X, y=Y, group=PID),
                        fill="gray25", colour="gray25", size=0.2)
base <- base + scale_color_gradientn(colours=rev(brewer.pal(n=9, name="RdBu")),
                                     space="Lab", limits=knots_range)
base <- base + coord_map()
base <- base + labs(x=NULL, y=NULL, title=NULL, colour = "Wind (knots)")
base <- base + xlim(xlims) + ylim(ylims)
base <- base + theme_bw()
base <- base + theme(text=element_text(family="Arial", face="plain", size=rel(5)),
                     panel.background = element_rect(fill = "gray10", colour = "gray30"),
                     panel.margin = unit(c(0,0), "lines"),
                     panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(),
                     plot.margin = unit(c(0,0,0,0), "lines"),
                     axis.text.x = element_blank(),
                     axis.text.y = element_blank(),
                     axis.ticks = element_blank(),
                     legend.position = c(0.2, 0.1),
                     legend.background = element_rect(fill="gray10", color="gray10"),
                     legend.text = element_text(color="white", size=rel(3.5),angle = 0),
                     legend.title = element_text(color="white", size=rel(5)),
                     legend.direction = "horizontal",
                     legend.key.width = unit(1.2, "cm"))
base 

# loop over each year, producing plot files that accumulate tracks over each month
for (year in unique(storms$Year)) { # loop for years 
  
  storm_ids <- unique(storms[storms$Year==year,]$ID)

  for (i in 1:length(storm_ids)) { # loop over the storms of the year 
    
    storms_yr <- storms %>% filter(Year==year, ID %in% storm_ids[1:i])
    
    message(sprintf("year %s - storm %s", year, storm_ids[i]))
    
    gg <- base
    gg <- gg + geom_path(data=storms_yr,
                         aes(x=Longitude, y=Latitude, group=ID, colour=Wind.kt),
                         size=2.0, alpha=2/4)
    gg <- gg + geom_text(label=year, aes(x=-108, y=50), size=rel(7), color="white", vjust=1)
    gg <- gg + geom_text(label=paste(gsub(".[[:digit:]]+$", "", storm_ids[1:i]), collapse="\n"),
                         aes(x=-108, y=48), size=rel(4.5), color="white", vjust=1,hjust=0)
    
    # change "quartz" to "cairo" if you're not on OS X
    # gg 
    png(filename=sprintf("./output/%s%03d.png", year, i),
        width=1020, height=800, type="cairo", bg="gray25")
    print(gg)
    dev.off()
  }
}

# convert to mp4 animation - needs imagemagick
# sudo port install ImageMagick
Sys.setenv(PATH=paste("/opt/local/bin", Sys.getenv("PATH"), sep=":") )
system("convert -delay 8 output/*png output/hurr-1.mp4")

# unlink("output/*png") # do this after verifying convert works
# file.remove(list.files(pattern=".png"))

# take an alternate approach for accumulating the entire hurricane history
# start with the base, but add to the ggplot object in a loop, which will
# accumulate all the tracks.

gg <- base
#lagy <- lagx <-  0 # to move text around
x0 <- -108; y0 <- 50; # initial coordinates for text 
for (year in unique(storms$Year)) {
  
  print(year) 
  storm_ids <- unique(storms[storms$Year==year,]$ID)
  
  #x0 <- x0+lagx; 
  #gg <- gg + geom_text(label=year, aes(x=x0, y=y0), size=rel(7), color="white") #, vjust=1,,hjust=0)
  #y0 <- y0+lagy
  #lagy <- lagy-2
  #if (y0<30) {
  #  lagx  <- lagx +2; y0 <- -50
  #} # reset position of text 
  
  for (i in 1:length(storm_ids)) {
    
    storms_yr <- storms %>% filter(ID %in% storm_ids[i])
    
    message(sprintf("year %s - storm %s", year, storm_ids[i]))

    gg <- gg + geom_path(data=storms_yr,
                         aes(x=Longitude, y=Latitude, group=ID, colour=Wind.kt),
                         size=1.4, alpha=1/4,linejoin = "round")
    gg1 <-  gg + geom_text(label=year, aes(x=-108, y=50), size=rel(7), color="white", vjust=1,
                         inherit.aes = FALSE,check_overlap = T)
    #gg <- gg + ggtitle(storms_yr)
    
    png(filename=sprintf("./output2/%s%03d.png", year, i),
        width=1020, height=800, type="cairo", bg="gray25")
    print(gg1)
    dev.off()
  }
}

system("convert -delay 8 output2/*png output2/hurr-2.mp4")
# unlink("output/*png") # do this after verifying convert works
