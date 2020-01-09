output[[id.goodreads.output]] <- renderDataTable({
  userId <- input[[id.goodreads.userid]]
  apiKey <- input[[id.goodreads.apikey]]

  if(nchar(apiKey) != 20) return()

  index <- 0
  page <- 1
  books <- NA
  repeat {
    print(paste0("Current page: ", page))
    url <- paste0("https://www.goodreads.com/review/list.xml?key=", apiKey, "&id=", userId, "&v=2&shelf=read&page=", page)
    data <- read_xml(url)
    reviewsContainer <- xml_find_first(data, ".//reviews")
    index <- xml_attr(reviewsContainer, "end")
    total <- xml_attr(reviewsContainer, "total")

    titles <- xml_text(xml_find_all(data, ".//title"))
    authors <- xml_text(xml_find_all(data, ".//authors/*[1]/name"))
    author_ratings <- as.numeric(xml_text(xml_find_all(data, ".//authors/*[1]/average_rating")))
    book_ratings <- as.numeric(xml_text(xml_find_all(data, ".//review/book/average_rating")))
    book_ratings_counts <- as.numeric(xml_text(xml_find_all(data, ".//review/book/ratings_count")))
    published_years <- as.numeric(xml_text(xml_find_all(data, ".//published")))
    num_pages <- as.numeric(xml_text(xml_find_all(data, ".//num_pages")))

    reviews <- data.frame(Title = titles, Book_Rating = book_ratings, Book_Rating_Count = book_ratings_counts,
      Author = authors, Author_Rating = author_ratings, Year_Published = published_years,
      Number_Of_Pages = num_pages, stringsAsFactors = FALSE)

    if (page == 1) {
      books <- reviews
    } else {
      books <- rbind(books, reviews)
    }

    Sys.sleep(1)
    page <- page + 1
    if(index == total) {
      break
    }
  }
  print(str(books))
  return(datatable(books, filter = "top"))
})
