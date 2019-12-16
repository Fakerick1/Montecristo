# Main ui.R

# First load in the tabs to gain the variable which contents is the tab
source(paste0(localSetting,"shiny/ui/sideBar.R"),local=TRUE)

ui <- fluidPage(
  useShinyjs(),
  tags$head(
    tags$title("Monte Cristo"),
    tags$link(rel = "shortcut icon", type="image/png", href="images/montecristo_ico.png"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/variables.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
  ),
  dashboardPage(
    dashboardHeader(
      title = actionLink(id.main.main, class = "logo", img(src = "images/montecristo_logo.png")),
      tags$li(
        id = id.button.menuItem.database,
        class = "dropdown menuItem",
        actionLink(id.database.button.menu, "Database")
      ),
      tags$li(
        id = id.button.menuItem.textGen,
        class = "dropdown menuItem",
        actionLink(id.textGen.button.menu, "Generator")
      ),
      tags$li(
        id = id.button.menuItem.visual,
        class = "dropdown menuItem",
        actionLink(id.visual.button.menu, "Visual")
      ),
      tags$li(
        id = id.button.menuItem.analysis,
        class = "dropdown menuItem",
        actionLink(id.analysis.button.menu, "Analysis")
      )
    ),
    dashboardSidebar(sideBar, collapsed = TRUE),
    dashboardBody(
      uiOutput("mainPage")
    )
  )
)

print("shiny - ui - ui.R")
