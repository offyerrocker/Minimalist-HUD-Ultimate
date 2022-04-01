return "subnauticahud",{
	name = "Subnautica HUD",
	desc = "Survival HUD from Subnautica",
	autodetect_assets = true,
	layer = -2,
	categories = {
		"misc" --nonfunctional; static image only
	},
	texture = "guis/textures/mhudu/subnauticahud",
	create_func = function(addon,parent_panel)
		local scale = 0.75
		
		local bitmap = parent_panel:bitmap({
			name = "bitmap",
			layer = 1,
			texture = addon.texture,
			x = 150,
			y = 400
		})
		bitmap:set_size(bitmap:w() * scale, bitmap:h() * scale)
		addon.bitmap = bitmap
	end
}
