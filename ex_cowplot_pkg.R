#
# introduction to cowplot 
# https://cran.r-project.org/web/packages/cowplot/vignettes/introduction.html
#

data(cars)
library(ggplot2)
# original ggplot 
ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) + 
        geom_point(size = 2.5)

require(cowplot)
plot.mpg <- ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) + 
        geom_point(size=2.5)
print(plot.mpg) 
# use save_plot() instead of ggsave() when using cowplot
save_plot("mpg.pdf", plot.mpg,
          base_aspect_ratio = 1.3 # make room for figure legend
)

# to add grid 
plot.mpg + background_grid(major = "xy", minor = "none")

plot.mpg + theme_gray() # create plot with default ggplot2 theme
theme_set(theme_gray()) # switch to default ggplot2 theme for good

# arranging graphs into a grid 
plot.mpg <- ggplot(mpg, aes(x = cty, y = hwy, colour = factor(cyl))) + 
        geom_point(size=2.5)
plot.mpg

plot.diamonds <- ggplot(diamonds, aes(clarity, fill = cut)) + geom_bar() +
        theme(axis.text.x = element_text(angle=70, vjust=0.5))
plot.diamonds

plot_grid(plot.mpg, plot.diamonds, labels = c("A", "B"))
plot_grid(plot.mpg, plot.diamonds, labels = c("A", "B"), align = "h")
plot_grid(plot.mpg, NULL, NULL, plot.diamonds, labels = c("A", "B", "C", "D"), ncol = 2)
plot_grid(plot.mpg, plot.diamonds, labels = c("A", "B"), nrow = 2, align = "v")

plot2by2 <- plot_grid(plot.mpg, NULL, NULL, plot.diamonds,
                      labels=c("A", "B", "C", "D"), ncol = 2)
save_plot("plot2by2.pdf", plot2by2,
          ncol = 2, # we're saving a grid plot of 2 columns
          nrow = 2, # and 2 rows
          # each individual subplot should have an aspect ratio of 1.3
          base_aspect_ratio = 1.3
)

# Generic plot annotations
ggdraw(plot.mpg) + 
        draw_plot_label("A", size = 14) + 
        draw_label("DRAFT!", angle = 45, size = 80, alpha = .2)

t <- (0:1000)/1000
spiral <- data.frame(x = .45+.55*t*cos(t*15), y = .55-.55*t*sin(t*15), t)
ggdraw(plot.mpg) + 
        geom_path(data = spiral, aes(x = x, y = y, colour = t), size = 6, alpha = .4)

boxes <- data.frame(
        x = sample((0:36)/40, 40, replace = TRUE),
        y = sample((0:32)/40, 40, replace = TRUE)
)
# plot on top of annotations
ggdraw() + 
        geom_rect(data = boxes, aes(xmin = x, xmax = x + .15, ymin = y, ymax = y + .15),
                  colour = "gray60", fill = "gray80") +
        draw_plot(plot.mpg) +
        draw_label("Plot is on top of the grey boxes", x = 1, y = 1,
                   vjust = 1, hjust = 1, size = 10, fontface = 'bold')

# plot below annotations
ggdraw(plot.mpg) + 
        geom_rect(data = boxes, aes(xmin = x, xmax = x + .15, ymin = y, ymax = y + .15),
                  colour = "gray60", fill = "gray80") + 
        draw_label("Plot is underneath the grey boxes", x = 1, y = 1,
                   vjust = 1, hjust = 1, size = 10, fontface = 'bold')

# place graphs at arbitrary locations and sizes 
plot.iris <- ggplot(iris, aes(Sepal.Length, Sepal.Width)) + 
        geom_point() + facet_grid(. ~ Species) + stat_smooth(method = "lm") +
        background_grid(major = 'y', minor = "none") + # add thin horizontal lines 
        panel_border() # and a border around each panel
# plot.mpg and plot.diamonds were defined earlier
ggdraw() +
        draw_plot(plot.iris, 0, .5, 1, .5) +
        draw_plot(plot.mpg, 0, 0, .5, .5) +
        draw_plot(plot.diamonds, .5, 0, .5, .5) +
        draw_plot_label(c("A", "B", "C"), c(0, 0, 0.5), c(1, 0.5, 0.5), size = 15)

# The functions background_grid() and panel_border() are convenience functions 
# defined by cowplot to save some typing when manipulating the background grid 
# and panel border.

