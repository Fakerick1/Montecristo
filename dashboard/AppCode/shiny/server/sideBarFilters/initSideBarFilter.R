init.sideBarFilters <- function() {
  #On first load, get data to put in filters and put it in (only books probably)
  allBooks <- db.books$find(
    query = '{}'
  )

  updateSelectInput(session,
    id.general.book,
    choices = allBooks$title)
}

print("shiny - server - serverSideBarFilters - initSideBarFilters.R")
