# quantile colorpalette 
# http://geotheory.co.uk/blog/2014/02/07/visualising-topography/

breaks = quantile(volcano, seq(0, 1, length.out=256))
cols = colorRampPalette(c("#55FFFF", "grey10"))(255)
par(mfrow = c(1, 2))
image(volcano, col=cols, axes=F, asp=T)
title(main = "Linear")
image(volcano, col=cols, breaks=breaks, axes=F, asp=T)
title(main = "Quantile")
