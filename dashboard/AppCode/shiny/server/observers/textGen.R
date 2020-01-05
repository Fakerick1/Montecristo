observeEvent(input[[id.textGen.button.menu]], {
  util.filter.showSidebar(TRUE)
  observers.main.updateActiveTab(id.button.menuItem.textGen)
  util.filter.setFilter("TextGen")
  output$mainPage <- renderUI(pages.textGen.getPage())
})

component.textGen.setOutputText <- function(text) {
  output[[id.textGen.output]] <- renderText({text})
}

observeEvent(input[[id.textGen.button.markov]], {
  #Get full text from db
  text <- db.books$find(
    query = paste0('{"title": "', input[[id.general.book]], '" }'),
    fields = '{"data" : true}')$data[[1]]

  model <- generate_markovify_model(
    input_text = text,
    markov_state_size = 2L,
    max_overlap_total = input[[id.textGen.markov.maxOverlapTotal]],
    max_overlap_ratio = (input[[id.textGen.markov.maxOverlapRatio]] / 100)
  )

  result <- markovify_text(
    markov_model = model,
    maximum_sentence_length = input[[id.textGen.markov.maxSentenceLength]],
    output_column_name = 'result',
    count = 1,
    tries = 100,
    only_distinct = TRUE,
    return_message = FALSE
  )

  component.textGen.setOutputText(result$result)
})

observeEvent(input[[id.textGen.button.neural]], {
  text <- db.books$find(
    query = paste0('{"title": "', input[[id.general.book]], '" }'),
    fields = '{"data" : true}')$data[[1]] %>%
    substr(100000, 200000) %>%
    tokenize_characters(lowercase = TRUE, strip_non_alphanum = FALSE, simplify = TRUE)

  print(paste("Length of text: ", length(text)))

  max_length <- 40

  chars <- text %>%
    unique() %>%
    sort()

  print(paste("Total characters: ", length(chars)))

  dataset <- map(
    seq(1, length(text) - max_length - 1, by = 3),
    ~list(sentence = text[.x:(.x + max_length - 1)],
          next_char = text[.x + max_length])
  )
  dataset <- transpose(dataset)

  print("Head of dataset: ")
  # print(head(dataset))

  vectorize <- function(data, chars, max_length) {
    x <- array(0, dim = c(length(data$sentence), max_length, length(chars)))
    y <- array(0, dim = c(length(data$sentence), length(chars)))

    for (i in 1:length(data$sentence)) {
      x[i,,] <- sapply(chars, function(x) {
        as.integer(x == data$sentence[[i]])
      })
      y[i,] <- as.integer(chars == data$next_char[[i]])
    }

    list(y = y,
         x = x)
  }

  vectors <- vectorize(dataset, chars, max_length)

  print("Head of vectors: ")
  # print(head(vectors))

  create_model <- function(chars, max_length) {
    keras_model_sequential() %>%
      layer_lstm(128, input_shape = c(max_length, length(chars))) %>%
      layer_dense(length(chars)) %>%
      layer_activation("softmax") %>%
      compile(
        loss = "categorical_crossentropy",
        optimizer = optimizer_rmsprop(lr = 0.01)
      )
  }

  fit_model <- function(model, vectors, epochs = 1) {
    model %>% fit(
      vectors$x, vectors$y,
      batch_size = 128,
      epochs = epochs
    )
    NULL
  }

  generate_phrase <- function(model, text, chars, max_length, diversity) {
    choose_next_char <- function(preds, chars, temperature) {
      preds <- log(preds) / temperature
      exp_preds <- exp(preds)
      preds <- exp_preds / sum(exp(preds))

      next_index <- rmultinom(1, 1, preds) %>%
        as.integer() %>%
        which.max()
      chars[next_index]
    }

    convert_sentence_to_data <- function(sentence, chars) {
      x <- sapply(chars, function(x) {
        as.integer(x == sentence)
      })
      array_reshape(x, c(1, dim(x)))
    }

    start_index <- sample(1:(length(text) - max_length), size = 1)
    sentence <- text[start_index:(start_index + max_length - 1)]
    generated <- ""

    for (i in 1:(max_length * 20)) {
      sentence_data <- convert_sentence_to_data(sentence, chars)

      preds <- predict(model, sentence_data)

      next_char <- choose_next_char(preds, chars, diversity)

      generated <- str_c(generated, next_char, collapse = "")

      sentence <- c(sentence[-1], next_char)
    }

    generated
  }

  iterate_model <- function(model, text, chars, max_length, diversity, vectors, iterations) {
    for(iteration in 1:iterations) {
      print(paste("Iteration: ", iteration))

      fit_model(model, vectors)

      # for(diversity in c(0.2, 0.5, 1)) {
      #   print(paste("Diversity: ", diversity))
      #
      #   current_phrase <- 1:10 %>%
      #     map_chr(function(x) generate_phrase(model, text, chars, max_length, diversity))
      #
      #   print(current_phrase)
      # }
    }
    NULL
  }

  model <- create_model(chars, max_length)

  iterate_model(model, text, chars, max_length, diversity, vectors, 40)

  phrase <- generate_phrase(model, text, chars, max_length, 0.6)
  component.textGen.setOutputText(phrase)
})
