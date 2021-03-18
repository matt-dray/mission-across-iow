
ui <- fluidPage(
    
    # Application title
    titlePanel("Mission Across IOW"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        
        sidebarPanel(
            
            strong("Start point"),
            fluidRow(
                column(
                    width = 6, 
                    numericInput(
                        inputId = "x1", label = "Lon", value = 50.658, 
                        min = 50.57, max = 50.77, step = 0.001)
                ),
                column(
                    width = 6,
                    numericInput(
                        inputId = "y1", label = "Lat", value = -1.472, 
                        min = -1.6, max = -1.06, step = 0.001)
                )
            ),
            strong("End point"),
            fluidRow(
                column(
                    width = 6,
                    numericInput(
                        inputId = "x2", label = "Lon", value = 50.707, 
                        min = 50.57, max = 50.77, step = 0.001)
                    ),
                column(
                    width = 6,
                    numericInput(
                        inputId = "y2", label = "Lat", value = -1.101, 
                        min = -1.6, max = -1.06, step = 0.001)
                )
            )
            
        ),  # end sidebarPanel
        
        mainPanel(
            
            leafletOutput("leafmap")

        )  # end mainPanel
        
    )  # end sidebarLayout
    
)  # end fluidPage
