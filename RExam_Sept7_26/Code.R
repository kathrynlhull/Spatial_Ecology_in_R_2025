# EXAM_07/09/2026 - WAIPAROUS CREEK BASIN, ALBERTA, CANADA, LAND USE CHANGE SATELLITE IMAGERY ANALYSIS
# Spatial Ecology in R 
# Kathryn Hull

# Below is the complete R code for this project
# Satellite imagery downloaded from GoogleEarth Engine, see related project JavaScript Coding


##  INSTALL R PACKAGES
library(imageRy) #Raster Imagery Operations, Vegetation Indices, Image Classification 
library(terra) #Spatial data analysis with vector and raster data (e.g. satellite imagery, DEM)
library(viridis) #Data visualization, colour maps and built-in palettes, colourblind friendly
library(RStoolbox) #Remote sensing image processing and analysis 
library(ggplot2) #Data visualization, custom aesthetics and geometries of charts 
library(patchwork) #Combines separate ggplot2 plots into a single composite layout

## SET WORKING DIRECTORY
setwd ("C:/Users/kalih/Desktop/Recology/RExam_Images")

## CREATE COMPOSITE TIME SERIES (1985-2022) OF TRUE COLOUR IMAGES
# Visualize individual image in true colour for proofing

# Load the 1985 GeoTIFF exported from GEE
img <- rast("WaiparousBasin_1985MASKEDFINAL.tif")
img

# View band names to ensure you have the right ones
names(img) 
# Expected: "SR_B1", "SR_B2", "SR_B3", "SR_B4", "SR_B5", "SR_B7"(Reference: (Reference: https://www.usgs.gov/faqs/what-are-band-designations-landsat-satellites)
# True Color: R=3, G=2, B=1
# stretch="lin" means “linear stretch” to improve visual contrast and brightness of an image 

plotRGB(img, r=3, g=2, b=1, 
        stretch="lin")
mtext("1985 True Colour", side = 3, line = 0.5, adj = 0.3, font = 2)

# Load the GeoTIFF files
# Make sure these filenames match exactly what you downloaded from Google Drive
wb_1985 <- rast("WaiparousBasin_1985MASKEDFINAL.tif")
wb_2010 <- rast("WaiparousBasin_2010MASKEDFINAL.tif")
wb_2016 <- rast("WaiparousBasin_2016_RawBandsL8CF.tif")
wb_2022 <- rast("WaiparousBasin_2022_RawBandsL8CF.tif")

# Set up the plotting window (2 rows, 2 columns)
par(mfrow = c(2, 2))
# mar = c(bottom, left, top, right)
mar = c(12, 4, 12, 4)

# 4. Plot each year in True Colour
# Landsat 5 TM Bands (1985, 2010): Red=3, Green=2, Blue=1
# Landsat 8 Bands (2016, 2022): Red=4, Green=3, Blue=2 

# 1985
plotRGB(wb_1985, r = 3, g = 2, b = 1, stretch = "lin")
# line = 0.5 puts it slightly above the plot; adj = 0 is left-aligned
mtext("1985 True Colour", side = 3, line =2, adj = 0.15, font = 1.5)

#2010
plotRGB(wb_2010, r = 3, g = 2, b = 1, stretch = "lin")
mtext("2010 True Colour", side = 3, line =2, adj = 0.15, font = 1.5)

# 2016 (Using Landsat 8 band order)
plotRGB(wb_2016, r = 4, g = 3, b = 2, stretch = "lin")
mtext("2016 True Colour", side = 3, line =2, adj = 0.15, font = 1.5)

# 2022 (Using Landsat 8 band order)
plotRGB(wb_2022, r = 4, g = 3, b = 2, stretch = "lin")
mtext("2022 True Colour", side = 3, line =2, adj = 0.15, font = 1.5)

#Print True Colour image composite to PDF
dev.copy2pdf(file="Waiparous Basin 1985 to 2022 True Colour.pdf")
dev.off() #Closes the viewing panel after having saved as PNG file 


##CREATE COMPOSITE TIME SERIES (1985-2022) OF FALSE COLOUR (FC) AND FC SWIR IMAGES
#False colour allows Near-Infrared (NIR) visualization in the red channel. Healthy vegetation appears bright red (chlorophyll reflects NIR strongly). Bare ground appears cyan or light blue.
#SWIR = SHORT WAVE INFRARED.  Water strongly absorbs SWIR light. FC SWIR allows visualization of different vegetation types (e.g.coniferous, deciduous, grassland)

# Set up the plotting window (2 rows, 2 columns)
par(mfrow = c(2, 2))
# mar = c(bottom, left, top, right)
mar = c(12, 4, 12, 4)

# Plot each year in False Colour
# Logic: Red channel = NIR, Green channel = Red, Blue channel = Green
#Dark Red=Dense Mature Forest, Light Red=Grassland/Shrubland/Regenerating Forest, Cyan=Bare Soil/Sand/Gravel/Rocky Terrain

# 1985 (Landsat 5: NIR=B4, Red=B3, Green=B2)
plotRGB(wb_1985, r = 4, g = 3, b = 2, stretch = "lin")
mtext("1985 False Colour", side = 3, line =2, adj = 0.15, font = 1.5)

# 2010 (Landsat 5: NIR=B4, Red=B3, Green=B2)
plotRGB(wb_2010, r = 4, g = 3, b = 2, stretch = "lin")
mtext("2010 False Colour", side = 3, line =2, adj = 0.15, font = 1.5)

# 2016 (Landsat 8: NIR=B5, Red=B4, Green=B3)
plotRGB(wb_2016, r = 5, g = 4, b = 3, stretch = "lin")
mtext("2016 False Colour", side = 3, line =2, adj = 0.15, font = 1.5)

# 2022 (Landsat 8: NIR=B5, Red=B4, Green=B3)
plotRGB(wb_2022, r = 5, g = 4, b = 3, stretch = "lin")
mtext("2022 False Colour", side = 3, line =2, adj = 0.15, font = 1.5)

#Print False Colour image composite to PDF
dev.copy2pdf(file=" Waiparous Basin 1985 to 2022 False Colour.pdf")
dev.off() #Closes the viewing panel after having saved image as PNG file 

#Plot in FALSE COLOUR SWIR
#Dark green=Dense Mature Forest, Light Green=Grassland/Shrubland/Regenerating Forest, Pink/Magenta=Bare Soil/Sand/Gravel/Rocky Terrain

# Set up the plotting window (2 rows, 2 columns)
par(mfrow = c(2, 2))
# mar = c(bottom, left, top, right)
mar = c(12, 4, 12, 4)

# Plot each year in False Colour SWIR
# Logic: Red channel = SWIR, Green channel = NIR, Blue channel = Green

# 1985 (Landsat 5: Red=B5 (maps SWIR1 to red), Green=B4 (maps NIR to green), Blue=B3 (maps red to blue))
plotRGB(wb_1985, r = 5, g = 4, b = 3, stretch = "lin")
mtext("1985 FC SWIR", side = 3, line =2, adj = 0.15, font = 1.5)

# 2010 (Landsat 5: Red=B5 (maps SWIR1 to red), Green=B4 (maps NIR to green), Blue=B3 (maps red to blue))
plotRGB(wb_2010, r = 5, g = 4, b = 3, stretch = "lin")
mtext("2010 FC SWIR", side = 3, line =2, adj = 0.15, font = 1.5)

# 2016 (Landsat 8: Red=B6 (maps SWIR1 to red), Green=B5 (maps NIR to green), Blue=B4 (maps red to blue))
plotRGB(wb_2016, r = 6, g =5, b =4, stretch = "lin")
mtext("2016 FC SWIR", side = 3, line =2, adj = 0.15, font = 1.5)

# 2022 (Landsat 8: Red=B6 (maps SWIR1 to red), Green=B5 (maps NIR to green), Blue=B4 (maps red to blue))
plotRGB(wb_2022, r = 6, g =5, b =4, stretch = "lin")
mtext("2022 FC SWIR", side = 3, line =2, adj = 0.2, font = 1.5)

#Print SWIR False Colour image composite to PDF
dev.copy2pdf(file=" Waiparous Basin 1985 to 2022 False Colour SWIR.pdf")
dev.off() #Close the viewing panel after having saved image as PNG file

## NDVI ANALYSIS
# DVI=Difference Vegetation Index calculated as NIR-Red. Plants reflect NIR and absorb red. 
# NDVI=Normalized Difference Vegetation Index (enables comparison across dates, sensors and variable light conditions by standardizing vegetation greenness into a -1 to +1 scale.) Calculated as (NIR-red)/(NIR+red). NDVI approx. 1 (Dense, healthy vegetation); NDVI approx 0 (Bare soil, stressed vegetation)
# Calculate NDVI for each year

# Landsat 5 (1985, 2010): (B4 - B3) / (B4 + B3) where B4=NIR, B3=Red 
ndvi_1985wb <- (wb_1985[["SR_B4"]] - wb_1985 [["SR_B3"]]) / (wb_1985 [["SR_B4"]] + wb_1985 [["SR_B3"]])
ndvi_2010wb <- (wb_2010[["SR_B4"]] - wb_2010 [["SR_B3"]]) / (wb_2010 [["SR_B4"]] + wb_2010 [["SR_B3"]])

# Landsat 8 (20106, 2022): (B5 - B4) / (B5 + B4) where B5=NIR, B4=Red
ndvi_2016wb <- (wb_2016[["SR_B5"]] - wb_2016 [["SR_B4"]]) / (wb_2016 [["SR_B5"]] + wb_2016 [["SR_B4"]])
ndvi_2022wb <- (wb_2022[["SR_B5"]] - wb_2022 [["SR_B4"]]) / (wb_2022 [["SR_B5"]] + wb_2022 [["SR_B4"]])

# Plot side-by-side into a 2 by 2 grid using colour "inferno" to maximize contrast. 
# Low NDVI values (e.g.conifer forests with branch shadows) display as deep, clear purples and dark reds.
# High NDVI values (e.g.healthy grassland or broadleaf canopies) display as searing yellow shades.

# Set up the plotting window (2 rows, 2 columns)
par(mfrow = c(2, 2))
# mar = c(bottom, left, top, right)
mar = c(12, 4, 12, 4)

plot(ndvi_1985wb,col=inferno(100), main="NDVI 1985")
plot(ndvi_2010wb,col=inferno(100), main="NDVI 2010")
plot(ndvi_2016wb,col=inferno(100), main="NDVI 2016")
plot(ndvi_2022wb,col=inferno(100), main="NDVI 2022")

# Print NDVI composite to PDF
dev.copy2pdf(file=" Waiparous Basin 1985 to 2022 NDVI.pdf")
dev.off() #Closes the viewing panel after having saved as PNG file

#  Create a stack of the 1985 and 2022 NDVI layers
ndvi_stack <- c(ndvi_1985wb, ndvi_2022wb)
names(ndvi_stack) <- c("ndvi_1985wb", " ndvi_2022wb")

# Create a 1985 vs 2022 NDVI ridgeline plot comparison 
im.ridgeline(ndvi_stack, scale=2)+ 
  labs(title = "NDVI 1985-2022 Ridgeline Plot")
# Interpretation: NDVI curves differ with the 2022 plot having a more gradually sloping right tail due to logging activities increasing open meadow and young (regenerating) forest composition on the landscape. 

# Print NDVI ridgeline plot to PDF
dev.copy2pdf(file="NDVI 1985-2022 Ridgeline Plot Stack.pdf")
dev.off() #Closes the viewing panel after having saved image as PNG file


## RGB IMAGERY AND RIDGELINE PLOT TIME SERIES ANALYSIS 

# Extract the RGB spectral bands and combine them into a stacked 3-band raster image
# 1985 (Landsat 5): Red=3, Green=2, Blue=1
p1985 <- rast("WaiparousBasin_1985MASKEDFINAL.tif")
p1985 <- c(p1985[[3]], p1985[[2]], p1985[[1]])

# 2022 (Landsat 8): Red=4, Green=3, Blue=2
p2022<- rast("WaiparousBasin_2016_RawBandsL8.tif")
p2022 <- c(p2022[[4]], p2022[[3]], p2022[[2]])

# Visual Check
im.plotRGB(p1985, 1, 2, 3) # Red, Green, blue
im.plotRGB(p2022, 1, 2, 3) # Red, Green, blue

# Create individual plots 
# Plot 1 & 2: Single band visual using red band to show vegetation cover change
plot1 <- im.ggplot(p1985[[1]]) + labs(title = "Single Red Band 1985")
plot2 <- im.ggplot(p2022[[1]]) + labs(title = "Single Red Band 2022")

# Plot 3 & 4: RGB Ridgeline Plots
# 'scale=2' Controls height and visual spacing of the curves to facilitate interpretation of data. 
# These show the distribution of pixel values across the RGB bands.
plot3 <- im.ridgeline(p1985, scale=2) + labs(title = "RGB Ridgeline 1985")
plot4 <- im.ridgeline(p2022, scale=2) + labs(title = "RGB Ridgeline 2022")

# Final Comparison Layout
plot1 + plot2 + plot3 + plot4
#Interpretation: 2022 bands all have curves with longer right tails and less defined peaks
#Less RGB light absorption and increasing reflection due to logging disturbance. 
#Red and then blue light is most strongly absorbed by plants; green is more weakly absorbed.  
#Landscape compexity obscures and dilutes effects of logging (natural meadows etc.)

# Print final plot to PDF
dev.copy2pdf(file="RGB 1985 and 2022 Imagery and Ridgeline Plots.pdf")
dev.off() #Closes the viewing panel after having saved image as PNG file

## IMAGE CLASSIFICATION USING FALSE COLOUR BANDS

# Create raster image subsets that select only the NIR, Red, and Green bands (False colour scheme for best land cover type differentiation)
# 1985 and 2020, Landsat 5: NIR=B4, red=B3, green=B2
wb_1985_subset <- wb_1985[[c(4, 3, 2)]]
wb_2010_subset<- wb_2010[[c(4, 3, 2)]]

# Use the im.classify() function from the imageRy R package to conduct unsupervised image classification 
# "Num_clusters=3" splits image into 3 classes based on prior FC image visualization. 

#1985 image classification
wb_1985c <- im.classify(wb_1985_subset, num_clusters=2) #Two classes does not capture land cover types
wb_1985c <- im.classify(wb_1985_subset, num_clusters=3) #Three classes better represents land cover types
#Class2=FOREST, Class3=MEADOW, Class1=RIVER/HUMAN BAREGRND 
# UPDATE if code is rerun as classes are randomly generated each time!

# Manually assign 1985 set classification classes to allow comparison among years
wb_1985cset <- wb_1985c
wb_1985cset[wb_1985c == 2] <- 1  # Set Forest to 1
wb_1985cset[wb_1985c == 3] <- 2  # Set Meadow to 2
wb_1985cset[wb_1985c == 1] <- 3  # Set RIVER/HUMAN BAREGRND to 3

plot(wb_1985cset)

#2010 image classification, repeat above steps
wb_2010c <- im.classify(wb_2010_subset, num_clusters=3)
#Class3=FOREST, Class1=MEADOW, Class2=RIVER/HUMAN BAREGRND 
# UPDATE if code is rerun as classes are randomly generated each time!

wb_2010cset <- wb_2010c
wb_2010cset[wb_2010c == 3] <- 1  # Set Forest to 1
wb_2010cset[wb_2010c == 1] <- 2  # Set Meadow to 2
wb_2010cset[wb_2010c == 2] <- 3  # Set RIVER/HUMAN BAREGRND to 3

plot(wb_2010cset)

# Repeat for 2016, Landsat 8: NIR=B5, red=B4, green=B3
wb_2016_subset <- wb_2016[[c(5, 4, 3)]]
wb_2016c <- im.classify(wb_2016_subset, num_clusters=3)
#Class1=FOREST, Class2=MEADOW, Class3=RIVER/HUMAN BAREGRND
# UPDATE if code is rerun as classes are randomly generated each time!

wb_2016cset <- wb_2016c
wb_2016cset[wb_2016c == 1] <- 1  # Set Forest to 1
wb_2016cset[wb_2016c == 2] <- 2  # Set Meadow to 2
wb_2016cset[wb_2016c == 3] <- 3  # Set RIVER/HUMAN BAREGRND to 3

plot(wb_2016cset)

# Repeat for 2022, Landsat 8: NIR=B5, red=B4, green=B3
wb_2022_subset <- wb_2022[[c(5, 4, 3)]]
wb_2022c <- im.classify(wb_2022_subset, num_clusters=3)
#Class2=FOREST, Class3=MEADOW, Class1=RIVER/HUMAN BAREGRND
# UPDATE if code is rerun as classes are randomly generated each time!

wb_2022cset <- wb_2022c
wb_2022cset[wb_2022c == 2] <- 1  # Set Forest to 1
wb_2022cset[wb_2022c == 3] <- 2  # Set Meadow to 2
wb_2022cset[wb_2022c == 1] <- 3  # Set RIVER/HUMAN BAREGRND to 3

plot(wb_2022cset)
dev.off() #Closes the viewing panel 

## LAND COVER CHANGE ANALYSIS USING CLASSIFIED IMAGES

# Calculate frequencies of land cover classes (freq/total)
# ncell() =  total number of cells (pixels) in a raster layer, including blank NA cells created when an image is cropped
# freq(), calculates frequency of each land cover class

# Generate an ncell() value that excludes NA since aoi clipped has blank cells
f1985 <- freq(wb_1985cset)
ncell1985_valid <- sum(f1985$count) #Extracts just the column with pixel counts from the freq table, excludes NA values

f2010<- freq(wb_2010cset)
ncell2010_valid <- sum(f2010$count)

f2016<- freq(wb_2016cset)
ncell2016_valid <- sum(f2016$count)

f2022<- freq(wb_2022cset)
ncell2022_valid <- sum(f2022$count)

# Calculate class cover percentages for 1985
perc1985 = freq(wb_1985cset) * 100 / ncell1985_valid
perc1985
#Forest=59.171206, #Meadow=31.360185, #River/Human Bareground=9.468609

# Calculate class cover percentages for 2010
perc2010 = freq(wb_2010cset) * 100 / ncell2010_valid
perc2010
#Forest=63.987238, #Meadow=30.573668, #River/Human Bareground=5.439094

# Calculate class cover percentages for 2016
perc2016 = freq(wb_2016cset) * 100 / ncell2016_valid
perc2016
#Forest=59.40405, #Meadow=26.87500, #River/Human Bareground=13.72095

# Calculate class cover percentages for 2022
perc2022 = freq(wb_2022cset) * 100 / ncell2022_valid
perc2022
#Forest=61.649862, #Meadow=31.927450, #River/Human Bareground=6.422688

# Create a data frame with each class
class <- c("forest", "meadow","river/human bareground")
perc1985<- c(59.2,31.4,9.5)
perc2010 <- c(63.9,30.6,5.4)
perc2016 <- c(59.4, 26.9,13.7)
perc2022<- c(61.6, 31.9,6.5)
# Generate a database of land use change percentages
twb_luc <- data.frame(class, perc1985, perc2010, perc2016, perc2022)
twb_luc

# Define the Colour Palette for Classes
# 1=FOREST 2=MEADOW, 3=RIVER/HUMAN BAREGRND
my_colours <- c("darkgreen", "cornsilk4", "yellow")

# Use the ggplot2 package for the final graphs
# Plot1_1985
p1 <- ggplot(twb_luc, aes(x=class, y=perc1985, fill=class)) + 
  geom_bar(stat="identity") +
  scale_fill_manual(values = my_colours) + 
  ylim(c(0,100)) +
  labs(title = "1985", y = "Percentage (%)", x = "") +
  theme_minimal() +
  theme(legend.position = "none")


# Plot2_2010
p2 <- ggplot(twb_luc, aes(x=class, y=perc2010, fill=class)) + 
  geom_bar(stat="identity") +
  scale_fill_manual(values = my_colours) + 
  ylim(c(0,100)) +
  labs(title = "2010", y = "Percentage (%)", x = "") +
  theme_minimal() +
  theme(legend.position = "none")

# Plot3_2016
p3 <- ggplot(twb_luc, aes(x=class, y=perc2016, fill=class)) + 
  geom_bar(stat="identity") +
  scale_fill_manual(values = my_colours) + 
  ylim(c(0,100)) +
  labs(title = "2016", y = "Percentage (%)", x = "") +
  theme_minimal() +
  theme(legend.position = "none")

# Plot4_2022
p4 <- ggplot(twb_luc, aes(x=class, y=perc2022, fill=class)) + 
  geom_bar(stat="identity") +
  scale_fill_manual(values = my_colours) + 
  ylim(c(0,100)) +
  labs(title = "2022", y = "Percentage (%)", x = "") +
  theme_minimal() +
  theme(legend.position = "none")

p1+p2+p3+p4

# Print final land cover bar graphs to PDF
dev.copy2pdf(file="Land Cover Trend, Bar Graphs 1985 to 2022.pdf")
dev.off() #Closes the viewing panel after having saved image as PNG file


## PLOT COMPOSITE OF TIME SERIES CLASSIFIED IMAGES

# Set up the plotting window  (2 rows, 2 columns)
par(mfrow = c(2, 2))
# mar = c(bottom, left, top, right)
mar = c(2, 4, 4, 4)
# oma = c(bottom, left, top, right), outer margin area
oma= c(12, 4, 4, 4)

# Plot 1985
plot(wb_1985cset, col = my_colours, main = "1985", axes = FALSE, legend=FALSE)

# Plot 2010
plot(wb_2010cset, col = my_colours, main = "2010", axes = FALSE, legend=FALSE)

# Plot 2016
plot(wb_2016cset, col = my_colours, main = "2016", axes = FALSE, legend=FALSE)

# Plot 2022
plot(wb_2022cset, col = my_colours, main = "2022", axes = FALSE, legend=FALSE)

legend ("bottomright",
        inset = c(0.5, -0.2),
        legend = c("Forest", "Meadow", "River/Human Bareground"), 
        fill = my_colours, 
        horiz = FALSE,     # horizontal legend
        bty = "n",         # No border
        cex = 0.8,         # Makes text larger
        xpd = TRUE)        # ALLOWS DRAWING OUTSIDE ALL PLOTS


# Print final WB image classification time series composite to PDF
dev.copy2pdf(file=" Waiparous Basin 1985 to 2022 Classified Image Analysis.pdf")
dev.off() #Closes the viewing panel after having saved image as PNG file


##HUMAN FOOTPRINT AND HYDROLOGY OVERLAY ANALYSIS

# Import Hydrology (Sreams/Rivers) Tif generated in GEE

wb_streams <- rast("WaiparousBasin_MERIT_Streams.tif")
plot(wb_streams)

# Ensure everything is resampled to the same grid (Landsat 30m)
# resample () changes the resolution, orientation and pixel grid of the stream raster to match the Landsat data
# resample () reference (https://developers.google.com/earth-engine/guides/resample)
wbstreams_res <- resample(wb_streams , wb_2016cset, method="near")

# Set all non-stream pixels (0) to NA (invisible)
wbstreams_final <- wbstreams_res
wbstreams_final[wbstreams_final ==0] <- NA
plot(wbstreams_final)
plot(wb_2016cset, col = my_colours, main = "2016", axes = FALSE, legend=FALSE)
plot(wbstreams_final, col="cyan", lwd=1.5, add=TRUE, legend=FALSE)


# ROAD and CUTBLOCK shapefiles from 2022 ABMI Human Footprint Inventory
# ABMI reference dataset source: https://abmi.ca/data-portal/80.html
# ROAD and CUTBLOCK shapefiles clipped to aoi in QGIS


#Import the Roads Shapefile (Vector) 
# 'vect' is the terra command for shapefiles
roads <- vect("wb_roadsclipped.shp")

# Match the projection of the imported shapefile 
# Use crs() function from Terra to match Coordinate Reference System
# This ensures the roads line up with your Landsat image perfectly
roads <- project(roads, crs(wb_2016cset))

dev.off() #Closes the viewing panel  

# Plot the Roads and Streams over the Landsat 2016 Image
plot(wb_2016cset, col = my_colours, main = "2016", axes = FALSE, legend=FALSE)
plot(wbstreams_final, col="cyan", lwd=1.5, add=TRUE, legend=FALSE)
lines(roads, col = "black", lwd = 1.5)
dev.off()  

# Calculate Road Surface Area for aoi
# Step A: Create a buffer (assume average width of 10m, so 5m on each side)
# Adjust 'width' based on the actual road types in Waiparous
road_polygons <- buffer(roads, width = 5)

# Step B: Dissolve overlapping buffers to avoid double-counting intersections
road_footprint <- aggregate(road_polygons)

# Step C: Calculate Road Area in Square Meters
# export area in square kilometers
road_area_sqm <- expanse(road_footprint) 
road_area_km2 <- road_area_sqm / 1e6

print(paste("Total Road Surface Area:", round(road_area_km2, 3), "sq km"))
#"Total Road Surface Area: 0.809 sq km"

# Import the ABMI 2022 Clipped Cutblock Shapefile (Vector) generated in QGIS
# 'vect' is the terra command for shapefiles
cutblocks_2022ABMI <- vect("wb_cutblockfix_clip.shp")

# Match the Projection (CRS)
# This ensures the roads line up with your Landsat image perfectly
cutblocks <- project(cutblocks_2022ABMI, crs(wb_2016cset))

# Calculate Cutblock Footprint Area
# 'expanse' calculates the area of each individual polygon in the collection
# Dividing by 1e6 converts square meters to square kilometers
areas_km2_cutblocks<- expanse(cutblocks, unit = "km")

# Calculate total footprint area (sum of all polygons)
cutblock_footprint <- sum(areas_km2_cutblocks)
cutblock_footprint 

print(paste("Total Cutblock Footprint Area:", round(cutblock_footprint, 2), "sq km"))
"Total Cutblock Footprint Area: 19.97 sq km"

# Calculate Total Human Footprint
total_human_footprint_km2 <- cutblock_footprint + road_area_km2
print(paste("Total Human Footprint Area:", round(total_human_footprint_km2, 2), "sq km"))
"Total Human Footprint: 20.77 sq km"

# Get the area of your AOI (Area of Interest) polygon in meters from GEE
aoi_area_km2 <- 155.81651679640706

# Calculate percentages for the Waiparous Basin aoi
footprint_percentage <- (total_human_footprint_km2 / aoi_area_km2) * 100
footprint_percentage
#Total Human Footprint = 13.33%
cutblock_percentage <- (cutblock_footprint / aoi_area_km2) * 100
cutblock_percentage
#Cutblocks = 12.81%
roads_percentage <- (road_area_km2 / aoi_area_km2) * 100
roads_percentage 
#Roads = 0.52%

# ABMI HUMAN FOOTPRINT OVERLAY MAPPING

# Build legend elements and labels
# Define your full color list
# Raster Colours + Vector Colors
all_cols <- c("darkgreen", "cornsilk4", "yellow", "cyan", "black", "red")

# Define your full label list
all_labels <- c("Forest (Classified)", 
                "Meadow (Classified)", 
                "Disturbance (Classified)", 
                "Watercourse (Merit Hydro)", 
                "Roads (ABMI 2022)", 
                "Cutblocks (ABMI 2022)")

# Set up the plotting window  (1 row, 2 columns)
par(mfrow = c(1, 2))

# Plot 2016 classified image with ABMI Footprint and Hydro overlay
plot(wb_2016cset, col = my_colours, main = "2016", axes = FALSE, legend=FALSE)
plot(wbstreams_final, col="cyan", lwd=1.5, add=TRUE, legend=FALSE)
lines(cutblocks, col = "red", lwd = 1.5)
lines(roads, col = "black", lwd = 2)

# Plot 2022 classified image with ABMI Footprint and Hydro overlay
plot(wb_2022cset, col = my_colours, main = "2022", axes = FALSE, legend=FALSE)
plot(wbstreams_final, col="cyan", lwd=1.5, add=TRUE, legend=FALSE)
lines(cutblocks, col = "red", lwd = 1.5)
lines(roads, col = "black", lwd = 2)

# Draw the legend
legend("bottomleft", 
       legend = all_labels, 
       # 'fill' handles the boxes for the first 3 (Raster)
       # For the lines, we set fill to NA so they don't show boxes
       fill = c("darkgreen", "cornsilk4", "yellow", NA, NA, NA),
       border = c("black", "black", "black", NA, NA, NA),
       
       # 'col' + 'lty' + 'lwd' handles the lines for the last 3 (Vector)
       # lty 1 (line type 1) = solid line
       # lwd (line width, where 1 = standard line thickness)
       col = c(NA, NA, NA, "cyan", "black", "red"),
       lty = c(NA, NA, NA, 1, 1, 1), 
       lwd = c(NA, NA, NA, 1.5, 3, 2),
       
       # Layout settings
       horiz = FALSE,      # Vertical list is usually clearer for 6 items
       bty = "n",          # No box around the legend
       cex = 0.8,          # Text size
       xpd = NA,           # Allow drawing in the margin
       inset = c(-1.2, -0.05)) # Nudge it to the right

# Print final composite to PDF
dev.copy2pdf(file=" Waiparous Basin 2016 and 2022 Classfied with 2022 ABMI Overlay.pdf")
dev.off() #Closes the viewing panel after having saved image as PNG file
