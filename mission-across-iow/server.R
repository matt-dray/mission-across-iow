# mission-across-iow Shiny app
# Matt Dray 2021
# Server

server <- function(input, output) {
  
  output$map <- renderLeaflet({
    
    # Build line between user's points, clip to IOW boundary
    line <- make_line(
      x1 = input$x1, y1 = input$y1, 
      x2 = input$x2, y2 = input$y2, 
      boundary_poly = iow_extent
    )
    
    # Generate a 25m buffer ('platinum standard') around the line
    buffer <- make_buffer(line = line)
    
    # Find intersection between features and line
    obstructions <- map(.x = features, ~find_obstruction(.x, line)) %>% 
      set_names("barrs", "bldgs", "natur", "wways")
    
    # Set multi-use variables
    marker_fill <- "darkblue"
    icon_fill <- "white"
    col_line <- "#000"
    col_artifical <- "#F00"
    col_water <- "#00F"
    weight_line <- 1
    weight_obstruction <- 2
    alpha_all <- 0.5
    
    # Interactive map
    leaflet() %>% 
      # Base groups: map tiles
      addProviderTiles("CartoDB.PositronNoLabels", group = "Simple") %>%
      addProviderTiles("Esri.WorldTopoMap", group = "Terrain") %>%
      addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
      # Overlay groups: line and buffer
      addPolygons(
        data = buffer, group = "Line/buffer", 
        color = col_line, weight = weight_line, dashArray = 4, 
        fill = TRUE, opacity = alpha_all
      ) %>% 
      addPolylines(
        data = line, group = "Line/buffer",
        color = col_line, weight = weight_line, 
        fill = FALSE
      ) %>%
      # Overlay groups: start and end points
      addAwesomeMarkers(
        lng = input$y1, lat = input$x1, group = "Start/end",
        icon = awesomeIcons(
          markerColor = "blue",
          icon = "play", library = "fa", iconColor = "#FFF"
        ),
        popup = paste0("<center>Start<br>", input$x1, ", ", input$y1, "<center>")
      ) %>% 
      addAwesomeMarkers(
        lng = input$y2, lat = input$x2, group = "Start/end",
        icon = awesomeIcons(
          markerColor = "blue",
          icon = "stop", library = "fa", iconColor = "#FFF"
        ),
        popup = paste0("<center>End<br>", input$x2, ", ", input$y2, "<center>")
      ) %>% 
      # Overlay groups: features in buffer
      addPolylines(
        data = obstructions$barrs, group = "Barriers",
        color = col_artifical, weight = weight_obstruction,
        label = paste("Barrier:", obstructions$barrs$type)
      ) %>% 
      addPolygons(
        data = obstructions$bldgs, group = "Buildings",
        color = col_artifical, weight = weight_obstruction, 
        fillColor = col_artifical, fillOpacity = alpha_all,
        label = paste("Building:", obstructions$bldgs$type)
      ) %>%
      addPolygons(
        data = filter(obstructions$natur, type == "water"), group = "Water",
        color = col_water, weight = weight_obstruction, 
        fillColor = col_water, fillOpacity = alpha_all,
        label = "Water body"
      ) %>% 
      addPolylines(
        data = obstructions$wways, group = "Water",
        color = col_water, weight = weight_obstruction,
        label = paste("Waterway:", obstructions$wways$type)
      ) %>% 
      # Control which layers are shown
      addLayersControl(
        baseGroups = c("Simple", "Terrain", "Satellite"),  # radio button
        overlayGroups = c(  # checkboxes
          "Line/buffer", "Start/end",  # line-related
          "Water", "Barriers", "Buildings"  # obstructions
        ),
        position = "topright",
        options = layersControlOptions(collapsed = FALSE)
      ) %>% 
      # Other map features
      addMeasure(  # tool for users to measure distances
        position = "topleft",
        primaryLengthUnit = "meters",
        primaryAreaUnit = "sqmeters"
      ) %>% 
      addFullscreenControl()  # clickable full-screen button
    
  })
}
