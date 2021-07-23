library(shiny)

ui <-
  fluidPage(

    # - Logo -
    fluidRow(
      align = "center",
      tags$img(
        src = "logo.png", width = 100,
        style = "padding-top: 40px;"
      )
    ),

    # - Title -
    fluidRow(
      align = "center",
      tags$h1(
        style = "padding-top: 10px; padding-bottom: 10px;",
        "Shiny Panda"
      )
    ),

    # - Instructions -
    fluidRow(
      align = "center",
      tags$p(
        style = "padding-bottom: 20px;",
        "Shiny Panda allows you to generate Pandas Profiling reports online.",
        tags$br(),
        "Simply upload your file, and a report will automatically download when
        ready."
      )
    ),

    # - Upload Button -
    fluidRow(
      align = "center",
      fileInput(
        inputId = "upload",
        label = NULL
      )
    )
  )

server <-
  function(input, output, session) {
  }

shinyApp(ui, server)