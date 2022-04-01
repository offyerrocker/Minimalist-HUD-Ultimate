--requires FakeFont class (included in MHUDU)
return "hce_hud",{
	name = "Halo CE - HUD",
	desc = "Ammo Counter, Health/Shields, and Crosshair from Halo: Combat Evolved",
	autodetect_assets = true,
	layer = 1,
	categories = {
		"health",
		"armor",
		"ammo",
		"crosshair"
	},
	hud_color = Color(121/255,197/255,255/255),
	hud_color_yellow = Color(255/255,195/255,74/255),
	hud_color_empty = Color(255/255,115/255,115/255),
	atlas_texture = "guis/textures/mhudu/haloce_atlas",
	atlas_data = {
		crosshair = {
			137,6,
			56,56
		},
		shields_outline = {
			242,0,
			236,64
		},
		shields_fill = {
			242,64,
			236,64
		},
		indicator_no_ammo = {
			3,60,
			40,22
		},
		indicator_no_grenades = {
			45,60,
			58,22
		},
		indicator_low_ammo = {
			3,85,
			40,22
		},
		indicator_reload = {
			45,86,
			42,11
		},
		bullet_single = {
			143,79,
			12,17
		},
		health_icon_fill = {
			232,138,
			20,17
		},
		health_icon_outline = {
			272,138,
			20,17
		},
		health_tick = {
			330,137,
			18,19
		},
		ammo_bar_icon = {
			117,84,
			20,12
		},
		ammo_bar_fill = {
			8,128,
			75,18
		},
		ammo_bar_outline = {
			84,128,
			75,18
		},
		grenade_bar_fill = {
			6,148,
			39,18
		},
		grenade_bar_outline = {
			64,148,
			39,18
		},
		grenade_icon = {
			128,67,
			10,12
		}
	},
	ammo_slots = {},
	health_ticks = {},
	create_func = function(addon,parent_panel)
		addon.parent_panel = parent_panel
		addon.hce_font_digits = FakeFont:new(addon.fake_font_data)
		
		local hud_cx,hud_cy = parent_panel:center()
		
		local hud_color = addon.hud_color
		local atlas_texture = addon.atlas_texture
		local atlas_data = addon.atlas_data
		local crosshair = parent_panel:bitmap({
			name = "crosshair",
			texture = atlas_texture,
			texture_rect = atlas_data.crosshair,
			color = hud_color,
			layer = 1
		})
		addon.crosshair = crosshair
		crosshair:set_center(hud_cx,hud_cy)
		
		
		local shields_x = -24
		local shields_y = 24
		local shields_outline = parent_panel:bitmap({
			name = "shields_outline",
			texture = atlas_texture,
			texture_rect = atlas_data.shields_outline,
			color = hud_color,
--			x = shields_x,
			y = shields_y,
			layer = 2
		})
		shields_outline:set_right(parent_panel:w() + shields_x)
		addon.shields_outline = shields_outline
		local shields_fill = parent_panel:bitmap({
			name = "shields_fill",
			texture = atlas_texture,
			texture_rect = atlas_data.shields_fill,
			color = hud_color,
			layer = 1
		})
		addon.shields_fill = shields_fill
		shields_fill:set_position(shields_outline:position())
		
		
		local tick_x = shields_outline:x() + 40
		local tick_y = shields_outline:y() + 40
		for i=1,8 do
			local health_tick = parent_panel:bitmap({
				name = "health_tick_" .. i,
				texture = atlas_texture,
				texture_rect = atlas_data.health_tick,
				x = tick_x,
				y = tick_y,
				color = hud_color,
				layer = 3
			})
			tick_x = tick_x + health_tick:w() - 2
			table.insert(addon.health_ticks,#addon.health_ticks+1,health_tick)
		end
		local health_icon_x = 16
		local health_icon_y = 40
		local health_icon_outline = parent_panel:bitmap({
			name = "health_icon_outline",
			texture = atlas_texture,
			texture_rect = atlas_data.health_icon_outline,
			color = hud_color,
			alpha = 0.66,
			layer = 3
		})
		addon.health_icon_outline = health_icon_outline
		health_icon_outline:set_x(shields_outline:x() + health_icon_x)
		health_icon_outline:set_y(shields_outline:y() + health_icon_y)
--		health_icon_outline:set_bottom(shields_outline:bottom() + health_icon_y)
		local health_icon_fill = parent_panel:bitmap({
			name = "health_icon_fill",
			texture = atlas_texture,
			texture_rect = atlas_data.health_icon_fill,
			layer = 2
		})
		health_icon_fill:set_center(health_icon_outline:center())
		addon.health_icon_fill = health_icon_fill
		local grenade_x = 168
		local grenade_y = 24
		local grenade_bar_outline = parent_panel:bitmap({
			name = "grenade_bar_outline",
			texture = atlas_texture,
			texture_rect = atlas_data.grenade_bar_outline,
			x = grenade_x,
			y = grenade_y,
			layer = 2
		})
		addon.grenade_bar_outline = grenade_bar_outline
		local grenade_bar_fill = parent_panel:bitmap({
			name = "grenade_bar_fill",
			texture = atlas_texture,
			texture_rect = atlas_data.grenade_bar_fill,
				color = hud_color,
			layer = 1
		})
		addon.grenade_bar_fill = grenade_bar_fill
		grenade_bar_fill:set_position(grenade_bar_outline:position())
		local grenade_icon = parent_panel:bitmap({
			name = "grenade_icon",
			texture = atlas_texture,
			texture_rect = atlas_data.grenade_icon,
			x = grenade_x + 20,
			y = grenade_y + 4,
			layer = 3
		})
		addon.grenade_icon = grenade_icon
		local frag_text = FakeText:new(parent_panel,{
			name = "frag_text",
			text = "0",
			font = "hce_font_digits",
			layer = 4,
--			align = "right",
			x = grenade_x + 8,
			y = grenade_y + 3
		})
		addon.frag_text = frag_text
		
		local ammo_bar_x = 82
		local ammo_bar_y = 24
		local ammo_bar_outline = parent_panel:bitmap({
			name = "ammo_bar_outline",
			texture = atlas_texture,
			texture_rect = atlas_data.ammo_bar_outline,
			x = ammo_bar_x,
			y = ammo_bar_y,
			layer = 2
		})
		addon.ammo_bar_outline = ammo_bar_outline
		local ammo_bar_fill = parent_panel:bitmap({
			name = "ammo_bar_fill",
			texture = atlas_texture,
			texture_rect = atlas_data.ammo_bar_fill,
			color = hud_color,
			layer = 1
		})
		addon.ammo_bar_fill = ammo_bar_fill
		ammo_bar_fill:set_position(ammo_bar_outline:position())
		local ammo_bar_icon = parent_panel:bitmap({
			name = "ammo_bar_icon",
			texture = atlas_texture,
			texture_rect = atlas_data.ammo_bar_icon,
			x = ammo_bar_x + 40,
			y = ammo_bar_y + 2,
			layer = 3
		})
		addon.ammo_bar_icon = ammo_bar_icon
		
		local mag_counter = FakeText:new(parent_panel,{
			name = "mag_counter",
			text = "0",
			font = "hce_font_digits",
			layer = 4,
			align = "right",
			w = 32,
			h = 16,
			x = ammo_bar_x + 8,
			y = ammo_bar_y + 3
		})
		addon.mag_counter = mag_counter
		
		
		
		local indicator_reload = parent_panel:bitmap({
			name = "indicator_reload",
			texture = atlas_texture,
			texture_rect = atlas_data.indicator_reload,
			layer = 3,
			color = hud_color,
			alpha = 0,
			visible = true
		})
		addon.indicator_reload = indicator_reload
		indicator_reload:set_left(crosshair:right() + 8)
		indicator_reload:set_bottom(crosshair:center_y() - 2)
		
		local indicator_low_ammo = parent_panel:bitmap({
			name = "indicator_low_ammo",
			texture = atlas_texture,
			texture_rect = atlas_data.indicator_low_ammo,
			layer = 3,
			color = hud_color,
			alpha = 0,
			visible = true
		})
		addon.indicator_low_ammo = indicator_low_ammo
		indicator_low_ammo:set_left(crosshair:right() + 8)
		indicator_low_ammo:set_top(crosshair:center_y() + 2)
		
		local indicator_no_ammo = parent_panel:bitmap({
			name = "indicator_no_ammo",
			texture = atlas_texture,
			texture_rect = atlas_data.indicator_no_ammo,
			layer = 3,
			color = hud_color,
			alpha = 0,
			visible = true
		})
		addon.indicator_no_ammo = indicator_no_ammo
		indicator_no_ammo:set_left(crosshair:right() + 8)
		indicator_no_ammo:set_top(crosshair:center_y() + 2)
		
		local indicator_no_grenades = parent_panel:bitmap({
			name = "indicator_no_grenades",
			texture = atlas_texture,
			texture_rect = atlas_data.indicator_no_grenades,
			layer = 3,
			color = hud_color,
			alpha = 0,
			visible = true
		})
		addon.indicator_no_grenades = indicator_no_grenades
		indicator_no_grenades:set_right(crosshair:left() - 8)
		indicator_no_grenades:set_bottom(crosshair:center_y() - 2)
	end,
	set_health = function(addon,current,total)
		local color = addon.hud_color
		local percent = current/total
		if percent <= 0.25 then 
			color = addon.hud_color_empty
		elseif percent <= 0.5 then 
			color = addon.hud_color_yellow
		end
		
		local num_ticks = #addon.health_ticks
		for i=num_ticks,1,-1 do 
			local j = num_ticks - i
			local tick = addon.health_ticks[i]
			if alive(tick) then 
				if j / num_ticks <= percent then 
					tick:show()
					tick:set_color(color)
				else
					tick:hide()
				end
			end
		end
		addon.health_icon_fill:set_color(color)
	end,
	set_shields = function(addon,current,total)
		local percent = current/total
		
		local texture_rect = addon.atlas_data.shields_fill
		local shields_fill = addon.shields_fill
		if alive(shields_fill) then
			local r_x,r_y,r_w,r_h = unpack(texture_rect)
			r_w = r_w * percent
			shields_fill:set_image(addon.atlas_texture,r_x,r_y,r_w,r_h)
			shields_fill:set_w(r_w)
--			shields_fill:set_position(addon.shields_outline:position())
			
		end
	end,
	generate_ammo_ticks = function(addon,slot,mag_total)
		local ammo_panel = addon.parent_panel:child("ammo_panel_" .. slot)
		if alive(ammo_panel) then 
			addon.parent_panel:remove(ammo_panel)
			ammo_panel = nil
		end
		
		ammo_panel = addon.parent_panel:panel({
			name = "ammo_panel_" .. tostring(slot),
			x = 24,
			y = 48,
			visible = false
		})
		addon.ammo_slots[slot] = ammo_panel
		
		local hud_color = addon.hud_color
		local item_offset_x = 26
		local item_offset_y = 0
		local texture_rect = addon.atlas_data.bullet_single
		local icon_w = texture_rect[3]
		local icon_h = texture_rect[4]
		local x_margin = 6
		local y_margin = 14
		
		
		local atlas_texture = addon.atlas_texture
		local columns = 20
		
		local rows_num_upper = 4
		local row_diag_offset = 6
		local row_data = {}
		for i=1,mag_total do 
			local j = i-1
			local column = j % columns
			local row = math.floor(j / columns)
			local x = column * x_margin
			x = x + item_offset_x + ((rows_num_upper - row) * row_diag_offset)
			local y = row * y_margin
			y = y + item_offset_y
			
			local ammo_tick = ammo_panel:bitmap({
				name = tostring(i),
				texture = atlas_texture,
				texture_rect = texture_rect,
				x = x,
				y = y,
				alpha = 0.25,
				color = hud_color,
				layer = 3
			})
			
			row_data[row] = row_data[row] or {}
			row_data[row][i] = ammo_tick
		end
		--[[
		local num_rows = #row_data
		for row_index,row_ticks in pairs(row_data) do 
			for tick_index,row_tick in pairs(row_ticks) do 
				row_tick:move((num_rows - row_index) * row_diag_offset)
			end
		end
		--]]
	end,
	set_ammo_ticks = function(addon,slot,current,total)
		for ammo_slot,ammo_panel in pairs(addon.ammo_slots) do 
			if ammo_slot ~= slot then 
				ammo_panel:hide()
			else
				ammo_panel:show()
				for i=1,total,1 do 
					local tick = ammo_panel:child(tostring(i))
					if alive(tick) then 
						if i <= current then
							tick:set_alpha(1)
						else
							tick:set_alpha(0.25)
						end
					end
				end
			end
		end
	end,
	update_func = function(addon,t,dt)
		local tau = 360
		local flash_speed = 2 * tau -- seconds per cycle
			--one cycle equals the time it takes to complete: (flashes_shown + flashes_hidden)
		local _t = flash_speed * t
		local flashes_shown = 3
		local flashes_hidden = 1
		local m = (tau * flashes_shown) - (_t % (tau * (flashes_shown + flashes_hidden)))
		local flash_alpha
		if m > 0 then 
--			flash_alpha = math.sin(_t)
			flash_alpha = math.clamp(math.sin(_t),0,1)
		else
			flash_alpha = 0
		end
		
		local pm = managers.player
		
		
		local player = pm:local_player()
		if alive(player) then 
		
			local peer_id = managers.network:session():local_peer():id()
			
			local grenades_amount = pm:get_grenade_amount(peer_id)
			
			if grenades_amount == 0 and pm:has_grenade(peer_id) then 
				addon.indicator_no_grenades:set_alpha(flash_alpha)
			end
			
			local equipped_weapon = player:inventory():equipped_unit()
			local weapon_base = alive(equipped_weapon) and equipped_weapon:base()
			if weapon_base then
				local mag = weapon_base:get_ammo_remaining_in_clip()
				local mag_max = weapon_base:get_ammo_max_per_clip()
				local mag_percent = mag / mag_max
				local reserves = weapon_base:get_ammo_total() - mag
				local reserves_max = weapon_base:get_max_ammo_excluding_clip()
				local reserves_percent = reserves/reserves_max
				
				if reserves_percent == 0 then 
					if mag_percent == 0 then 
						addon.indicator_no_ammo:set_alpha(flash_alpha)
					else
						addon.indicator_no_ammo:set_alpha(0)
					end
					addon.indicator_low_ammo:set_alpha(0)
					addon.indicator_reload:set_alpha(0)
				else
					addon.indicator_no_ammo:set_alpha(0)
					if mag_percent <= 0.25 then 
						addon.indicator_reload:set_alpha(flash_alpha)
					else
						addon.indicator_reload:set_alpha(0)
					end
					
					if reserves_percent <= 0.25 then 
						addon.indicator_low_ammo:set_alpha(flash_alpha)
					else
						addon.indicator_low_ammo:set_alpha(0)
					end
				end
			end
		end
	end,
	register_func = function(addon)
		local player = managers.player:local_player()
		
		--force grenade count check
		local _,grenades_amount = managers.blackmarket:equipped_grenade()
		addon.frag_text:set_text(string.format("%i",grenades_amount))

		if alive(player) then 
			--force hud ammo check
			for id, weapon in pairs(player:inventory():available_selections()) do
				if alive(weapon.unit) then 
					local base = weapon.unit:base()
					if base then 
	--					managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
						addon.generate_ammo_ticks(addon,id,base:get_ammo_max_per_clip())
					end
				end
			end
		end
		
		MHUDU:AddListener("set_criminal_health","mhudu_halocehud_criminalhealthchanged",{
			callback = function(i,data,...)
				if i == HUDManager.PLAYER_PANEL and data.total ~= 0 then 
					addon.set_health(addon,data.current,data.total)
				end
			end
		})
		
		MHUDU:AddListener("set_criminal_armor","mhudu_halocehud_criminalarmorchanged",{
			callback = function(i,data,...)
				if i == HUDManager.PLAYER_PANEL and data.total ~= 0 then 
					addon.set_shields(addon,data.current,data.total)
				end
			end
		})
		
		MHUDU:AddListener("set_criminal_ammo_data","mhudu_halocehud_criminalammochanged",{
			callback = function(i,type,max_clip,current_clip,current_left,max,...)
				if i == HUDManager.PLAYER_PANEL then
					if type == "primary" then 
						addon:set_ammo_ticks(2,current_clip,max_clip)
					elseif type == "secondary" then 
						addon:set_ammo_ticks(1,current_clip,max_clip)
					end 
					local reserves = math.clamp(current_left - current_clip,0,999)
					addon.mag_counter:set_text(string.format("%02i",reserves))
					if reserves <= 0 then 
						addon.ammo_bar_fill:set_color(addon.hud_color_empty)
					else
						addon.ammo_bar_fill:set_color(addon.hud_color)
					end
				end
			end
		})
		
		MHUDU:AddListener("set_criminal_grenades_amount","mhudu_halocehud_criminalgrenadeschanged",{
			callback = function(i,data,...)
				if i == HUDManager.PLAYER_PANEL then 
					local icon = data.icon
					local amount = data.amount
					addon.frag_text:set_text(string.format("%i",amount))
					if amount <= 0 then 
						addon.grenade_bar_fill:set_color(addon.hud_color_empty)
					else
						addon.grenade_bar_fill:set_color(addon.hud_color)
					end
				end
			end
		})
		
	end,
	destroy_func = function(addon)
		MHUDU:RemoveListener("set_criminal_health","mhudu_halocehud_criminalhealthchanged")
		MHUDU:RemoveListener("set_criminal_armor","mhudu_halocehud_criminalarmorchanged")
		MHUDU:RemoveListener("set_criminal_ammo_data","mhudu_halocehud_criminalammochanged")
		MHUDU:RemoveListener("set_criminal_grenades_amount","mhudu_halocehud_criminalgrenadeschanged")
	end,
	fake_font_data = {
		name = "hce_font_digits",
		version = 1,
		font_size = 12,
		atlas = "guis/textures/mhudu/haloce_atlas",
		tracking = -4,
		leading = 12,
		start = {3,5},
		characters = {
			["1"] = {
				2,0,
				8 + 4,12
			},
			["2"] = {
				18,0,
				14,12
			},
			["3"] = {
				37,0,
				13,12
			},
			["9"] = {
				55,0,
				13,12
			},
			["."] = {
				73,0,
				5,12
			},
			["-"] = {
				90,0,
				10 + 2,12
			},
			["8"] = {
				109,0,
				13,12
			},
			["4"] = {
				37 - 2,12,
				8 + 2,12
			},
			[":"] = {
				54,12,
				7 + 5,12
			},
			["5"] = {
				72,12,
				12,12
			},
			["m"] = {
				89,12,
				15,12
			},
			["6"] = {
				108,12,
				13,12
			},
			["0"] = {
				0,24,
				12,12
			},
			["7"] = {
				23 - 3,24,
				9 + 3,12
			}
		}
	}
}