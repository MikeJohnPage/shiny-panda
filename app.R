# ---- Load ----
library(shiny)
library(tools)
library(vroom)
library(readxl)
library(shinybusy)

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

    # - Logos -
    fluidRow(
      align = "center",

      # - MikeJohnPage -
      column(
        width = 4,
        align = "center",
        tags$a(
          href = "https://mikejohnpage.com",
          target = "_blank",
          tags$img(
            src = "mikejohnpage.png",
            width = 200,
            style = "padding-top: 30px;"
          )
        )
      ),

      # - Shiny Panda -
      column(
        width = 4,
        align = "center",
        tags$img(
          src = "logo.png",
          width = 100,
          style = "padding-top: 30px; padding-bottom: 30px"
        )
      ),

      # - GitHub -
      column(
        width = 4,
        align = "center",
        tags$a(
          href = "https://github.com/mikejohnpage/shiny-panda",
          target = "_blank",
          tags$img(
            src = "github.png",
            width = 30,
            style = "padding-top: 50px;"
          )
        )
      )
    ),

    # - Title -
    fluidRow(
      align = "center",
      tags$h1(
        style = "font-size: 75px; padding-top: 60px; padding-bottom: 5px;",
        "Shiny Panda"
      )
    ),

    # - Instructions -
    fluidRow(
      align = "center",
      tags$h2(
        style = "padding-top: 0px; padding-bottom: 50px; padding-left: 10px; padding-right: 10px",
        "Upload a file. Get back a Pandas Profiling report."
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
          show_modal_gif(
            src = "loading.gif",
            text = "Generating report, this could take a while...",
            height = "270px",
            width = "270px"
          )

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

          remove_modal_gif()
        }
      )
  }

# ---- Run App ----
shinyApp(ui, server)