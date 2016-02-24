install.packages("classInt")
library("classInt")
data(jenks71)
pal1 <- c("wheat1", "red3")
opar <- par(mfrow=c(2,3))

intervals=classIntervals(jenks71$jenks71, n=5, style="fixed",
                         fixedBreaks=c(15.57, 25, 50, 75, 100, 155.30))
intervals
plot(intervals, pal=pal1, main="Fixed")
plot(classIntervals(jenks71$jenks71, n=5, style="sd"), pal=pal1, main="Pretty standard deviations")
plot(classIntervals(jenks71$jenks71, n=5, style="equal"), pal=pal1, main="Equal intervals")
plot(classIntervals(jenks71$jenks71, n=5, style="quantile"), pal=pal1, main="Quantile")

set.seed(1)
plot(classIntervals(jenks71$jenks71, n=5, style="kmeans"), pal=pal1, main="K-means")
plot(classIntervals(jenks71$jenks71, n=5, style="hclust", method="complete"),
     pal=pal1, main="Complete cluster")
plot(classIntervals(jenks71$jenks71, n=5, style="hclust", method="single"),
     pal=pal1, main="Single cluster")
plot(classIntervals(jenks71$jenks71, n=5, style="jenks"),
     pal=pal1, main="JENKS")

classIntervals(jenks71$jenks71, n=5, style="jenks")


plot(intervals,pal = palette())


library(RColorBrewer)
par(mar = c(1, 4, 1, 1))
display.brewer.all()
pal2=brewer.pal(10,name = "Spectral")
plot(intervals,pal = pal2,main="TITLE")
