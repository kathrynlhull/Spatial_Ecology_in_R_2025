# WAIPAROUS BASIN (ALBERTA,CA) VEGETATION CHANGE LAND USE ANALYSIS (1985-2022) 🌲🐟   
### Spatial Ecology in R (B2111) (2025/2026)
#### Kathryn Hull, Matriculation number: 0001178795


# 1. Introduction 

The Waiparous Creek watershed, in the headwaters of the greater Bow River Basin, Alberta, Canada, is ecologically significant as it contains among the last remaining critical habitat for an endangered native trout species, Westslope Cutthroat Trout (_Oncorhynchus clarkii lewisi_) (Fisheries and Oceans Canada 2014). Among the threats to this species are logging impacts that contribute sediment into suitable trout streams, negatively impacting their survival, reproduction and habitat suitability. Westslope Cutthroat Trout require cool, well oxygenated water, clean (unconsolidated) gravel substrate, and abundant riparian edge cover and shade. Cumulative logging impacts have accelerated in the Waiparous Creek basin from 2010-2022.  This project aims to visualize, quantify and analyze these impacts by way of vegetation change satellite imagery analysis and land cover classification compared to benchmark reference conditions in 1985. This analysis is validated against human footprint mapping done by the Alberta Biodiversity Monitoring Institute ([ABMI Human Footprint Inventory](https://abmi.ca/abmi-home/what-we-do/land-cover-and-land-use-mapping/human-footprint-mapping.html)). Lastly, a cursory erosion risk assessment is included for cutblocks using terrain analysis tools. 

![Waiparous Creek Basin Study Area Map](RExam_Images/WaiparousBasin_AOI.png)

# 2. Project Objectives 

The primary objectives of this project include:
-i) Satellite imagery visualization: True Colour, False Colour and Shortwavelength-Infrared False Colour 
-ii) NDVI (Normalized Difference Vegetation Index) analysis
-iii) Time series, RGB Ridgeline Plot analysis 
-iv) Image classification time series analysis
-v) Land cover change analysis 
-vi) ABMI Human Footprint and Hydrology overlay analysis
-vii) Terrain mapping, cutblock slope erosion risk analysis

# 3. Methodology  

## Satellite Imagery Acquisition 
Preliminary visualization of the Waiparous Basin Study area was done using the GoogleEarth Pro application and QGIS, including use of historic imagery visualization tools. This refined the selection of 1985 (baseline), 2010 (start of logging impacts, 2016 (logging maximal concurrent extent), and 2022 (final year of logging) for comparative analysis. 

Satellite imagery used in this project was obtained from [Google Earth Engine, GEE] (https://earthengine.google.com/). 
> [!NOTE]
> JavaScript code utilized in GEE is given in the file Code.js.
> [!NOTE]
> For 1985 and 2010, the GEE Landsat 5 Thematic Mapper (TM) Collection 2, Level-2 dataset was used (ee.ImageCollection, LANDSAT/LT05/C02/T1_L2)
> For 2016 and 2022, Landsat 8 Operational Land Imager (OLI) / Thermal Infrared Sensor (TIRS) Collection 2, Level-2 dataset was used (ee.ImageCollection, LANDSAT/LC08/C02/T1_L2)
> The Landsat Missions are part of the U.S. Geological Survey (USGS) National Land Imaging (NLI) Program (https://www.usgs.gov/landsat-missions/landsat-satellite-missions). 
> Reference data source: https://www.usgs.gov/landsat-missions 
> 
## Waiparous Creek Watershed Study Area Delineation
The Waiparous Basin study area was clipped from the HydroBASINS Level 12 dataset (source: https://www.hydrosheds.org/products/hydrobasins). 

## Setting the Working Directory
All imagery generated in GEE was saved to a desktop folder Working Directory, using the setwd () function in R. 
````md
setwd("C:/Users/kalih/Desktop/Recology/RExam_Images")
````
## R Packages Installed
````r
library(imageRy) #Raster Imagery Operations, Vegetation Indices, Image Classification 
library(terra) #Spatial data analysis with vector and raster data (e.g. satellite imagery, DEM)
library(viridis) #Data visualization, colour maps and built-in palettes, colourblind friendly
library(RStoolbox) #Remote sensing image processing and analysis 
library(ggplot2) #Data visualization, custom aesthetics and geometries of charts 
library(patchwork) #Combines separate ggplot2 plots into a single composite layout
````
# 4. Image Visualization
Multi plot comparisons for 1985, 2010, 2016 and 2022 were generated for each of the visualizations below. 
Example R coding to set up a 2 by 2 plot window: 
````r
par(mfrow = c(2, 2))
mar = c(12, 4, 12, 4) # margins (bottom, left, top, right)
````

## True Colour Multi Plot

![True Colour Maps](RExam_Images/TrueColourPlots.png)   

A True Colour RGB composite stacks red, green and blue bands into a single image for visualization of imagery that gives an intuitive, realistic representation that matches human vision. (Red, green and blue light represent that portion of the electromagnetic spectrum visible to the human eye)- 

Landsat 5 TM Bands (1985 and 2010 imagery), Red = Band 3, Green = Band 2, and Blue = Band 1
> Landsat 5 image R code example: 
````r
wb_1985 <- rast("WaiparousBasin_1985MASKEDFINAL.tif") # Load the GeoTIFF raster file generated in GEE
plotRGB(wb_1985, r = 3, g = 2, b = 1, stretch = "lin") # Creates a plot in R using the red, green and blue bands. Stretch="lin" means “linear stretch” to improve visual contrast and brightness of an image.    
````
Landsat 8 Bands  (2016 and 2022 imagery), Red = Band 4, Green = Band 3, Blue = Band 2
> Landsat 8 image R code example: 
````r
plotRGB(wb_2016, r = 4, g = 3, b = 2, stretch = "lin")
````
Reference: https://www.usgs.gov/faqs/what-are-band-designations-landsat-satellites#main-content 
