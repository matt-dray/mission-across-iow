# Prep workspace ----------------------------------------------------------

# Attach packages
library(sf)
library(geojsonio)
library(osmextract)

# Focus-location string
loc <- "Isle of Wight"


# Get IoW boundary --------------------------------------------------------


# Fetch local authority district boundaries from the ONS Open Geography Portal
# Dec 2020, generalised (20m) - clipped to the coastline (Mean High Water mark)
iow_extent <- geojson_read(
  "https://opendata.arcgis.com/datasets/db23041df155451b9a703494854c18c4_0.geojson",
  what = "sp"  # read as spatial class
) %>% 
  st_as_sf() %>%  # convert to sf class
  filter(LAD20NM == loc)  # filter to Isle of Wight

# Write the sf object to RDS
write_rds(
  iow_extent,
  "../data/iow-boundary-general-coastline-dec20.rds"
)


# Get OSM data ------------------------------------------------------------


# Fetch polygonal features for IoW
osm_polys <- oe_get(
  loc, layer = "multipolygons",
  stringsAsFactors = FALSE, quiet = TRUE
)

# Fetch line features for IoW
osm_lines <-  oe_get(loc, stringsAsFactors = FALSE, quiet = TRUE)

# Get all the features as a list object with one element per feature
features <- map2(
  list(osm_lines, osm_polys, osm_polys, osm_lines),
  list("barrier", "building", "natural", "waterway"),
  isolate_feature
) %>% 
  set_names("barrs", "bldgs", "natur", "wways")

# Write the sf object to RDS
write_rds(features, "../data/osm-features-selected.rds")