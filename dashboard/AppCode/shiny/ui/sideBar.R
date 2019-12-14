sideBar <- sidebarMenu(
  id = id.general.sidebar,

  #Empty selectInputs to be filled serverside
  selectInput(id.general.book, label = "Book", choices = c(""), multiple = FALSE),
  selectInput(id.general.chapter, label = "Chapter", choices = c(""), multiple = FALSE),
  selectInput(id.general.word, label = "Word", choices = c(""), multiple = FALSE),

  htmlOutput("urlText", inline = TRUE)
)

print("shiny - ui - sideBar.R")
