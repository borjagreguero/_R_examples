# 
# HEATMAPS 
# 
# http://rud.is/projects/facetedheatmaps.html
#
library(data.table)  # faster fread() and better weekdays()
library(dplyr)       # consistent data.frame operations
library(purrr)       # consistent & safe list/vector munging
library(tidyr)       # consistent data.frame cleaning
library(lubridate)   # date manipulation - ymd_hms for time series 
library(countrycode) # turn country codes into pretty names
library(ggplot2)     # base plots are for Coursera professors
library(scales)      # pairs nicely with ggplot2 for plot label formatting
library(gridExtra)   # a helper for arranging individual ggplot objects
library(ggthemes)    # has a clean theme for ggplot2
library(viridis)     # best. color. palette. evar.
library(DT)          # prettier data.frame output
library(RCurl)

x <- getURL("https://raw.github.com/hrbrmstr/facetedcountryheatmaps/data/eventlog.csv")
y <- fread(text = x)

attacks <- tbl_df(fread("./data/eventlog.csv")) # tbl_df {dplyr}
datatable(head(attacks))

make_hr_wkday <- function(cc, ts, tz) {
  real_times <- ymd_hms(ts, tz=tz[1], quiet=TRUE)
  data_frame(source_country=cc, 
             wkday=weekdays(as.Date(real_times, tz=tz[1])),
             hour=format(real_times, "%H", tz=tz[1]))
}

group_by(attacks, tz) %>%
  do(make_hr_wkday(.$source_country, .$timestamp, .$tz)) %>% 
  ungroup() %>% 
  mutate(wkday=factor(wkday,
                      levels=levels(weekdays(0, FALSE)))) -> attacks
datatable(head(attacks))

wkdays <- count(attacks, wkday, hour) # count by days and hours 
datatable(head(wkdays))

gg <- ggplot(wkdays, aes(x=hour, y=wkday, fill=n))
#This does all the hard work. 
# geom_tile() will make tiles at each x&y location we’ve already specified. 
# I knew we had events for every hour, but if you had missing days or hours, you could use tidyr::complete() to fill those in. 
# We’re also telling it to use a thin (0.1 units) white border to separate the tiles.
gg <- gg + geom_tile(color="white", size=0.1)
#  an awesome color scale. Read the viridis package vignette for more info. 
# By specifying a name here, we get a nice label on the legend.
gg <- gg + scale_fill_viridis(name="# Events", label=comma)
# a 1:1 aspect ratio (i.e. geom_tile()–which draws rectangles–will draw nice squares).
gg <- gg + coord_equal()
gg <- gg + labs(x=NULL, y=NULL, title="Events per weekday & time of day")

# makes the plot look really nice. I customize a number of theme elements, 
# starting with a base theme of theme_tufte() from the ggthemes package.
# It removes alot of chart junk without having to do it manually.
gg <- gg + theme_tufte(base_family="Helvetica")

#I like my plot titles left-aligned. For hjust:
# 0 == left
# 0.5 == centered
# 1 == right
gg <- gg + theme(plot.title=element_text(hjust=0))

# We don’t want any tick marks on the axes and I want the text to be slightly smaller than the default.
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(axis.text=element_text(size=7))

# for the legend, adjust 
gg <- gg + theme(legend.title=element_text(size=8))
gg <- gg + theme(legend.text=element_text(size=6))
gg

# rank-order the countries and want nice country names versus 2-letter abbreviations. 
# We’ll do that first:
count(attacks, source_country) %>% 
  mutate(percent=percent(n/sum(n)), count=comma(n)) %>% 
  mutate(country=sprintf("%s (%s)",
                         countrycode(source_country, "iso2c", "country.name"),
                         source_country)) %>% 
  arrange(desc(n)) -> events_by_country

datatable(events_by_country[,5:3])

# we’ll do a simple ggplot facet, but also exclude the top 2 attacking countries since they skew things 
filter(attacks, source_country %in% events_by_country$source_country[3:12]) %>% 
  count(source_country, wkday, hour) %>% 
  ungroup() %>% 
  left_join(events_by_country[,c(1,5)]) %>% 
  complete(country, wkday, hour, fill=list(n=0)) %>% 
  mutate(country=factor(country,
                        levels=events_by_country$country[3:12])) -> cc_heat
# Before we go all crazy and plot, let me explain ^^ a bit. 
#I’m filtering by the top 10 (excluding the top 2) countries, 
# then doing the group/count. 
# I need the pretty country info, so I’m joining that to the result.
# Not all countries attacked every day/hour, so we use that complete() operation
# I mentioned earlier to ensure we have values for all countries for each day/hour 
# combination. Finally, I want to print the heatmaps in order, 
# so I turn the country into an ordered factor.

gg <- ggplot(cc_heat, aes(x=hour, y=wkday, fill=n))
gg <- gg + geom_tile(color="white", size=0.1)
gg <- gg + scale_fill_viridis(name="# Events")
gg <- gg + coord_equal()
gg <- gg + facet_wrap(~country, ncol=2)
gg <- gg + labs(x=NULL, y=NULL, title="Events per weekday & time of day by country\n")

gg <- gg + theme_tufte(base_family="Helvetica")
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(axis.text=element_text(size=5))
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(plot.title=element_text(hjust=0))
gg <- gg + theme(strip.text=element_text(hjust=0))
gg <- gg + theme(panel.margin.x=unit(0.5, "cm"))
gg <- gg + theme(panel.margin.y=unit(0.5, "cm"))

gg <- gg + theme(legend.title=element_text(size=6))
gg <- gg + theme(legend.title.align=1)
gg <- gg + theme(legend.text=element_text(size=6))
gg <- gg + theme(legend.position="bottom")
gg <- gg + theme(legend.key.size=unit(0.2, "cm"))
gg <- gg + theme(legend.key.width=unit(1, "cm"))
gg

# To get individual scales for each country we need to make 
# n separate ggplot object and combine then using gridExtra::grid.arrange.
count(attacks, source_country, wkday, hour) %>% # this time for all countries, no filter
  ungroup() %>% 
  left_join(events_by_country[,c(1,5)]) %>% 
  complete(country, wkday, hour, fill=list(n=0)) %>% 
  mutate(country=factor(country,
                        levels=events_by_country$country)) -> cc_heat2

# one plot for each with lapply 
lapply(events_by_country$country[1:16], function(cc) {
  gg <- ggplot(filter(cc_heat2, country==cc),  # filter each country 
               aes(x=hour, y=wkday, fill=n, frame=country))
  gg <- gg + geom_tile(color="white", size=0.1)
  gg <- gg + scale_x_discrete(expand=c(0,0))
  gg <- gg + scale_y_discrete(expand=c(0,0))
  gg <- gg + scale_fill_viridis(name="")
  gg <- gg + coord_equal()
  gg <- gg + labs(x=NULL, y=NULL, 
                  title=sprintf("%s", cc))
  gg <- gg + theme_tufte(base_family="Helvetica")
  gg <- gg + theme(axis.ticks=element_blank())
  gg <- gg + theme(axis.text=element_text(size=5))
  gg <- gg + theme(panel.border=element_blank())
  gg <- gg + theme(plot.title=element_text(hjust=0, size=6))
  gg <- gg + theme(panel.margin.x=unit(0.5, "cm"))
  gg <- gg + theme(panel.margin.y=unit(0.5, "cm"))
  gg <- gg + theme(legend.title=element_text(size=6))
  gg <- gg + theme(legend.title.align=1)
  gg <- gg + theme(legend.text=element_text(size=6))
  gg <- gg + theme(legend.position="bottom")
  gg <- gg + theme(legend.key.size=unit(0.2, "cm"))
  gg <- gg + theme(legend.key.width=unit(1, "cm"))
  gg
}) -> cclist

# make grid of plots 
cclist[["ncol"]] <- 2
do.call(grid.arrange, cclist)



