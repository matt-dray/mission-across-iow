
# Line and buffer ---------------------------------------------------------


# Create a straight line
make_line <- function(x1, y1, x2, y2, boundary_poly) {
  sf::st_linestring(matrix(c(y1, y2, x1, x2), ncol = 2)) %>% 
    sf::st_sfc(crs = 4326) %>% 
    sf::st_intersection(boundary_poly)
}

# Create a buffer around the straight line
make_buffer <- function(line, buffer_size = 25) {
  sf::st_buffer(st_transform(line, crs = 27700), dist = buffer_size) %>%
    sf::st_transform(crs = 4326)
}


# OSM data ----------------------------------------------------------------


# Filter for a single feature type from oe_get() output
isolate_feature <- function(sf_in, feature) {
  sf_in %>% 
    dplyr::filter(!is.na(sf_in[[feature]])) %>% 
    dplyr::select(osm_id, type = all_of(feature), geometry)
}


# Obstructions ------------------------------------------------------------


# Extract features that intersect with the line or buffer geometry
find_obstruction <- function(features_sf, path_sf) {
  row_nums <- sf::st_intersects(path_sf, features_sf)[[1]]
  dplyr::slice(features_sf, row_nums)
}
