-- Menu management

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_MHUDU", function(menu_manager)
	MHUDUCore._animator = QuickAnimate:new("minimalisthudultimate_animator",{parent = MHUDUCore,updater_type = QuickAnimate.updater_types.BeardLib,paused = false})
	Hooks:Call("LoadQuickAnimateLibrary",MHUDUCore._animator)
	
	BeardLib:AddUpdater("MHUDU_Update",callback(MHUDUCore,MHUDUCore,"Update"))
	
	MenuCallbackHandler.callback_mhudu_enable_minimalism_countdown = function(self,item)
		local value = item:value() == "on"
		MHUDUCore.settings.minimalism_countdown_enabled = value
		MHUDUCore:SaveSettings()
	end
	
	MenuCallbackHandler.callback_mhudu_enable_randomization_weighted_mode = function(self,item)
		local value = item:value() == "on"
		MHUDUCore.settings.addon_randomization_weighted_mode = value
		MHUDUCore:SaveSettings()
	end

	MenuCallbackHandler.callback_mhudu_set_minimalism_countdown_interval = function(self,item)
		MHUDUCore.settings.minimalism_countdown_interval = tonumber(item:value())
		MHUDUCore:SaveSettings()
	end
	
	MHUDUCore:CheckCreateAddonFolder()
	
	--load addons from user and from base mhudu
	MHUDUCore:LoadAddons()
	
	MHUDUCore:LoadSettings()
end)

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_MHUDU", function(menu_manager, nodes)
	MenuHelper:NewMenu(MHUDUCore.menu_data.menu_ids.main)
	MenuHelper:NewMenu(MHUDUCore.menu_data.menu_ids.addons)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_MHUDU", function(menu_manager, nodes)

	
	MenuHelper:AddToggle({
		id = "mhudu_enable_minimalism_countdown",
		title = "menu_mhudu_enable_minimalism_countdown_title",
		desc = "menu_mhudu_enable_minimalism_countdown_desc",
		callback = "callback_mhudu_enable_minimalism_countdown",
		value = MHUDUCore.settings.minimalism_countdown_enabled,
		menu_id = MHUDUCore.menu_data.menu_ids.main,
		priority = 3
	})
	
	MenuHelper:AddSlider({
		id = "mhudu_set_minimalism_countdown_interval",
		title = "menu_mhudu_set_minimalism_countdown_interval_title",
		desc = "menu_mhudu_set_minimalism_countdown_interval_desc",
		callback = "callback_mhudu_set_minimalism_countdown_interval",
		value = MHUDUCore.settings.minimalism_countdown_interval,
		min = 0,
		max = 600,
		step = 1,
		default_value = MHUDUCore.default_settings.minimalism_countdown_interval,
		menu_id = MHUDUCore.menu_data.menu_ids.main,
		show_value = true,
		priority = 2
	})
		
	MenuHelper:AddToggle({
		id = "mhudu_enable_randomization_weighted_mode",
		title = "menu_mhudu_enable_randomization_weighted_mode_title",
		desc = "menu_mhudu_enable_randomization_weighted_mode_desc",
		callback = "callback_mhudu_enable_randomization_weighted_mode",
		value = MHUDUCore.settings.addon_randomization_weighted_mode,
		menu_id = MHUDUCore.menu_data.menu_ids.main,
		priority = 1
	})
	
	for addon_id,addon_data in pairs(MHUDUCore._addons) do 
		local user_data = addon_data.user_data
		local addon_menu_id = "mhudu_addon_submenu_" .. tostring(addon_id)
		MenuHelper:NewMenu(addon_menu_id)
		MHUDUCore.menu_data.addon_generated_submenus[addon_id] = addon_menu_id
		
		local callback_name = "callback_mhudu_addon_enable_" .. tostring(addon_id)
		MenuCallbackHandler[callback_name] = function(self,item)
			local enabled = item:value() == "on"
			MHUDUCore.settings.enabled_addons[addon_id] = enabled
			MHUDUCore:SaveSettings()
		end
		MenuHelper:AddToggle({
			id = "mhudu_addon_enable_" .. addon_id,
			title = "menu_mhudu_addon_enable_generic_title",
			desc = "menu_mhudu_addon_enable_generic_desc",
			callback = callback_name,
			value = MHUDUCore.settings.enabled_addons[addon_id] and true or false,
			menu_id = addon_menu_id
		})
		
	end
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_MHUDU", function( menu_manager, nodes )
	do 
		local menu_id = MHUDUCore.menu_data.menu_ids.main
		local title = "menu_mhudu_main_title"
		local desc = "menu_mhudu_main_desc"
		nodes[menu_id] = MenuHelper:BuildMenu(menu_id)
		MenuHelper:AddMenuItem(nodes.blt_options,menu_id,title,desc)
	end
	
	do 
		local menu_id = MHUDUCore.menu_data.menu_ids.addons
		local title = "menu_mhudu_addons_title"
		local desc = "menu_mhudu_addons_desc"
		nodes[menu_id] = MenuHelper:BuildMenu(menu_id)
		MenuHelper:AddMenuItem(nodes[MHUDUCore.menu_data.menu_ids.main],menu_id,title,desc)
	end
	
	for addon_id,menu_id in pairs(MHUDUCore.menu_data.addon_generated_submenus) do 
		local addon_data = MHUDUCore._addons[addon_id]
		local title = addon_data.name_id
		local desc = addon_data.desc_id
		nodes[menu_id] = MenuHelper:BuildMenu(menu_id)
		MenuHelper:AddMenuItem(nodes[MHUDUCore.menu_data.menu_ids.addons],menu_id,title,desc)
	end
end)
