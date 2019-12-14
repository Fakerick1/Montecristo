print("start loading selectors")

db.DWH.selectotron <- function(select = "*", from, join, where, group_by, order_by, filter_alias = "", filter_player = TRUE, filter_match = TRUE, filter_season = TRUE, filter_team = TRUE) {
  # Get parts of query used for filtering the data based on the filters

  # Could not be combined into one expression since R apparently evaluates both expressions even if the first one is not TRUE in an & expression.
  filterable <- function(filter, filter_bool) {
    if (!identical(filter, character(0)) & filter_bool) {
      !is.null(input[[filter]])
    } else {
      FALSE
    }
  }

  getFilterQuery <- function(alias) {
    # Get intersect of selectedfilters with each group, to find the currently active filter for each filter group
    # Check if filter of group is active, if it is, the filter will be assigned to current<Name>Filter
    currentPlayerFilter <- intersect(filterGroups.selectedFilters, filterGroups.where.player)
    currentMatchFilter <- intersect(filterGroups.selectedFilters, filterGroups.where.match)
    #currentSeasonFilter <- intersect(filterGroups.selectedFilters, filterGroups.where.season)
    currentTeamFilter <- intersect(filterGroups.selectedFilters, filterGroups.where.team)

    filterQuery <- ""
    if (filterable(currentPlayerFilter, filter_player)) {
      # If a player filter is active and the player filter is not empty, include it in the query
      filterQuery <- paste0(filterQuery, "AND ", ifelse(alias == "", "", paste0(alias, ".")), "playerId IN (\"", paste(input[[currentPlayerFilter]], collapse = "\",\""), "\") ")
    }
    if (filterable(currentMatchFilter, filter_match)) {
      filterQuery <- paste0(filterQuery, "AND ", ifelse(alias == "", "", paste0(alias, ".")), "matchId IN (\"", paste(input[[currentMatchFilter]], collapse = "\",\""), "\") ")
    }
    #if (filterable(currentSeasonFilter, filter_season)) {
      # Only works in tables with 'timestamp' column, will require joining with matches table to get it to work correctly
      #selectedMonths <- util.general.getMonthsForSeasonStrings(input[[currentSeasonFilter]])
      #firstMonth <- min(selectedMonths)
      #lastMonth <- max(selectedMonths)
      #filterQuery <- paste0(filterQuery, "AND timestamp BETWEEN \"", paste0(firstMonth, "-01"), "\" AND \"", paste0(lastMonth, "-31\""))
    #}
    if (filterable(currentTeamFilter, filter_team)) {
      filterQuery <- paste0(filterQuery, "AND ", ifelse(alias == "", "", paste0(alias, ".")), "team IN (\"", paste(input[[currentTeamFilter]], collapse = "\",\""), "\") ")
    }
    return(filterQuery)
  }

  # Comments detail the building of the query, assuming all parameters have been supplied
  query <- "SELECT "
  query <- paste0(query, select, " ")
  # 'SELECT <param:select> '

  query <- paste0(query, "FROM ", from, " ")
  # 'SELECT <param:select> FROM <param:from> '

  if (!missing(join)) query <- paste0(query, join, " ")
  # 'SELECT <param:select> FROM <param:from> <param:join> '

  query <- paste0(query, "WHERE 1 = 1 ", getFilterQuery(filter_alias))
  # 'SELECT <param:select> FROM <param:from> <param:join> <filters> '

  if (!missing(where)) query <- paste0(query, "AND ", where, " ")
  # 'SELECT <param:select> FROM <param:from> <param:join> <filters> <param:where> '

  if (!missing(group_by)) query <- paste0(query, "GROUP BY ", group_by, " ")
  # 'SELECT <param:select> FROM <param:from> <param:join> <filters> <param:where> <param:group_by> '

  if (!missing(order_by)) query <- paste0(query, "ORDER BY ", order_by)
  # 'SELECT <param:select> FROM <param:from> <param:join> <filters> <param:where> <param:group_by> <param:order_by>'

  query <- paste0(query, ";")
  # 'SELECT <param:select> FROM <param:from> <param:join> <filters> <param:where> <param:group_by> <param:order_by>;'

  return(dbGetQuery(db.DWH.connection, query))
}

db.DWH.selectotron.initData <- function(query) {
  return(dbGetQuery(db.DWH.connection, query))
}

source(paste0(localSetting,"database/SQLfunctions/selectors/general.R"),local=TRUE)
source(paste0(localSetting,"database/SQLfunctions/selectors/management.R"),local=TRUE)
source(paste0(localSetting,"database/SQLfunctions/selectors/match.R"),local=TRUE)
source(paste0(localSetting,"database/SQLfunctions/selectors/player.R"),local=TRUE)
source(paste0(localSetting,"database/SQLfunctions/selectors/team.R"),local=TRUE)

print("end loading selectors")
print("R - database - SQLfunctions - select")
