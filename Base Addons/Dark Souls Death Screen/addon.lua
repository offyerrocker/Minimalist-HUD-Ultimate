return "darksoulsdeath",{
	name = "Dark Souls HUD",
	desc = "Adds the most important HUD element from Dark Souls.",
	autodetect_assets = true,
	layer = 1000,
	categories = {
		"misc"
	},
	create_func = function(addon,parent_panel)
		local panel = parent_panel:panel({
			name = "panel",
			visible = false
		})
		addon.panel = panel
		
		local gradient = panel:gradient({
			name = "gradient",
			alpha = 1,
			h = 100,
			orientation = "vertical",
			gradient_points = {
				0,
				Color.black:with_alpha(0),
				0.25,
				Color.black,
				0.75,
				Color.black,
				1,
				Color.black:with_alpha(0)
			},
			valign = "center",
			layer = 99
		})
		addon.gradient = gradient
		gradient:set_center_y(panel:center_y())
		local text = panel:text({
			name = "text",
			text = "YOU DIED",
			font = "fonts/tnr_32",
			align = "center",
			vertical = "center",
			font_size = 32,
			color = Color(152/255,0,0),
			layer = 100
		})
		addon.text = text
	end,
	animate_death = function(addon)
		local panel = addon.panel
		local text = addon.text
		local gradient = addon.gradient
		gradient:set_alpha(0)
		gradient:set_gradient_points({
			0,
			Color.black:with_alpha(0),
			0.25,
			Color.black,
			0.75,
			Color.black,
			1,
			Color.black:with_alpha(0)
		})
		gradient:set_h(100)
		gradient:set_center_y(panel:center_y())
		text:set_font_scale(1)
		text:set_alpha(0)
		
		if math.random() < 0.1 then 
			text:set_text("SKILL ISSUE")
		else
			text:set_text("YOU DIED")
		end
		local from_h = 100
		local to_h = 200
		local from_scale = 1
		to_scale = 2
		
		panel:show()
		text:stop()
		gradient:stop()
		
		local fadein_duration = 1.5
		local animate_duration = 7
		local hold_duration = 3
		local fadeout_duration = 1.5
		
		local fadeout = function(o,from_alpha)
			wait(fadein_duration + hold_duration)
			over(fadeout_duration,function(progress)
				local p_sq = progress * progress
				o:set_alpha(from_alpha-(p_sq * from_alpha))
			end)
			o:set_alpha(0)
		end
		local fadein = function(o,to_alpha)
			over(fadein_duration,function(progress)
				local p_sq = progress * progress
				o:set_alpha(p_sq * to_alpha)
			end)
			o:set_alpha(to_alpha)
		end
		
		gradient:animate(fadein,0.7)
		text:animate(fadein,0.9)
		gradient:animate(fadeout,0.7)
		text:animate(fadeout,0.9)
		
		--[[
		gradient:animate(function(o)
			local trns = Color.black:with_alpha(0)
			local opaq = Color.black:with_alpha(1)
			over(animate_duration * 2,function(progress)
				local p_sq = progress * progress
				o:set_gradient_points({
					0,
					trns,

					p_sq/2,
					opaq,
					
					1-(p_sq/2),
					opaq,

					1,
					trns
				})
			end)
		end)
		--]]
		
		text:animate(function(o)
			over(animate_duration,function(progress)
				local p_sq = progress * progress
				o:set_font_scale(from_scale + ((to_scale - from_scale) * p_sq))
				o:set_center_y(panel:center_y())
			end)
			o:set_font_scale(to_scale)
--			panel:hide()
		end)
		
		--[[
		MHUDU:animate(gradient,function(o,t,dt,start_t,duration,from_h,to_h)
			gradient:set_h(
		end,nil,animate_duration,gradient:h(),200)
		MHUDU:animate(text,function(o,t,dt,start_t,duration)
			
			o:set_font_scale(o:font_scale() + (dt * 2))
		end,nil,animate_duration)
		--]]
		
		
	end,
	register_func = function(addon)
		managers.chat:_receive_message(1,"[SYSTEM]","Being summoned to another world as a dark spirit...",Color("990000"))
		
		Hooks:PostHook(PlayerDamage,"on_downed","mhudu_darksouls_ondowned",function(self)
			addon.animate_death(addon)
		end)
		
	end,
	destroy_func = function(addon)
		Hooks:RemovePostHook("mhudu_darksouls_ondowned")
	end
}