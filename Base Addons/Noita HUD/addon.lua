return "noitahud",{
	name = "Noita HUD",
	desc = "Wands HUD from Noita",
	autodetect_assets = true,
	layer = -10,
	categories = {
		"misc" --nonfunctional; static image only
	},
	texture = "guis/textures/mhudu/noita_hud",
	create_func = function(addon,parent_panel)
		local scale = 0.75
		
		local bitmap = parent_panel:bitmap({
			name = "bitmap",
			layer = 1,
			texture = addon.texture,
			x = 0
		})
		bitmap:set_size(bitmap:w() * scale, bitmap:h() * scale)
		addon.bitmap = bitmap
	end
}
