return "spaceengineersmeters",{
	name = "Space Engineers HUD",
	desc = "Survival HUD from Space Engineers",
	autodetect_assets = true,
	layer = -1,
	categories = {
		"misc" --nonfunctional; static image only
	},
	texture = "guis/textures/mhudu/spaceengineershud",
	create_func = function(addon,parent_panel)
		local scale = 0.75
		
		local bitmap = parent_panel:bitmap({
			name = "bitmap",
			layer = 1,
			texture = addon.texture,
			x = 0
		})
		bitmap:set_size(bitmap:w() * scale, bitmap:h() * scale)
		bitmap:set_bottom(parent_panel:bottom() - 16)
		addon.bitmap = bitmap
	end
}
