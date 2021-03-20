# mission-across-iow Shiny app
# Matt Dray 2021
# Fetch, prepare and save datasets


# Prep workspace ----------------------------------------------------------


# Attach packages
library(here)       # CRAN v1.0.1
library(dplyr)      # CRAN v1.0.5
library(purrr)      # CRAN v0.3.4
library(readr)      # CRAN v1.4.0
library(geojsonio)  # CRAN v0.9.4
library(osmextract) # CRAN v0.2.1
library(sf)         # CRAN v0.9-7

# Load functions
source(here("mission-across-iow", "R", "utils.R"))

# Focus-location string
loc <- "Isle of Wight"

# LAD boundaries (December 2020) UK BGC from the ONS Open Geography Portal
# Generalised (20m) - clipped to the coastline (Mean High Water mark)
# https://geoportal.statistics.gov.uk/datasets/local-authority-districts-december-2020-uk-bgc
geojson_path <- 
  "https://opendata.arcgis.com/datasets/db23041df155451b9a703494854c18c4_0.geojson"


# Get IoW boundary --------------------------------------------------------


# Read LAD boundaries, filter to IOW
iow_extent <- geojson_read(geojson_path, what = "sp") %>% 
  st_as_sf(crs = 4326) %>%
  filter(LAD20NM == loc)

# Write the sf object to RDS
write_rds(
  iow_extent,
  here("mission-across-iow", "data", "iow-boundary-general-coastline-dec20.rds")
)


# Get OSM data ------------------------------------------------------------


# Fetch polygonal features for IoW
osm_polys <- oe_get(
  loc, 
  layer = "multipolygons",
  stringsAsFactors = FALSE,
  quiet = TRUE
) %>%
  st_transform(crs = 4326)

# Fetch line features for IoW
osm_lines <-  oe_get(loc, stringsAsFactors = FALSE, quiet = TRUE) %>%
  st_transform(crs = 4326)

# Get all the features as a list object with one element per feature
features <- map2(
  list(osm_lines, osm_polys, osm_polys, osm_lines),
  list("barrier", "building", "natural", "waterway"),
  isolate_feature
) %>% 
  set_names("barrs", "bldgs", "natur", "wways")

# Write the sf object to RDS
write_rds(
  features, 
  here("mission-across-iow", "data", "osm-features-selected.rds")
)
