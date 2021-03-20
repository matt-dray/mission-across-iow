# mission-across-iow Shiny app
# Matt Dray 2021
# User interface

ui <- fluidPage(
    
    theme = bs_theme(
        bg = "#333333",
        fg = "#FFFFFF",
        primary = "#BEBEBE",
        base_font = font_google("IBM Plex Sans Condensed")
    ),
    
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    
    titlePanel("[WIP] Mission Across IOW"),
    
    sidebarLayout(
        
        sidebarPanel(
            
            div(
                img(src = "iow-flag-institute.png", width = "50%"),
                style = "text-align: center;"
            ),
            hr(),
            
            p("Find the best straight line route across",
              a(href = "https://en.wikipedia.org/wiki/Isle_of_Wight", 
                "the Isle of Wight"), "UK"
            ),
            p("Inspired by",
              a(href = "https://www.youtube.com/channel/UCW5OrUZ4SeUYkUg1XqcjFYA", 
                "Tom 'Geowizard' Davies")),
            hr(),
            
            p("Select start and end points."),
            fluidRow(
                column(
                    width = 6, 
                    numericInput(
                        inputId = "x1", label = "Start lon", value = 50.658, 
                        min = 50.57, max = 50.77, step = 0.001)
                ),
                column(
                    width = 6,
                    numericInput(
                        inputId = "y1", label = "Start lat", value = -1.472, 
                        min = -1.6, max = -1.06, step = 0.001)
                )
            ),
            fluidRow(
                column(
                    width = 6,
                    numericInput(
                        inputId = "x2", label = "End lon", value = 50.707, 
                        min = 50.57, max = 50.77, step = 0.001)
                    ),
                column(
                    width = 6,
                    numericInput(
                        inputId = "y2", label = "End lat", value = -1.101, 
                        min = -1.6, max = -1.06, step = 0.001)
                )
            ),
            hr(),
            
            p(
                a(href="https://www.matt-dray.com", "Matt Dray"), "|", 
                a(href="https://www.github.com/matt-dray/mission-across-iow", "Source")
            )
            
        ),  # end sidebarPanel
        
        mainPanel(
            
            leafletOutput("map", height = "100%")

        )  # end mainPanel
        
    )  # end sidebarLayout
    
)  # end fluidPage
