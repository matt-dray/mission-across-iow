# Initial code via 
# https://github.com/bhaskarvk/leaflet.extras/blob/master/inst/examples/shiny/draw-events/app.R

library(leaflet.extras)
library(shiny)


# UI ----------------------------------------------------------------------


ui <- fluidPage(
  titlePanel("Mission Across IoW"),
  br(),
  sidebarLayout(
    sidebarPanel(
      HTML("This is some dummy text"),
      textOutput("text")
    ),
    mainPanel(leafletOutput("leafmap"))
  )
)


# Server ------------------------------------------------------------------


server <- function(input, output, session) {
  
  poly <- reactiveValues(poligonos = list())

  output$leafmap <- renderLeaflet({
    leaflet() %>%
      # Base groups: map tiles
      addProviderTiles("CartoDB.PositronNoLabels", group = "Simple") %>%
      addProviderTiles("Esri.WorldTopoMap", group = "Terrain") %>%
      addProviderTiles("Esri.WorldImagery", group = "Satellite") %>%
      addLayersControl(
        baseGroups = c("Simple", "Terrain", "Satellite"),
        position = "topright",
        options = layersControlOptions(collapsed = FALSE)
      ) %>% 
      # Draw toolbar
      addDrawToolbar(
        singleFeature = TRUE,
        editOptions = editToolbarOptions(),
        polylineOptions = drawPolylineOptions(),
        polygonOptions = FALSE,
        circleOptions = FALSE,
        rectangleOptions = FALSE,
        markerOptions = FALSE,
        circleMarkerOptions = FALSE
      )
  })
  
  polygons <- eventReactive(input$mymap_draw_all_features, {
    
    features <- input$leafmap_draw_new_feature
    poly$poligonos <- c(poly$poligonos, features)
    
    return(poly$poligonos)
    
  })
  

  
  # # Start of Drawing
  # observeEvent(input$leafmap_draw_start, {
  #   print("Start of drawing")
  #   print(input$leafmap_draw_start)
  # })
  #          
  # # Stop of Drawing
  # observeEvent(input$leafmap_draw_stop, {
  #   print("Stopped drawing")
  #   print(input$leafmap_draw_stop)
  # })
  # 
  # # New Feature
  # observeEvent(input$leafmap_draw_new_feature, {
  #   print("New Feature")
  #   print(input$leafmap_draw_new_feature)
  # })
  # 
  # # Edited Features
  # observeEvent(input$leafmap_draw_edited_features, {
  #   print("Edited Features")
  #   print(input$leafmap_draw_edited_features)
  # })
  # 
  # # Deleted features
  # observeEvent(input$leafmap_draw_deleted_features, {
  #   print("Deleted Features")
  #   print(input$leafmap_draw_deleted_features)
  # })
  # 
  # # We also listen for draw_all_features which is called anytime
  # # features are created/edited/deleted from the map
  # observeEvent(input$leafmap_draw_all_features, {
  #   print("All Features")
  #   print(input$leafmap_draw_all_features)
  # })
  
}

shinyApp(ui, server)