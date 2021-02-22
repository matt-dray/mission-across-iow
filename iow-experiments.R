
# Prep workspace ----------------------------------------------------------


# Attach packages
library(here)
library(dplyr)
library(purrr)
library(leaflet)
library(leaflet.extras)
library(sf)
library(geojsonio)
library(osmextract)

# Source bespoke functions
source(here("R", "mission-critical.R"))

# Focus-location string
loc <- "Isle of Wight"


# Get IoW boundary --------------------------------------------------------


# Fetch local authority district boundaries from the ONS Open Geography Portal
# May 2020, generalised (20m) - clipped to the coastline (Mean High Water mark)
iow_extent <- geojson_read(
  "https://opendata.arcgis.com/datasets/3b374840ce1b4160b85b8146b610cd0c_0.geojson",
  what = "sp"  # read as spatial class
) %>% 
  st_as_sf() %>%  # convert to sf class
  filter(LAD20NM == loc)  # filter to Isle of Wight


# Create line and buffer --------------------------------------------------


# Generate a demo line
line <- make_line(
  x1 = 50.658188, y1 = -1.472367, 
  x2 = 50.707817, y2 = -1.101455, 
  boundary_poly = iow_extent
)

# Generate a 25m buffer around the demo line (this is considered 'platinum'
# standard)
buffer <- make_buffer(linestring = line)


# Get OSM data ------------------------------------------------------------


# Fetch polygonal features for IoW
osm_poly <- oe_get(
  loc, layer = "multipolygons", stringsAsFactors = FALSE, quiet = TRUE
)

# Fetch line features for IoW
osm_lines <-  oe_get(loc, stringsAsFactors = FALSE, quiet = TRUE)

# Get all the features as a list object with one element per feature
features <- map2(
  list(osm_lines, osm_poly, osm_lines),
  list("barrier", "building", "waterway"),
  isolate_feature
) %>% 
  set_names("barrs", "bldgs", "wways")


# Find obstructions -------------------------------------------------------


# Find intersection between features and line
obstructions <- map(
  features,
  ~find_obstruction(line, .x)
) %>% 
  set_names("barrs", "bldgs", "wways")


# Plot --------------------------------------------------------------------


# Interactive map
leaflet() %>% 
  # Base groups: map tiles
  addProviderTiles("CartoDB.PositronNoLabels", group = "Simple") %>%
  addProviderTiles("Esri.WorldTopoMap", group = "Terrain") %>%
  addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
  # Overlay groups: line and buffer
  addPolygons(
    data = buffer, group = "Line/buffer", 
    color = "#000", weight = 1, dashArray = 4, fill = TRUE, opacity = 0.5
  ) %>% 
  addPolylines(
    data = line, group = "Line/buffer",
    color = "#000", weight = 1, fill = FALSE
  ) %>%
  # Overlay groups: features in buffer
  addPolylines(
    data = obstructions$barrs, group = "Barriers",
    color = "#F00", weight = 2,
    label = paste("Barrier:", obstructions$barrs$type)
  ) %>% 
  addPolygons(
    data = obstructions$bldgs, group = "Buildings",
    color = "#F00", weight = 2, fill = TRUE, fillColor = "#F00", fillOpacity = 0.5,
    label = paste("Building:", obstructions$bldgs$type)
  ) %>% 
  addPolylines(
    data = obstructions$wways, group = "Waterways",
    color = "#00F", weight = 2,
    label = paste("Waterway:", obstructions$wways$type)
  ) %>% 
  # Control which layers are shown
  addLayersControl(
    baseGroups = c("Simple", "Terrain", "Satellite"),
    overlayGroups = c("Line/buffer", "Waterways", "Barriers", "Buildings"),
    position = "topright",
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  # Other map features
  addMeasure(
    position = "topright",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters"
  ) %>% 
  addFullscreenControl()
