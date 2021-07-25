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
        inputId = "upload",
        label = NULL,
        accept = c(
          ".csv",
          ".tsv",
          ".xls",
          ".xlsx"
        )
      )
    ),

    # - Download Button -
    fluidRow(
      align = "center",
      downloadButton("download")
    )
  )

server <-
  function(input, output, session) {
    data <-
      reactive({
        req(input$upload)
        switch(
          EXPR = file_ext(input$upload$name),
          csv = vroom(input$upload$datapath, delim = ","),
          tsv = vroom(input$upoad$datapath, delim = "\t"),
          xls = read_excel(input$upload$datapath),
          xlsx = read_excel(input$upload$datapath)
        )
      })

      output$download <-
        downloadHandler(
          filename = "report.csv",
          content = function(file){
            vroom_write(data(), file)
          }
        )

    # Debug data being read in
    # observe({
    #   print(data())
    # })
  }

shinyApp(ui, server)