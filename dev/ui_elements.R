## ------------------------------------- ##
# User Interface Elements
## ------------------------------------- ##
# Call needed libraries
library(shiny); library(htmltools)

# User Interface (UI) --------------
element_ui <- fluidPage(

  # Add a title that appears in the browser tab
  title = "Shiny UI Elements",

  # Title within app
  headerPanel(list(title = "User Interface Elements",
                   htmltools::img(src = "lter_logo.png",
                                  height = 42, align = "right") ) ),

  # Explain this 'app'
  htmltools::br(),
  htmltools::h4("This 'app' is meant to show the range of allowable user interface (UI) elements that Shiny has ready for your use. In addition to including each input type in the app, how Shiny perceives that input internally is placed immediately below its respective input. This should prove helpful as you develop more nuanced ", htmltools::code("server"), " operations in future."),
  htmltools::br(),

  # Decide on layout -- Three equal columns
  fluidRow(

    # UI Note ---------------------
    ## Each input option has the following structure
    ### 1) Line break
    ### 2) Name of function
    ### 3) Actual input
    ### 4) How Shiny receives that input

    # UI - Column 1 ---------------
    column(width = 4,

           # Checkbox singular
           hr(style = "border-top: 2px solid #525252;"),
           h4("UI Element =", code("checkboxInput()")),
           checkboxInput(inputId = "checkbox_solo",
                         label = "Checkbox Label",
                         value = FALSE),
           h5("Outputs:"),
           verbatimTextOutput(outputId = "checkbox_solo_out"),

           # Checkboxes Group
           hr(style = "border-top: 2px solid #525252;"),
           h4("UI Element =", code("checkboxGroupInput()")),
           checkboxGroupInput(inputId = "checkbox_group",
                              label = "Checkbox Group Label",
                              choices = c("A", "B", "C", "D"),
                              selected = "C"),
           h5("Outputs:"),
           verbatimTextOutput(outputId = "checkbox_group_out"),

           # Dropdown menu
           hr(style = "border-top: 2px solid #525252;"),
           h4("UI Element =", code("selectInput()")),
           selectInput(inputId = "select",
                       label = "Dropdown Label",
                       choices = c("A", "B", "C", "D"),
                       selected = "C",
                       multiple = FALSE),
           h5("Outputs:"),
           verbatimTextOutput(outputId = "select_out"),

           # Radiobuttons
           hr(style = "border-top: 2px solid #525252;"),
           h4("UI Element =", code("radioButtons()")),
           radioButtons(inputId = "radio",
                              label = "Radiobuttons Label",
                              choices = c("A", "B", "C", "D"),
                              selected = "C"),
           h5("Outputs:"),
           verbatimTextOutput(outputId = "radio_out"),

    ), # Close `column(...`

    # UI - Column 2 ---------------
    column(width = 4,

           # numericInput
           hr(style = "border-top: 2px solid #525252;"),
           h4("UI Element =", code("numericInput()")),
           numericInput(inputId = "numeric",
                        label = "Numeric Field",
                        value = 20,
                        min = 0, max = 100, step = 1),
           h5("Outputs:"),
           verbatimTextOutput(outputId = "numeric_out"),

           # textInput
           hr(style = "border-top: 2px solid #525252;"),
           h4("UI Element =", code("textInput()")),
           textInput(inputId = "text",
                     label = "Free-Text Field",
                     placeholder = "Placeholder",
                     width = "70%"),
           h5("Outputs:"),
           verbatimTextOutput(outputId = "text_out"),

           # passwordInput
           hr(style = "border-top: 2px solid #525252;"),
           h4("UI Element =", code("passwordInput()")),
           passwordInput(inputId = "pw",
                         label = "Password Field"),
           h5("Outputs:"),
           verbatimTextOutput(outputId = "pw_out"),

    ), # Close `column(...`

    # UI - Column 3 ---------------
    column(width = 4,

           # sliderInput
           hr(style = "border-top: 2px solid #525252;"),
           h4("UI Element =", code("sliderInput()")),
           sliderInput(inputId = "slider",
                         label = "Slider",
                       min = 0, max = 10, step = 0.5, value = 2),
           h5("Outputs:"),
           verbatimTextOutput(outputId = "slider_out"),

# Single date
hr(style = "border-top: 2px solid #525252;"),
h4("UI Element =", code("dateInput()")),
dateInput(inputId = "date_solo",
          label = "Single Date",
          value = NULL, #this makes it start on today!
          min = '1900-01-01',
          max = '2200-01-01'),
h5("Outputs:"),
verbatimTextOutput(outputId = "date_solo_out"),

# Date range
hr(style = "border-top: 2px solid #525252;"),
h4("UI Element =", code("dateRangeInput()")),
dateRangeInput(inputId = "date_range",
            label = "Range of Dates",
            start = "2022-09-19",
            end = "2022-09-23",
            startview = "month",
            min = '1900-01-01',
            max = '2200-01-01'),
h5("Outputs:"),
verbatimTextOutput(outputId = "date_range_out"),

    ) # Close `column(...`
  ) # Close `fluidRow(...`
) # Close `fluidPage(...`

# Server ---------------------------
# The server is technically a function
element_server <- function(input, output){

  # Server - Column 1 Handling -----
  ## Multiple choice / choose all that apply inputs
  output$checkbox_group_out <- renderPrint({ input$checkbox_group })
  output$checkbox_solo_out <- renderPrint({ input$checkbox_solo })
  output$select_out <- renderPrint({ input$select })
  output$radio_out <- renderPrint({ input$radio })

  # Server - Column 2 Handling -----
  ## Numeric/text/password inputs
  output$numeric_out <- renderPrint({ input$numeric })
  output$text_out <- renderPrint({ input$text })
  output$pw_out <- renderPrint({ input$pw })

  # Server - Column 3 Handling -----
  ## Misc. other inputs
  output$slider_out <- renderPrint({ input$slider })
  output$date_solo_out <- renderPrint({ input$date_solo })
  output$date_range_out <- renderPrint({ input$date_range })

} # Close `function(...){...`

# Assemble App ---------------------
shinyApp(ui = element_ui, server = element_server)

# End ----
