return "slotyourchalice",{
	name = "Destiny 2 - Menagerie Popup",
	desc = "Popup from Destiny 2's Season of Opulence",
	autodetect_assets = true,
	layer = 77,
	categories = {
		"misc" --this addon does not show any useful information
	},
	countdown_timer = 0,
	countdown_min = 0,
	countdown_max = 30,
	bg_height = 86,
	chalice_icon_size = 48,
	chalice_icon_x = 0,
	chalice_icon_y = 12,
	chalice_icon_alpha = 1,
	title_text_alpha = 1,
	desc_text_alpha = 0.5,
	title_x = 12,
	title_y = 0,
	desc_x = 12,
	desc_y = 24,
	stripe_height = 10,
	seq_1_duration = 0.33,
	seq_2_duration = 1,
	bg_color = Color("282627"),
	stripe_color = Color("2bebee"),
	chalice_texture = "guis/textures/mhudu/d2_chalice_icon",
	waits = {},
	create_func = function(addon,parent_panel)
		local chalice_texture = addon.chalice_texture
		local bg_color = addon.bg_color
		local chalice_icon_x = addon.chalice_icon_x
		local chalice_icon_y = addon.chalice_icon_y
		local chalice_icon_size = addon.chalice_icon_size
		local stripe_color = addon.stripe_color
		local bg_height = addon.bg_height
		local stripe_height = addon.stripe_height
		
		local title_x = addon.title_x
		local title_y = addon.title_y
		local desc_x = addon.desc_x
		local desc_y = addon.desc_y
		
		local panel = parent_panel:panel({
			name = "panel"
		})
		addon.panel = panel
		
		local parent_w = panel:w()
		local bg_gradient = panel:gradient({
			name = "bg_gradient",
			w = parent_w,
			h = bg_height,
			x = 0,
			y = 0,
			alpha = 1,
			orientation = "horizontal",
			gradient_points = {
				0,
				bg_color:with_alpha(0),
				1,
				bg_color:with_alpha(0)
			},
			layer = 1
		})
		bg_gradient:set_bottom(panel:bottom())
		addon.bg_gradient = bg_gradient
		
		local stripe_gradient = panel:gradient({
			name = "stripe_gradient",
			w = parent_w,
			h = stripe_height,
			x = 0,
			y = bg_gradient:y() - stripe_height,
			orientation = "horizontal",
			gradient_points = {
				0,
				stripe_color:with_alpha(0),
				1,
				stripe_color:with_alpha(0)
			},
			layer = 2
		})
		addon.stripe_gradient = stripe_gradient

		local chalice_icon = panel:bitmap({
			name = "chalice_icon",
			texture = chalice_texture,
			w = chalice_icon_size,
			h = chalice_icon_size,
			blend_mode = "add",
			alpha = 0,
			x = (panel:w() / 3) + chalice_icon_x,
			y = bg_gradient:y() + chalice_icon_y,
			layer = 3
		})
		addon.chalice_icon = chalice_icon
		
		local title_text = panel:text({
			name = "title_text",
			text = "Chalice Requires Runes",
			font = "fonts/grotesk_bold",
			font_size = 24,
			alpha = 0,
			x = chalice_icon:right() + title_x,
			y = chalice_icon:y() + title_y,
			layer = 3
		})
		addon.title_text = title_text
		local desc_text = panel:text({
			name = "desc_text",
			text = "Slot runes into your Chalice to customize Menagerie Rewards.",
			font = "fonts/grotesk_normal",
			font_size = 16,
			alpha = 0,
			x = chalice_icon:right() + desc_x,
			y = chalice_icon:y() + desc_y,
			layer = 3
		})
		addon.desc_text = desc_text
	end,
	register_func = function(addon)
	
	--[[
		MHUDU:AddListener("set_criminal_health","testaddon_oncriminalhealthset",{
			callback = function(id,data)
				if id == HUDManager.PLAYER_PANEL then 
					addon.test_bitmap:set_color(Color(1,math.random(),1))
					addon.test_text:set_text(string.format("%0.2f",data.current))
				end
			end
		})
	--]]
		
	end,
	destroy_func = function()
	end,
	update_func = function(addon,t,dt)
		if addon.countdown_timer <= 0 then 
			local next_suffering = math.random(addon.countdown_min,addon.countdown_max - 1) + math.random()
			addon.animate_chalice_sequence_1(addon)
			addon.countdown_timer = addon.countdown_timer + next_suffering
		else
			addon.countdown_timer = addon.countdown_timer - dt
		end
	end,
	animate_chalice_sequence_1 = function(addon)
		addon.reset_chalice_sequence(addon)
		
		MHUDU:animate(addon.bg_gradient,"animate_gradient_scroll",
			function(o,duration,col_1,col_2,...)
				o:set_gradient_points({0,col_1,1,col_1})
				addon.animate_chalice_sequence_2(addon)
			end,
			addon.seq_1_duration,addon.bg_color:with_alpha(1),addon.bg_color:with_alpha(0)
		)
		
		local new_wait = MHUDU:animate_wait(0.5,function()
			MHUDU:animate(addon.stripe_gradient,"animate_gradient_scroll",
				function(o,duration,col_1,col_2,...)
					o:set_gradient_points({0,col_1,1,col_1})
				end,
				addon.seq_1_duration,addon.stripe_color:with_alpha(1),addon.stripe_color:with_alpha(0)
			)
		end)
		table.insert(addon.waits,new_wait)
		
	end,
	animate_chalice_sequence_2 = function(addon)
		
		MHUDU:animate(addon.chalice_icon,"animate_fadein",nil,addon.seq_2_duration,addon.chalice_icon_alpha)
		local new_wait = MHUDU:animate_wait(0.5,function()
			MHUDU:animate(addon.title_text,"animate_fadein",nil,addon.seq_2_duration,addon.title_text_alpha)
		end)
		table.insert(addon.waits,new_wait)
		new_wait = MHUDU:animate_wait(1,function()
			MHUDU:animate(addon.desc_text,"animate_fadein",nil,addon.seq_2_duration,addon.desc_text_alpha)
		end)
		table.insert(addon.waits,new_wait)
		
		new_wait = MHUDU:animate_wait(5,
			function()
				MHUDU:animate(addon.panel,"animate_fadeout",
					function()
						addon.reset_chalice_sequence(addon)
					end,
					1,
					addon.panel:alpha()
				)
			end
		)
		table.insert(addon.waits,new_wait)
	end,
	reset_chalice_sequence = function(addon)
		local bg_color = addon.bg_color
		local stripe_color = addon.stripe_color
		MHUDU:animate_stop(addon.chalice_icon)
		addon.chalice_icon:set_alpha(0)
		MHUDU:animate_stop(addon.title_text)
		addon.title_text:set_alpha(0)
		MHUDU:animate_stop(addon.desc_text)
		addon.desc_text:set_alpha(0)
		MHUDU:animate_stop(addon.bg_gradient)
		addon.bg_gradient:set_gradient_points({0,bg_color:with_alpha(0),1,bg_color:with_alpha(0)})
		MHUDU:animate_stop(addon.stripe_gradient)
		addon.stripe_gradient:set_gradient_points({0,stripe_color:with_alpha(0),1,stripe_color:with_alpha(0)})
		addon.panel:set_alpha(1)
		addon.dump_waits(addon)
	end,
	dump_waits = function(addon)
		local num_waits = #addon.waits
		for i=num_waits,1,-1 do 
			MHUDU:animate_stop(table.remove(addon.waits,i))
		end
	end
}
