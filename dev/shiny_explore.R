
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
                                          tabPanel(title = "Boxplot",
                                                   shiny::plotOutput(outputId = "box_out")),
                                          tabPanel(title = "Scatter Plot",
                                                   shiny::plotOutput(outputId = "point_out")),
                                          tabPanel(title = "Violin Plot",
                                                   shiny::plotOutput(outputId = "violin_out"))
                       ) # Close 'tabsetPanel'
      ) # Close 'mainPanel'
    ) # Close 'sidebarLayout'
  ) # Close UI
  
  # Server ----
  explore_server <- function(input, output, session){ 
    
    # Defaults / Constants ----
    default_fill <- "#ff006e"
    
    # Server - Data ingestion ----
    df_raw <- reactive({
      # If no file is attached, do nothing
      if(is.null(input$file_upload)) { return(NULL) } else {
        # If there is a file, make it reactive
        read.csv(file = input$file_upload$datapath, stringsAsFactors = FALSE) }
    })
    
    # Server - Update axis dropdowns ----
    shiny::observe({
      shiny::updateSelectInput(session = session, inputId = "plot_x",
                               choice = names(df_raw()),
                               select = names(df_raw())[1])
    })
    shiny::observe({
      shiny::updateSelectInput(session = session, inputId = "plot_y",
                               choice = names(df_raw()),
                               select = names(df_raw())[2])
    })
    shiny::observe({
      shiny::updateSelectInput(session = session, inputId = "plot_groups",
                               choice = c("No groups", names(df_raw())),
                               select = "No groups")
    })
    
    # Server - React to axis choices
    picked_x <- reactive({ input$plot_x })
    picked_y <- reactive({ input$plot_y })
    picked_groups <- reactive({ input$plot_groups })
    
    # Server - Data table rendering ----
    output$table_out <- DT::renderDataTable({
      if(is.null(input$file_upload)){ attach_error } else {
        DT::datatable(data = df_raw(), 
                      options = list(pageLength = 10),
                      rownames = FALSE) }
    })
    
    # Server - Remove missing values ----
    df_subx <- reactive({
      df_raw()[is.na(df_raw()[[picked_x()]]) != TRUE, ]
    })
    df_subxy <- reactive({
      df_subx()[is.na(df_subx()[[picked_y()]]) != TRUE, ]
    })
    df_ready <- reactive({
      if(picked_groups() == "No groups"){ df_subxy() } else {
        df_subxy()[is.na(df_subxy()[[picked_groups()]]) != TRUE, ] }
    })
    
    # Server - Boxplot core ----
    box_core <- reactive({
      ggplot2::ggplot(data = df_ready(), 
                      ggplot2::aes(x = .data[[picked_x()]], 
                                   y = .data[[picked_y()]])) +
        ggplot2::labs(x = picked_x(), y = picked_y()) +
        supportR::theme_lyon() +
        theme(axis.text.x = ggplot2::element_text(angle = 35, hjust = 1))
    })
    
    # Server - Boxplot final ----
    output$box_out <- shiny::renderPlot(
      if(picked_groups() == "No groups"){ 
        box_core() +
          ggplot2::geom_boxplot(ggplot2::aes(fill = "x"), pch = 21) +
          ggplot2::geom_jitter(width = 0.1, alpha = 0.5) +
          ggplot2::scale_fill_manual(values = c("x" = default_fill)) +
          ggplot2::theme(legend.position = "none")
      } else {
        box_core() +
          ggplot2::geom_boxplot(ggplot2::aes(fill = .data[[picked_groups()]]),
                                pch = 21) +
          ggplot2::geom_jitter(width = 0.1, alpha = 0.5)
      }
    )
    
    # Server - Scatterplot core ----
    point_core <- reactive({
      ggplot2::ggplot(data = df_ready(), 
                      ggplot2::aes(x = .data[[picked_x()]], 
                                   y = .data[[picked_y()]])) +
        ggplot2::labs(x = picked_x(), y = picked_y()) +
        supportR::theme_lyon() +
        theme(axis.text.x = ggplot2::element_text(angle = 35, hjust = 1))
    })
    
    # Server - Scatterplot final ----
    output$point_out <- shiny::renderPlot(
      if(picked_groups() == "No groups"){ 
        point_core() +
          ggplot2::geom_jitter(ggplot2::aes(fill = "x"), width = 0.1, 
                               pch = 21, size = 2.5) +
          ggplot2::scale_fill_manual(values = c("x" = default_fill)) +
          ggplot2::theme(legend.position = "none")
      } else {
        point_core() +
          ggplot2::geom_jitter(ggplot2::aes(fill = .data[[picked_groups()]]),
                               width = 0.1, pch = 21, size = 2.5)
      }
    )
    
    # Server - Violin core ----
    violin_core <- reactive({
      ggplot2::ggplot(data = df_ready(), 
                      ggplot2::aes(x = .data[[picked_x()]], 
                                   y = .data[[picked_y()]])) +
        ggplot2::labs(x = picked_x(), y = picked_y()) +
        supportR::theme_lyon() +
        theme(axis.text.x = ggplot2::element_text(angle = 35, hjust = 1))
    })
    
    # Server - Violin final ----
    output$violin_out <- shiny::renderPlot(
      if(picked_groups() == "No groups"){ 
        violin_core() +
          ggplot2::geom_violin(ggplot2::aes(fill = "x")) +
          ggplot2::geom_jitter(width = 0.1, alpha = 0.5) +
          ggplot2::scale_fill_manual(values = c("x" = default_fill)) +
          ggplot2::theme(legend.position = "none")
      } else {
        violin_core() +
          ggplot2::geom_violin(ggplot2::aes(fill = .data[[picked_groups()]]) ) +
          ggplot2::geom_jitter(width = 0.1, alpha = 0.5)
      }
    )
    
    # Server - Error/warning messages ----
    # If data aren't attached
    attach_error <- data.frame("ALERT" = c("No data detected. Have you attached your data file?"))  
  } # Close server
  
  # App Call ----
  shiny::shinyApp(ui = explore_ui, server = explore_server) }

# Invoke function
shiny_explore()
