return "terrariahotbar",{
	name = "Terraria Hotbar",
	desc = "Item Hotbar from Terraria",
	autodetect_assets = true,
	layer = -1,
	categories = {
		"misc" --nonfunctional; static image only
	},
	texture = "guis/textures/mhudu/terraria_hotbar",
	create_func = function(addon,parent_panel)
		local bitmap = parent_panel:bitmap({
			name = "bitmap",
			layer = 1,
			texture = addon.texture,
			x = 400,
			y = 10
		})
		addon.bitmap = bitmap
	end
}
