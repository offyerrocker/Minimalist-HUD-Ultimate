local mvec3_normalize = mvector3.normalize
local mvec3_dot = mvector3.dot

local addon_id = "doom"
return addon_id,{
	name = "DOOM HUD",
	desc = "Heads-up display from DOOM (1993)",
	autodetect_assets = true,
	layer = 1,
	categories = {
		"health",
		"armor",
		"ammo",
		"throwables"
	},
	_update_t = 0,
	update_interval = 1,
	portrait_size = 64,
	get_rect = function(addon,name,hurt_level)
		local size = addon.portrait_size
		local x = 0
		local y = 0
		name = tostring(name)
		if addon.face_atlas[name] then 
			x,y = unpack(addon.face_atlas[name])
			return {x * size,y * size,size,size}
		elseif addon.face_atlas.expressions[name] then
			x = addon.face_atlas.expressions[name]
			hurt_level = hurt_level or 1
---			hurt_level = tonumber(hurt_level) --integer
			return {x * size,hurt_level * size,size,size}
		end
		return {0,0,size,size}
	end,
	fake_fonts = {},
	face_atlas_name = "guis/textures/mhudu/doom_portrait_atlas",
	face_atlas = {
		expressions = {
			EVL = 0, -- grin
			KILL = 1, --grit
			OUCH = 2, --shock
			TR = 3, --look right
			ST = 4, --look forward
			TL = 5, --look left
			KILL_TL = 6, --grit look left
			KILL_TR = 7 --grit look right
		},
		DEAD = {0,5},
		GOD = {1,5}
	},
	DAMAGE_TIERS = 4, --5, technically, except we count from 0
	lookat_angle_threshold = 45,
	hit_indicator_duration = 2,
	health_low_threshold = 0.5,
	hud_atlas_name = "guis/textures/mhudu/doom_hud_atlas",
	ver_offset = 16,
	font_size = 56,
	font_y = 24,
	font_size = 24,
	info = {
		health_current = 0,
		health_total = 1,
		hit_indicators = {}
	},
	create_func = function(addon,parent_panel)
	
		for font_name,font_data in pairs(addon.fake_font_data) do 
			addon.fake_fonts[font_name] = FakeFont:new(font_data)
		end
		
		local hud_panel = parent_panel:panel({
			name = "hud_panel"
		})
		addon.panel = hud_panel
		
		local bg_subpanel = parent_panel:panel({
			name = "bg_subpanel",
			visible = true,
			w = 1280,
			h = 128
		})
		bg_subpanel:set_bottom(parent_panel:bottom())
		addon.bg_subpanel = bg_subpanel
		local bg_main = bg_subpanel:bitmap({
			name = "bg_main",
			texture = addon.hud_atlas_name,
			texture_rect = {
				0,0,
				1280,128
			},
			layer = -3
		})
		local bg_arms = bg_subpanel:bitmap({
			name = "bg_arms",
			texture = addon.hud_atlas_name,
			texture_rect = {
				416,132,
				160,128
			},
			x = 416,
			y = 0,
			visible = false,
			layer = -2
		})
		
		
		local y_offset = bg_subpanel:y()
		local digits_y = 12 + y_offset
		
		local ammo_text = FakeText:new(hud_panel,{
			name = "ammo_text",
			text = "00",
			font = "doom_font_digits_large",
			w = 160,
			h = 64,
			x = 4,
			y = digits_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.ammo_text = ammo_text
		
		local health_text = FakeText:new(hud_panel,{
			name = "health_text",
			text = "100%",
			font = "doom_font_digits_large",
			w = 220,
			h = 88,
			x = 196,
			y = digits_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.health_text = health_text
		
		local frag_text = FakeText:new(hud_panel,{
			name = "frag_text",
			text = "0",
			font = "doom_font_digits_large",
			w = 140,
			h = 88,
			x = 428 - 32,
			y = digits_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.frag_text = frag_text
		
		local armor_text = FakeText:new(hud_panel,{
			name = "armor_text",
			text = "150%",
			font = "doom_font_digits_large",
			w = 224,
			h = 88,
			x = 716,
			y = digits_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.armor_text = armor_text
		
		
		local reserve_row_1_y = y_offset + 16
		local reserve_row_2_y = y_offset + 40
		local reserve_row_3_y = y_offset + 64
		local reserve_row_4_y = y_offset + 88
		
		local reserve_column_1_x = 1092
		local reserve_column_2_x = 1180
		
		local reserve_w = 60
		local reserve_h = 24
		
		local reserve_ammo_current_1 = FakeText:new(hud_panel,{
			name = "reserve_ammo_current_1",
			text = "0",
			font = "doom_font_digits_yellow_shadow",
			w = reserve_w,
			h = reserve_h,
			x = reserve_column_1_x,
			y = reserve_row_1_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.reserve_ammo_current_1 = reserve_ammo_current_1
		
		local reserve_ammo_current_2 = FakeText:new(hud_panel,{
			name = "reserve_ammo_current_2",
			text = "0",
			font = "doom_font_digits_yellow_shadow",
			w = reserve_w,
			h = reserve_h,
			x = reserve_column_1_x,
			y = reserve_row_2_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.reserve_ammo_current_2 = reserve_ammo_current_2
		
		local reserve_ammo_current_3 = FakeText:new(hud_panel,{
			name = "reserve_ammo_current_3",
			text = "0",
			font = "doom_font_digits_yellow_shadow",
			w = reserve_w,
			h = reserve_h,
			x = reserve_column_1_x,
			y = reserve_row_3_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.reserve_ammo_current_3 = reserve_ammo_current_3
		
		local reserve_ammo_current_4 = FakeText:new(hud_panel,{
			name = "reserve_ammo_current_4",
			text = "0",
			font = "doom_font_digits_yellow_shadow",
			w = reserve_w,
			h = reserve_h,
			x = reserve_column_1_x,
			y = reserve_row_4_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.reserve_ammo_current_4 = reserve_ammo_current_4
		
		local reserve_ammo_total_1 = FakeText:new(hud_panel,{
			name = "reserve_ammo_total_1",
			text = "0",
			font = "doom_font_digits_yellow_shadow",
			w = reserve_w,
			h = reserve_h,
			x = reserve_column_2_x,
			y = reserve_row_1_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.reserve_ammo_total_1 = reserve_ammo_total_1
		
		local reserve_ammo_total_2 = FakeText:new(hud_panel,{
			name = "reserve_ammo_total_2",
			text = "0",
			font = "doom_font_digits_yellow_shadow",
			w = reserve_w,
			h = reserve_h,
			x = reserve_column_2_x,
			y = reserve_row_2_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.reserve_ammo_total_2 = reserve_ammo_total_2
		local reserve_ammo_total_3 = FakeText:new(hud_panel,{
			name = "reserve_ammo_total_2",
			text = "0",
			font = "doom_font_digits_yellow_shadow",
			w = reserve_w,
			h = reserve_h,
			x = reserve_column_2_x,
			y = reserve_row_3_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.reserve_ammo_total_3 = reserve_ammo_total_3
		local reserve_ammo_total_4 = FakeText:new(hud_panel,{
			name = "reserve_ammo_total_2",
			text = "0",
			font = "doom_font_digits_yellow_shadow",
			w = reserve_w,
			h = reserve_h,
			x = reserve_column_2_x,
			y = reserve_row_4_y,
			align = "right",
--			vertical = "bottom",
			tracking = 0
		})
		addon.reserve_ammo_total_4 = reserve_ammo_total_4
		
		
		local doomguy_portrait = hud_panel:bitmap({
			name = "doomguy_portrait",
			texture = addon.face_atlas_name,
			texture_rect = addon.get_rect(addon,"ST",1),
			layer = -1,
			w = 128,
			h = 128,
			x = 580,
			y = y_offset
		})
		addon.doomguy_portrait = doomguy_portrait
	end,
	register_func = function(addon)
		--poll health, check regularly for doom face expressions
		
		local player = managers.player:local_player()
		
		--force grenade count check
		local _,grenades_amount = managers.blackmarket:equipped_grenade()
		addon.frag_text:set_text(string.format("%i",grenades_amount))

		if alive(player) then 
			--force hud ammo check
			for id, weapon in pairs(player:inventory():available_selections()) do --or inv._available_selections
				if alive(weapon.unit) then 
					managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
				end
			end
		end
		
		MHUDU:AddListener("set_criminal_health","mhudu_doomhud_criminalhealthchanged",{
			callback = function(i,data,...)
				if i == HUDManager.PLAYER_PANEL and data.total ~= 0 then 
					addon.health_text:set_text(string.format("%i%%",math.round(100 * data.current/data.total)))
					addon.info.health_current = data.current
					addon.info.health_total = data.total
				end
			end
		})
		
		MHUDU:AddListener("set_criminal_armor","mhudu_doomhud_criminalarmorchanged",{
			callback = function(i,data,...)
				if i == HUDManager.PLAYER_PANEL and data.total ~= 0 then 
					addon.armor_text:set_text(string.format("%i%%",math.round(100 * data.current/data.total)))
				end
			end
		})
		
		MHUDU:AddListener("set_criminal_ammo_data","mhudu_doomhud_criminalammochanged",{
			callback = function(i,type,max_clip,current_clip,current_left,max,...)
				if i == HUDManager.PLAYER_PANEL then
					if type == "primary" then 
						addon.reserve_ammo_current_1:set_text(string.format("%02i",math.clamp(current_left - current_clip,0,999)))
						addon.reserve_ammo_total_1:set_text(string.format("%02i",math.clamp(max - max_clip,0,999)))
					elseif type == "secondary" then 
						addon.reserve_ammo_current_2:set_text(string.format("%02i",math.clamp(current_left - current_clip,0,999)))
						addon.reserve_ammo_total_2:set_text(string.format("%02i",math.clamp(max - max_clip,0,999)))
					end
					addon.ammo_text:set_text(string.format("%02i",math.clamp(current_clip,0,99)))
				end
			end
		})
		
		MHUDU:AddListener("set_criminal_grenades_amount","mhudu_doomhud_criminalgrenadeschanged",{
			callback = function(i,data,...)
				if i == HUDManager.PLAYER_PANEL then 
					local icon = data.icon
					local amount = data.amount
					addon.frag_text:set_text(string.format("%i",amount))
				end
			end
		})
		
		Hooks:PostHook(HUDHitDirection,"_add_hit_indicator","mhudu_doomhud_playerhitindicator",function(self,damage_origin, damage_type, fixed_angle)
			table.insert(addon.info.hit_indicators,{damage_origin = damage_origin,damage_type = damage_type,fixed_angle = fixed_angle,start_t = Application:time()})
		end)

	end,
	destroy_func = function(addon)
		MHUDU:RemoveListener("set_criminal_health","mhudu_doomhud_criminalhealthchanged")
		MHUDU:RemoveListener("set_criminal_armor","mhudu_doomhud_criminalarmorchanged")
		MHUDU:RemoveListener("set_criminal_ammo_data","mhudu_doomhud_criminalammochanged")
		MHUDU:RemoveListener("set_criminal_grenades_amount","mhudu_doomhud_criminalgrenadeschanged")
	end,
	update_func = function(addon,t,dt)
		local player = managers.player:local_player()
		local has_set_doomface = false

		if alive(player) then 
			local state = player:movement():current_state()
			if player:character_damage()._invulnerable or player:character_damage()._god_mode then 
				has_set_doomface = true
				addon.set_doomface(addon,"GOD")
				addon._update_t = t + addon.update_interval
			end

			if state._shooting_t and (t - state._shooting_t >= 2) then 
				addon.set_doomface(addon,"EVL")
				addon._update_t = t + addon.update_interval
				has_set_doomface = true
			end
				
			local hit_indicator_duration = addon.hit_indicator_duration
			for i=#addon.info.hit_indicators,1,-1 do 
				local hit_indicator = addon.info.hit_indicators[i]
				if hit_indicator.start_t + hit_indicator_duration < t then 
					table.remove(addon.info.hit_indicators,i)
					hit_indicator = nil
				elseif not has_set_doomface then 
					--always use latest hit indicator for doom's indicator
					if hit_indicator.damage_origin and hit_indicator.source ~= player then
						local angle_threshold = addon.lookat_angle_threshold
						local player_aim = player:movement():m_head_rot():yaw() or 0
				
						if hit_indicator.source ~= player then 
							if hit_indicator.damage_origin then 
								local angle_to = addon.angle_from(hit_indicator.damage_origin,player:position())
								angle_to = ((90 + angle_to - player_aim) % 360) - 180
								if angle_to > angle_threshold then 
									addon.set_doomface(addon,"KILL_TL")
									has_set_doomface = true
								elseif angle_to < -angle_threshold then 
									addon.set_doomface(addon,"KILL_TR")
									has_set_doomface = true
								else 
									addon.set_doomface(addon,"KILL")
								end
							end
						end
					end
				end
			end

			if (not has_set_doomface) and (addon._update_t < t) then 
				addon._update_t = t + addon.update_interval
				local r_doomface_direction = math.random()
				if r_doomface_direction < 0.33 then 
					addon.set_doomface(addon,"TL",nil,true)
				elseif r_doomface_direction > 0.66 then 
					addon.set_doomface(addon,"TR",nil,true)
				else
					addon.set_doomface(addon,"ST",nil,true)
				end
			end
		end
	end,
	angle_from = function(a,b,c,d) -- converts to angle with ranges (-180 , 180); for result range 0-360, do +180 to result
		a = a or "nil"
		b = b or "nil"
		c = c or "nil"
		d = d or "nil"
		local function do_angle(x1,y1,x2,y2)
			local angle = 0
			local x = x2 - x1 --x diff
			local y = y2 - y1 --y diff
			if x ~= 0 then 
				angle = math.atan(y / x) % 180
				if y == 0 then 
					if x > 0 then 
						angle = 180 --right
					else
						angle = 0 --left 
					end
				elseif y > 0 then 
					angle = angle - 180
				end
			else
				if y > 0 then
					angle = 270 --up
				else
					angle = 90 --down
				end
			end
			
			return angle
		end
		local vectype = type(Vector3())
		if (type(a) == vectype) and (type(b) == vectype) then  --vector pos diff
			return do_angle(a.x,a.y,b.x,b.y)
		elseif (type(a) == "number") and (type(b) == "number") and (type(c) == "number") and (type(d) == "number") then --manual x/y pos diff
			return do_angle(a,b,c,d)
		else
			return
		end
	end,
	set_doomface = function(addon,name,hurt_level,skip_interval)
		name = name or "ST"
		local doomguy_portrait = addon.doomguy_portrait
		if not hurt_level then 
			hurt_level = math.round(1 - (addon.info.health_current / addon.info.health_total)) * addon.DAMAGE_TIERS
		end
		doomguy_portrait:set_image(addon.face_atlas_name,unpack(addon.get_rect(addon,name,hurt_level)))
		if not skip_interval then 
			addon._update_t = Application:time() + 2
		end
	end,
	fake_font_data = {
		digits_1 = {
			name = "doom_font_digits_small",
			version = 1,
			font_size = 20,
			atlas = "guis/textures/mhudu/doom_hud_atlas",
			tracking = 4,
			leading = 24,
			start = {4,132},
			characters = {
				["0"] = {
					0,0,
					12,20
				},
				["1"] = {
					16,0,
					8,20
				},
				["2"] = {
					28,0,
					12,20
				},
				["3"] = {
					44,0,
					12,20
				},
				["4"] = {
					60,0,
					12,20
				},
				["5"] = {
					76,0,
					12,20
				},
				["6"] = {
					92,0,
					12,20
				},
				["7"] = {
					108,0,
					12,20
				},
				["8"] = {
					124,0,
					12,20
				},
				["9"] = {
					140,0,
					12,20
				}
			}
		},
		digits_2 = {
			name = "doom_font_digits_grey_shadow",
			version = 1,
			font_size = 24,
			atlas = "guis/textures/mhudu/doom_hud_atlas",
			tracking = 4,
			leading = 28,
			start = {4,156},
			characters = {
				["0"] = {
					0,0,
					16,24
				},
				["1"] = {
					20,0,
					16,24
				},
				["2"] = {
					40,0,
					16,24
				},
				["3"] = {
					60,0,
					16,24
				},
				["4"] = {
					80,0,
					16,24
				},
				["5"] = {
					100,0,
					16,24
				},
				["6"] = {
					120,0,
					16,24
				},
				["7"] = {
					140,0,
					16,24
				},
				["8"] = {
					160,0,
					16,24
				},
				["9"] = {
					180,0,
					16,24
				}
			}
		},
		digits_3 = {
			name = "doom_font_digits_yellow_shadow",
			version = 1,
			font_size = 24,
			atlas = "guis/textures/mhudu/doom_hud_atlas",
			tracking = 4,
			leading = 28,
			start = {4,184},
			characters = {
				["0"] = {
					0,0,
					16,24
				},
				["1"] = {
					20,0,
					16,24
				},
				["2"] = {
					40,0,
					16,24
				},
				["3"] = {
					60,0,
					16,24
				},
				["4"] = {
					80,0,
					16,24
				},
				["5"] = {
					100,0,
					16,24
				},
				["6"] = {
					120,0,
					16,24
				},
				["7"] = {
					140,0,
					16,24
				},
				["8"] = {
					160,0,
					16,24
				},
				["9"] = {
					180,0,
					16,24
				}
			}
		},
		digits_4 = {
			name = "doom_font_digits_large",
			version = 1,
			font_size = 64,
			atlas = "guis/textures/mhudu/doom_hud_atlas",
			tracking = 4,
			leading = 68,
			start = {580,132},
			characters = {
				["0"] = {
					0,0,
					56,64
				},
				["1"] = {
					60,0,
					44,64
				},
				["2"] = {
					108,0,
					56,64
				},
				["3"] = {
					168,0,
					56,64
				},
				["4"] = {
					228,0,
					56,64
				},
				["5"] = {
					288,0,
					56,64
				},
				["6"] = {
					348,0,
					56,64
				},
				["7"] = {
					408,0,
					56,64
				},
				["8"] = {
					468,0,
					56,64
				},
				["9"] = {
					528,0,
					56,64
				},
				["%"] = {
					588,0,
					56,64
				},
				["-"] = {
					648,0,
					32,64
				}
			}
		},
		doom_font_main = {
			name = "doom_font_main",
			version = 1,
			font_size = 28,
			atlas = "guis/textures/mhudu/doom_hud_atlas",
			tracking = 4,
			leading = 28,
			start = {580,200},
			characters = {
				["0"] = {
					0,0,
					32,28
				},
				["1"] = {
					36,0,
					20,28
				},
				["2"] = {
					60,0,
					32,28
				},
				["3"] = {
					96,0,
					32,28
				},
				["4"] = {
					132,0,
					28,28
				},
				["5"] = {
					164,0,
					28,28
				},
				["6"] = {
					196,0,
					32,28
				},
				["7"] = {
					232,0,
					32,28
				},
				["8"] = {
					268,0,
					32,28
				},
				["9"] = {
					304,0,
					32,28
				},
				["A"] = {
					0,32,
					32,28
				},
				["B"] = {
					36,32,
					32,28
				},
				["C"] = {
					72,32,
					32,28
				},
				["D"] = {
					108,32,
					32,28
				},
				["E"] = {
					144,32,
					32,28
				},
				["F"] = {
					180,32,
					32,28
				},
				["G"] = {
					216,32,
					32,28
				},
				["H"] = {
					252,32,
					32,28
				},
				["I"] = {
					288,32,
					16,28
				},
				["J"] = {
					308,32,
					32,28
				},
				["K"] = {
					344,32,
					32,28
				},
				["L"] = {
					380,32,
					32,28
				},
				["M"] = {
					416,32,
					32,28
				},
				["N"] = {
					456,32,
					32,28
				},
				["O"] = {
					492,32,
					32,28
				},
				["P"] = {
					528,32,
					32,28
				},
				["Q"] = {
					564,32,
					32,28
				},
				["R"] = {
					600,32,
					32,28
				},
				["S"] = {
					636,32,
					28,28
				},
				["T"] = {
					0,68,
					32,28
				},
				["U"] = {
					36,68,
					32,28
				},
				["V"] = {
					72,68,
					28,28
				},
				["W"] = {
					104,68,
					36,28
				},
				["X"] = {
					144,68,
					36,28
				},
				["Y"] = {
					184,68,
					32,28
				},
				["Z"] = {
					220,68,
					28,28
				},
				["'"] = { --apostrophe
					252,68,
					16,28
				},
				
				["'"] = { --single quotation mark
					272,68,
					16,28
				},
				["`"] = { --backtick, i think?
					292,68,
					16,28
				},
				[":"] = { --colon
					312,68,
					16,28
				},
				[";"] = {
					332,68,
					16,28
				},
				[" "] = { --space character (should not be used)
					352,68,
					4,28
				},
				["|"] = { --vertical pipe
					372,68,
					16,28
				},
				["["] = {
					392,68,
					20,28
				},
				["]"] = {
					416,68,
					20,28
				},
				["="] = {
					440,68,
					20,28
				},
				["+"] = {
					464,68,
					20,28
				},
				["<"] = {
					488,68,
					20,28
				},
				[">"] = {
					512,68,
					20,28
				},
				['"'] = { --quotation mark
					536,68,
					28,28
				},
				["#"] = {
					566,68,
					28,28
				},
				["$"] = {
					602,68,
					28,28
				},
				["%"] = {
					632,68,
					36,28
				},
				["("] = {
					0,100,
					28,28
				},
				[")"] = {
					32,100,
					28,28
				},
				["*"] = {
					64,100,
					28,28
				},
				["/"] = {
					96,100,
					28,28
				},
				["\\"] = {
					128,100,
					28,28
				},
				["^"] = {
					160,100,
					28,28
				},
				["&"] = {
					192,100,
					32,28
				},
				["@"] = {
					228,100,
					36,28
				},
				["_"] = {
					268,100,
					32,28
				},
				["?"] = {
					304,100,
					32,28
				},
				["!"] = {
					340,100,
					16,28
				},
				["-"] = {
					360,100,
					24,28
				}
			},
			character_copies = {
				a = "A",
				b = "B",
				c = "C",
				d = "D",
				e = "E",
				f = "F",
				g = "G",
				h = "H",
				i = "I",
				j = "J",
				k = "K",
				l = "L",
				m = "M",
				n = "N",
				o = "O",
				p = "P",
				q = "Q",
				r = "R",
				s = "S",
				t = "T",
				u = "U",
				v = "V",
				w = "W",
				x = "X",
				y = "Y",
				z = "Z"
			}
		}
	}
}
