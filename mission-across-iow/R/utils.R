# mission-across-iow Shiny app
# Matt Dray 2021
# General purpose server functions


# Line and buffer ---------------------------------------------------------


# Create a straight line
make_line <- function(x1, y1, x2, y2,  # latlongs of start and end
                      boundary_poly) {  # polygon of the island extent
  sf::st_linestring(matrix(c(y1, y2, x1, x2), ncol = 2)) %>%  # to matrix
    sf::st_sfc(crs = 4326) %>%   # set coord reference system
    sf::st_intersection(boundary_poly)  # clip line to island boundary
}

# Create a buffer around the straight line
make_buffer <- function(line,  # as created with make_line()
                        buffer_size = 25) {  # 25m is 'platinum' standard
  sf::st_buffer( 
    sf::st_transform(line, crs = 27700),  # line to draw buffer around
    dist = buffer_size  # size of buffer to draw
  ) %>%
    sf::st_transform(crs = 4326)  # reset coord reference system
}


# OSM data ----------------------------------------------------------------


# Filter for a single feature type from oe_get() output
isolate_feature <- function(sf_in,  # OSM sf object
                            feature) {  # the filter to isolate
  sf_in %>% 
    dplyr::filter(!is.na(sf_in[[feature]])) %>%  # filter for feature
    dplyr::select(osm_id, type = all_of(feature), geometry)  # simplify object
}


# Obstructions ------------------------------------------------------------


# Extract features that intersect with the line or buffer geometry
find_obstruction <- function(features_sf,  # sf object containing features
                             path_sf = c("line", "buffer")) {  # intersection
  row_nums <- sf::st_intersects(path_sf, features_sf)[[1]]  # rows with obstruction
  dplyr::slice(features_sf, row_nums)  # extract matching rows
}
