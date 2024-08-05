
# PURPOSE:
## Function that creates a local Shiny app where data can be attached and easily visualized/summarized
## Long-term goal is that you could export graphs & code to make graphs from that app


# See similar Shiny app I built (HerbVar data portal) here:
## https://github.com/HerbVar-Network/Data-Portal/blob/main/Data%20Portal%20Actual/app.R

## For more info on tags object & HTML shortcuts:
## https://shiny.rstudio.com/articles/tag-glossary.html

# Load libraries
librarian::shelf(tidyverse, shiny, htmltools, DT)

# Define function
shiny_explore <- function(){
  
  # UI ----
  explore_ui <- shiny::fluidPage(
    
    # UI - Header / Instructions
    # Browser tab text
    title = "Shiny Explore",
    # Instructions
    htmltools::tags$h3("Welcome!"),
    htmltools::tags$h4("Please attach a data file of your choice and then use the provided tabs to explore your desired graphs."),
    htmltools::br(),
    # Issue link
    htmltools::tags$h4("If you encounter an issue, please ",
                       htmltools::tags$a(href = "https://github.com/njlyon0/supportR/issues",
                                         "open a GitHub issue", target = "_blank"),
                       "and the author of ", htmltools::tags$code("supportR"),
                       "will attempt to resolve the problem."),
    htmltools::br(),
    
    shiny::sidebarLayout(
      
      # UI - Sidebar panel ----
      sidebarPanel(width = 3, 
                   
                   # Attach file
                   fileInput(inputId = "file_upload",
                             label = htmltools::tags$h3("Attach file here:"),
                             accept = c(".csv"), width = "100%"),
                   "Note that the file ", htmltools::tags$strong("must"), " be a CSV.",
                   
                   htmltools::br(),
                   
                   # Select X/Y axes & group variable
                   shiny::selectInput(inputId = "plot_x", label = "X Axis",
                                      choices = "Pending data upload"),
                   shiny::selectInput(inputId = "plot_y", label = "Y Axis",
                                      choices = "Pending data upload"),
                   shiny::selectInput(inputId = "plot_groups", label = "Grouping Variable",
                                      choices = "Pending data upload"),
                   
      ), # Close 'sidebarPanel'
      
      # UI - Main panel ----
      shiny::mainPanel(width = 9,
                       shiny::tabsetPanel(id = "graph_tabs",
                                          tabPanel(title = "Data Table", 
                                                   DT::dataTableOutput(outputId = "table_out")),
                                          tabPanel(title = "Violin Plot"
                                                   ),
                                          tabPanel(title = "Scatter Plot"
                                                   )
                       ) # Close 'tabsetPanel'
      ) # Close 'mainPanel'
    ) # Close 'sidebarLayout'
  ) # Close UI
  
  # Server ----
  explore_server <- function(input, output, session){ 
    
    # Server - Data ingestion ----
    df_actual <- reactive({
      # If no file is attached, do nothing
      if(is.null(input$file_upload)) { return(NULL) } else {
        # If there is a file, make it reactive
        read.csv(file = input$file_upload$datapath, stringsAsFactors = FALSE) }
    })
    
    # Server - Update axis dropdowns ----
    shiny::observe({
      shiny::updateSelectInput(session = session, inputId = "plot_x",
                               choice = names(df_actual()),
                               select = names(df_actual())[1])
    })
    shiny::observe({
      shiny::updateSelectInput(session = session, inputId = "plot_y",
                               choice = names(df_actual()),
                               select = names(df_actual())[2])
    })
    shiny::observe({
      shiny::updateSelectInput(session = session, inputId = "plot_groups",
                               choice = c("No groups", names(df_actual())),
                               select = "No groups")
    })
    
    # Server - Data table rendering ----
    output$table_out <- DT::renderDataTable({
      if(is.null(input$file_upload)){ attach_error } else {
          DT::datatable(data = df_actual(), 
                        options = list(pageLength = 10),
                        rownames = FALSE) }
    })
  
    # Server - Error/warning messages ----
    # If data aren't attached
    attach_error <- data.frame("ALERT" = c("No data detected. Have you attached your data file?"))  
  }
  
  
  
  
  
  # App Call ----
  shiny::shinyApp(ui = explore_ui, server = explore_server) }

# Invoke function
shiny_explore()


