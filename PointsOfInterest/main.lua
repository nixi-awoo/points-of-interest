PLUGIN = nil

function Initialize(Plugin)
	PLUGIN = Plugin
	Plugin:SetName("Points Of Interest")
	Plugin:SetVersion(1)

	cPluginManager.BindCommand("/poi", "", poiMain, " ~ Points Of Interest");
	cPluginManager:AddHook(cPluginManager.HOOK_UPDATING_SIGN, poiOperatorCreate);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, poiOperatorClaim);

	-- Init the arrays
	createArrayPoiList()
	createArrayClaimedList()

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end
