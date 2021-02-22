
# Line and buffer ---------------------------------------------------------


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


# OSM data ----------------------------------------------------------------


# Filter for a single feature type from oe_get() output
isolate_feature <- function(sf_in, feature) {
  sf_in %>% 
    filter(!is.na(sf_in[[feature]])) %>% 
    select(osm_id, type = all_of(feature), geometry)
}


# Obstructions ------------------------------------------------------------


# Extract features that intersect with the line or buffer geometry
find_obstruction <- function(geometry, features_sf) {
  slice(
    features_sf,
    st_intersects(geometry, features_sf)[[1]])
}
