return "rocketleagueboost",{
	name = "Rocket League Boost",
	desc = "Boost Meter from Rocket League",
	autodetect_assets = true,
	layer = 765,
	categories = {
		"misc"
	},
	PANEL_W = 440,
	PANEL_H = 440,
	BOOST_LABEL_SHADOW_OFFSET = 4,
	BOOST_LABEL_ANGLE = 2.5,
	boost_1_texture = "guis/textures/mhudu/rocketleague_boost_static",
	boost_2_texture = "guis/textures/mhudu/rocketleague_boost_radial",
	SCALE = 0.5,
	BOOST_1_X = -16,
	BOOST_1_Y = 18,
	BOOST_X = -400,
	BOOST_Y = -400,
	BOOST_ANGLE = 45,
	BOOST_FONT_SIZE = 64,
	BOOST_LABEL_X = -2,
	BOOST_LABEL_Y = 2,
	BOOST_RANGE = 5/8,
	create_func = function(addon,parent_panel)
		local data = addon
		local eurostile_ext = "fonts/font_eurostile_ext"
		local rocketleague_orange = Color("fd6500")
		local SCALE = data.SCALE
		local w = data.PANEL_W * SCALE
		local h = data.PANEL_H * SCALE
		local BOOST_X = data.BOOST_X * SCALE
		local BOOST_Y = data.BOOST_Y * SCALE
		local rocketleague = parent_panel:panel({
			name = "rocketleague",
			layer = 2,
			w = w,
			h = h,
			x = BOOST_X + parent_panel:w() - w,
			y = BOOST_Y + parent_panel:h() - h
		})
		addon.rocketleague_panel = rocketleague
		
		local BOOST_LABEL_SHADOW_OFFSET = data.BOOST_LABEL_SHADOW_OFFSET * SCALE
		
		local BOOST_1_X = data.BOOST_1_X * SCALE
		local BOOST_1_Y = data.BOOST_1_Y * SCALE
		
		local BOOST_FONT_SIZE = data.BOOST_FONT_SIZE * SCALE
		local BOOST_LABEL_X = data.BOOST_LABEL_X * SCALE
		local BOOST_LABEL_Y = data.BOOST_LABEL_Y * SCALE
		
		local boost_radial = rocketleague:bitmap({
			name = "boost_radial",
			layer = 2,
			texture = data.boost_2_texture,
			rotation = data.BOOST_ANGLE,
			w = w,
			h = h,
			x = BOOST_1_X,
			y = BOOST_1_Y,
			render_template = "VertexColorTexturedRadial"
		})
		addon.boost_radial = boost_radial
	--	boost_radial:set_center(rocketleague:w() / 2,rocketleague:h()/2)
		
		local boost_bg = rocketleague:bitmap({
			name = "boost_bg",
			layer = 1,
			texture = data.boost_1_texture,
	--		rotation = data.BOOST_ANGLE,
			w = w,
			h = h
		})
		addon.boost_bg = boost_bg
		
		local boost_label = rocketleague:text({
			name = "boost_label",
			layer = 4,
			text = "100",
			align = "center",
			vertical = "center",
			x = BOOST_LABEL_X,
			y = BOOST_LABEL_Y,
			rotation = data.BOOST_LABEL_ANGLE,
			font = eurostile_ext,
			font_size = BOOST_FONT_SIZE,
			color = Color.white,
			visible = true
		})
		addon.boost_label = boost_label
		local boost_label_shadow = rocketleague:text({
			name = "boost_label_shadow",
			layer = 3,
			text = "100",
			align = "center",
			vertical = "center",
			blend_mode = "add",
			x = BOOST_LABEL_X + BOOST_LABEL_SHADOW_OFFSET,
			y = BOOST_LABEL_Y - BOOST_LABEL_SHADOW_OFFSET,
			rotation = data.BOOST_LABEL_ANGLE,
			font = eurostile_ext,
			font_size = BOOST_FONT_SIZE,
			color = rocketleague_orange,
			visible = true
		})
		addon.boost_label_shadow = boost_label_shadow
		
	end,
	update_func = function(addon)
		local player = managers.player:local_player()
		if alive(player) then 
			local movement = player:movement()
			local current = movement._stamina
			local total = movement:_max_stamina()
			if total then 
				local ratio = current/total
				local text = string.format("%d",ratio * 100)
				addon.boost_label:set_text(text)
				addon.boost_label_shadow:set_text(text)
				
				addon.boost_radial:set_color(Color((3/8) + (ratio * 5/8),0,0))
			end
		end
	end
}