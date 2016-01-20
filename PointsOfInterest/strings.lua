colourDefault = cChatColor.Plain
colourPrimary = cChatColor.Blue
colourSecondary = cChatColor.LightBlue
colourHighlight = cChatColor.Rose
colourInfo = cChatColor.LightGray

stringMain = {
  colourInfo .. "Unknown Command...",
  colourHighlight .. "Points Of Interest",
  colourPrimary .. "/poi" .. colourSecondary  .." update" .. colourDefault .. " - Update Points Of Interest database",
  colourPrimary .. "/poi" .. colourSecondary  .." claimed {player}" .. colourDefault .. " - List claimed POIs",
  colourPrimary .. "/poi" .. colourSecondary  .." ammount" .. colourDefault .. " - Show the total ammount of POIs",
  colourPrimary .. "/poi" .. colourSecondary  .." list" .. colourDefault .. " - List all POIs",
  colourPrimary .. "/poi" .. colourSecondary  .." tp" .. colourDefault .. " - Teleport to a POI",
  colourPrimary .. "/poi" .. colourSecondary  .." remove [id]" .. colourDefault .. " - Remove a POI with a specific id",
  colourPrimary .. "/poi" .. colourSecondary  .." purge [id] {player}" .. colourDefault .. " - Purge all claims with a POI id",
  colourPrimary .. "/poi" .. colourSecondary  .." purgeplayer [player]" .. colourDefault .. " - Purge all claims of a player"
}

stringSettings = {
  colourInfo .. "Unknown Setting:"
}

stringPermissions = {
  colourInfo .. "insufficient permissions..."
}

-- Strings for commands

stringUpdate = {
  colourInfo .. "Updating Points Of Interest Database",
  colourInfo .. "Update Finished"
}

stringRemove = {
  colourInfo .. "No id specified",
  colourInfo .. "POI removed",
  colourInfo .. "POI with this id does not exist"
}

stringPurge = {
  colourInfo .. "No id specified",
  colourInfo .. "All claimed records removed",
  colourInfo .. "No record with this POI id exists"
}

stringPurgeplayer = {
  colourInfo .. "No username specified",
  colourInfo .. "All claimed records removed",
  colourInfo .. "No record with this username exists"
}

stringAmmount = {
  colourInfo .. "Ammount of loaded POIs: " .. colourHighlight
}

stringList = {
  colourInfo .. "List of all POIs",
  colourHighlight .. "ID" .. colourDefault .. " - " .. colourPrimary .. "Name" .. colourDefault .. " - " .. colourSecondary .. " X / Y / Z"
}

stringClaimed = {
  colourInfo .. "List of POIs claimed by you",
  colourInfo .. "List of POIs claimed by " .. colourPrimary
}

stringTeleport = {
  colourInfo .. "No id specified",
  colourInfo .. "Teleporting to " .. colourPrimary,
  colourInfo .. "You have not yet claimed this POI",
  colourInfo .. "POI not found"
}

-- Strings for functions

stringCreate = {
  colourInfo .. "Successfully created a POI named " .. colourPrimary
}

stringClaim = {
  colourSecondary .. " just found a Point Of Interest named: " .. colourPrimary ,
  colourInfo .. "You have already found this Point Of Interest"
}

stringReward = {
  "Item reward was added to your inventory",
  "Item reward did not fit into your inventory"
}

stringSign = {
  "Last Visitor:",
  "-unclaimed-",
  "Visits: "
}
