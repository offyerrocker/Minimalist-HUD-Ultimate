return "teamfortress2hud",{
	name = "Team Fortress 2 HUD",
	desc = "Health, Ammo, and Minimalism Timer counter for Team Fortress 2.",
	autodetect_assets = true,
	layer = 3,
	categories = {
		"health",
		"ammo"
	},
	
	HEALTH_SCALE = 0.75,
	HEALTH_BITMAP_W = 128,
	HEALTH_BITMAP_H = 128,
	AMMO_TEXT_X = 118,
	HEALTH_LOW_THRESHOLD = 1/2,
	AMMO_LOW_THRESHOLD = 1/5,
	AMMO_GHOST_ALPHA = 0.3,
	AMMO_GHOST_SIZE_MUL = 1.1,
	
	box_texture = "guis/textures/mhudu/tf2_box",
	health_fill_texture = "guis/textures/mhudu/tf2_health_fill",
	health_outline_texture = "guis/textures/mhudu/tf2_health_outline",
	create_func = function(addon,parent_panel)
		
		
		local tf2_color_grey = Color("363331")
		local tf2_color_grey_light = Color("7d7a78")
		local tf2_color_cream = Color("ece3cb")
		local tf2_font = "fonts/tf2"
		local tf2_build_font = "fonts/tf2_build"
		local health_w = 128 * 1
		local health_h = 128 * 1
		local health_scale = addon.HEALTH_SCALE
		local HEALTH_BITMAP_W = addon.HEALTH_BITMAP_W
		local HEALTH_BITMAP_H = addon.HEALTH_BITMAP_H
		
		local health_panel = parent_panel:panel({
			name = "health_panel",
			w = health_w * health_scale,
			h = health_h * health_scale,
			x = -64 + (health_w + 256), -- tf2_hud:w() - 
			y = -100 + parent_panel:h() - (health_h)
		})
		
		local health_fill = health_panel:bitmap({
			name = "health_fill",
			layer = 3,
			w = HEALTH_BITMAP_W * health_scale,
			h = HEALTH_BITMAP_H * health_scale,
			texture = "guis/textures/mhudu/tf2_health_fill"
		})
		addon.health_fill = health_fill
		local health_ghost = health_panel:bitmap({
			name = "health_ghost",
			layer = 1,
			w = HEALTH_BITMAP_W * health_scale,
			h = HEALTH_BITMAP_H * health_scale,
			color = Color.red,
			rotation = 0.001,
			texture = "guis/textures/mhudu/tf2_health_fill",
			alpha = 0
		})
		addon.health_ghost = health_ghost
		local health_outline = health_panel:bitmap({
			name = "health_outline",
			layer = 2,
			w = HEALTH_BITMAP_W * health_scale,
			h = HEALTH_BITMAP_H * health_scale,
			texture = "guis/textures/mhudu/tf2_health_outline"
		})
		addon.health_outline = health_outline
		
		local health_font_size = 28 * health_scale
		local health_label = health_panel:text({
			name = "health_label",
			layer = 4,
			text = "150",
			align = "center",
			vertical = "center",
			y = -health_font_size,
			font = tf2_font,
			font_size = health_font_size,
			color = tf2_color_grey_light,
			alpha = 0.75,
			visible = true
		})
		addon.health_label = health_label 
		
		
		
		
		
		

		local AMMO_GHOST_ALPHA = addon.AMMO_GHOST_ALPHA
		local AMMO_GHOST_SIZE_MUL = addon.AMMO_GHOST_SIZE_MUL
		local ammo_scale = 1
		local ammo_w = 178 * ammo_scale * AMMO_GHOST_SIZE_MUL
		local ammo_h = 84 * ammo_scale * AMMO_GHOST_SIZE_MUL --84
		local ammo_mag_font_size = 96 * ammo_scale
		local ammo_reserve_font_size = 40 * ammo_scale
		local ammo_text_x = 118
		local ammo_text_ver_offset = -4
		
		local ammo_panel = parent_panel:panel({
			name = "ammo_panel",
			w = ammo_w,
			h = ammo_h,
			x =  parent_panel:w() - (ammo_w + 256),
			y = -100 + parent_panel:h() - (ammo_h + 32)
		})
		addon.ammo_panel = ammo_panel
		local ammo_box = ammo_panel:bitmap({
			name = "ammo_box",
			layer = 1,
			texture = "guis/textures/mhudu/tf2_box",
	--		blend_mode = "mul",
			alpha = 0.9
		})
		addon.ammo_box = ammo_box
		local ammo_box_ghost = ammo_panel:bitmap({
			name = "ammo_box_ghost",
			layer = 2,
			texture = "guis/textures/mhudu/tf2_box",
	--		blend_mode = "add",
			alpha = AMMO_GHOST_ALPHA,
			rotation = 0.001,
			visible = false
	--		color = Color.red
		})
		addon.ammo_box_ghost = ammo_box_ghost
		ammo_box:set_x(ammo_panel:w() * (AMMO_GHOST_SIZE_MUL - 1))
		ammo_box:set_y(ammo_panel:h() - ammo_box:height())
		ammo_box_ghost:set_size(ammo_box:w() * AMMO_GHOST_SIZE_MUL,ammo_box:h() * AMMO_GHOST_SIZE_MUL)
		ammo_box_ghost:set_center(ammo_box:x() + (ammo_box:w() / 2),ammo_box:y() + (ammo_box:h() / 2))

		local ammo_mag_label = ammo_panel:text({
			name = "ammo_mag_label",
			text = "4",
			align = "right",
			x = ammo_text_x - ammo_panel:w(),
			y = ammo_text_ver_offset + ammo_panel:h() - ammo_mag_font_size,
			font = tf2_build_font,
			font_size = ammo_mag_font_size,
			color = tf2_color_cream,
			layer = 4,
			visible = true
		})
		addon.ammo_mag_label = ammo_mag_label
		local ammo_mag_shadow = ammo_panel:text({
			name = "ammo_mag_shadow",
			text = "4",
			align = "right",
			x = 1 + ammo_text_x - ammo_panel:w(),
			y = 1 + ammo_text_ver_offset + ammo_panel:h() - ammo_mag_font_size,
			font = tf2_build_font,
			font_size = ammo_mag_font_size,
			color = Color.black,
			layer = 3,
			visible = true
		})
		addon.ammo_mag_shadow = ammo_mag_shadow
		local ammo_reserve_label = ammo_panel:text({
			name = "ammo_reserve_label",
			text = "16",
			align = "left",
	--		vertical = "bottom",
			x = ammo_text_x + 4,
	--		y = ammo_mag_font_size,
			y = ammo_text_ver_offset + ammo_panel:h() - (1.2 * ammo_reserve_font_size),
			font = tf2_font,
			font_size = ammo_reserve_font_size,
			color = tf2_color_cream,
			layer = 4,
			visible = true
		})
		addon.ammo_reserve_label = ammo_reserve_label
		local ammo_reserve_shadow = ammo_panel:text({
			name = "ammo_reserve_shadow",
			text = "16",
			align = "left",
			x = 1 + ammo_text_x + 4,
			y = 1 + ammo_text_ver_offset + ammo_panel:h() - (1.2 * ammo_reserve_font_size),
			font = tf2_font,
			font_size = ammo_reserve_font_size,
			color = Color.black,
			layer = 3,
			visible = true
		})
		addon.ammo_reserve_shadow = ammo_reserve_shadow
		
	
	
	
	
	end,
	register_func = function(addon)
		
		local player = managers.player:local_player()
		
		MHUDU:AddListener("set_criminal_health","mhudu_tf2hud_criminalhealthchanged",{
			callback = function(i,data,...)
				if i == HUDManager.PLAYER_PANEL and data.total ~= 0 then 
					addon.set_health(addon,data.current,data.total)
				end
			end
		})
		
		MHUDU:AddListener("set_criminal_ammo_data","mhudu_tf2hud_criminalammochanged",{
			callback = function(i,type,max_clip,current_clip,current_left,max,...)
				if i == HUDManager.PLAYER_PANEL then
					addon.set_ammo(addon,current_clip,current_left,max_clip)
				end
			end
		})
		
	end,
	destroy_func = function(addon)
		MHUDU:RemoveListener("set_criminal_health","mhudu_tf2hud_criminalhealthchanged")
		MHUDU:RemoveListener("set_criminal_ammo_data","mhudu_tf2hud_criminalammochanged")
	end,
	update_func = function(addon,t,dt)
	
		local health_ghost = addon.health_ghost
		if alive(health_ghost) and health_ghost:visible() then 
			local health_alpha = (0.5 + math.sin(t * 1666)) / 2
			health_ghost:set_alpha(health_alpha)
		end
	
		
		local ammo_box_ghost = addon.ammo_box_ghost
		if alive(ammo_box_ghost) and ammo_box_ghost:visible() then 
			local ammo_alpha = (1 + math.sin(t * 1500)) / 2
			if ammo_alpha > 0.2 then 
				ammo_box_ghost:set_alpha(addon.AMMO_GHOST_ALPHA)
			else 
				ammo_box_ghost:set_alpha(0)
			end
		end
		
	
	
	end,
	set_health = function(addon,current,total)
		local data = addon
		local health_outline = addon.health_outline
		local health_ghost = addon.health_ghost
		
		local health_label = addon.health_label
		local health_bitmap = addon.health_fill
		
		health_label:set_text(string.format("%d",current * 10))
		
		if total then 
			local ratio = current / total
			local w = data.HEALTH_BITMAP_W * data.HEALTH_SCALE
			local h = data.HEALTH_BITMAP_H * data.HEALTH_SCALE
			health_bitmap:set_texture_rect(0,data.HEALTH_BITMAP_W * (1 - ratio),data.HEALTH_BITMAP_W,data.HEALTH_BITMAP_H * ratio)
			health_bitmap:set_size(w,h * ratio)
			health_bitmap:set_position((health_bitmap:parent():w() - health_bitmap:w()) / 2,health_bitmap:parent():h() - health_bitmap:h())
			if ratio <= data.HEALTH_LOW_THRESHOLD then 
				health_bitmap:set_color(Color.red)
				health_ghost:show()
				local r = 3 - (ratio / data.HEALTH_LOW_THRESHOLD)
				health_ghost:set_size(w * r,h * r)
				health_ghost:set_center(health_outline:x() + (health_outline:w() / 2),health_outline:y() + (health_outline:h() / 2))
			else
				health_ghost:hide()
				health_bitmap:set_color(Color.white)
			end
			
		end
	end,
	set_ammo = function(addon,mag,reserves,max_mag)
		addon.ammo_mag_label:set_text(math.min(mag,99))
		addon.ammo_mag_shadow:set_text(math.min(mag,99))
		addon.ammo_reserve_label:set_text(math.min(reserves,99))
		addon.ammo_reserve_shadow:set_text(math.min(reserves,99))
		
		addon.ammo_box_ghost:set_visible(mag / max_mag <= addon.AMMO_LOW_THRESHOLD)
	end
}