
--management

Hooks:PreHook(HUDTeammate,"remove_panel","MHUDU_hudteammate_removepanel",function(self,weapons_panel,...)
	MHUDU:teammate_remove_panel(self._id,weapons_panel,...)
end)

Hooks:PostHook(HUDTeammate,"add_panel","MHUDU_hudteammate_addpanel",function(self,...)
	MHUDU:teammate_add_panel(self._id,...)
end)



--setters

Hooks:PostHook(HUDTeammate,"set_name","MHUDU_hudteammate_setname",function(self,name,...)
	MHUDU:feed_criminal_name(self._id,name,...)
end)

Hooks:PostHook(HUDTeammate,"set_health","MHUDU_hudteammate_sethealth",function(self,data,...)
	MHUDU:feed_criminal_health(self._id,data,...)
end)

Hooks:PostHook(HUDTeammate,"set_armor","MHUDU_hudteammate_setarmor",function(self,data,...)
	MHUDU:feed_criminal_armor(self._id,data,...)
end)

Hooks:PostHook(HUDTeammate,"set_deployable_equipment_amount","MHUDU_hudteammate_setdeployableamount",function(self,index,data,...)
	MHUDU:feed_deployable_amount(self._id,index,data,...)
end)

Hooks:PostHook(HUDTeammate,"set_grenades_amount","MHUDU_hudteammate_setgrenadesamount",function(self,data,...)
	if data and PlayerBase.USE_GRENADES then 
		MHUDU:feed_grenades_amount(self._id,data,...)
	end
end)

Hooks:PostHook(HUDTeammate,"set_ammo_amount_by_type","MHUDU_hudteammate_setammoamounts",function(self,...)
	MHUDU:feed_ammo_data(self._id,...)
end)

Hooks:PostHook(HUDTeammate,"add_special_equipment","MHUDU_hudteammate_setspecialequipment",function(self,data,...)
	MHUDU:feed_add_mission_equipment(self._id,data,...)
end)

Hooks:PostHook(HUDTeammate,"set_special_equipment_amount","MHUDU_hudteammate_setspecialequipmentamount",function(self,equipment_id,amount,...)
	MHUDU:feed_set_mission_equipment_amount(self._id,equipment_id,amount,...)
end)

Hooks:PostHook(HUDTeammate,"remove_special_equipment","MHUDU_hudteammate_removespecialequipment",function(self,equipment_id,...)
	MHUDU:feed_remove_mission_equipment(self._id,equipment_id,...)
end)

Hooks:PostHook(HUDTeammate,"clear_special_equipment","MHUDU_hudteammate_clearallspecialequipment",function(self,...)
	MHUDU:feed_clear_mission_equipment(self._id,...)
end)