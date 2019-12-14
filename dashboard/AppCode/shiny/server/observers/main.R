# Event for the logo in the top left of the application
observeEvent(input[[id.main.main]], {
  util.filter.showSidebar(FALSE)
  observers.main.updateActiveTab("MAIN")
  output$mainPage <- renderUI(pages.main.getPage())
})

# Global variables that track which page is currently loaded
activeTab <<- "NONE"
previousTab <<- "NONE"

observers.main.updateActiveTab <- function(selectedTab) {
  previousTab <<- activeTab
  activeTab <<- selectedTab
  if (previousTab != "NONE") shinyjs::removeClass(id = previousTab, class = "active-tab")
  if (selectedTab != "MAIN") shinyjs::addClass(id = selectedTab, class = "active-tab")
}
