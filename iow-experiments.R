# Attach packages
library(dplyr)
library(leaflet)
library(leaflet.extras)
library(sf)
library(geojsonio)
library(osmextract)

# Focus-location string
loc <- "Isle of Wight"

# Fetch local authority district boundaries from the ONS Open Geography Portal
# May 2020, generalised (20m) - clipped to the coastline (Mean High Water mark)
iow_extent <- geojson_read(
  "https://opendata.arcgis.com/datasets/3b374840ce1b4160b85b8146b610cd0c_0.geojson",
  what = "sp"  # read as spatial class
) %>% 
  st_as_sf() %>%  # convert to sf class
  filter(LAD20NM == loc)  # filter to Isle of Wight

# Create a straight line
make_line <- function(x1, y1, x2, y2, boundary_poly) {
  st_linestring(matrix(c(y1, y2, x1, x2), ncol = 2)) %>% 
    st_sfc(crs = 4326) %>% 
    st_intersection(boundary_poly)
}

# Create a buffer around the straight line
make_buffer <- function(linestring, buffer_size = 25) {
  st_buffer(st_transform(line, crs = 27700), dist = buffer_size) %>%
    st_transform(crs = 4326)
}

# Generate a demo line
line <- make_line(
  x1 = 50.658188, y1 = -1.472367, 
  x2 = 50.707817, y2 = -1.101455, 
  boundary_poly = iow_extent
)

# Generate a buffer around the demo line
buffer <- make_buffer(linestring = line)

# Fetch polygonal features for IoW
osm_poly <- oe_get(
  loc, layer = "multipolygons", stringsAsFactors = FALSE, quiet = TRUE
)

# Fetch line features for IoW
osm_lines <-  oe_get(loc, stringsAsFactors = FALSE, quiet = TRUE)

# Filter for a single feature type from oe_get() output
isolate_feature <- function(sf_in, feature) {
  sf_in %>% 
    filter(!is.na(sf_in[[feature]])) %>% 
    select(osm_id, all_of(feature), geometry)
}

# Isolated features
waterways <- isolate_feature(osm_lines, "waterway")
barriers <- isolate_feature(osm_lines, "barrier")
buildings <- isolate_feature(osm_poly, "building")

# Features intersecting with the line
waterways_int <- st_intersection(line, waterways)
barriers_int <- st_intersection(line, barriers)
buildings_int <- st_intersection(line, buildings)

# Count number of intersections
length(waterways_int)

# Interactive map
leaflet() %>% 
  # Base groups: map tiles
  addProviderTiles(providers$CartoDB.PositronNoLabels, group = "Simple") %>%
  addProviderTiles(providers$Esri.WorldTopoMap, group = "Terrain") %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
  # Overlay groups: features
  addPolygons(
    data = buildings, group = "Buildings",
    color = "#F00", weight = 1, fill = FALSE
  ) %>% 
  addPolylines(
    data = waterways, group = "Waterways",
    color = "#00F", weight = 1, fill = FALSE
  ) %>% 
  addPolylines(
    data = barriers, group = "Barriers",
    color = "#0F0", weight = 1, fill = FALSE
  ) %>% 
  # Overlay groups: line and buffer
  addPolylines(data = line, group = "Line") %>%
  addPolygons(data = buffer, group = "Buffer") %>% 
  # Overlay groups: intersection markers 
  addMarkers(data = waterways_int, group = "Obstructions") %>% 
  # Control which layers are shown
  addLayersControl(
    baseGroups = c("Simple", "Terrain", "Satellite"),
    overlayGroups = c(
      "Line", "Buffer", "Obstructions",
      "Waterways", "Barriers", "Buildings"),
    position = "topright",
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  hideGroup(c("Buildings", "Waterways", "Barriers")) %>% 
  # Other map features
  addFullscreenControl()
