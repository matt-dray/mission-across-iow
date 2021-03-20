# mission-across-iow Shiny app
# Matt Dray 2021
# Attach and load globally

# Attach packages
library(bslib)          # CRAN v0.2.4
library(dplyr)          # CRAN v1.0.5          
library(fontawesome)    # CRAN v0.1.0    
library(readr)          # CRAN v1.4.0          
library(leaflet)        # CRAN v2.0.4.1        
library(leaflet.extras) # CRAN v1.0.0 
library(purrr)          # CRAN v0.3.4          
library(sf)             # CRAN v0.9-7             
library(shiny)          # CRAN v1.6.0          

# Load functions
source("R/utils.R")

# Read boundary dataset
# An sf-class multipolygon of the island's boundary
iow_extent <- read_rds("data/iow-boundary-general-coastline-dec20.rds")

# Read features dataset
# A list of sf-class lines and polygons that represent obstructions
features <- read_rds("data/osm-features-selected.rds")

