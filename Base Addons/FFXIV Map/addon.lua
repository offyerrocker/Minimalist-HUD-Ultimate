return "ffxiv_limsa",{
	name = "FFXIV Map",
	desc = "Map of Limsa Lominsa",
	autodetect_assets = true,
	layer = -5,
	categories = {
		"misc" --nonfunctional; static image only
	},
	texture = "guis/textures/mhudu/limsa_map",
	create_func = function(addon,parent_panel)
		local scale = 0.75
		
		local bitmap = parent_panel:bitmap({
			name = "bitmap",
			layer = 1,
			y = 120,
			alpha = 0.66,
			texture = addon.texture
		})
		bitmap:set_size(bitmap:w() * scale, bitmap:h() * scale)
		bitmap:set_right(parent_panel:w())
		addon.bitmap = bitmap
	end
}
