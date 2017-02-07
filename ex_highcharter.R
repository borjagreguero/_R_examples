
library(highcharter)
library(dplyr)

rainfall <- data.frame(date = as.Date(rep(c("2000-01-01", "2000-01-02", "2000-01-03", "2000-01-04"), 2), "%Y-%m-%d"), 
                       value = c(13.2, 9.5, 7.3, 0.2, 150, 135, 58, 38), 
                       variable = c(rep("rain", 4), rep("discharge", 4)))

rainfall 

hc <- highchart() %>% 
        hc_yAxis_multiples(list(title = list(text = "rainfall depth (mm)"), reversed = TRUE), 
                           list(title = list(text = "flow (m3/s)"), 
                                opposite = TRUE)) %>% 
        hc_add_series(data = filter(rainfall, variable == "rain") %>% mutate(value = -value) %>% .$value, type = "column") %>% 
        hc_add_series(data = filter(rainfall, variable == "discharge") %>% .$value, type = "spline", yAxis = 1) %>% 
        hc_xAxis(categories = rainfall$date, title = list(text = "date"))
hc

hc <- highchart() %>% 
        hc_yAxis_multiples(list(title = list(text = "rainfall depth (mm)"), reversed = FALSE), 
                           list(title = list(text = "flow (m3/s)"), 
                                opposite = TRUE)) %>% 
        hc_add_series(data = filter(rainfall, variable == "rain") %>% mutate(value = -value) %>% .$value, type = "column") %>% 
        hc_add_series(data = filter(rainfall, variable == "discharge") %>% .$value, type = "spline", yAxis = 1) %>% 
        hc_xAxis(categories = rainfall$date, title = list(text = "date"))
hc


#  WITH GGPLOT2 
library(ggplot2) 
ggplot() + 
        facet_grid(variable ~ ., scales = "free", switch = "y", labeller = labeller(variable = c("rain" = "rainfall depth (mm)", "discharge" = "flow m3/s"))) + 
        geom_col(data = filter(rainfall, variable == "rain"), aes(date, value), fill = "skyblue3") + 
        theme_bw() + 
        geom_line(data = filter(rainfall, variable == "discharge"), aes(date, value)) +
        labs(title = "A rainfall hyetograph and streamflow hydrograph") 

