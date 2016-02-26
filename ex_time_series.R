# TIME SERIES
# https://2780fa3c-a-62cb3a1a-s-sites.googlegroups.com/site/rdatamining/docs/RDataMining-slides-time-series-analysis.pdf?attachauth=ANoY7crU-HBijes7nziqQ8MYlMSCfVtrmiVh_KEsKYzMvGi84FSp9ky46YtCBXW5J9IdGuHr0lAM1PdwqPPEAXvNz3g2ZctxfyW2QE4KOIfPVotn8_BHneiom4tyWDd2mezjpfrmeh81L1leDZB7Ovt0X4iO_LejWtXJUXi-8uf-TQD4t9Va_xbAYQnORYEx9dLR_b38_58KG2tIsQ37V9micVRcfKv7yhpjtidBP1UWuPSsSEVJwWKuklDJBR2w97hOeoqMk0B3&attredirects=0
#
# class ts
# represents data which has been sampled at equispaced points in time
# frequency=7: a weekly series
# frequency=12: a monthly series
# frequency=4: a quarterly series
a <- ts(1:20, frequency = 12, start = c(2011, 3))
print(a)
str(a)
attributes(a)

# Time Series Decomposition -> trend, seasonal, cyclical, irregular 
plot(AirPassengers)

apts <- ts(AirPassengers, frequency = 12)
f <- decompose(apts)
plot(f$figure, type = "b") # seasonal figures

plot(f)

# Time Series Forecasting
# Autoregressive moving average (ARMA)
# Autoregressive integrated moving average (ARIMA)

# build an ARIMA model
fit <- arima(AirPassengers, order = c(1, 0, 0), 
             list(order = c(2,1, 0), period = 12))
fore <- predict(fit, n.ahead = 24)

# error bounds at 95% confidence level 
U <- fore$pred + 2 * fore$se
L <- fore$pred - 2 * fore$se
ts.plot(AirPassengers, fore$pred, U, L,
        col = c(1, 2, 4, 4), lty = c(1, 1, 2, 2))
legend("topleft", col = c(1, 2, 4), lty = c(1, 1, 2),
       c("Actual", "Forecast", "Error Bounds (95% Confidence)"))


# Time Series Clustering
#     Dynamic Time Warping (DTW)
#         DTW finds optimal alignment between two time series.
library(dtw)
idx <- seq(0, 2 * pi, len = 100)
a <- sin(idx) + runif(100)/10
b <- cos(idx)
align <- dtw(a, b, step = asymmetricP1, keep = T)
dtwPlotTwoWay(align)

