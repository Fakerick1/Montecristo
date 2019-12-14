db.DWH.selectotron.general.getPlayerNameById <- function(playerId) {
  db.DWH.selectotron(
    select = "name",
    from = "clean_player",
    where = paste0("playerId = ", playerId))
}
