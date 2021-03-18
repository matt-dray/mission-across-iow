# Attach packages
library(shiny)          # CRAN v1.6.0
library(dplyr)          # CRAN v1.0.5
library(readr)          # CRAN v1.4.0
library(purrr)          # CRAN v0.3.4
library(leaflet)        # CRAN v2.0.4.1
library(leaflet.extras) # CRAN v1.0.0
library(sf)             # CRAN v0.9-7

# Load functions
source("R/utils.R")

# Read datasets
iow_extent <- read_rds("data/iow-boundary-general-coastline-dec20.rds")
features <- read_rds("data/osm-features-selected.rds")