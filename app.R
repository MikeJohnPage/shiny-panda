# ---- Load ----
library(shiny)
library(tools)
library(vroom)
library(readxl)
library(waiter)

# Note: Do not load reticulate to prevent a default virtual env being set

# ---- Python ----
# Use virtualenv as it is available on shinyapps.io as a default system package:
# https://docs.rstudio.com/shinyapps.io/appendix.html#default-system-packages

# Create virtualenv if not available
if (!(Sys.getenv("VIRTUALENV_NAME") %in% reticulate::virtualenv_list())) {
  reticulate::virtualenv_create(
    envname = Sys.getenv("VIRTUALENV_NAME"),
    python = Sys.getenv("PYTHON_PATH")
  )

  reticulate::virtualenv_install(
    Sys.getenv("VIRTUALENV_NAME"),
    packages = "pandas-profiling",
    ignore_installed = TRUE
  )
}

# Load virtualenv
reticulate::use_virtualenv(
  Sys.getenv("VIRTUALENV_NAME"),
  required = TRUE
)

# ---- UI ----
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

# ---- Server ----
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
        filename = "report.html",
        content = function(file) {
          
          # - Generate Pandas Profiling report -
          pandas_profiling <-
            reticulate::import(
              "pandas_profiling",
              convert = FALSE
            )

          profile <-
            pandas_profiling$ProfileReport(
              data(),
              title = "Pandas Profiling Report"
            )

          profile$to_file(file)
        }
      )
  }

# ---- Run App ----
shinyApp(ui, server)