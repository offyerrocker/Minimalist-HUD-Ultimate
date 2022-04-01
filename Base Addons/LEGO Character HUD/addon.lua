return "legostarwars_characters",{
	name = "LEGO Characters",
	desc = "LEGO video game franchise style character portraits",
	autodetect_assets = true,
	layer = 1,
	categories = {
		"misc"
	},
	portrait_size = 96,
	portrait_x = 128,
	portrait_y = 128,
	atlas_texture = "guis/textures/mhudu/lego_characters_atlas",
	create_func = function(addon,parent_panel)
		local size = addon.portrait_size
		local character_icon = parent_panel:bitmap({
			name = "character_icon",
			layer = 1,
			texture = addon.atlas_texture,
			texture_rect = {size * (math.random(8) - 1),size * (math.random(2) - 1),size,size},
			w = size,
			h = size,
			x = addon.portrait_x,
			y = addon.portrait_y
		})
	end
}