observeEvent(input[[id.goodreads.button.menu]], {
  util.filter.showSidebar(TRUE)
  util.filter.setFilter("Goodreads")
  observers.main.updateActiveTab(id.button.menuItem.goodreads)
  output$mainPage <- renderUI(pages.goodreads.getPage())
})
