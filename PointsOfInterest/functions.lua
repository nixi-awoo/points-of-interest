function poiMain(Split, Player)

	if (#Split < 2) then
    -- If there is an argument missing
    Player:SendMessageSuccess(stringMain[2])
		for i = 3, #stringMain do
	    Player:SendMessage(stringMain[i])
	  end
	else

	  if (Split[2] == "update") and (checkPermission(Player, "poi.update") == true) then
	    Player:SendMessageInfo(stringUpdate[1])
	    createArrayPoiList()
	    createArrayClaimedList()
			Player:SendMessageSuccess(stringUpdate[2])
	  elseif (Split[2] == "claimed") and (checkPermission(Player, "poi.claimed") == true) then
			poiOperatorClaimed(Split, Player)
		elseif (Split[2] == "ammount") and (checkPermission(Player, "poi.ammount") == true) then
			Player:SendMessageSuccess(stringAmmount[1] .. poiListAmmount)
		elseif (Split[2] == "list") and (checkPermission(Player, "poi.list") == true) then
			poiOperatorList(Split, Player)
		elseif (Split[2] == "tp") and (checkPermission(Player, "poi.teleport") == true) then
			poiOperatorTeleport(Split, Player)
		elseif (Split[2] == "remove") and (checkPermission(Player, "poi.remove") == true) then
			poiOperatorRemove(Split, Player)
		elseif (Split[2] == "purge") and (checkPermission(Player, "poi.purge") == true) then
			poiOperatorPurge(Split, Player)
		elseif (Split[2] == "purgeplayer") and (checkPermission(Player, "poi.purgeplayer") == true) then
			poiOperatorPurgeplayer(Split, Player)
		end

	end
  return true
end

--
-- Arrays
--

function createArrayPoiList()
  -- Create an array of all POIs
  poiList = {}
	poiListNextId = 1

  local i = 0
  local db = sqlite3.open(PLUGIN:GetLocalFolder() .. "/database.sqlite3")
  for row in db:nrows("SELECT * FROM poi_list") do
    poiList[i] = {}
    poiList[i][0] = row.poi_id
    poiList[i][1] = row.poi_name
    poiList[i][2] = row.poi_x
    poiList[i][3] = row.poi_y
    poiList[i][4] = row.poi_z

		if (poiList[i][0] >= poiListNextId) then
			poiListNextId = poiList[i][0]+1
		end

    i = i + 1
  end
  db:close()
  poiListAmmount = i

  return true
end

function createArrayClaimedList()
  -- Create an array of all Claims
  claimedList = {}
	claimedListNextId = 0

  local i = 0
  local db = sqlite3.open(PLUGIN:GetLocalFolder() .. "/database.sqlite3")
  for row in db:nrows("SELECT * FROM poi_claimed") do
    claimedList[i] = {}
    claimedList[i][0] = row.claimed_id
    claimedList[i][1] = row.poi_id
    claimedList[i][2] = row.player_name

		if (claimedList[i][0] >= claimedListNextId) then
			claimedListNextId = claimedList[i][0]+1
		end

    i = i + 1
  end
  db:close()
	claimedListAmmount = i
end

--
-- Operators
--

function poiOperatorCreate(World, BlockX, BlockY, BlockZ, Line1, Line2, Line3, Line4, Player)
  if (Player == nil) then
		-- Not changed by a player
		return false;
	end

	if (Line1 == "[POI]") or (Line1 == "[poi]") or (Line1 == "[QS]") or (Line1 == "[qs]") and (Line2 ~= nil) then
		if (checkPermission(Player, "poi.create") == true) then
			Player:SendMessageSuccess(stringCreate[1] .. Line2)

			local poiName = Line2
			local poiClaimed = 0;

	    local db = sqlite3.open(PLUGIN:GetLocalFolder() .. "/database.sqlite3")
	    local stmt = db:prepare("INSERT INTO poi_list (poi_id, poi_name, poi_x, poi_y, poi_z) VALUES (?, ?, ?, ?, ?)")
			stmt:bind(1, poiListNextId)
			stmt:bind(2, poiName)
	    stmt:bind(3, BlockX)
	    stmt:bind(4, BlockY)
	    stmt:bind(5, BlockZ)
	    stmt:step()
	    db:close()

	    createArrayPoiList()

	    return false, poiName, stringSign[1], stringSign[2], stringSign[3] .. 0;
		end
	end
end

--

function poiOperatorClaim(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
  if (Player == nil) then
    -- Not changed by a player
    return false;
  end

  for i = 0, poiListAmmount-1 do

    if (poiList[i][2] == BlockX) and (poiList[i][3] == BlockY) and (poiList[i][4] == BlockZ) then
      -- if the clicked block has the same position as a poi
			if (checkPermission(Player, "poi.claim") == true) then
	      for j = 0, claimedListAmmount-1 do
	        if (claimedList[j][1] == poiList[i][0]) and (claimedList[j][2] == Player:GetName()) then
	          Player:SendMessageFailure(stringClaim[2])

	          return true
	        end
	        j = j + 1
	      end

	      local db = sqlite3.open(PLUGIN:GetLocalFolder() .. "/database.sqlite3")
	      local stmt = db:prepare("INSERT INTO poi_claimed (claimed_id, poi_id, player_name) VALUES (?, ?, ?)")
				stmt:bind(1, claimedListNextId)
				stmt:bind(2, poiList[i][0])
	      stmt:bind(3, Player:GetName())
	      stmt:step()
	      db:close()

				if (setClaimBroadcast == "player") then
					Player:SendMessageSuccess(colourPrimary .. Player:GetName() .. stringClaim[1] .. poiList[i][1])
				elseif (setClaimBroadcast == "world") then
					Player:GetWorld():BroadcastChat(colourPrimary .. Player:GetName() .. stringClaim[1] .. poiList[i][1])
				elseif (setClaimBroadcast == "global") then
					cRoot:Get():BroadcastChat(colourPrimary .. Player:GetName() .. stringClaim[1] .. poiList[i][1])
				elseif (setClaimBroadcast ~= "none") then
					LOG(stringSettings[1] .. " setClaimBroadcast = " .. setClaimBroadcast)
				end

				poiOperatorUpdateSign(Player, BlockX, BlockY, BlockZ)
				poiOperatorClaimEffect(Player, BlockX, BlockY, BlockZ)
				poiOperatorRewardXP(Player, BlockX, BlockY, BlockZ)
				poiOperatorRewardItem(Player, BlockX, BlockY, BlockZ)
	      createArrayClaimedList()
			end
      return true;
    end
    i = i + 1
  end

	return false
end

--

function poiOperatorUpdateSign(Player, BlockX, BlockY, BlockZ)

	for i = 0, poiListAmmount-1 do
    if (poiList[i][2] == BlockX) and (poiList[i][3] == BlockY) and (poiList[i][4] == BlockZ) then
      -- if the block has the same position as a poi
			local IsValid, Line1, Line2, Line3, Line4 = Player:GetWorld():GetSignLines(BlockX, BlockY, BlockZ)

			local numberLength = #Line4 - #stringSign[3]
			local number = Line4:sub(#stringSign[3], #stringSign[3] + numberLength)
			number = number + 1
			Line4 = stringSign[3] .. number

      Player:GetWorld():SetSignLines(BlockX, BlockY, BlockZ, Line1, Line2, Player:GetName(), Line4)
    end
    i = i + 1
  end
end

--

function poiOperatorClaimEffect(Player, BlockX, BlockY, BlockZ)
	if (setClaimEffectEnabled == 1) then
		Player:GetWorld():BroadcastParticleEffect(setClaimEffect, BlockX, BlockY, BlockZ, 0, 0, 0, 1, setClaimEffectAmmount)
	end
end

--

function poiOperatorTeleportEffect(Player)
	local BlockX = Player:GetPosX()
	local BlockY = Player:GetPosY()
	local BlockZ = Player:GetPosZ()
	Player:GetWorld():BroadcastParticleEffect(setClaimEffect, BlockX, BlockY, BlockZ, 0, 0, 0, 1, setClaimEffectAmmount)
end

--

function poiOperatorRewardXP(Player, BlockX, BlockY, BlockZ)
	if (setRewardxpEnabled == 1) then
		if (setRewardxpSplashEnabled == 1) then
			Player:GetWorld():CreateProjectile(BlockX, BlockY, BlockZ, 73, nil, cItem())
		end
		Player:GetWorld():SpawnExperienceOrb(BlockX, BlockY, BlockZ, setRewardxpAmmount)
	end
end

--

function poiOperatorRewardItem(Player, BlockX, BlockY, BlockZ)
	if (setRewardItemEnabled == 1) then
		local item = cItem(setRewardItem, setRewardItemAmmount)
		local itemsAdded = Player:GetInventory():AddItem(item)
		if (itemsAdded == item.m_ItemCount) then
	  	Player:SendMessageSuccess(stringReward[1]);
		else
		  Player:SendMessageFailure(stringReward[2]);
		end
	end
end

--
-- Command Operators
--

function poiOperatorClaimed(Split, Player)
	local string = ""
	local ammount = 0
  if (Split[3] == nil) then
    -- List POIs claimed by the current player
    for i = 0, claimedListAmmount-1 do
      if (claimedList[i][2] == Player:GetName()) then
        -- If there is a POI claimed by user
        for j = 0, poiListAmmount-1 do
          if (poiList[j][0] == claimedList[i][1]) then
						string = string .. poiList[i][1] .. ", "
						ammount = ammount + 1
          end
          j = j + 1
        end
      end
      i = i + 1
    end
		Player:SendMessageSuccess(stringClaimed[1] .. colourDefault .. " (" .. colourHighlight .. ammount .. colourDefault .. ")")
  else
    -- List POIs claimed by a specific player
    for i = 0, claimedListAmmount-1 do
      if (claimedList[i][2] == Split[3]) then
        -- If there is a POI claimed by user
        for j = 0, poiListAmmount-1 do
          if (poiList[j][0] == claimedList[i][1]) then
            string = string .. poiList[i][1] .. ", "
						ammount = ammount + 1
          end
          j = j + 1
        end
      end
      i = i + 1
    end
		Player:SendMessageSuccess(stringClaimed[2] .. colourPrimary .. Split[3] .. colourDefault .. " (" .. colourHighlight .. ammount .. colourDefault .. ")")
  end
	if (string ~= "") then
		Player:SendMessage(string)
	end
end

--

function poiOperatorList(Split, Player)
  Player:SendMessageSuccess(stringList[1] .. colourDefault .. " (" .. colourHighlight ..  poiListAmmount .. colourDefault ..")")
  Player:SendMessage(stringList[2])
  for i = 0, poiListAmmount-1 do
		local string = colourHighlight .. poiList[i][0] .. colourDefault .. " - " .. colourPrimary .. poiList[i][1] .. colourDefault .. " - " .. colourSecondary .. poiList[i][2] .. " / " .. poiList[i][3] .. " / " .. poiList[i][4]
    Player:SendMessage(string)
    i = i + 1
  end

  return true
end

--

function poiOperatorTeleport(Split, Player)
	if (Split[3] == nil) then
    Player:SendMessageFailure(stringPurgeplayer[1])
  else
		for i = 0, poiListAmmount-1 do
		  if (tostring(poiList[i][0]) == Split[3]) then
				if (setTeleportEffectEnabled == "out") or (setTeleportEffectEnabled == "both") then
					poiOperatorTeleportEffect(Player)
				end
				Player:TeleportToCoords(poiList[i][2], poiList[i][3], poiList[i][4])
		    Player:SendMessageSuccess(stringTeleport[1] .. poiList[i][1])
				if (setTeleportEffectEnabled == "in") or (setTeleportEffectEnabled == "both") then
					poiOperatorTeleportEffect(Player)
				end
				if (setTeleportEffectEnabled ~= "out") and (setTeleportEffectEnabled ~= "in") and (setTeleportEffectEnabled ~= "both") and (setTeleportEffectEnabled ~= "none") then
					LOG(stringSettings[1] .. " setTeleportEffectEnabled = " .. setTeleportEffectEnabled)
				end
		  end
		  i = i + 1
	  end
		Player:SendMessageFailure(stringTeleport[2])
	end
end

--

function poiOperatorRemove(Split, Player)
  if (Split[3] == nil) then
    Player:SendMessageFailure(stringRemove[1])
  else
    for i = 0, poiListAmmount-1 do
      if (tostring(poiList[i][0]) == Split[3]) then
        local db = sqlite3.open(PLUGIN:GetLocalFolder() .. "/database.sqlite3")
        local stmt = db:prepare("DELETE FROM poi_list WHERE poi_id = ?")
        stmt:bind(1, Split[3])
        stmt:step()
        db:close()

				poiOperatorPurge(Split, Player)
        createArrayPoiList()

        Player:SendMessageSuccess(stringRemove[2])
        return true
      end
      i = i + 1
    end
    Player:SendMessageFailure(stringRemove[3])
  end

  return false
end

--

function poiOperatorPurge(Split, Player)
  if (Split[3] == nil) then
    Player:SendMessageFailure(stringPurge[1])
  else
		if (Split[4] == nil) then
			-- if player name was not specified (purge all)
	    for i = 0, claimedListAmmount-1 do
	      if (tostring(claimedList[i][1]) == Split[3]) then
	        local db = sqlite3.open(PLUGIN:GetLocalFolder() .. "/database.sqlite3")
					stmt = db:prepare("DELETE FROM poi_claimed WHERE poi_id = ?")
	        stmt:bind(1, Split[3])
	        stmt:step()
	        db:close()

	        createArrayClaimedList()

	        Player:SendMessageSuccess(stringPurge[2])
	        return true
	      end
	      i = i + 1
	    end
		else
			-- if playername was specified
			for i = 0, claimedListAmmount-1 do
	      if (tostring(claimedList[i][1]) == Split[3]) and (claimedList[i][2] == Split[4]) then
	        local db = sqlite3.open(PLUGIN:GetLocalFolder() .. "/database.sqlite3")
					stmt = db:prepare("DELETE FROM poi_claimed WHERE poi_id = ?")
	        stmt:bind(1, Split[3])
	        stmt:step()
	        db:close()

	        createArrayClaimedList()

	        Player:SendMessageSuccess(stringPurge[2])
	        return true
	      end
	      i = i + 1
	    end
		end
    Player:SendMessageFailure(stringPurge[3])
  end

  return false
end

--

function poiOperatorPurgeplayer(Split, Player)
  if (Split[3] == nil) then
    Player:SendMessageFailure(stringPurgeplayer[1])
  else
		-- if player name was not specified (purge all)
	  for i = 0, claimedListAmmount-1 do
	    if (tostring(claimedList[i][2]) == Split[3]) then
	      local db = sqlite3.open(PLUGIN:GetLocalFolder() .. "/database.sqlite3")
				stmt = db:prepare("DELETE FROM poi_claimed WHERE player_name = ?")
	      stmt:bind(1, Split[3])
	      stmt:step()
	      db:close()

	      createArrayClaimedList()

	      Player:SendMessageSuccess(stringPurgeplayer[2])
	      return true
	    end
	    i = i + 1
	  end
    Player:SendMessageFailure(stringPurgeplayer[3])
  end

  return false
end
