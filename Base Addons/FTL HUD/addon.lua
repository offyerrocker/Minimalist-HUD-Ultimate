return "ftlhud",{
	name = "FTL HUD",
	desc = "Shows FTL-styled crewmember health",
	autodetect_assets = true,
	layer = 60,
	categories = {
		"team_health"
	},
	health_threshold_low = 2/3,
	health_threshold_empty = 0.25,
	name_max_len = 7,
	races = {
		human = {
			row = 1,
			variations = 6
		},
		zoltan = {
			row = 2,
			variations = 5
		},
		engi = {
			row = 3,
			variations = 1
		},
		rock = {
			row = 4,
			variations = 3
		},
		mantis = {
			row = 5,
			variations = 5
		},
		crystal = {
			row = 6,
			variations = 4
		},
		lanius = {
			row = 7,
			variations = 4
		}
	},
	crew_icon_size = 56, --rect only
	atlas_name = "guis/textures/mhudu/ftl_race_atlas",
	crew_plate_texture = "guis/textures/mhudu/ftl_crew_plate",
	get_rect = function(addon,race)
		local icon_size = addon.crew_icon_size
		local variations
		if not (race and addon.races[tostring(race)]) then
			race = table.random_key(addon.races)
		end
		if race then 
			local race_data = addon.races[tostring(race)]
			variations = variations or race_data.variations
			
			local column = 1
			if variations > 1 then 
				column = math.random(variations)
			end
			return {(column - 1) * icon_size,(race_data.row - 1) * icon_size,icon_size,icon_size}
		end
		return {0,0,icon_size,icon_size}
	end,
	font_size = 6,
	scale = 1.5,
	hud_x = 108,
	hud_y = 200,
	teammate_w = 60,
	teammate_h = 20,
	health_x = -5,
	health_y = -5,
	health_w = 30,
	health_h = 3,
	teammate_margin_v = 3,
	icon_x = 4,
	icon_y = 2,
	icon_size = 16,
	name_x = 25,
	name_y = 4,
	ftl_bar_full = Color.green,
	ftl_bar_low = Color.yellow,
	ftl_bar_empty = Color.red,
	create_func = function(addon,parent_panel)
		local ftl_panel = parent_panel:panel({
			name = "ftl_panel",
			layer = 3,
			x = addon.hud_x,
			y = addon.hud_y
		})
		addon.ftl_panel = ftl_panel
		
		--in this case, these should be added asap such that teammate hud elements are ready to go whenever the addon is actually activated and shown
		MHUDU:AddListener("add_teammate_panel","mhudu_ftlhud_addteammate",{callback=callback(addon,addon,"add_teammate")})
		MHUDU:AddListener("remove_teammate_panel","mhudu_ftlhud_removeteammate",{callback=callback(addon,addon,"remove_teammate")})
		MHUDU:AddListener("set_criminal_name","mhudu_ftlhud_setteammatename",{callback=callback(addon,addon,"set_teammate_name")})
		MHUDU:AddListener("set_criminal_health","mhudu_ftlhud_setteammatehealth",{callback=callback(addon,addon,"set_teammate_health")})
	end,
	destroy_func = function(addon)
		MHUDU:RemoveListener("add_teammate_panel","mhudu_ftlhud_addteammate")
		MHUDU:RemoveListener("remove_teammate_panel","mhudu_ftlhud_removeteammate")
		MHUDU:RemoveListener("set_criminal_name","mhudu_ftlhud_setteammatename")
		MHUDU:RemoveListener("set_criminal_health","mhudu_ftlhud_setteammatehealth")
	end,
	set_teammate_health = function(addon,i,data)
		local ftl_panel = addon.ftl_panel
		local ftl_bar_full = addon.ftl_bar_full
		local ftl_bar_low = addon.ftl_bar_low
		local ftl_bar_empty = addon.ftl_bar_empty
		local current = data.current
		local total = data.total
		if i and current and total and ftl_panel and alive(ftl_panel) then 
			local teammate = ftl_panel:child("teammate_" .. tostring(i))
			if teammate and alive(teammate) then 
	--			teammate:show()
				local ratio = current/total
				local hp_bar = teammate:child("health_bar")
				hp_bar:set_w(addon.health_w * addon.scale * ratio)
				if ratio <= addon.health_threshold_empty then 
					hp_bar:set_color(ftl_bar_empty)
				elseif ratio <= addon.health_threshold_low then 
					hp_bar:set_color(ftl_bar_low)
				else
					hp_bar:set_color(ftl_bar_full)
				end
			end
		end
	end,
	set_teammate_name = function(addon,i,raw_name)
		local ftl_panel = addon.ftl_panel
		if i and raw_name and ftl_panel and alive(ftl_panel) then 
			local teammate = ftl_panel:child("teammate_" .. tostring(i))
			if teammate and alive(teammate) then 
				local name = raw_name
				if string.len(raw_name) > addon.name_max_len then
					name = string.sub(raw_name,1,addon.name_max_len) .. "."
				end
				teammate:child("name"):set_text(name)
			end
		end
	end,
	add_teammate = function(addon,i)
		local ftl_panel = addon.ftl_panel
		local ftl_font = "fonts/coderscrux"
		if i and ftl_panel and alive(ftl_panel) then 
			local result = ftl_panel:child("teammate_" .. tostring(i))
			if result and alive(result) then 
				result:show()
				return result
			end
		else
			return
		end
		
		local scale = addon.scale
		local health_w = addon.health_w * scale
		local health_h = addon.health_h * scale
		local health_x = addon.health_x * scale
		local health_y = addon.health_y * scale
		
		local icon_size = addon.icon_size * scale
		local icon_x = addon.icon_x * scale
		local icon_y = addon.icon_y * scale
		
		local teammate_w = addon.teammate_w * scale
		local teammate_h = addon.teammate_h * scale
		
		local teammate_margin_v = addon.teammate_margin_v * scale
		
		local name_x = addon.name_x * scale
		local name_y = addon.name_y * scale
		local font_size = addon.font_size * scale
		
		local teammate_panel = ftl_panel:panel({
			name = "teammate_" .. tostring(i),
			layer = 3,
			w = teammate_w,
			h = teammate_h,
			y = (i - 1) * (teammate_h + teammate_margin_v)
		})
		local nameplate = teammate_panel:bitmap({
			name = "nameplate",
			layer = 1,
			texture = addon.crew_plate_texture,
			w = teammate_w,
			h = teammate_h
		})
		
		--ftl race icon;
	--races are selected randomly from variants but distributed evenly among races
	--the chance of getting a human is the same as getting an engi,
	--even though there are 6 human variants and 1 engi variant
		local icon = teammate_panel:bitmap({
			name = "icon",
			layer = 2,
			texture = addon.atlas_name,
			texture_rect = addon.get_rect(addon),
			w = icon_size,
			h = icon_size,
			x = icon_x,
			y = icon_y
		})
		
		local name = teammate_panel:text({
			name = "name",
			layer = 4,
			text = "Bomfy M.",
			x = name_x,
			y = name_y,
			font = ftl_font,
			font_size = font_size,
			color = Color.white,
			visible = true
		})
		
		local health_bar = teammate_panel:rect({
			name = "health_bar",
			layer = 3,
			w = health_w,
			h = health_h,
			x = health_x + (teammate_panel:w() - health_w),
			y = health_y + (teammate_panel:h() - health_h),
			color = Color.green
		})
		
		local debug_ = teammate_panel:rect({
			name = "debug",
			color = Color(i/4,4/i,(i-4)/4),
			alpha = 0.5,
			visible = false
		})
	end,
	remove_teammate = function(addon,i)
		local ftl_panel = addon.ftl_panel
		if i and ftl_panel and alive(ftl_panel) then 
			local panel = ftl_panel:child("teammate_" .. tostring(i))
			if panel and alive(panel) then 
				ftl_panel:remove(panel)
				return true
			end
		end
		return false
	end
}