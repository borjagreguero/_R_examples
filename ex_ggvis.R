# https://campus.datacamp.com/courses/ggvis-data-visualization-r-tutorial/chapter-one-the-grammar-of-graphics?ex=2

# Load the ggvis package
library(ggvis)

# Change the code below to plot the disp variable of mtcars on the x axis
mtcars %>% ggvis(~disp, ~mpg) %>% layer_points()

# The ggvis packages is loaded into the workspace already

# Change the code below to make a graph with red points
mtcars %>% ggvis(~wt, ~mpg, fill := "red") %>% layer_points()

# Change the code below draw smooths instead of points
mtcars %>% ggvis(~wt, ~mpg) %>% layer_smooths()

# Change the code below to make a graph containing both points and a smoothed summary line
mtcars %>% ggvis(~wt, ~mpg) %>% layer_points() %>% layer_smooths()

# with fill 
mtcars %>% ggvis(~mpg, ~wt, fill = ~cyl)
mtcars %>% ggvis(~wt, ~mpg) %>% layer_points() %>% layer_lines()
mtcars %>% ggvis(~wt, ~mpg) %>% layer_bars() 

# Adapt the code: show bars instead of points
pressure %>% ggvis(~temperature, ~pressure) %>% layer_bars()

# Adapt the codee: show lines instead of points
pressure %>% ggvis(~temperature, ~pressure) %>% layer_lines()

# Extend the code: map the fill property to the temperature variable
pressure %>% ggvis(~temperature, ~pressure, fill=~temperature) %>% layer_points()

# Extend the code: map the size property to the pressure variable
pressure %>% ggvis(~temperature, ~pressure, size= ~pressure) %>% layer_points()

faithful %>% 
        ggvis(~waiting, ~eruptions, fill := "red") %>% 
        layer_points() %>% 
        add_axis("y", title = "Duration of eruption (m)", 
                 values = c(2, 3, 4, 5), subdivide = 9) %>% 
        add_axis("x", title = "Time since previous eruption (m)")


library(dplyr)
mtcars %>%
        ggvis(x = ~mpg, y = ~disp) %>%
        mutate(disp = disp / 61.0237) %>% # convert engine displacment to litres
        layer_points()

mtcars %>% ggvis(~mpg, ~disp, stroke = ~vs) %>% layer_points()
mtcars %>% ggvis(~mpg, ~disp, fill = ~vs) %>% layer_points()
mtcars %>% ggvis(~mpg, ~disp, size = ~vs) %>% layer_points()
mtcars %>% ggvis(~mpg, ~disp, shape = ~factor(cyl)) %>% layer_points()
mtcars %>% ggvis(~wt, ~mpg, fill := "red", stroke := "black") %>% layer_points()
mtcars %>% ggvis(~wt, ~mpg, size := 300, opacity := 0.4) %>% layer_points()
mtcars %>% ggvis(~wt, ~mpg, shape := "cross") %>% layer_points()

mtcars %>% 
        ggvis(~wt, ~mpg, 
              size := input_slider(10, 100),
              opacity := input_slider(0, 1)
        ) %>% 
        layer_points()

mtcars %>% 
        ggvis(~wt) %>% 
        layer_histograms(width =  input_slider(0, 2, step = 0.10, label = "width"),
                         center = input_slider(0, 2, step = 0.05, label = "center"))

keys_s <- left_right(10, 1000, step = 50)
mtcars %>% ggvis(~wt, ~mpg, size := keys_s, opacity := 0.5) %>% layer_points()

mtcars %>% ggvis(~wt, ~mpg) %>% 
        layer_points() %>% 
        add_tooltip(function(df) df$wt)

# paths and polygons 
df <- data.frame(x = 1:10, y = runif(10))
df %>% ggvis(~x, ~y) %>% layer_paths()

t <- seq(0, 2 * pi, length = 100)
df <- data.frame(x = sin(t), y = cos(t))
df %>% ggvis(~x, ~y) %>% layer_paths(fill := "red")

df <- data.frame(x = 1:10, y = runif(10))
df %>% ggvis(~x, ~y) %>% layer_ribbons()

df %>% ggvis(~x, ~y + 0.1, y2 = ~y - 0.1) %>% layer_ribbons()

set.seed(1014)
df <- data.frame(x1 = runif(5), x2 = runif(5), y1 = runif(5), y2 = runif(5))
df %>% ggvis(~x1, ~y1, x2 = ~x2, y2 = ~y2, fillOpacity := 0.1) %>% layer_rects()

df <- data.frame(x = 3:1, y = c(1, 3, 2), label = c("a", "b", "c"))
df %>% ggvis(~x, ~y, text := ~label) %>% layer_text()

df %>% ggvis(~x, ~y, text := ~label) %>% layer_text(fontSize := 50)

df %>% ggvis(~x, ~y, text := ~label) %>% layer_text(angle := 45)

t <- seq(0, 2 * pi, length = 20)
df <- data.frame(x = sin(t), y = cos(t))
df %>% ggvis(~x, ~y) %>% layer_paths()

df %>% ggvis(~x, ~y) %>% arrange(x) %>% layer_paths()

mtcars %>% ggvis(~mpg) %>% layer_histograms()

# INTERACTIVE PLOTS 

mtcars %>% ggvis(x = ~wt) %>%
        layer_densities(
                adjust = input_slider(.1, 2, value = 1, step = .1, label = "Bandwidth adjustment"),
                kernel = input_select(
                        c("Gaussian" = "gaussian",
                          "Epanechnikov" = "epanechnikov",
                          "Rectangular" = "rectangular",
                          "Triangular" = "triangular",
                          "Biweight" = "biweight",
                          "Cosine" = "cosine",
                          "Optcosine" = "optcosine"),
                        label = "Kernel")
        )

mtcars %>% ggvis(~wt, ~mpg) %>%
        layer_points(size := input_slider(100, 1000, label = "black")) %>%
        layer_points(fill := "red", size := input_slider(100, 1000, label = "red"))

#