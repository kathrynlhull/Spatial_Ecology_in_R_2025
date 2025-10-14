# install.packages("sdm")
# install.packages("terra")

library(sdm) #quotations no longer needed 
library(terra)

file <- system.file("external/species.shp", package="sdm")
# [1] "C:/Users/kalih/AppData/Local/R/win-library/4.4/sdm/external/species.shp"

rana <- vect(file)
rana

rana$Occurrence

plot(rana)
pres <- rana[rana$Occurrence==1]

# Exercise: plot in a multiframe the rana dataset beside the pres dataset
par(mfrow=c(1,2))
plot(rana)
plot(pres)
