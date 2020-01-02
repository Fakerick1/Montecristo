output[[id.analysis.nlp.output]] <- renderPlot({
  selectedChapter <- input[[id.general.chapter]]

  chapter <- db.chapters$find(
    query = paste0('{"title": "', input[[id.general.book]], '"}'),
    fields = '{"data" : true}')$data[[1]] %>%
    filter(nword > 50) %>%
    select(text)

  chapter <- chapter$text[selectedChapter]

  chapter <- paste(chapter, collapse = "")

  print(str(chapter))
  print(nchar(chapter))
  str <- as.String(chapter)
  sent_token_annotator <- Maxent_Sent_Token_Annotator()
  word_token_annotator <- Maxent_Word_Token_Annotator()

  a2 <- annotate(str, list(sent_token_annotator, word_token_annotator))

  entity_annotator <- Maxent_Entity_Annotator(kind = "location")
  a3 <- annotate(str, entity_annotator, a2)

  print(str[entity_annotator(str, a2)])
  print("Done")
})
