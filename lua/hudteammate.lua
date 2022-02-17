--[[

Hooks:PostHook(HUDTeammate,"set_health","MHUDU_hudteammate_sethealth",function(self,data)
	if self._main_player and data then 
		MHP:SetHealth(data.current,data.total)
	end
	MHP:SetFTLHealth(self._id,data.current,data.total)
end)

Hooks:PreHook(HUDTeammate,"remove_panel","MHUDU_hudteammate_sethealth",function(self,weapons_panel)
	MHP:RemoveTeammate(self._id)
end)

Hooks:PostHook(HUDTeammate,"set_name","MHUDU_hudteammate_sethealth",function(self,name)
	MHP:SetTeammateName(self._id,name)
end)

Hooks:PostHook(HUDTeammate,"add_panel","MHUDU_hudteammate_sethealth",function(self)
	MHP:AddTeammate(self._id)
end)

Hooks:PostHook(HUDTeammate,"set_armor","MHUDU_hudteammate_sethealth",function(self,data)
	if self._main_player and data then 
		MHP:SetArmor(data.current,data.total)
	end
end)

Hooks:PostHook(HUDTeammate,"set_deployable_equipment_amount","MHUDU_hudteammate_sethealth",function(self,index,data)
	if self._main_player and data then 
		MHP:SetDeployableAmount(data)
	end
end)

Hooks:PostHook(HUDTeammate,"set_grenades_amount","MHUDU_hudteammate_sethealth",function(self,data)
	if self._main_player and data and PlayerBase.USE_GRENADES then 
		MHP:SetGrenadesAmount(data)
	end
end)

Hooks:PostHook(HUDTeammate,"set_ammo_amount_by_type","MHUDU_hudteammate_sethealth",function(self,...)
	if self._main_player then 
		MHP:SetAmmo(...)
	end
end)


--]]