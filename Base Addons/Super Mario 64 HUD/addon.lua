return "mario64",{
	name = "Super Mario 64 HUD",
	desc = "Lives, coins, and stars indicator from Super Mario 64.",
	autodetect_assets = true,
	layer = 1,
	categories = {
		"revives",
		"payout",
		"secured_bags"
	},
	atlas_texture = "guis/textures/mhudu/mario64_atlas",
	fake_font_data = {
		name = "mario64_font",
		version = 1,
		font_size = 64,
		atlas = "guis/textures/mhudu/mario64_atlas",
		tracking = 0,
		leading = 64,
		start = {0,0},
		characters = {
			["1"] = {
				0*64,0*64,
				64,64
			},
			["2"] = {
				1*64,0*64,
				64,64
			},
			["3"] = {
				2*64,0*64,
				64,64
			},
			["4"] = {
				3*64,0*64,
				64,64
			},
			["5"] = {
				4*64,0*64,
				64,64
			},
			["6"] = {
				5*64,0*64,
				64,64
			},
			["7"] = {
				6*64,0*64,
				64,64
			},
			["8"] = {
				7*64,0*64,
				64,64
			},
			["9"] = {
				8*64,0*64,
				64,64
			},
			["0"] = {
				9*64,0*64,
				64,64
			},
			["A"] = {
				0,1*64,
				64,64
			},
			["B"] = {
				1*64,1*64,
				64,64
			},
			["C"] = {
				2*64,1*64,
				64,64
			},
			["D"] = {
				3*64,1*64,
				64,64
			},
			["E"] = {
				4*64,1*64,
				64,64
			},
			["F"] = {
				5*64,1*64,
				64,64
			},
			["G"] = {
				6*64,1*64,
				64,64
			},
			["H"] = {
				7*64,1*64,
				64,64
			},
			["I"] = {
				8*64,1*64,
				64,64
			},
			["J"] = {
				9*64,1*64,
				64,64
			},
			["K"] = {
				0,2*64,
				64,64
			},
			["L"] = {
				1*64,2*64,
				64,64
			},
			["M"] = {
				2*64,2*64,
				64,64
			},
			["N"] = {
				3*64,2*64,
				64,64
			},
			["O"] = {
				4*64,2*64,
				64,64
			},
			["P"] = {
				5*64,2*64,
				64,64
			},
			["Q"] = {
				6*64,2*64,
				64,64
			},
			["R"] = {
				7*64,2*64,
				64,64
			},
			["S"] = {
				8*64,2*64,
				64,64
			},
			["T"] = {
				9*64,2*64,
				64,64
			},
			["U"] = {
				0,3*64,
				64,64
			},
			["V"] = {
				1*64,3*64,
				64,64
			},
			["W"] = {
				2*64,3*64,
				64,64
			},
			["X"] = {
				3*64,3*64,
				64,64
			},
			["Y"] = {
				4*64,3*64,
				64,64
			},
			["Z"] = {
				5*64,3*64,
				64,64
			},
			[" "] = {
				6*64,3*64,
				64,64
			},
			["?"] = {
				7*64,3*64,
				64,64
			},
			["'"] = {
				8*64,3*64,
				64,64
			},
			['"'] = {
				9*64,3*64,
				64,64
			},
			["!"] = { --mario
				0*64,4*64,
				64,64
			},
			["@"] = { --coin
				1*64,4*64,
				64,64
			},
			["#"] = { --star
				2*64,4*64,
				64,64
			},
			["$"] = { --camera
				3*64,4*64,
				64,64
			},
			["%"] = { --lakitu
				4*64,4*64,
				64,64
			},
			["^"] = { --red x
				5*64,4*64,
				64,64
			},
			["&"] = { --up/down arrows
				6*64,4*64,
				64,64
			},
			["*"] = { --"x" used in hud counters such as lives/coins
				7*64,4*64,
				64,64
			}
		}
	},
	create_func = function(addon,parent_panel)
		addon.font = FakeFont:new(addon.fake_font_data)
		local lives_counter = FakeText:new(parent_panel,{
			name = "lives_counter",
			text = "!*4",
			font = "mario64_font",
			align = "left",
			x = 200,
			y = 60
		})
		addon.lives_counter = lives_counter
		
		local coins_counter = FakeText:new(parent_panel,{
			name = "coins_counter",
			text = "@*0",
			font = "mario64_font",
			align = "left",
			x = 500,
			y = 60
		})
		addon.coins_counter = coins_counter
		
		local stars_counter = FakeText:new(parent_panel,{
			name = "coins_counter",
			text = "#*0",
			font = "mario64_font",
			align = "left",
			x = 800,
			y = 60
		})
		addon.stars_counter = stars_counter
	end,
	register_func = function(addon)
		
		Hooks:PostHook(LootManager,"sync_secure_loot","mhudu_mariohud_onsecureloot",function(self,carry_id,multiplier_level,silent,peer_id)
			local num_secured = managers.loot:get_secured_mandatory_bags_amount()
			local optional_secured = managers.loot:get_secured_bonus_bags_amount()
			
			addon.coins_counter:set_text("@*" .. tostring(optional_secured or 0))
			addon.stars_counter:set_text("#*" .. tostring(num_secured or 0))
		end)
		
		MHUDU:AddListener("set_criminal_health","mhudu_mariohud_criminalhealthchanged",{
			callback = function(i,data,...)
				if i == HUDManager.PLAYER_PANEL and data.revives then 
					addon.lives_counter:set_text("!*" .. data.revives)
				end
			end
		})
		Hooks:RemovePostHook("mhudu_mariohud_onsecureloot")
	end
}