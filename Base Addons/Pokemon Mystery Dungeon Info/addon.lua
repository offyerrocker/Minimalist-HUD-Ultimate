--todo: 
--		scrolling animations maybe i guess
--		add more message procs
--			use throwable or ability
--			place equipment
--			player take damage
--			player change state (incl. downed, custody)
--			acquire mission equipment
--			use mission equipment

local addon_id = "mysterydungeon"
return addon_id,{
	name = "Pokémon Mystery Dungeon - Battle Feed",
	desc = "Helpful information in a custom message feed",
	autodetect_assets = true,
	layer = 1,
	categories = {
		"chat",
		"misc"
	},
	atlas_rect = {
		left = {
			1 * 4,1 * 4,
			6 * 4,30 * 4
		},
		center = {
			7 * 4,1 * 4,
			6 * 4,30 * 4
		},
		right = {
			13 * 4,1 * 4,
			6 * 4,30 * 4
		}
	},
	fonts = {
		shadow = "fonts/pkmn_mdr_30_shadow",--"fonts/pkmn_mdr_shadow",
		noshadow = "fonts/pkmn_mdr_30_noshadow",
	},
	bg_texture = "guis/textures/mhudu/pkmn_mdr_bg",
	state_lookups = {
		bleedout = " was bleeding out!",
		fatal = " was knocked out!",
		incapacitated = " was incapacitated!",
		dead = " was defeated!",
		arrested = " was arrested!"
	},
	message_count = 0,
	font_size = 24,
--	max_num_text_objects = 24,
	feed_text_objects = {},
	weapon_name_by_unit = {},
	create_func = function(addon,parent_panel)
		addon.parent_panel = parent_panel

		local parent_w = parent_panel:w()
		local parent_h = parent_panel:h()
		
		local segment_ratio = 1/5
		local bg_ratio = 5.533
		
		local bg_texture = addon.bg_texture
		
		local x_margin_ratio = 0.4
		local y_margin_ratio = 0.33
		
		local feed_panel_w = 100 * bg_ratio
		local feed_panel_h = 100
		
		local x_margin = feed_panel_w * x_margin_ratio
		local feed_panel_x = x_margin + 100
		local feed_panel_y = parent_panel:bottom() - (parent_h * y_margin_ratio)
		
		local bg_h = feed_panel_h
		local bg_bookend_w = bg_h * segment_ratio
		local bg_center_w = feed_panel_w - (bg_bookend_w * 2)
		
		local text_x_margin_ratio = 0.05
		local text_y_margin_ratio = 0.125
		
		local feed_panel = parent_panel:panel({
			name = "feed_panel",
			x = feed_panel_x,
			y = feed_panel_y,
			w = feed_panel_w,
			h = feed_panel_h
		})
		
		local bg_left = feed_panel:bitmap({
			name = "bg_left",
			texture = bg_texture,
			texture_rect = addon.atlas_rect.left,
			x = 0,
			y = 0,
			w = bg_bookend_w,
			h = bg_h,
			color = Color.white,
			alpha = 1,
			layer = 1
		})
		addon.bg_left = bg_left
		local bg_center = feed_panel:bitmap({
			name = "bg_center",
			texture = bg_texture,
			texture_rect = addon.atlas_rect.center,
			x = bg_left:right(),
			y = 0,
			w = bg_center_w,
			h = bg_h,
			color = Color.white,
			alpha = 1,
			layer = 2
		})
		addon.bg_center = bg_center
		local bg_right = feed_panel:bitmap({
			name = "bg_right",
			texture = bg_texture,
			texture_rect = addon.atlas_rect.right,
			x = bg_center:right(),
			y = 0,
			w = bg_bookend_w,
			h = bg_h,
			color = Color.white,
			alpha = 1,
			layer = 1
		})
		addon.bg_right = bg_right
		
		local _bg_center_w = bg_center:w()
		local _bg_center_h = bg_center:h()
		local feed_text_bound_w = _bg_center_w * (1 - (text_x_margin_ratio * 2))
		local feed_text_bound_h = _bg_center_h * (1 - (text_y_margin_ratio * 2))
		local feed_text_bound_x = bg_center:x() + (_bg_center_w * text_x_margin_ratio)
		local feed_text_bound_y = bg_center:y() + (_bg_center_h * text_y_margin_ratio)
		local feed_text_bound = feed_panel:panel({
			name = "feed_text_bound",
			x = feed_text_bound_x,
			y = feed_text_bound_y,
			w = feed_text_bound_w,
			h = feed_text_bound_h,
			layer = 3
		})
		addon.feed_text_bound = feed_text_bound
	end,
	register_func = function(addon)
		local pm = managers.player
		local player_unit = pm:local_player()
		
		addon.max_lines = math.floor(addon.feed_text_bound:h() / addon.font_size)
		
		addon.get_weapon_name(addon,1)
		addon.get_weapon_name(addon,2)
		
		Hooks:PostHook(PlayerDamage,"on_downed","mhudu_pkmdr_ondowned",function(self)
			local player_name = managers.network.account:username()
			local player_color = Color.yellow
			local substrings = {
				{s = "Oh no! ",color = nil},
				{s = player_name,color = player_color},
				{s = " was defeated!",color = nil}
			}
			
			local color_data = {}
			local s_all = ""
			local c = 0
			for i,v in ipairs(substrings) do 
				local str = tostring(v.s)
				local col = v.color
				s_all = s_all .. str
				local s_start = c
				local s_end = s_start + utf8.len(str)
				if col then
					table.insert(color_data,{
						s_start = s_start,
						s_end = s_end,
						color = col
					})
				end
				c = s_end
			end
			
			addon.add_text(addon,s_all,color_data)
		end)
		
		--[[
		Hooks:PostHook(TeamAIDamage,"_die","mhudu_pkmdr_teamai_on_death",function(self)
			local unit_name = managers.criminals:character_name_by_unit(self._unit)
			
			OffyLib:c_log("Oh no! " .. tostring(unit_name or self) .. " was defeated! They left the rescue team.")
		end)
		Hooks:PostHook(TeamAIDamage,"on_arrested","mhudu_pkmdr_teamai_arrested",function(self)
			local unit_name = managers.criminals:character_name_by_unit(self._unit)
			
			OffyLib:c_log("Oh no! " .. tostring(unit_name or self) .. " was arrested!")
		end)
		Hooks:PostHook(TeamAIDamage,"damage_tase","mhudu_pkmdr_teamai_tased",function(self,attack_data)
			local unit_name = managers.criminals:character_name_by_unit(self._unit)
			
			OffyLib:c_log("New AI state: tased for " .. tostring(unit_name or self))
		end)
--			OffyLib:c_log("New AI state: " .. tostring(state_name) .. " for " .. tostring(unit_name or self))
		--]]

		pm:register_message(Message.OnPlayerDodge,"mhudu_pkmdr_onplayerdodge",function()
			local player_name = managers.network.account:username()
			local player_color = Color.yellow
			local substrings = {
				{s = player_name,color = player_color},
				{s = " is unaffected!",color = nil}
			}
			
			local color_data = {}
			local s_all = ""
			local c = 0
			for i,v in ipairs(substrings) do 
				local str = tostring(v.s)
				local col = v.color
				s_all = s_all .. str
				local s_start = c
				local s_end = s_start + utf8.len(str)
				if col then
					table.insert(color_data,{
						s_start = s_start,
						s_end = s_end,
						color = col
					})
				end
				c = s_end
			end
			
			addon.add_text(addon,s_all,color_data)
		end)
		pm:register_message(Message.OnEnemyShot, "mhudu_pkmdr_onenemyshot",function(unit, attack_data)
			if alive(unit) then
				local attacker_unit = attack_data.attacker_unit
				local damage = attack_data.damage or 0
				local player_name = "Hoppip"
				local player_color = Color.yellow
				
				local weapon_name = "Gun"
				local move_color = Color("63ff63")
				
				local unit_base = unit:base()
				local unit_color = Color("00ffff")
				local tweak_table = unit_base._tweak_table
				local unit_name = tweak_table
				if HopLib then 
					local name_provider = HopLib:name_provider()
					unit_name = name_provider:name_by_id(tweak_table)
				end
				unit_name = unit_name or "Enemy"
				
				
				local weapon_unit = attack_data.weapon_unit
				if alive(weapon_unit) then 
					local weapon_key = weapon_unit:key()
					local _weapon_name = addon.weapon_name_by_unit[weapon_key]
					if _weapon_name then 
						--get registered weapon name
						weapon_name = _weapon_name
					elseif _weapon_name == false then 
						--blacklisted; do not search for weapon name
					else 
						--search for custom weapon name
						local weapon_base = weapon_unit:base()
						if weapon_base then 
							if type(weapon_base.get_name_id) == "function" then
								weapon_id = weapon_base:get_name_id()
							end
							_weapon_name = managers.weapon_factory:get_weapon_name_by_weapon_id(weapon_id) or false
							addon.weapon_name_by_unit[weapon_key] = _weapon_name
							weapon_name = _weapon_name or weapon_name
						end
						
					end
				end
				
				--if the player who shot the enemy was you (not one of your teammates):
				if attacker_unit == managers.player:local_player() then 
					player_color = Color.yellow
					player_name = managers.network.account:username()
				else
					local peer_id = managers.criminals:character_color_id_by_unit(attacker_unit) 
					if peer_id then 
						local peer = managers.network:session():peer(peer_id)
						if peer then 
							player_name = peer:name()
						end
						player_color = tweak_data.chat_colors[peer_id] or player_color
					end
				end
				
				do
					local substrings = {
						{s = player_name,color = player_color},
						{s = " used ",color = nil},
						{s = weapon_name,color = move_color},
						{s = "!",color = nil}
					}
					
					local attacker_color_data = {}
					local s_all = ""
					local c = 0
					for i,v in ipairs(substrings) do 
						local str = tostring(v.s)
						local col = v.color
						s_all = s_all .. str
						local s_start = c
						local s_end = s_start + utf8.len(str)
						if col then
							table.insert(attacker_color_data,{
								s_start = s_start,
								s_end = s_end,
								color = col
							})
						end
						c = s_end
					end
					
					addon.add_text(addon,s_all,attacker_color_data)
				end
				do 
					local substrings = {
						{s = unit_name,color=unit_color},
						{s = " took ",color=nil},
						{s = string.format("%i",damage * 10),color=nil},
						{s = " damage!",color=nil}
					}
					
					local target_color_data = {}
					local s_all = ""
					local c = 0
					for i,v in ipairs(substrings) do 
						local str = tostring(v.s)
						local col = v.color
						s_all = s_all .. str
						local s_start = c
						local s_end = s_start + utf8.len(str)
						if col then
							table.insert(target_color_data,{
								s_start = s_start,
								s_end = s_end,
								color = col
							})
						end
						c = s_end
					end
					addon.add_text(addon,s_all,target_color_data)
				end
				if attack_data.result.type == "death" then 
					local substrings = {
						{s = unit_name,color=unit_color},
						{s = " was defeated!",color=nil}
					}
					
					local target_color_data = {}
					local s_all = ""
					local c = 0
					for i,v in ipairs(substrings) do 
						local str = tostring(v.s)
						local col = v.color
						s_all = s_all .. str
						local s_start = c
						local s_end = s_start + utf8.len(str)
						if col then
							table.insert(target_color_data,{
								s_start = s_start,
								s_end = s_end,
								color = col
							})
						end
						c = s_end
					end
					addon.add_text(addon,s_all,target_color_data)
				end
			end
		end)
--[[ 
		pm:register_message(Message.OnEnemyKilled, "mhudu_pkmdr_onenemykilled",function(equipped_unit,variant,unit)
			do return end
			log("Enemy killed" .. tostring(unit))
			if alive(unit) then
				local unit_base = unit:base()
				local unit_color = Color("00ffff")
				local tweak_table = unit_base._tweak_table or "none"
				local unit_name = tweak_table
				if HopLib then 
					local name_provider = HopLib:name_provider()
					unit_name = name_provider:name_by_id(tweak_table)
				end
				
				do 
					local substrings = {
						{s = unit_name,color=unit_color},
						{s = " was defeated!",color=nil}
					}
					
					local target_color_data = {}
					local s_all = ""
					local c = 0
					for i,v in ipairs(substrings) do 
						local str = v.s
						local col = v.color
						s_all = s_all .. str
						local s_start = c
						local s_end = s_start + utf8.len(str)
						if col then
							table.insert(target_color_data,{
								s_start = s_start,
								s_end = s_end,
								color = col
							})
						end
						c = s_end
					end
					addon.add_text(addon,s_all,target_color_data)
				end
			end
		end)
		--]]
		
		Hooks:PostHook(HuskPlayerMovement,"sync_movement_state","mhudu_pkmdr_teammate_state_change",function(self,state,down_time)
			local unit_name = managers.criminals:character_name_by_unit(self._unit)
			local state_desc = state and addon.state_lookups[state]
			if unit_name and state_desc then 
				local unit_color = Color.yellow
				local substrings = {
					{s = unit_name,color=unit_color},
					{s = state_desc,color=nil}
				}
				
				local color_data = {}
				local s_all = ""
				local c = 0
				for i,v in ipairs(substrings) do 
					local str = tostring(v.s)
					local col = v.color
					s_all = s_all .. str
					local s_start = c
					local s_end = s_start + utf8.len(str)
					if col then
						table.insert(color_data,{
							s_start = s_start,
							s_end = s_end,
							color = col
						})
					end
					c = s_end
				end
				addon.add_text(addon,s_all,color_data)
			end
		end)
		
		if not alive(player_unit) then 
			return
		end
		--[[ does not work
		player_unit:character_damage():add_listener("mhudu_pkmdr_on_player_death",{"death"},function(unit,damage_info)
			local player_color = Color.yellow
			local player_name = managers.network.account:username()
			local substrings = {
				{s = "Oh no! ",color=nil},
				{s = player_name,color=player_color},
				{s = " was defeated!",color=nil}
			}
			
			local color_data = {}
			local s_all = ""
			local c = 0
			for i,v in ipairs(substrings) do 
				local str = v.s
				local col = v.color
				s_all = s_all .. str
				local s_start = c
				local s_end = s_start + utf8.len(str)
				if col then
					table.insert(color_data,{
						s_start = s_start,
						s_end = s_end,
						color = col
					})
				end
				c = s_end
			end
			addon.add_text(addon,s_all,color_data)
		end)
		--]]
	end,
	destroy_func = function(addon)
		local pm = managers.player
		local player_unit = pm:local_player()
		pm:unregister_message(Message.OnEnemyShot, "mhudu_pkmdr_onenemyshot")
--		pm:unregister_message(Message.OnEnemyKilled, "mhudu_pkmdr_onenemykilled")
		pm:unregister_message(Message.OnPlayerDodge, "mhudu_pkmdr_onplayerdodge")
		if alive(player_unit) then 
--			player_unit:character_damage():remove_listener("mhudu_pkmdr_on_player_death")
		end
		Hooks:RemovePostHook("mhudu_pkmdr_ondowned")
		Hooks:RemovePostHook("mhudu_pkmdr_teammate_state_change")
	end,
--	update_func = function(addon,t,dt) end,
	add_text = function(addon,text_string,color_range_data)
		local feed_text_bound = addon.feed_text_bound
		if alive(feed_text_bound) then
			local max_lines = addon.max_lines
			local text_objects = addon.feed_text_objects
			
			local font_shadow = addon.fonts.shadow
			local font_size = addon.font_size
			
			local animate_duration = 0.5
			local message_count = addon.message_count + 1
			addon.message_count = message_count
			
			
			local new_feed_message = feed_text_bound:text({
				name = "feed_message_" .. message_count,
				text = text_string,
				color = Color.white,
				x = 0,
				y = 0,
--				rotation = 0.0001, --debug for disabling clipping
				font = font_shadow,
				font_size = font_size,
				wrap = true,
				layer = 3
			})
			if color_range_data then 
				for k,v in ipairs(color_range_data) do 
					new_feed_message:set_range_color(v.s_start,v.s_end,v.color)
				end
			end
			
			table.insert(text_objects,1,new_feed_message)
			
			local num_lines = new_feed_message:number_of_lines()
			local line_height = new_feed_message:line_height()
			local total_lines = 0
			for i=#text_objects,1,-1 do 
				if total_lines > max_lines or i >= max_lines then 
				
					local text_obj = table.remove(text_objects,i)
					if alive(text_obj) then
--						text_obj:stop()
--						MHUDU:animate_stop(text_obj)
						text_obj:parent():remove(text_obj)
					end
				else
					local text_obj = text_objects[i] 
					if alive(text_obj) then 
						local to_y = total_lines * line_height
--						local current_y = text_obj:y()
						text_obj:set_y(to_y)

--						local delta_y =  - (to_y - current_y)
--						text_obj:stop()
--						text_obj:animate(addon.animate_text_conveyor,0,delta_y,animate_duration)
--						MHUDU:animate_stop(text_obj)
--						MHUDU:animate(text_obj,"animate_move_simple",nil,animate_duration,nil,nil,current_y,to_y)

						total_lines = total_lines + text_obj:number_of_lines()
					end
				end
			end
		end
		
	end,
	animate_text_conveyor = function(o,x_distance,y_distance,duration)
		local t_rem = duration
		while t_rem > 0 do 
			local dt = coroutine.yield()
			t_rem = t_rem - dt
			o:move(x_distance * dt,y_distance * dt)
		end
	end,
	get_weapon_name = function(addon,slot)
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
			local weapon_id = weaponbase.get_name_id and weaponbase:get_name_id() or weaponbase._name_id
			if weapon_id then 
				local weapon_name = managers.weapon_factory:get_weapon_name_by_weapon_id(weapon_id)
				if slot == 1 then 
					weapon_name = managers.blackmarket:equipped_secondary().custom_name or weapon_name
				elseif slot == 2 then 	
					weapon_name = managers.blackmarket:equipped_primary().custom_name or weapon_name
				end
				return weapon_name
			end
		end
	end
}
