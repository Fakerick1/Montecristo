observeEvent(input[[id.visual.button.menu]], {
  util.filter.showSidebar(FALSE)
  observers.main.updateActiveTab(id.button.menuItem.visual)
  util.filter.setFilter("Visual")
  output$mainPage <- renderUI(pages.visual.getPage())
})

observeEvent(input[[id.visual.button.noveltyChapterDifference]], {
  util.filter.showSidebar(TRUE)
  util.filter.setFilter("Novelty")
  output$mainPage <- renderUI(pages.visual.noveltyChapterDifference())
})

observeEvent(input[[id.visual.button.noveltyNewWords]], {
  util.filter.showSidebar(TRUE)
  util.filter.setFilter("Novelty")
  output$mainPage <- renderUI(pages.visual.noveltyNewWords())
})
