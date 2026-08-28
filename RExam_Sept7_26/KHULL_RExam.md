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
The Waiparous Basin study area (area of interest - aoi) was clipped from the HydroBASINS Level 12 dataset (source: https://www.hydrosheds.org/products/hydrobasins). 

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
> [!NOTE]
> Complete R coding for all of the below is given in the file Code.R

# 4. Image Visualization

Prior to image visualization, GeoTiff raster files for each year generated in GEE were loaded in r. 
Example:
````r
wb_1985 <- rast("WaiparousBasin_1985MASKEDFINAL.tif") # Loads the 1985 Waiparous Basin aoi GeoTIFF raster file generated in GEE
````
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
> Landsat 5 True Colour image R code example: 
````r
plotRGB(wb_1985, r = 3, g = 2, b = 1, stretch = "lin") # Creates a True Colour RGB plot in R using the red, green and blue bands. Stretch="lin" means “linear stretch” to improve visual contrast and brightness of an image.    
````
Landsat 8 Bands  (2016 and 2022 imagery), Red = Band 4, Green = Band 3, Blue = Band 2
> Landsat 8 True Colour image R code example: 
````r
plotRGB(wb_2016, r = 4, g = 3, b = 2, stretch = "lin")
````
Reference: https://www.usgs.gov/faqs/what-are-band-designations-landsat-satellites#main-content 

## False Colour Multi Plot

![False Colour Maps](RExam_Images/FC_Plots.png)

> **Interpretation**
> False Colour visualization uses Near-Infrared (NIR)-Red-Green (i.e. NRG) wavelength light bands (channels). NIR is mapped to the red channel, red is mapped to the green channel and green is mapped to the blue channel. False Colour (NRG) is useful for monitoring vegetation cover and changes in vegetation composition.  Chlorophyll in plants reflect NIR intensely, thus photosynthesizing vegetation shows as red. Deciduous vegetation appear as bright red while coniferous trees, reflect less NIR and appear darker. Grassland/shrubland open meadows appear as pink or light red. Areas of bare ground or rock appear cyan or blue as they have low NIR reflection and reflect moderately across all displayed bands. Clear and clean water bodies appear black as all radiation in the spectral range is absorbed. 

Landsat 5 TM Bands (1985 and 2010 imagery), NIR = Band 4, Red = Band 3, Green = Band 2
> Landsat 5 False Colour NRG image R code example: 
````r
plotRGB(wb_1985, r = 4, g = 3, b = 2, stretch = "lin") # Creates a False Colour NRG plot in R where red channel = NIR, green channel = Red, Blue channel = Green
````
Landsat 8 Bands  (2016 and 2022 imagery), NIR = Band 5, Red = Band 4, Green = Band 3
> Landsat 8 False Colour image R code example: 
````r
plotRGB(wb_2022, r = 5, g = 4, b = 3, stretch = "lin") # Creates a False Colour NRG plot in R where red channel = NIR, green channel = Red, Blue channel = Green
````
## False Colour SWIR Multi Plot

![False Colour SWIR Maps](RExam_Images/FCSWIR_REVPLOTS.png)

> **Interpretation**
> False Colour Shortwavelength Infrared (SWIR) plots are generated using SWIR1 mapped to the red channel, NIR mapped to the green channel and Green mapped to the blue channel. This composite is useful for discriminating between vegetated and non-vegetated surfaces, where moist exposed soil appears darker than dry areas. Healthy plants reflect NIR strongly and absorb SWIR. Dense coniferous vegetation appears dark green; Grassland/shrubland open meadows appear light or lime green. Logged cutblocks appear in shades of pink since bare soil, rocks and wood reflect high levels of SWIR (boosting the red channel) and moderate visible green light (boosting the blue channel). A combination of high red (SWIR) and moderate blue (green visible band) with lower green (NIR) creates the light pink to magenta colour. Watercourses appear purple since water strongly absorbs both SWIR and NIR wavelengths (i.e., red and green are very low) and reflects some visible green light (seen as blue). Shallow gravel riverbeds as in the Waiparous basin or water with suspended sediment adds a signal back into the SWIR/red or green channels, mixing with the blue to create a purplish tone (not pure black).

Landsat 5 TM Bands (1985 and 2010 imagery), SWIR1 = Band 5, NIR = Band 4, Red = Band 3, Green = Band 2
> Landsat 5 False Colour NRG image R code example: 
````r
plotRGB(wb_1985, r = 5, g = 4, b = 2, stretch = "lin")# Creates a False Colour SWIR plot in R where red channel = SWIR1, green channel = NIR, Blue channel = Green
````
Landsat 8 Bands  (2016 and 2022 imagery), SWIR1 = Band 6, NIR = Band 5, Red = Band 4, Green = Band 3
> Landsat 8 False Colour image R code example: 
````r
plotRGB(wb_2022, r = 6, g =5, b =3, stretch = "lin") # Creates a False Colour SWIR plot in R where red channel = SWIR1, green channel = NIR, Blue channel = Green
````
# 5. NDVI Analysis

A Difference Vegetation Index (DVI) is calculated as follows:
$` DVI = NIR - Red `$   
Since healthy plants strongly reflect NIR and absorb red light, a DVI quantifies vegetation presence and density. Higher DVI values indicate healthier or denser vegetation; lower values indicate sparse or stressed vegetation. 

A Normalized Difference Vegetation Index (NDVI) enables comparison of vegetation health and density across dates, sensors and variable light conditions by standardizing vegetation greenness into a -1 to +1 scale. 

NDVI is calculated using this formula: 
NDVI = (NIR − Red) / (NIR + Red)  
NDVI values approximating 1 represent dense, healthy vegetation); NDVI values approximating 0 represent bare soil and stressed vegetation. 

Example NDVI R calculation for Landsat 5 (1985 / 2010) Imagery:
````r
ndvi_1985wb <- (wb_1985[["SR_B4"]] - wb_1985 [["SR_B3"]]) / (wb_1985 [["SR_B4"]] + wb_1985 [["SR_B3"]]) #For Landsat 5, B4=NIR, B3=Red
````

Example NDVI R calcuation for Landsat 8 (2016 / 2022) Imagery:
````r
ndvi_2022wb <- (wb_2022[["SR_B5"]] - wb_2022 [["SR_B4"]]) / (wb_2022 [["SR_B5"]] + wb_2022 [["SR_B4"]])  #For Landsat 8, B5=NIR, B4=Red
````
Resulting NDVI Multi Plot, using the "inferno" colour palette from the viridis R package (https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html). 
### NDVI Time Series Composite for the Waiparous Basin Study Area
![NDVI Time Series Composite](RExam_Images/NDVI_Plots.png)

> **Interpretation**
> This is a colour-blind safe palette that shows clear contrasts for low values from dark/black-purple for bare soil or water to high values from orange or bright yellow for dense broadleaf or grassland vegetation. Note that conifer forests dispaly as deep purples and dark reds (low NDVI values) due to branch shadows.  Needle-shaped leaves create internal canopy gaps and shadowing which reduces the total surface area available to scatter NIR light. 

## 1985 vs 2022 Stacked NDVI Ridgeline Plot
A stacked NDVI ridgeline plot was generated for the benchmark year (1985) compared to 2022 (post logging). By stacking the plots vertically, NDVI differences can be visualized clearly.  

R coding:
````r
ndvi_stack <- c(ndvi_1985wb, ndvi_2022wb)
names(ndvi_stack) <- c("ndvi_1985wb", " ndvi_2022wb")
im.ridgeline(ndvi_stack, scale=2)+ 
  labs(title = "NDVI 1985-2022 Ridgeline Plot") # 'scale=2' Controls height and visual spacing of the curves to facilitate interpretation of data.
````

### NDVI Stacked Ridgeline Plot for the Waiparous Basin Study Area
![NDVI Stacked Ridgeline Plot](RExam_Images/NDVI_RidgelineStack.png)

> **Interpretation**
> NDVI curves differ slightly with the 2022 plot having a more gradually sloping right tail due to logging activities increasing open meadow and young (regenerating) forest composition on the landscape. Broader curves indicate a higher diversity in land cover types whereas narrow curves indicate more vegetation uniformity.  

# 6. RGB Imagery and Ridgeline Plot Time Series Analysis 
A secondary time series analysis for the 1985 (benchmark) and 2022 (post logging) images was done using RGB imagery (using only the red band to show vegetation cover change) and ridgeline plots where the Red-Green-Blue bands are extracted and combined into a 3-band raster image. 

This analysis uses the imageRy package im.ggplot() and im.ridgeline() functions (https://cran.r-project.org/web/packages/imageRy/refman/imageRy.html). 

R coding:
````r
p1985 <- rast("WaiparousBasin_1985MASKEDFINAL.tif") 
p1985 <- c(p1985[[3]], p1985[[2]], p1985[[1]]) # Landsat 5 Bands: Red=3, Green=2, Blue=1; Extract RGB bands and combine into 3-band raster image
p2022<- rast("WaiparousBasin_2016_RawBandsL8.tif")
p2022 <- c(p2022[[4]], p2022[[3]], p2022[[2]]) # Landsat 8 Bands: Red=4, Green=3, Blue=2; Extract RGB bands and combine into 3-band raster image
plot1 <- im.ggplot(p1985[[1]]) + labs(title = "Single Red Band 1985") # Single band visual using red band to show vegetation cover change
plot2 <- im.ggplot(p2022[[1]]) + labs(title = "Single Red Band 2022")  # Single band visual using red band to show vegetation cover change
plot3 <- im.ridgeline(p1985, scale=2) + labs(title = "RGB Ridgeline 1985") # Ridgeline plots show the distribution of pixel values across the RGB bands.
plot4 <- im.ridgeline(p2022, scale=2) + labs(title = "RGB Ridgeline 2022") # Ridgeline plots show the distribution of pixel values across the RGB bands.
plot1 + plot2 + plot3 + plot4
````

### RGB Ridgeline Time Series for the Waiparous Basin Study Area
![RGB Ridgeline Time Series](RExam_Images/Timeseries_RidgelineRGB.png)
> **Interpretation**
> The ridgeline plots are similar, except that 2022 RGB bands all have broader curves with longer right tails and less defined peaks indicating less vegetation uniformity. Logging disturbance means less RGB light absorption and increasing RGB light reflection due to reduced healthy vegetation cover and increased bare ground cover.  Red and then blue light is most strongly absorbed by chlorophyll in plants; green is more weakly absorbed. However, ridegeline plots are quite similar overall.  The natural landscape complexity including open grassy meadows and broad gravel floodplains along waterways in the Waiparous basin obscures and dilutes the effects of logging in the plots.

# 7. Image Classification Using False Colour Bands

The im.classify() function from the imageRy R package was used to conduct unsupervised image classification specifying 3 classes of land cover type (based on prior False Colour image visualization above). Prior to classification raster image subsets were created for each study year that select only the NIR, Red and Green Bands (i.e., False colour scheme for optimized land cover type differentiation). 

Example R coding:
````r
wb_1985_subset <- wb_1985[[c(4, 3, 2)]] # Creates a raster image subset for 1985 selecting Landsat 5 bands, NIR=B4, Red=B3, Green=B2
wb_1985c <- im.classify(wb_1985_subset, num_clusters=3) # Used to classify image into 3 land cover classes
````
Class clustering is randomly assigned each time this code is run. To allow for time series land cover classification comparison, classes were manually assigned as follows: Forest=1 (represents coniferous forest); Meadow=2 (represents natural open meadows and regenerating cutblocks); River/Human Bareground =3 (includes new cutblocks, roadways, and gravel riverbeds). 

Example R coding to set class numbering assignment, with numbers in [] varying based on random im.classify() function above:
````r
wb_1985cset <- wb_1985c
wb_1985cset[wb_1985c == 2] <- 1  # Set Forest to 1 
wb_1985cset[wb_1985c == 3] <- 2  # Set Meadow to 2
wb_1985cset[wb_1985c == 1] <- 3  # Set RIVER/HUMAN BAREGRND to 3
````  
A consistent colour palette was defined for image classification using this coding:
````r
my_colours <- c("darkgreen", "cornsilk4", "yellow") # c(Forest, Meadow, River/Human Bareground)
````
A two by two grid with an outer margin for the legend text was used to plot classified images from all years using the colour scheme legend above.
````r
par(mfrow = c(2, 2)) # Set up the plotting window  (2 rows, 2 columns)
mar = c(2, 4, 4, 4) # mar = c(bottom, left, top, right)
oma= c(12, 4, 4, 4) # oma = c(bottom, left, top, right), outer margin area
plot(wb_1985cset, col = my_colours, main = "1985", axes = FALSE, legend=FALSE) # 1985 classified image plot
plot(wb_2010cset, col = my_colours, main = "2010", axes = FALSE, legend=FALSE) # 2010 classified image plot
plot(wb_2016cset, col = my_colours, main = "2016", axes = FALSE, legend=FALSE) # 2016 classified image plot
plot(wb_2022cset, col = my_colours, main = "2022", axes = FALSE, legend=FALSE) # 2022 classified image plot
legend ("bottomright",
        inset = c(0.5, -0.2),
        legend = c("Forest", "Meadow", "River/Human Bareground"), 
        fill = my_colours,  #use custom predefined colour palette 
        horiz = FALSE,     # horizontal legend
        bty = "n",         # No border
        cex = 0.8,         # Makes text larger
        xpd = TRUE)        # ALLOWS DRAWING OUTSIDE ALL PLOTS
````
### Time Series Image Classification for the Waiparous Basin Study Area
![Time Series Image Classification Composite](RExam_Images/ImageClassification.png)

# 8. Land Cover Change Analysis

To quantify land cover changes over time in the study area, a simple analysis was done to calculate the relative frequency of each land cover class (i.e., frequency/total). The ncell() total number of cells (pixels) in each raster image was adjusted to exclude blank NA cells. Since the aoi was clipped to the Waiparous Basin, it includes blank NA cells that are not displayed (i.e., those that fall outside of the basin polygon). 

Example R coding: 
````r
f1985 <- freq(wb_1985cset) # Determine the frequency of each of the three set cover types from the classification analysis above for the 1985 raster image
ncell1985_valid <- sum(f1985$count) # Determine the valid total number of cells in the aoi by summing only the column with the cell counts from the frequency table to exclude blank NA cells.
perc1985 = freq(wb_1985cset) * 100 / ncell1985_valid # Determine the cover class percentages for 1985
#Repeat above coding for 2010, 2016 and 2022
````
Cover class percentages from this analysis were then combined into a data frame and a summary comprehensive table:
````r
class <- c("forest", "meadow","river/human bareground")
perc1985<- c(59.2,31.4,9.5)
perc2010 <- c(63.9,30.6,5.4)
perc2016 <- c(59.4, 26.9,13.7)
perc2022<- c(61.6, 31.9,6.5)
twb_luc <- data.frame(class, perc1985, perc2010, perc2016, perc2022)
````

### Land Cover Class Change Table
 | Class | 1985 (%) | 2010 (%) | 2016 (%) | 2022 (%) |
|-------|:-------:|:-------:|:-------:|:-------:|
| 1                 Forest  |  59.2    |  63.9    | 59.4     |    61.6 |
| 2                 Meadow  |  31.4    | 30.6     | 26.9     |   31.9  |
| 3 River/Human Bareground  |   9.5    | 5.4      |  13.7    |   6.5   |
 
The ggplot2 R package was used to display this data in a comparative bar graph format using the predefined "my_colours" colour scheme. 
References: https://ggplot2.tidyverse.org/; https://r4ds.hadley.nz/data-visualize; https://r-charts.com/ranking/bar-plot-ggplot2/; https://ggplot2.tidyverse.org/reference/ggtheme.html.  

Example R coding:
````r
p1 <- ggplot(twb_luc, aes(x=class, y=perc1985, fill=class)) +  
  geom_bar(stat="identity") + 
  scale_fill_manual(values = my_colours) + 
  ylim(c(0,100)) +
  labs(title = "1985", y = "Percentage (%)", x = "") +
  theme_minimal() +
  theme(legend.position = "none")
# Above code (repeated for each year - p2 [2010], p3 [2016], p4 [2022])

#aes() aesthetics mapping function, where "class" categories are placed on the x axis; "per1985" numerical values from the twb_luc data frame column determine the vertical y axis values for bar heights; fill=class instructs the chart to give a unique fill colour to each category in the class column.
#geom_bar () function for rending a rectangular bar plot.
#(stat="identity") tells R to use the exact numeric value in the perc1985 column for the bar heights.
#scale_fill_manual(values = my_colours) forces the bars to use a custom "my_colours" colour palette
#ylim(c(0,100)) sets the limits for the Y axis from 0% to 100%
#theme_minimal() uses a minimalist theme for a clean, uncluttered chart.
#theme(legend.position = "none") removes the automatically generated colour legend

p1+p2+p3+p4 # develops a composite of the four plots
````
### Land Cover Class Analysis Visualization Using ggplots2 
![Land Cover Change Bar Plots](RExam_Images/LandCoverChange_Barplots.png)

# 9. Human Footprint Inventory and Hydrology Overlay Analysis

Published hydrology and Human Footprint Inventory data for the study area was imported into R for visualization overlays using classified images generated above. This data was clipped to the Waiparous Basin aoi to quantify road and cutblock surface areas and total disturbed footprint specific to this study area. The hydrology stream overlay allows for distinction of natural gravel waterbeds versus road or other human disturbance. 

A hydrology GeoTiff file was generated using JavaScript coding in GEE (see Code.js file).  Significant tributary streams were added using the [MERIT Hydro Global Hydrography Dataset](https://developers.google.com/earth-engine/datasets/catalog/MERIT_Hydro_v1_0_1). 

The following r code was used to import the Waiparous Basin MERIT stream raster TIF, resample it to match the Landsat 30 m grid, and to create an overlay plot onto the 2016 classified image. 
````r
wb_streams <- rast("WaiparousBasin_MERIT_Streams.tif") #import the Merit Stream GeoTiff from GEE
wbstreams_res <- resample(wb_streams , wb_2016cset, method="near") # This function from the Terra package transfers the values of the Streams.tif to match the geometry (cell size) of the 30 m Landsat "wb_2016cset" raster object.
#Resample() function coding reference: https://www.pmassicotte.com/posts/2022-04-28-changing-spatial-resolution-of-a-raster-with-terra/
wbstreams_final <- wbstreams_res 
wbstreams_final[wbstreams_final ==0] <- NA #Set all non-stream pixels (0) to NA (invisible) 
plot(wb_2016cset, col = my_colours, main = "2016", axes = FALSE, legend=FALSE) #Axes and legend set to FALSE to hide axis lines, ticks and coordinate labels and to exclude a plot legend
plot(wbstreams_final, col="cyan", lwd=1.5, add=TRUE, legend=FALSE) #Lwd is the line thickness; Add=true forces R to draw these streams directly on top of the plot above
```` 
Road and cutblock shapefiles for the study area were extracted and clipped to the aoi in QGIS from the Alberta Biological Monitoring Institute (ABMI) Human Footprint Inventory data portal (https://abmi.ca/data-portal/80.html). 
 
The following R code was used to import ABMI shapefiles into R and to calculate road surface, cutblock area, and total human footprint for the Waiparous Basin study area.

````r
roads <- vect("wb_roadsclipped.shp") #Import the ABMI roads vector shapefile clipped to the aoi in QGIS. vect() is the Terra package function for vector shapefiles.
roads <- project(roads, crs(wb_2016cset)) #Match the projection of the imported shapefile to that of the "wb_2016cset" raster using the crs() Terra function (Coordinate Reference System).
road_polygons <- buffer(roads, width = 5) #To calculate road surface area create a road polygon from the line file using a buffer width of 5 m since the average road width in the aoi is approximately 10 m. Uses the buffer() function from the Terra package.
road_footprint <- aggregate(road_polygons) #Aggregates all of the road polygons into a single polygon; aggregate() function is from the Terra package.
road_area_sqm <- expanse(road_footprint) #Compute the surface area in square meters for the road_footprint polygon using expanse() function from Terra package.
road_area_km2 <- road_area_sqm / 1e6 #Convert to square kilometers 
cutblocks_2022ABMI <- vect("wb_cutblockfix_clip.shp") #Import the ABMI cutblock (timber harvest block) vector shapefile clipped to the aoi in QGIS.  
cutblocks <- project(cutblocks_2022ABMI, crs(wb_2016cset)) #Match the Coordinate Reference System of the imported shapefile to that of the "wb_2016cset" raster
areas_km2_cutblocks<- expanse(cutblocks, unit = "km") #Compute the surface area in square km for each individual cutblock polygons
cutblock_footprint <- sum(areas_km2_cutblocks) #Sum the surface area for the cutblocks 
total_human_footprint_km2 <- cutblock_footprint + road_area_km2 #Calculate a total human footprint for the study area that sums cutblock and road footprint 
aoi_area_km2 <- 155.81651679640706 #Area in square km for the Waiparous Basin aoi generated in GEE
footprint_percentage <- (total_human_footprint_km2 / aoi_area_km2) * 100 #Calculate a total human footprint percentage for the aoi
cutblock_percentage <- (cutblock_footprint / aoi_area_km2) * 100 #Calculate a total cutblock footprint percentage for the aoi
roads_percentage <- (road_area_km2 / aoi_area_km2) * 100 #Calculate a total road footprint percentage for the aoi
footprint_df <- data.frame(road_area_km2,roads_percentage, cutblock_footprint,cutblock_percentage, total_human_footprint_km2,footprint_percentage) #Summarize in a table
````
## Human Footprint Summary for the Study Area
 | Road Area (sqKm) | Road Area (%) | Cutblock Area (sqKm) | Cutblock (%) | Total Human Footprint Area (sqKm) | Total Human Footprint Area (%)|
|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|
|0.81|0.52|20.0|12.8|20.8|13.3|


### Human Footprint Inventory and Hydrology Overlays (Using 2016 and 2022 Classified Images Base Maps)
> [!NOTE]
> See the file Code.R for coding used to generate the map composite below.

![Land Cover Change Bar Plots](RExam_Images/ABMI_Overlays.png)

> **Interpretation**
> There is good conformity between mapped ABMI cutblocks and yellow areas of land disturbance (from image classification). In 2022, the ABMI shapefile missed a cutblock in the north extent of the study area, thus the human footprint summary above is an underestimation.

# 10. Terrain Mapping, Cutblock Slope Erosion Risk Analysis

A cursory analysis was done as described below to identify and determine erosion risk for cutblocks based on slope steepness using Digital Elevation Model (DEM) raster data for the study area imported from GEE.

This analysis entailed the following steps (see coding below):
i) Load the DEM from GEE
ii) Calculate slope in degrees
iii) Generate a hillshade map using Terra package functions based on slope and aspect values from the DEM
iv) Plot the hillshade map using a custom colour palette to show slope gradient from white (flat) to red (steep) in shades of orange
v) Define cutblock slope steepness categories where flat slopes are defined as >10%, moderate slopes are 10% to 15%, and steep slopes are >15% (ttps://sis.agr.gc.ca/cansis/nsdb/dss/v3/cmp/slope_p.html). 
vi) Calculate the area and percentage of each cutblock steepness category
vii) Generate a composite plot with slope (in degrees), stream and road lines, and colour coded slope steepness categories with percentages for each shown as a pie chart graphic.

````r
#Coding below uses Terra package
elevation <- rast("WaiparousBasin_Elevation.tif") #Load the DEM (elevation.tif) file generated in GEE
slope_r <- terrain(elevation, v="slope", unit="degrees") # Calculate Slope in degrees
sl <- terrain(elevation, v="slope", unit="radians") #Calculate slope in radian units for hillshade map
as <- terrain(elevation, v="aspect", unit="radians") #Calculate aspect in radian units for hillshade map
hs <- shade(sl, as, angle = 45, direction = 315) 







