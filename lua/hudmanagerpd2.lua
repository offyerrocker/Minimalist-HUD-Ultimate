Hooks:PostHook(HUDManager,"_setup_player_info_hud_pd2","mhudu_create_hud",function(self)
	local hud = managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2)
	local parent_panel 
	local should_use_vanilla_hud_parent = false
	
	
	if should_use_vanilla_hud_parent then 
		parent_panel = hud and hud.panel
	end
	
	MHUDU:CreateHUD(parent_panel)
	
	MHUDU:CreateAddonHUDs()
	
--	MHUDU:StartTimer()
end)
