observeEvent(input[[id.visual.button.menu]], {
  util.filter.showSidebar(TRUE)
  observers.main.updateActiveTab(id.button.menuItem.visual)
  util.filter.setFilter("Visual")
  output$mainPage <- renderUI(pages.visual.getPage())
})
