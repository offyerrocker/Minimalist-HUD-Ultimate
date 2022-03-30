PersonaFakeFont = PersonaFakeFont or class(FakeText)

function PersonaFakeFont:init(parent_panel,attributes,...)
	self.fonts_list = attributes.fonts or {}
	return FakeText.init(self,parent_panel,attributes,...)
end

function PersonaFakeFont:set_text(text)
	
	self:set_empty()
	self.text_string = text
	local panel = self.panel
	if not alive(panel) then 
		return
	end
	local attributes = self.attributes
	local font_size = attributes.font_size
	local tracking = attributes.tracking or 0
	local leading = attributes.leading or font_size
	
	local align = attributes.align or "left"
	
	local line_num = 1
	if align ~= "center" then 
		local x,y
		local it_i
		local it_m
		local it_d
		local it_sign
		if align == "right" then 
			x = panel:w()
			y = 0
			it_i = utf8.len(text)
			it_m = 1
			it_d = -1
			it_sign = -1
		else
			x = 0
			y = 0
			it_i = 1
			it_m = utf8.len(text)
			it_d = 1
			
			it_sign = 1
		end
		
		for i=it_i,it_m,it_d do
			local char_raw = string.sub(text,i,i)
			local char_name = char_raw
			
			local r_fontsize = 32
			local angle_range = 15
			local r_sign = math.sign(math.random() - 0.5)
			local r_color_1
			local r_color_2
			local inv_roll = math.random()
			local is_inverted = inv_roll < 0.25
			if is_inverted then 
				r_color_1 = Color.black
				r_color_2 = Color.white
			else 
				r_color_1 = Color.white
				r_color_2 = Color.black
			end
			local is_block = true --inv_roll < 0.3
			local r_font_name = table.random_key(self.fonts_list)
			local r_font = self.fonts_list[r_font_name]
			local r_rotation = math.pow(math.random(),3) * angle_range * r_sign
			
			local char_frame = panel:panel({
				name = "char_frame_" .. tostring(i),
				w = font_size,
				h = font_size,
				x = x,
				y = y,
				layer = i
			})
			local debug_rect = char_frame:rect({
				name = "debug_rect",
				alpha = 0.15,
				color = Color(math.random(),math.random(),math.random())
			})
			local new_character = char_frame:text({
				name = "char_" .. tostring(i),
				text = char_name,
--				align = "center",
--				vertical = "center",
				x = 0,
				y = 0,
--				x = x,
--				y = y,
				font = r_font,
--				rotation = r_rotation,
				color = r_color_1,
				layer = i
			})
			local _x,_y,_w,_h = new_character:text_rect()
--[[
			Log("---")
			logall({
			text=char_name,
			color=r_color_1,
			is_block=is_block,
			is_inverted=is_inverted,
			rotation = r_rotation,
			_x,_y,_w,_h
			})
			Log("---")
--]]
			new_character:set_rotation(r_rotation)
--			new_character:set_world_center(x,y)
			local block_bg
			if is_block then 
				block_bg = char_frame:bitmap({
					name = "block_" .. tostring(i),
					color = r_color_2,
--					x = x,
--					y = y,
					w = _w + 6,
					h = _h + 6,
					rotation = r_rotation,
					alpha = 0.25,
					layer = i - 0.5
				})
				block_bg:set_world_center(char_frame:world_center())
			end
			table.insert(self.characters,#self.characters + 1,{gui_object = new_character,character = char_name})
			
			x = x + ((_w + tracking) * it_sign)
		end
	end
end





return "persona",{
	name = "Persona HUD",
	desc = "I'm not joking around.",
	autodetect_assets = true,
	layer = 1,
	categories = {
		"misc"
	},
	fonts = {
		coolsville = "fonts/coolsville_32",
		futura = "fonts/futura",
		italianate = "fonts/italianate_32",
		roland = "fonts/roland_32",
		times = "fonts/tnr_32",
		monofonto = "fonts/monofonto", --requires fallout VATS (included in MHUDU)
		bsch = "fonts/font_medium" --bahnschrift (included in pd2)
	},
	create_func = function(addon,parent_panel)
		local test_rect = parent_panel:rect({
			name = "test_rect",
			color = Color.red,
			alpha = 0.75,
			w = 300,
			h = 300,
			x = 600,
			y = 500
		})
		addon.test_rect = test_rect
		
		local ptext = PersonaFakeFont:new(parent_panel,
			{
				font_size = 32,
				fonts = addon.fonts,
				text="Whomst'ven't",
				x = 100,
				y = 100
			}
		)
		addon.ptext = ptext
	end,
	register_func = function(addon)
	end,
	destroy_func = function(addon)
	end,
	update_func = function(addon,t,dt)
	end
}