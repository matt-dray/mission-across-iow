# mission-across-iow Shiny app
# Matt Dray 2021
# General purpose server functions


# Line and buffer ---------------------------------------------------------


# Create a straight line
make_line <- function(x1, y1, x2, y2,  # latlongs of start and end
                      boundary_poly) {  # polygon of the island extent
  
  x <- st_linestring(matrix(c(y1, y2, x1, x2), ncol = 2))  # to matrix
  
  y <- st_sfc(x, crs = 4326)  # set coord reference system
  
  z <- st_intersection(y, boundary_poly)  # clip line to island boundary
  
  return(z)
  
}

# Create a buffer around the straight line
make_buffer <- function(line,  # as created with make_line()
                        buffer_size = 25) {  # 25m is 'platinum' standard
  
  x <- st_transform(line, crs = 27700)  # line to draw buffer around
  
  y <- st_buffer(x, dist = buffer_size)
  
  z <- st_transform(y, crs = 4326)  # reset coord reference system

  return(z)
  
}


# OSM data ----------------------------------------------------------------


# Filter for a single feature type from oe_get() output
isolate_feature <- function(sf_in,  # OSM sf object
                            feature) {  # the filter to isolate
  
  sf_in %>% 
    filter(!is.na(sf_in[[feature]])) %>%  # filter for feature
    select(osm_id, type = all_of(feature), geometry)  # simplify object
  
}


# Obstructions ------------------------------------------------------------


# Extract features that intersect with the line or buffer geometry
find_obstruction <- function(features_sf,  # sf object containing features
                             path_sf = c("line", "buffer")) {  # intersection
  
  row_nums <- st_intersects(path_sf, features_sf)[[1]]  # rows with obstruction
  
  slice(features_sf, row_nums)  # extract matching rows
  
}
