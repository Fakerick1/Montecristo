observeEvent(input[[id.analysis.button.menu]], {
  util.filter.showSidebar(TRUE)
  observers.main.updateActiveTab(id.button.menuItem.analysis)
  util.filter.setFilter("Analysis")
  output$mainPage <- renderUI(pages.analysis.getPage())
})
