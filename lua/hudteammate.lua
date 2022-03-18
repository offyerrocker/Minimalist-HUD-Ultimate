
--management

Hooks:PreHook(HUDTeammate,"remove_panel","MHUDU_hudteammate_sethealth",function(self,weapons_panel,...)
	MHUDU:teammate_remove_panel(weapons_panel,...)
end)

Hooks:PostHook(HUDTeammate,"add_panel","MHUDU_hudteammate_sethealth",function(self,...)
	MHUDU:teammate_add_panel(self._id,...)
end)



--setters

Hooks:PostHook(HUDTeammate,"set_name","MHUDU_hudteammate_sethealth",function(self,name,...)
	MHUDU:feed_criminal_name(self._id,name,...)
end)

Hooks:PostHook(HUDTeammate,"set_health","MHUDU_hudteammate_sethealth",function(self,data,...)
	MHUDU:feed_criminal_health(self._id,data,...)
end)

Hooks:PostHook(HUDTeammate,"set_armor","MHUDU_hudteammate_sethealth",function(self,data,...)
	MHUDU:feed_criminal_armor(self._id,data,...)
end)

Hooks:PostHook(HUDTeammate,"set_deployable_equipment_amount","MHUDU_hudteammate_sethealth",function(self,index,data,...)
	MHUDU:feed_deployable_amount(self._id,index,data,...)
end)

Hooks:PostHook(HUDTeammate,"set_grenades_amount","MHUDU_hudteammate_sethealth",function(self,data,...)
	if data and PlayerBase.USE_GRENADES then 
		MHUDU:feed_grenades_amount(self._id,data,...)
	end
end)

Hooks:PostHook(HUDTeammate,"set_ammo_amount_by_type","MHUDU_hudteammate_sethealth",function(self,...)
	MHUDU:feed_ammo_data(self._id,...)
end)
