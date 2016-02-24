# Visualising The Evolution Of Migration Flows With rCharts

# https://aschinchon.wordpress.com/2015/10/19/visualising-the-evolution-of-migration-flows-with-rcharts/

# Obtaining top 20 countries of the world according to % of migrants respect its population
# To do this, I divide total number of migrants between 1960 and 2009 by the mean population in the same period.
# I do the same to obtain top 20 countries of the world according to % of immigrants.
# In both cases, I only consider countries with population greater than 2 million.
# For these countries, I calculate % of migrants in each decade (60’s, 70’s, 80’s, 90’s and 00’s), dividing total number of migrants by mean population each decade
# I do the same in the case of immigrants.
# Instead of representing directly % of migrants and immigrants, I represent the ranking of countries according these indicators by decade

library(data.table)
library(rCharts)
library(dplyr)
setwd("YOUR WORKING DIRECTORY HERE")
populflows = read.csv(file="enigma-org.worldbank.migration-remittances.migrants.migration-flow-c57405e33412118c8757b1052e8a1490.csv", stringsAsFactors=FALSE)
population = fread("enigma-org.worldbank.hnp.data-eaa31d1a34fadb52da9d809cc3bec954.csv")
population %>% 
  filter(indicator_name=="Population, total") %>% 
  as.data.frame %>% 
  mutate(decade=(year-year%%10)) %>% 
  group_by(country_name, country_code, decade) %>% 
  summarise(population=mean(value)) %>% 
  plyr::rename(., c("country_name"="country")) -> population2
populflows %>% filter(!is.na(total_migrants)) %>% 
  group_by(migration_year, destination_country) %>% 
  summarise(inmigrants = sum(total_migrants))  %>% 
  plyr::rename(., c("destination_country"="country", "migration_year"="decade"))   -> inmigrants
populflows %>% filter(!is.na(total_migrants)) %>% 
  group_by(migration_year, country_of_origin) %>% 
  summarise(migrants = sum(total_migrants)) %>%  
  plyr::rename(., c("country_of_origin"="country", "migration_year"="decade"))   -> migrants
# Join of data sets
migrants %>% 
  merge(inmigrants, by = c("country", "decade")) %>%
  merge(population2, by = c("country", "decade")) %>%
  mutate(p_migrants=migrants/population, p_inmigrants=inmigrants/population) -> populflows2
# Global Indicators
populflows2 %>% 
  group_by(country) %>% 
  summarise(migrants=sum(migrants), inmigrants=sum(inmigrants), population=mean(population)) %>% 
  mutate(p_migrants=migrants/population, p_inmigrants=inmigrants/population)  %>% 
  filter(population > 2000000)  %>%
  mutate(rank_migrants = dense_rank(desc(p_migrants)), rank_inmigrants = dense_rank(desc(p_inmigrants))) -> global
# Migrants dataset
global %>% 
  filter(rank_migrants<=20) %>% 
  select(country) %>% 
  merge(populflows2, by = "country") %>% 
  arrange(decade, p_migrants) %>%
  mutate(decade2=as.numeric(as.POSIXct(paste0(as.character(decade), "-01-01"), origin="1900-01-01"))) %>%
  plyr::ddply("decade", transform, rank = dense_rank(p_migrants)) -> migrants_rank
# Migrants dataset
global %>% 
  filter(rank_inmigrants<=20) %>% 
  select(country) %>% 
  merge(populflows2, by = "country") %>% 
  arrange(decade, p_inmigrants) %>%
  mutate(decade2=as.numeric(as.POSIXct(paste0(as.character(decade), "-01-01"), origin="1900-01-01"))) %>%
  plyr::ddply("decade", transform, rank = dense_rank(p_inmigrants)) -> inmigrants_rank
# Function for plotting
plotBumpChart <- function(df){
  bump_chart = Rickshaw$new()
  mycolors = ggthemes::tableau_color_pal("tableau20")(20)
  bump_chart$layer(rank ~ decade2, group = 'country_code', data = df, type = 'line', interpolation = 'none', colors = mycolors)
  bump_chart$set(slider = TRUE, highlight = TRUE, legend=TRUE)
  bump_chart$yAxis(tickFormat = "#!  function(y) { if (y == 0) { return '' } else { return String((21-y)) } } !#")
  bump_chart$hoverDetail(yFormatter = "#! function(y){return (21-y)} !#")
  return(bump_chart)
}
plotBumpChart(migrants_rank)
plotBumpChart(inmigrants_rank)
