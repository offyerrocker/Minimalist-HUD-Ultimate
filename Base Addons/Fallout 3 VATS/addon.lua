local mvec3_normalize = mvector3.normalize
local mvec3_dot = mvector3.dot

local addon_id = "fo3vats"
return addon_id,{
	name = "Fallout 3 - V.A.T.S.",
	desc = "Vault-Tec Assisted Targeting System",
	autodetect_assets = true,
	layer = 2,
	categories = {
		"misc"
	},
	bar_x = 4,
	bodies = {
--		"Hips",
		"Spine",
--		"Spine1",
--		"Spine2",
--		"Neck",
		"Head",
--		"LeftShoulder",
		"LeftArm",
--		"LeftForeArm",
--		"RightShoulder",
		"RightArm",
--		"RightForeArm",
--		"LeftUpLeg",
		"LeftLeg",
--		"LeftFoot",
--		"RightUpLeg",
		"RightLeg",
--		"RightFoot"
	},
	body_panels = {},
	weapon_stats = {},
	font_name = "fonts/monofonto",
	ui_color = Color(32/255,1,128/255),
	font_size = 24,
	vats_texture_overlay = "guis/textures/mhudu/vats_overlay",
	vats_texture_overlay_center = "guis/textures/mhudu/vats_overlay_center",
	vats_texture_bg = "guis/textures/mhudu/vats_bg",
	generate_vats_box = function(addon,vats_hud,name)
	--approximately 128x72 ratio, or 16x9
		local w = 64
		local h = 36
		local h_pad = 16
		local box = vats_hud:panel({
			name = name,
			w = w,
			h = h + h_pad,
			visible = false
		})
		local body_name = box:text({
			name = "body_name",
			text = name,
			font = addon.font_name,
			font_size = 14,
			color = addon.ui_color,
			align = "left",
			halign = "grow",
			x = 4
		})
		local bg = box:bitmap({
			name = "bg",
			texture = addon.vats_texture_bg,
			w = 64,
			h = 36,
			y = h_pad,
			layer = -1,
			visible = true
		})
		local liner = box:bitmap({
			name = "liner",
			texture = addon.vats_texture_overlay,
			w = 64,
			h = 36,
			y = h_pad,
			layer = 1,
			color = addon.ui_color,
			visible = true
		})
		local bar = box:rect({
			name = "bar",
			color = addon.ui_color,
			w = 36,
			h = 5,
			x = addon.bar_x,
			y = 5 + h_pad,
			visible = true
		})
		local label = box:text({
			name = "label",
			text = "69%", --haha nice
			font = addon.font_name,
			font_size = 16,
			color = addon.ui_color,
			align = "left",
			x = 4,
			y = 8 + h_pad
		})
		local debug_box = box:rect({
			name = "debug",
			color = Color.red,
			alpha = 0.1,
			visible = false
		})
	end,
	cache_weapon_stats = function(addon,slot)
		local player = managers.player and managers.player:local_player()
		if not alive(player) then 
			return
		end
		local inventory = player:inventory()
		if not inventory then 
			return
		end
		
		local weapon
		if not slot then 
			slot = inventory:equipped_selection()
			weapon = inventory:equipped_unit()
		elseif type(slot) == "number" then 
			weapon = inventory:unit_by_selection(slot)
		else 
			slot = inventory:equipped_selection()
			if slot == 1 then 
				slot = 2
			elseif slot == 2 then
				slot = 1
			end
			weapon = inventory:unit_by_selection(slot)
		end
		
		local weaponbase = weapon and weapon:base()
		if weaponbase then
			local stats = weaponbase._current_stat_indices
			
			local current_stats = {}
			
			current_stats.spread = 20 --approximate weapon spread stat
			
			addon.weapon_stats[weapon:key()] = current_stats
			
		end
	end,
	create_func = function(addon,parent_panel)
		local panel = parent_panel:panel({
			name = "vats"
		})
		addon.panel = panel
		for _,name in pairs(addon.bodies) do 
			addon.body_panels[name] = addon.generate_vats_box(addon,panel,name)
		end
	end,
	register_func = function(addon)
		addon.cache_weapon_stats(addon,1)
		addon.cache_weapon_stats(addon,2)
	end,
	destroy_func = function(addon)
	end,
	update_func = function(addon,t,dt)
		if addon.disable_upd then return end
		
		local pm = managers.player
		local player = pm:local_player()
		local vats_panel = addon.panel
		if alive(vats_panel) then
			if alive(player) then
				
				local state = player:movement():current_state()
				
				local fire_position = state:get_fire_weapon_position()
				local fire_direction = state:get_fire_weapon_direction()
				local my_weapon = state._equipped_unit
				local wpn_base = my_weapon:base()
				local wpn_stats = addon.weapon_stats[my_weapon:key()]
				
				local spread = wpn_stats and wpn_stats.spread or 20
				local hit_chance = 0
				
				
						
				local fwd_ray = state and state._fwd_ray
				local aim_unit = fwd_ray and fwd_ray.unit
				local fwd_body
				if alive(aim_unit) and aim_unit:character_damage() and alive(fwd_ray.body) then 
					fwd_body = fwd_ray.body
					hit_chance = math.clamp((spread - 1) / 25,0,100)
				else
					hit_chance = 0
				end
				
				local autoaim = wpn_base:check_autoaim(fire_position,fire_direction,nil,true)
				local unit = autoaim and autoaim.unit or aim_unit
				if alive(unit) and unit:character_damage() and not unit:character_damage():dead() then
					local unit_position = unit:position()
					local distance_to = math.max(mvector3.distance(player:position(),unit_position),1)
					local current_camera = managers.viewport:get_current_camera()
					local ws = MHUDU._ws
					
					local hp_r = unit:character_damage():health_ratio()
					
					vats_panel:show()
					for _,name in pairs(addon.bodies) do 
						local body = unit:get_object(Idstring(name))
						local box = vats_panel:child(name)
						if alive(box) then 
							local label = box:child("label")
							if body then 
								local oobb = body:oobb()
								local center = oobb and oobb:center() or unit_position
								
								local screen_pos = ws:world_to_screen(current_camera,center)
								local pos_x = screen_pos.x
								local pos_y = screen_pos.y
								
								--centering
								local screen_unit_pos = ws:world_to_screen(current_camera,unit_position)
								local screen_center_x = screen_unit_pos.x
								local screen_center_y = screen_unit_pos.y
								
								local max_screen_distance = 36
								
								if hp_r then
									box:child("bar"):set_w(hp_r * 36)
								end
								
								if name == "Head" or name == "Spine" then 
									if name == "Spine" then
										pos_y = pos_y + max_screen_distance
									elseif name == "Head" then 
										pos_y = pos_y - max_screen_distance
									end
									box:child("liner"):set_image(addon.vats_texture_overlay_center)
									box:child("liner"):set_w( math.abs(box:child("liner"):w()))
									box:child("liner"):set_x( 0 )
									box:child("bg"):set_w( math.abs(box:child("bg"):w()))
									box:child("bg"):set_x( 0 )
									box:child("bar"):set_x( addon.bar_x )
									
									label:set_align("center")
									box:child("body_name"):set_align("center")
									
									pos_x = pos_x - (box:w() / 2)
								elseif pos_x > screen_center_x then
									box:child("liner"):set_image(addon.vats_texture_overlay)
									box:child("liner"):set_w( math.abs(box:child("liner"):w()))
									box:child("liner"):set_x( 0 )
									box:child("bg"):set_w( math.abs(box:child("bg"):w()))
									box:child("bg"):set_x( 0 )
									box:child("bar"):set_x( addon.bar_x )
									label:set_align("right")
									box:child("body_name"):set_align("right")
									
									pos_x = screen_center_x + max_screen_distance
								else
									box:child("liner"):set_image(addon.vats_overlay)
									box:child("liner"):set_w( -math.abs(box:child("liner"):w()))
									box:child("liner"):set_x( - box:child("liner"):w())
									box:child("bg"):set_w( -math.abs(box:child("bg"):w()))
									box:child("bg"):set_x( -box:child("bg"):w())
									box:child("bar"):set_x( box:w() - (box:child("bar"):w() + addon.bar_x) )
									label:set_align("left")
									box:child("body_name"):set_align("left")
									
									pos_x = screen_center_x - (max_screen_distance + box:w())
								end
								box:set_position(pos_x,pos_y)
								
								
								if fwd_body == body then 
									label:set_text(string.format("%i",hit_chance))
								else
									if oobb then 
										box:show()
										local vec_to = fire_position - center
										mvec3_normalize(vec_to)
										local dot = mvec3_dot(fire_direction,vec_to)--autoaim.ray or autoaim.normal)
										label:set_text(string.format("%d",math.pow(math.abs(dot),distance_to / 10) * 100) .. "%")
									end
								end
							else
								box:hide()
							end
						end
					end
					vats_panel:show()
				else
					vats_panel:hide()
				end
			else
				vats_panel:hide()
			end
		end
	end
}
