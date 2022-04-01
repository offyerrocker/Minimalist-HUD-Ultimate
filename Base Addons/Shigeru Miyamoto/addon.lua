return "shiggy",{
	name = "Miyamoto Shigeru",
	desc = "The legendary game designer, Miyamoto Shigeru.",
	autodetect_assets = true,
	layer = 100,
	categories = {
		"misc"
	},
	atlas_texture = "guis/textures/mhudu/shiggy",
	create_func = function(addon,parent_panel)
		local portrait = parent_panel:bitmap({
			name = "portrait",
			layer = 1,
			texture = addon.atlas_texture,
			rotation = -30,
			x = 100
		})
		portrait:set_bottom(parent_panel:h() + 40)
	end
}