observeEvent(input[[id.textGen.button.menu]], {
  util.filter.showSidebar(TRUE)
  observers.main.updateActiveTab(id.button.menuItem.textGen)
  util.filter.setFilter("TextGen")
  output$mainPage <- renderUI(pages.textGen.getPage())
})
