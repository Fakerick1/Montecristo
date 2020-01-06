output[[id.analysis.nlp.output]] <- renderTable({
  selectedChapter <- input[[id.general.chapter]]

  chapter <- db.chapters$find(
    query = paste0('{"title": "', input[[id.general.book]], '"}'),
    fields = '{"data" : true}')$data[[1]] %>%
    select(text)

  chapter <- chapter$text[selectedChapter]

  chapter <- paste(chapter, collapse = "")

  text <- as.String(chapter)
  sent_token_annotator <- Maxent_Sent_Token_Annotator()
  word_token_annotator <- Maxent_Word_Token_Annotator()

  tokens <- annotate(text, list(sent_token_annotator, word_token_annotator))

  location_annotator <- Maxent_Entity_Annotator(kind = "location")
  person_annotator <- Maxent_Entity_Annotator(kind = "person")

  persons <- text[person_annotator(text, tokens)]
  locations <- text[location_annotator(text, tokens)]

  entitiesDf <- data.frame(Name = character(0), Type = character(0))
  personsDf <- data.frame(Name = character(0), Type = character(0))
  locationsDf <- data.frame(Name = character(0), Type = character(0))

  if(!identical(persons, character(0))) {
    personsDf <- data.frame(Name = persons, Type = "person", stringsAsFactors = FALSE)
  }

  if(!identical(locations, character(0))) {
    locationsDf <- data.frame(Name = locations, Type = "location", stringsAsFactors = FALSE)
  }

  entitiesDf <- rbind(personsDf, locationsDf)

  return(unique(entitiesDf))

})
