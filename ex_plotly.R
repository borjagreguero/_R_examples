
library(plotly)
set.seed(100)
d <- diamonds[sample(nrow(diamonds), 1000), ]
head(d) 
plot_ly(d, x = carat, y = price, text = paste("Clarity: ", clarity),
        mode = "markers", color = carat, size = carat)

library(ggplot2)
p <- ggplot(data = d, aes(x = carat, y = price)) +
  geom_point(aes(text = paste("Clarity:", clarity)), size = 4) +
  geom_smooth(aes(colour = cut, fill = cut)) + facet_wrap(~ cut)

gg <- ggplotly(p)

p <- plot_ly(economics, x = date, y = uempmed, name = "unemployment")

# add shapes to the layout
p <- layout(p, title = 'Highlighting with Rectangles', 
            shapes = list(
              list(type = "rect", 
                   fillcolor = "blue", line = list(color = "blue"), opacity = 0.3, 
                   x0 = "1980-01-01", x1 = "1985-01-01", xref = "x", 
                   y0 = 4, y1 = 12.5, yref = "y"), 
              list(type = "rect",
                   fillcolor = "blue", line = list(color = "blue"), opacity = 0.2, 
                   x0 = "2000-01-01", x1 = "2005-01-01", xref = "x", 
                   y0 = 4, y1 = 12.5, yref = "y"))) 

# This allows us to mix data manipulation and visualization verbs in a pure(ly) functional, predictable and pipeable manner. Here, we take advantage of dplyr's filter() verb to label the highest peak in the time series:
p %>%
  add_trace(y = fitted(loess(uempmed ~ as.numeric(date)))) %>%
  layout(title = "Median duration of unemployment (in weeks)",
         showlegend = FALSE) %>%
  dplyr::filter(uempmed == max(uempmed)) %>%
  layout(annotations = list(x = date, y = uempmed, text = "Peak", showarrow = T))

# plotly visualizations don't actually require a data frame. This makes chart types that accept a z argument especially easy to use if you have a numeric matrix:
plot_ly(z = volcano, type = "surface")


###### United States Bubble Map
library(plotly)
df <- read.csv('https://raw.githubusercontent.com/plotly/datasets/master/2014_us_cities.csv')
df$hover <- paste(df$name, "Population", df$pop/1e6, " million")

df$q <- with(df, cut(pop, quantile(pop)))
levels(df$q) <- paste(c("1st", "2nd", "3rd", "4th", "5th"), "Quantile")
df$q <- as.ordered(df$q)
head(df) 

g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showland = TRUE,
  landcolor = toRGB("gray85"),
  subunitwidth = 1,
  countrywidth = 1,
  subunitcolor = toRGB("white"),
  countrycolor = toRGB("white")
)

plot_ly(df, lon = lon, lat = lat, text = hover,
        marker = list(size = sqrt(pop/10000) + 1),
        color = q, type = 'scattergeo', locationmode = 'USA-states') %>%
  layout(title = '2014 US city populations<br>(Click legend to toggle)', geo = g)
