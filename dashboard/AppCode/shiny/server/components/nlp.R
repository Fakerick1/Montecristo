output[[id.analysis.nlp.output]] <- renderTable({
  selectedChapter <- input[[id.general.chapter]]

  chapter <- db.chapters$find(
    query = paste0('{"title": "', input[[id.general.book]], '"}'),
    fields = '{"data" : true}')$data[[1]] %>%
    filter(nword > 50) %>%
    select(text)

  chapter <- chapter$text[selectedChapter]

  chapter <- paste(chapter, collapse = "")

  text <- as.String(chapter)
  sent_token_annotator <- Maxent_Sent_Token_Annotator()
  word_token_annotator <- Maxent_Word_Token_Annotator()

  tokens <- annotate(text, list(sent_token_annotator, word_token_annotator))

  location_annotator <- Maxent_Entity_Annotator(kind = "location")
  person_annotator <- Maxent_Entity_Annotator(kind = "person")

  persons <- data.frame(Name = text[person_annotator(text, tokens)], Type = "person", stringsAsFactors = FALSE)
  locations <- data.frame(Name = text[location_annotator(text, tokens)], Type = "location", stringsAsFactors = FALSE)
  entities <- rbind(persons, locations)

  return(unique(entities))

})
