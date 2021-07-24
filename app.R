library(shiny)
library(tools)
library(vroom)
library(readxl)

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
        inputId = "file",
        label = NULL,
        accept = c(
          ".csv",
          ".tsv",
          ".xls",
          ".xlsx"
        )
      )
    )
  )

server <-
  function(input, output, session) {
    data <-
      reactive({
        req(input$file)
        switch(
          EXPR = file_ext(input$file$name),
          csv = vroom(input$file$datapath, delim = ","),
          tsv = vroom(input$file$datapath, delim = "\t"),
          xls = read_excel(input$file$datapath),
          xlsx = read_excel(input$file$datapath)
        )
      })

    # Debug data being read in
    # observe({
    #   print(data())
    # })
  }

shinyApp(ui, server)