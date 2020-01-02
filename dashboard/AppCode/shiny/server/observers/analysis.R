observeEvent(input[[id.analysis.button.menu]], {
  util.filter.showSidebar(FALSE)
  observers.main.updateActiveTab(id.button.menuItem.analysis)
  output$mainPage <- renderUI(pages.analysis.getPage())
})

observeEvent(input[[id.analysis.button.nlp]], {
  util.filter.showSidebar(TRUE)
  util.filter.setFilter("Analysis")
  output$mainPage <- renderUI(pages.analysis.nlp())
})
