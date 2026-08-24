# EXAM_07/09/2026 - WAIPAROUS CREEK BASIN, ALBERTA, CANADA, LAND USE CHANGE SATELLITE IMAGERY ANALYSIS
# Spatial Ecology in R 
# Kathryn Hull

# Satellite imagery source: https://earthengine.google.com/ 
# Below is the coding for extracting satellite imagery clipped to the Waiparous Creek Subbasin
# Time series shows baseline reference year (1985), year of first logging impact (2010) and subsequent full logging impacts (2016 and 2022)
# 1985 and 2010 uses Landsat 5 imagery; 2016 and 2022 use Landsat 8 imagery
# Coding source for cloud masking: https://servir-amazonia.github.io/barbados-training/intro-gee2/processing-cloudmasking-landsat.html 

// 1. Load the HydroBASINS Level 12 dataset (source: https://www.hydrosheds.org/products/hydrobasins) 
var hydroBasins = ee.FeatureCollection("WWF/HydroSHEDS/v1/Basins/hybas_12");

// 2. Filter for the Waiparous Creek subbasin ID based on pre-mapping done in QGIS
var waiparousbasin = hydroBasins.filter(ee.Filter.eq('HYBAS_ID', 7120246560));

// 3. Update your variable name as “area of interest (aoi)”
var aoi = waiparousbasin.geometry();

// 4. Visualize the exact boundary
Map.centerObject(aoi, 11);
Map.addLayer(waiparousbasin, {color: 'blue'}, 'Waiparous Creek Watershed Boundary');

// 5. Calculate the area of the aoi
var areaKm2 = aoi.area(1).divide(1e6);
print('aoi Area (sq km):', areaKm2);

// 6. Mask Cloud and Shadow Cover, Select Bands and Export to Google Drive 
//Reference Coding Source: https://servir-amazonia.github.io/barbados-training/intro-gee2/processing-cloudmasking-landsat.html

// --- CONFIGURATION ---
var year = '1985'; 

// 6a.Function to mask clouds using the Quality Assurance (QA) band
function maskL5clouds(image) {
  var qa = image.select('QA_PIXEL');

//6b. Bitmask for Landsat 5: Bit 3 is Cloud, Bit 4 is Cloud Shadow (reference:https://www.usgs.gov/landsat-missions/landsat-collection-2-quality-assessment-bands)
  var cloudBitMask = 1 << 3;
  var cloudShadowBitMask = 1 << 4;

  // 6c. Both flags should be zero, indicating clear conditions.
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
    .and(qa.bitwiseAnd(cloudShadowBitMask).eq(0));
  return image.updateMask(mask);
}

// 6d. Load and Mask the Collection
var collection = ee.ImageCollection("LANDSAT/LT05/C02/T1_L2")
  .filterBounds(aoi)
  .filterDate('1985-06-01','1985-08-31') // Full summer season period June to end of August
  .map(maskL5clouds); // Apply the cloud mask to EVERY image in the collection

// 6e. Create the Median Composite
// Now, the median only looks at pixels that passed the cloud mask
var image = collection.median().clip(aoi);

// 6f. Select bands for R (reference:https://www.usgs.gov/faqs/what-are-band-designations-landsat-satellites) 
var exportImage = image.select(['SR_B1', 'SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B7']);

//6g. Export to Drive
Export.image.toDrive({
  image: exportImage,
  description: 'WaiparousBasin_1985MASKEDFINAL',
  scale: 30,
  region: aoi,
  fileFormat: 'GeoTIFF'
});

// Repeat for 2010

// --- CONFIGURATION ---
var year = '2010'; 

// Function to mask clouds using the Quality Assurance (QA) band
function maskL5clouds(image) {
  var qa = image.select('QA_PIXEL');

// Bitmask for Landsat 5: Bit 3 is Cloud, Bit 4 is Cloud Shadow (reference: https://www.usgs.gov/landsat-missions/landsat-collection-2-quality-assessment-bands)
  var cloudBitMask = 1 << 3;
  var cloudShadowBitMask = 1 << 4;

  // Both flags should be zero, indicating clear conditions.
  var mask = qa.bitwiseAnd(cloudBitMask).eq(0)
    .and(qa.bitwiseAnd(cloudShadowBitMask).eq(0));

  return image.updateMask(mask);
}

// Load and Mask the Collection
var collection = ee.ImageCollection("LANDSAT/LT05/C02/T1_L2")
  .filterBounds(aoi)
  .filterDate('2010-06-01','2010-08-31') // Full summer season period June to end of August
  .map(maskL5clouds); // Apply the cloud mask to EVERY image in the collection

// Create the Median Composite
// Now, the median only looks at pixels that passed the cloud mask
var image = collection.median().clip(aoi);

// Select bands for R
var exportImage = image.select(['SR_B1', 'SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B7']);

// Export to Drive
Export.image.toDrive({
  image: exportImage,
  description: 'WaiparousBasin_2010MASKEDFINAL',
  scale: 30,
  region: aoi,
  fileFormat: 'GeoTIFF'
});

//CONFIGURATION for 2016 and 2022 USING LANDSAT8---
var year = '2016'; 

// Cloud Mask Function for Landsat 8 (reference: https://www.usgs.gov/landsat-missions/landsat-collection-2-quality-assessment-bands) 
function maskL8clouds(image) {
  var qa = image.select('QA_PIXEL');
// Bitmask for Landsat 8: Bit 1 = Dilated Cloud, Bit 2 = Cirrus, Bit 3 = Cloud, Bit 4= Cloud Shadow
  var mask = qa.bitwiseAnd(1 << 1).eq(0)
    .and(qa.bitwiseAnd(1 << 2).eq(0))
    .and(qa.bitwiseAnd(1 << 3).eq(0))
    .and(qa.bitwiseAnd(1 << 4).eq(0));
  return image.updateMask(mask);
}

// Load Landsat 8 Collection 2 Level 2
var collection = ee.ImageCollection("LANDSAT/LC08/C02/T1_L2")
  .filterBounds(aoi)
  .filterDate('2016-06-01', '2016-08-31')
  .map(maskL8clouds);

// Create Median Composite and Clip
var image = collection.median().clip(aoi);

// Select Original Bands
// This keeps the native Landsat 8 names: SR_B1, SR_B2, SR_B3, SR_B4, SR_B5, SR_B6, SR_B7
var exportImage = image.select(['SR_B1', 'SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B6', 'SR_B7']);

// Export to Drive
Export.image.toDrive({
  image: exportImage,
  description: 'WaiparousBasin_2016_RawBandsL8CF',
  scale: 30,
  region: aoi,
  fileFormat: 'GeoTIFF',
  maxPixels: 1e9
});

// var year = '2022'; 

// Cloud Mask Function for Landsat 8 (reference: https://www.usgs.gov/landsat-missions/landsat-collection-2-quality-assessment-bands) 
function maskL8clouds(image) {
  var qa = image.select('QA_PIXEL');
// Bitmask for Landsat 8: Bit 1 = Dilated Cloud, Bit 2 = Cirrus, Bit 3 = Cloud, Bit 4= Cloud Shadow
  var mask = qa.bitwiseAnd(1 << 1).eq(0)
    .and(qa.bitwiseAnd(1 << 2).eq(0))
    .and(qa.bitwiseAnd(1 << 3).eq(0))
    .and(qa.bitwiseAnd(1 << 4).eq(0));
  return image.updateMask(mask);
}

// Load Landsat 8 Collection 2 Level 2
var collection = ee.ImageCollection("LANDSAT/LC08/C02/T1_L2")
  .filterBounds(aoi)
  .filterDate('2022-06-01', '2022-08-31')
  .map(maskL8clouds);

// Create Median Composite and Clip
var image = collection.median().clip(aoi);

// Select Original Bands
// This keeps the native Landsat 8 names: SR_B1, SR_B2, SR_B3, SR_B4, SR_B5, SR_B6, SR_B7
var exportImage = image.select(['SR_B1', 'SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B6', 'SR_B7']);

// Export to Drive
Export.image.toDrive({
  image: exportImage,
  description: 'WaiparousBasin_2022_RawBandsL8CF',
  scale: 30,
  region: aoi,
  fileFormat: 'GeoTIFF',
  maxPixels: 1e9
});

# Below is the coding for extracting a watercourse (hydrology) layer clipped to the study area
# Repository source for hydrology data: https://developers.google.com/earth-engine/datasets/catalog/MERIT_Hydro_v1_0_1 

// ADDING WATERCOURSES 

// Load MERIT Hydro
var merit = ee.Image("MERIT/Hydro/v1_0_1");

// Select the corrected band name 'upa' (Upstream drainage area)
// The units are in square kilometers.
// Threshold of 1.0 km² captures significant tributary streams.
var streams = merit.select('upa').gt(1.0).selfMask().clip(aoi);

// Visualize to confirm (Streams will appear in blue)
Map.addLayer(streams, {palette: ['blue']}, 'MERIT Streams (>1km2)');

// Export as GeoTIFF
Export.image.toDrive({
  image: streams,
  description: 'WaiparousBasin_MERIT_Streams',
  scale: 90,             // MERIT native resolution is ~90m
  region: aoi,
  fileFormat: 'GeoTIFF'
});

# Below is the coding for exporting a digital elevation model (DEM) for the study area

// EXPORT A DIGITAL ELEVATION MODEL (DEM) for the Waiparous Basin AOI 

// Load the NASADEM dataset
var dataset = ee.Image("NASA/NASADEM_HGT/001");

//Select the elevation band (HGT)
var elevation = dataset.select('elevation').clip(aoi);

// Export the DEM to Google Drive
Export.image.toDrive({
  image: elevation,
  description: 'WaiparousBasin_Elevation',
  scale: 30,             // 30 meters matches Landsat
  region: aoi,
  fileFormat: 'GeoTIFF',
  maxPixels: 1e9
});

