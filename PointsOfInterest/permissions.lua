function checkPermission(Player, Permission)
   if (not Player:HasPermission(Permission)) then
      failedPermissions(Player)
      return false
   end
   return true
end

function failedPermissions(Player)
  Player:SendMessageFailure(stringPermissions[1])
end
