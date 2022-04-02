return "shiggy",{
	name = "Miyamoto Shigeru",
	desc = "The legendary game designer, Miyamoto Shigeru.",
	autodetect_assets = true,
	layer = 100,
	categories = {
		"misc",
		--misc is the only category that applies, but i don't want this to be the first HUD element a player gets
		--(for comedic value, it's funnier if it comes later on, after a bunch of normal game HUD elements)
		--so adding more random categories (including duplicates) will decrease the likelihood of it appearing, assuming that the options is enabled
		"misc",
		"misc",
		"misc",
		"misc",
		"misc",
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
		portrait:set_bottom(parent_panel:h() + 56)
	end
}