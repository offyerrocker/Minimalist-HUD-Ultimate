local addon_id = "test"
return addon_id,{
	name = "Test addon 1",
	desc = "Hello there!",
--	menu_title_id = "",
--	menu_desc_id = "",
	
	autodetect_assets = true,
	categories = {
		--optional
		--if the option is enabled, MHUDU makes an effort to choose a different type of HUD element each time.
		--MHUDU finds all of the categories of all enabled addons, 
		--and chooses an addon of the least-populated category. 
		--this should ensure a generally varied experience each time, 
		--though you can disable this in settings,
		--since having few addons installed will likely lead to very similar activation sequences of addons each playthrough.
		
		"health",
		"ammo",
		"deployables",
		"grenades",
		"armor",
		"team",
		"equipment",
		"cable_ties",
		"hostages",
		
		"crosshair",
		"pagers",
		"money",
		"level",
		"loot",
		"chat",
		"time",
		"temperature",
		"killstreak"
	},
	
	create_func = function(addon,parent_panel)
		--this is called once, when loading into a heist (provided the addon is enabled)
		--alternatively, this may be called mid-heist if the addon is enabled after the heist has already started
		
		--addon:
			--this argument is your addon data, as you are defining in this very file!
			--this is provided in order to allow access to all of your addon's data
			--without cluttering the global table.
			--i mean, if you want to clutter the global table on your machine, go ahead, i guess. nobody can stop you
		
		--parent_panel:
			--this is the panel on which you should add hud elements
			
			--if you need your own workspace for some reason, you may make one,
			--but make sure to account for this accordingly in your unregister_func,
			--since this is part of MHUDU's disposal process for addons
		
		local test_bitmap = parent_panel:bitmap({
			name = "hello",
			texture = "guis/textures/mhudu/lego_characters_atlas",
			texture_rect = {
				56,56,56,56
			},
			x = 100,
			y = 100,
			w = 100,
			h = 100,
			color = Color.white,
			alpha = 0.5
		})
		addon.test_bitmap = test_bitmap
		
		local chalice_icon = parent_panel:bitmap({
			name = "hello",
			texture = "guis/textures/mhudu/d2_chalice_icon",
			x = 200,
			y = 200,
			color = Color.white,
			alpha = 1
		})
		addon.chalice_icon = chalice_icon
		
		local test_text = parent_panel:text({
			name = "text",
			text = "whomst've",
			color = Color.blue,
			font = "fonts/myriad_pro",
			font_size = 32
		})
		addon.test_text = test_text
		
		local grot_1 = parent_panel:text({
			name = "text",
			text = "whomst've",
			color = Color.blue,
			y = 300,
			font = "fonts/grotesk_normal",
			font_size = 32
		})
		local grot_2 = parent_panel:text({
			name = "text",
			text = "whomst've",
			color = Color.blue,
			y = 400,
			font = "fonts/grotesk_bold",
			font_size = 32
		})
		addon.grot_1 = grot_1
		addon.grot_2 = grot_2
		addon.test_text = test_text
	end,
	register_func = function(addon)
		--called when the addon is selected to be enabled by the element timer, 
		--or if the timer mode is disabled (ie. if the user has chosen to enable all addons from the start)
		
		MHUDU:AddListener("set_criminal_health","testaddon_oncriminalhealthset",{
			callback = function(id,data)
				if id == HUDManager.PLAYER_PANEL then 
					addon.test_bitmap:set_color(Color(1,math.random(),1))
					addon.test_text:set_text(string.format("%0.2f",data.current))
				end
			end
		})
		
		
	end,
	destroy_func = function()
		--called when the addon is removed
		--ie. when the user disables the addon mid-heist, if the addon is active
		--you do not need to remove the panel gui objects parented to the parent_panel, 
		--as MHUDU will handle this for you,
		--but you should un-register any listeners or hooks that you added in your register_func
		
		
		MHUDU:RemoveListener("set_criminal_health","testaddon_onstuffhappens")
		
	end,
	update_func = function()
		--optional. if your addon has code that runs every frame,
		--place it here so that MHUDU can safely handle starting/stopping it
		--in case the user disables the addon mid-heist, after the addon is already active.
	end
}
