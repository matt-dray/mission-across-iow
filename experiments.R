# Mission Across Wales
# Experiments
# Matt Dray, 2021-01-21


# Prepare workspace -------------------------------------------------------


# Attach packages
library(sf)
library(tidyverse)
library(leaflet)
library(geojsonio)


# Geospatial objects ------------------------------------------------------


# Welsh border
cym_clip <- st_read("data/NUTS_Level_1__January_2018__Boundaries-shp") %>% 
  st_as_sf() %>% 
  st_transform(crs = 4326) %>% 
  filter(nuts118nm == "Wales")

# Buildings
cym_build <- st_read(
  "data/wales-latest-free.shp/",
  layer = "gis_osm_buildings_a_free_1"
)

# Main rivers
cym_water <- st_read("data/MainRivers/") %>% 
  st_transform(crs = 4326) 

# An example line and buffer
cym_line <- st_linestring(matrix(c(-4.22, -2.91, 52.7, 52.7), ncol = 2)) %>% 
  st_sfc(crs = 4326) %>% st_transform(crs = 27700)
cym_line_buffer <- st_buffer(cym_line, dist = 25) %>% st_transform(crs = 4326)


# Crops -------------------------------------------------------------------


# Crop the Welsh border to a focus area
box_out <- c(
  xmin = -4.22, xmax = -2.91, 
  ymin = 52.62, ymax = 52.78
)

# Crop the geospatial objects to the focus area
cym_clip_crop <- st_crop(cym_clip, st_bbox(box_out, crs = 4326))
cym_build_crop <- st_intersection(cym_build, cym_clip_crop)
cym_water_crop <- st_intersection(cym_water, cym_clip_crop)
cym_line_crop <- st_intersection(cym_line_buffer, cym_clip_crop)


# Leaflet map -------------------------------------------------------------


# Simple interactive map of objects in focus area
leaflet() %>% 
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = cym_clip_crop) %>% 
  addPolygons(data = cym_build_crop) %>% 
  addPolylines(data = cym_water_crop) %>% 
  addPolylines(data = cym_line_crop)
