# https://www.gislounge.com/mapping-county-demographic-data-in-r/
# Mapping County Demographic Data in R

install.packages(c("choroplethr", "choroplethrMaps")) 
library(choroplethr)
library(choroplethrMaps)

# create a simple map 
data(df_pop_county) 
head(df_pop_county) 
# regions are county fips codes 

county_choropleth(df_pop_county)
# add title and legend 
county_choropleth(df_pop_county,
                  title ="2012County Population Estimates", 
                  legend = "Population")

# change colors 
county_choropleth(df_pop_county,
                  title = "2012 State Population Estimates",
                  legend = "Population", 
                  num_colors = 2)

county_choropleth(df_pop_county,
                  title = "2012 County Population Estimates",
                  legend = "Population", 
                  num_colors = 1) # 1 color = a continous scale 

# more demographics 
data("df_county_demographics")
colnames(df_county_demographics)


# maps the value column 
df_county_demographics$value = df_county_demographics$percent_white 
county_choropleth(df_county_demographics,
                  title = "2013 County Demographics\nPercent White", 
                  legend = "Percent White")


