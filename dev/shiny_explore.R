
# PURPOSE:
## Function that creates a local Shiny app where data can be attached and easily visualized/summarized
## Long-term goal is that you could export graphs & code to make graphs from that app


# Define function
shiny_explore <- function(){
  
  # UI ----
  explore_ui <- shiny::fluidPage(
    "Hello there!"
  )
  
  # Server ----
  explore_server <- function(input, output){ 
    
  }
  
  # App Call ----
  shiny::shinyApp(ui = explore_ui, server = explore_server) }

# Invoke function
shiny_explore()


