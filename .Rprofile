# This file configures the virtualenv and Python paths differently depending on
# the environment the app is running in (local vs remote server).

# ------------------------- Settings (Do not edit) -------------------------- #

if (Sys.info()[["user"]] == "shiny"){
  
  # Running on shinyapps.io
  Sys.setenv(PYTHON_PATH = "python3")
  Sys.setenv(VIRTUALENV_NAME = "shiny_panda") # Installs into default shiny virtualenvs dir
  Sys.setenv(RETICULATE_PYTHON = paste0("/home/shiny/.virtualenvs/", "shiny_panda", "/bin/python"))
  
} else {
  
  # Running locally
  Sys.setenv(PYTHON_PATH = "python3")
  Sys.setenv(VIRTUALENV_NAME = "shiny_panda") # exclude "/" => installs into ~/.virtualenvs/
  # RETICULATE_PYTHON is not required locally, RStudio infers it based on the ~/.virtualenvs path
}