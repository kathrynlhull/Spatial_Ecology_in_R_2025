# Spectral indices from satellite images

library(terra)
library(imageRy)
library(viridis)

#Listing files
im.list()

# Importing data
m1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")

#layer 1=NIR, layer 2= red, layer =green
im.plotRGB(m1992, r=1, g=2, b=3)
im.plotRGB(m1992, r=2, g=1, b=3)
im.plotRGB(m1992, r=2, g=3, b=1)  #good to accentuate bare soil, bare soil becomes yellow

# Importing data
m2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")

#layer 1=NIR, layer 2= red, layer =green
im.plotRGB(m2006, r=1, g=2, b=3)
im.plotRGB(m2006, r=2, g=1, b=3)
im.plotRGB(m2006, r=2, g=3, b=1)  #good to accentuate bare soil, bare soil becomes yellow

#1992 to 2006 shows change in forest cover over time.

#DVI 1992 
#100 NIR
#0 red (vegetation, due to high reflectance near infrared (NIR), and absorb completely the red)
#dvi=nir-red =100

#60 NIR
#20 red
#dvi=NIR-red=40

dvi1992<-m1992[[1]] - m1992[[2]] 
dvi2006<-m2006[[1]] - m2006[[2]] 

par(mfrow=c(1,2))
plot(dvi(1992)
plot(dvi2006) 

library(virids)
     
par(mfrow=c(1,2))
plot(dvi(1992,col=inferno(100))
plot(dvi2006,col=inferno(100))

#calculate NDVI
ndvi1992<-im.ndvi(m1992,1,2)


