
# https://cran.r-project.org/web/packages/tmap/vignettes/tmap-nutshell.html

library(tmap)

qtm(Europe)
qtm(Europe, fill="well_being", text="iso_a3", text.size="AREA", format="Europe", style="gray", 
    text.root=5, fill.title="Well-Being Index", fill.textNA="Non-European countries")

tm_shape(Europe) +
        tm_polygons("well_being", textNA="Non-European countries", title="Well-Being Index") +
        tm_text("iso_a3", size="AREA", root=5) + 
        tm_format_Europe() +
        tm_style_grey()

data(land, rivers, metro)

tm_shape(land) + 
        tm_raster("trees", breaks=seq(0, 100, by=20), legend.show = FALSE) +
        tm_shape(Europe, is.master = TRUE) +
        tm_borders() +
        tm_shape(rivers) +
        tm_lines(lwd="strokelwd", scale=5, legend.lwd.show = FALSE) +
        tm_shape(metro) +
        tm_bubbles("pop2010", "red", border.col = "black", border.lwd=1, 
                   size.lim = c(0, 11e6), sizes.legend = c(1e6, 2e6, 4e6, 6e6, 10e6), 
                   title.size="Metropolitan Population") +
        tm_text("name", size="pop2010", scale=1, root=4, size.lowerbound = .6, 
                bg.color="white", bg.alpha = .75, 
                auto.placement = 1, legend.size.show = FALSE) + 
        tm_format_Europe() +
        tm_style_natural()

# By assigning multiple values to at least one of the aesthetic arguments:
tm_shape(Europe) +
        tm_polygons(c("HPI", "gdp_cap_est"), 
                    style=c("pretty", "kmeans"),
                    palette=list("RdYlGn", "Purples"),
                    auto.palette.mapping=FALSE,
                    title=c("Happy Planet Index", "GDP per capita")) +
        tm_format_Europe() + 
        tm_style_grey()

tm_shape(metro) +
        tm_bubbles(size=c("pop1970", "pop2020"), title.size="Population") +
        tm_facets(free.scales=FALSE) +
        tm_layout(panel.labels=c("1970", "2020"))

# By defining a group-by variable in tm_facets:
tm_shape(Europe) +
        tm_polygons("well_being", title="Well-Being Index") +
        tm_facets("part") +
        tm_style_grey()

tm_shape(Europe[Europe$continent=="Europe",]) +
        tm_fill("part", legend.show = FALSE) +
        tm_facets("name", free.coords=TRUE, drop.units=TRUE)

#### MAP LAYOUT 

data(land)
data(World)
pal8 <- c("#33A02C", "#B2DF8A", "#FDBF6F", "#1F78B4", "#999999", "#E31A1C", "#E6E6E6", "#A6CEE3")
tm_shape(land, ylim = c(-88,88), relative=FALSE) +
        tm_raster("cover_cls", palette = pal8, title="Global Land Cover", legend.hist=TRUE, legend.hist.z=0) +
        tm_shape(World) +
        tm_borders() +
        tm_format_World(inner.margins=0) +
        tm_legend(text.size=1,
                  title.size=1.2,
                  position = c("left","bottom"), 
                  bg.color = "white", 
                  bg.alpha=.2, 
                  frame="gray50", 
                  height=.6, 
                  hist.width=.2,
                  hist.height=.2, 
                  hist.bg.color="gray60", 
                  hist.bg.alpha=.5)

data("Europe")
head(Europe@data) 

qtm(Europe, style="natural", title="Natural style") # equivalent to: qtm(Europe) + tm_style_natural(title="Natural style")
qtm(Europe, style="cobalt", title="Cobalt style") # equivalent to: qtm(Europe) + tm_style_cobalt(title="Cobalt style")

# make a categorical map
qtm(Europe, fill="economy", title=paste("Style:", tmap_style()))
## current tmap style is "white

# change to color-blind-friendly style
current_style <- tmap_style("col_blind")
## tmap style set to "col_blind"

# make a categorical map
qtm(Europe, fill="economy", title=paste("Style:", tmap_style()))
## current tmap style is "col_blind"

# change back
tmap_style(current_style)
## tmap style set to "white"

(tm <- qtm(World) +
        tm_layout(outer.margins=c(.05,0,.05,0), 
                  inner.margins=c(0,0,.02,0), asp=0))
tm + tm_layout(design.mode=TRUE)

tm_shape(land, projection="eck4") +
        tm_raster("elevation", breaks=c(-Inf, 250, 500, 1000, 1500, 2000, 2500, 3000, 4000, Inf),  
                  palette = terrain.colors(9), title="Elevation", auto.palette.mapping=FALSE) +
        tm_shape(World) +
        tm_borders("grey20") +
        tm_grid(projection="longlat", labels.size = .5) +
        tm_text("name", size="AREA") +
        tm_compass(position = c(.65, .15), color.light = "grey90") +
        tm_credits("Eckert IV projection", position = c(.85, 0)) +
        tm_style_classic(inner.margins=c(.04,.03, .02, .01), legend.position = c("left", "bottom"), 
                         legend.frame = TRUE, bg.color="lightblue", legend.bg.color="lightblue", 
                         earth.boundary = TRUE, space.color="grey90")


#### SAVING MAPS 
tm <- tm_shape(World) +
        tm_fill("well_being", id="name", title="Well-being") +
        tm_format_World()
save_tmap(tm, "World_map.png", width=1920, height=1080)

# IN HTML 
save_tmap(tm, "World_map.html")

# See vignette("tmap-modes") for more on interactive maps.

###### Tips n’ tricks
# Selections can be made by treating the data.frame of the shape object:
tm_shape(Europe[Europe$name=="Austria", ]) +
        tm_polygons()

# a manual legend 
data(World)

tm_shape(World) +
        tm_fill() +
        tm_shape(rivers) +
        tm_lines(col="dodgerblue3") +
        tm_add_legend(type="line", col="dodgerblue3", title="World map") +
        tm_format_World()

# Arugments of the bounding box function bb can be passed directly to tm_shape:
tm_shape(World, bbox = "India") +
        tm_polygons("MAP_COLORS", palette="Pastel2") +
        tm_shape(metro) +
        tm_bubbles("pop2010", title.size = "Population") +
        tm_text("name", size = "pop2010", 
                legend.size.show = FALSE, 
                root=8, size.lowerbound = .7, auto.placement = TRUE)

