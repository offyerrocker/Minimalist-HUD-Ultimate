--simple/naive implementation of fonts given a texture atlas and list of glyph coordinates
--doesn't support most GuiText methods but i needed it for the weird dynamic style of persona

FakeFont = FakeFont or class()
FakeFont.fonts = {}
function FakeFont:init(data,name)
	if data.version == 1 then 
		self.setup_data = data
		local new_data = FakeFont.generate_data_v1(data)
		self.data = new_data
		name = name or data.name
		if name then 
			FakeFont.fonts[data.name] = new_data
		end
	end
end

function FakeFont.generate_data_v1(data)
	local rect_x = data.start[1]
	local rect_y = data.start[2]
	local new_data = {
		glyphs = (data.glyphs and table.deep_map_copy(data.glyphs)) or {},
		atlas = data.atlas,
		font_size = data.font_size,
		tracking = data.tracking,
		leading = data.leading,
		special_char_lookup = data.special_char_lookup or {}
	}
	local max_glyph_size = 0
	for char_name,char_data in pairs(data.characters) do 
		local x = rect_x + char_data[1]
		local y = rect_y + char_data[2]
		local w = char_data[3]
		local h = char_data[4]
		max_glyph_size = math.max(h,max_glyph_size)
		new_data.glyphs[char_name] = {
			w = w,
			h = h,
			kern = char_data.kern,
			rect = {
				x,y,w,h
			}
		}
	end
	if data.character_copies then 
		for new_char,copied_char in pairs(data.character_copies) do 
			new_data.glyphs[new_char] = new_data.glyphs[copied_char]
		end
	end
	new_data.max_glyph_size = max_glyph_size
	return new_data
end

FakeText = FakeText or class()
function FakeText:init(parent_panel,attributes)
	attributes = attributes or {}
	local fake_font
	local font = attributes.font
	local text = attributes.text
	if type(font) == "table" then 
		fake_font = font
	else
		fake_font = FakeFont.fonts[font]
	end
	self.attributes = attributes
	self.characters = {}
	local panel_name = ""
	if attributes.name then 
		panel_name = attributes.name
	end
	
	local panel = parent_panel:panel({
		name = panel_name,
		layer = attributes.layer,
		x = attributes.x,
		y = attributes.y,
		w = attributes.w,
		h = attributes.h
	})
	self.panel = panel
	self.fake_font = fake_font
	
	if text then 
		self:set_text(text)
	end
end

function FakeText:set_empty()
	for k,v in pairs(self.characters) do 
		self.characters[k] = nil
	end
	local panel = self.panel
	if alive(panel) then 
		for _,child in pairs(panel:children()) do 
			if alive(child) then 
				panel:remove(child)
			end
		end
	end
end

function FakeText:set_font(fake_font_name)
	if FakeFont.fonts[fake_font_name] then 
		self:_set_font(FakeFont.fonts[fake_font_name])
	end
end

function FakeText:_set_font(fake_font_data)
	self.fake_font = fake_font_data
	self:set_text(self.text_string)
end

function FakeText:set_text(text)
	self:set_empty()
	self.text_string = text
	local panel = self.panel
	if not alive(panel) then 
		return
	end
	local attributes = self.attributes
	local fake_font_data = self.fake_font
	local glyphs = fake_font_data.glyphs
	local tracking = attributes.tracking or fake_font_data.tracking
	local leading = attributes.leading or fake_font_data.leading
	
	local align = attributes.align or "left"
	
	local font_scale = attributes.font_scale or 1
--	local desired_font_size = attributes.font_size
--	local font_scale = fake_font_data.max_glyph_size * desired_font_size
	local font_size = fake_font_data.font_size * font_scale --todo get from attributes
	
--	local total_w = 0
	local line_num = 1
	
	if align ~= "center" then 
		local x
		local it_i
		local it_m
		local it_d
		local it_sign
		if align == "right" then 
			x = panel:w()
			it_i = utf8.len(text)
			it_m = 1
			it_d = -1
			
			it_sign = -1
		else
			x = 0
			it_i = 1
			it_m = utf8.len(text)
			it_d = 1
			
			it_sign = 1
		end
		for i=it_i,it_m,it_d do
			local char_raw = string.sub(text,i,i)
			local char_name = fake_font_data.special_char_lookup[char_raw] or char_raw
			local glyph_data = glyphs[char_name]
			if glyph_data then 
				
				local w = glyph_data.w
				local h = glyph_data.h
				local kern = glyph_data.kern or 0
				local new_character
				
				if char_name == " " then 
	--				w = 0
					kern = 0
				else
					new_character = panel:bitmap({
						name = char_name .. "_" .. i,
						texture = fake_font_data.atlas,
						texture_rect = glyph_data.rect,
						x = x,
						--w = w,
						--h = h,
						y = 0
					})
					if align == "right" then 
						new_character:set_right(x)
					end
					new_character:set_bottom(line_num * leading)
					
				end
				table.insert(self.characters,#self.characters + 1,{gui_object = new_character, character = char_name})
				

				x = x + ((kern + w + tracking) * it_sign)
			end
		end
	else
	end
end

function FakeText:set_align(align)
	self.attributes.align = align
	self:set_text(self.text_string)
end

function FakeText:set_font_size(font_size)
	self.attributes.font_size = font_size
	self:set_text(self.text_string)
end

function FakeText:set_leading(leading)
	self.attributes.leading = leading
	self:set_text(self.text_string)
end

function FakeText:set_tracking(tracking)
	self.attributes.tracking = tracking
	self:set_text(self.text_string)
end

function FakeText:set_w(w)
	return self.panel:set_w(w)
end

function FakeText:width()
	return self.panel:width()
end

function FakeText:set_width(w)
	return self.panel:set_width(w)
end

function FakeText:set_h(h)
	return self.panel:set_h(h)
end

function FakeText:height()
	return self.panel:height()
end

function FakeText:h()
	return self.panel:h()
end

function FakeText:set_height(h)
	return self.panel:set_height(h)
end

function FakeText:set_x(x)
	return self.panel:set_x(x)
end

function FakeText:x()
	return self.panel:x()
end

function FakeText:set_y(y)
	return self.panel:set_y(y)
end

function FakeText:y()
	return self.panel:y()
end

function FakeText:set_range_color(r1,r2,c)
	for i=r1,r2,math.sign(r2-r1) do 
		local char_data = self.characters[i]
		
		if char_data and alive(char_data.gui_object) then 
			char_data.gui_object:set_color(c)
		end
		
	end
end


--[[
(some) methods that need to be cloned: 

[set_world_shape] : [function: 0x562baad8]
[set_leftbottom] : [function: 0x562b9fe0]
[set_right] : [function: 0x562b88e8]
[button_release] : [function: 0x562b8f78]
[tostring] : [function: 0x562ba160]
[axis_move] : [function: 0x562ba6e8]
[set_world_lefttop] : [function: 0x562bacb8]
[after] : [function: 0x562b85a0]
[set_rotation] : [function: 0x562b8ab0]
[set_kern] : [function: 0x562b9b18]
[animate] : [function: 0x562bb900]
[world_position] : [function: 0x562bbd50]
[mouse_move] : [function: 0x562b9f08]
[rightbottom] : [function: 0x562ba748]
[set_world_left] : [function: 0x562bb960]
[top] : [function: 0x562b8b88]
[set_width] : [function: 0x562ba0e8]
[__index] : [table: 0x31e83800]
[size] : [function: 0x562bb9f0]
[set_blend_mode] : [function: 0x562ba7a8]
[halign] : [function: 0x562ba880]
[set_word_wrap] : [function: 0x562ba2e0]
[line_height] : [function: 0x562ba190]
[set_world_center_x] : [function: 0x562ba370]
[__properties] : [table: 0x31e83880]
[mouse_press] : [function: 0x562b9188]
[key_release] : [function: 0x562baa00]
[center_x] : [function: 0x562b8ff0]
[set_world_leftbottom] : [function: 0x562b8fd8]
[valign] : [function: 0x562bb480]
[font_scale] : [function: 0x562b8900]
[set_center] : [function: 0x562b8de0]
[set_righttop] : [function: 0x562bb4f8]
[set_font] : [function: 0x562bb4c8]
[left] : [function: 0x562b9fc8]
[type_id] : [userdata: 0x2b1b4ef0]
[number_of_lines] : [function: 0x562b89c0]
[set_center_y] : [function: 0x562badd8]
[button_press] : [function: 0x562b98f0]
[__property_writers] : [table: 0x31e838e0]
[leftbottom] : [function: 0x562bbf00]
[set_shape] : [function: 0x562b8288]
[world_left] : [function: 0x562ba5f8]
[mouse_exit] : [function: 0x562baf70]
[stop] : [function: 0x562bacd0]
[set_color] : [function: 0x562b9aa0]
[world_x] : [function: 0x562bae80]
[inside] : [function: 0x562bb120]
[alpha] : [function: 0x562b9ec0]
[key_click] : [function: 0x562bb288]
[set_selection] : [function: 0x562bb228]
[render_template] : [function: 0x562bb1e0]
[world_center] : [function: 0x562bb060]
[mouse_click] : [function: 0x562ba2b0]
[line_breaks] : [function: 0x562b86f0]
[set_text] : [function: 0x562bbf90]
[__tostring] : [function: 0x562b8390]
[set_height] : [function: 0x562b95d8]
[set_bottom] : [function: 0x562b9470]
[set_position] : [function: 0x562bb6d8]
[center_y] : [function: 0x562b9db8]
[script_reference] : [true]
[set_text_id] : [function: 0x562ba220]
[set_direction] : [function: 0x562ba910]
[bottom] : [function: 0x562bb420]
[set_extension] : [function: 0x562bb438]
[type_name] : [Text]
[clear_range_color] : [function: 0x562bb5b8]
[set_world_x] : [function: 0x562b9818]
[set_align] : [function: 0x562bb7f8]
[world_right] : [function: 0x562bb5e8]
[__eq] : [function: 0x562bbb28]
[mouse_enter] : [function: 0x562b82e8]
[set_world_righttop] : [function: 0x562bb9a8]
[set_world_y] : [function: 0x562bb2b8]
[text_rect] : [function: 0x562b9e90]
[__gc] : [function: 0x562b9908]
[rotation] : [function: 0x562b99b0]
[parent] : [function: 0x562b8e10]
[character_rect] : [function: 0x562b80a8]
[point_to_index] : [function: 0x562b8630]
[set_visible] : [function: 0x562b8480]
[selection] : [function: 0x562bb1f8]
[set_selection_color] : [function: 0x562b8ac8]
[selected_text] : [function: 0x562bbdc8]
[set_top] : [function: 0x562b8e40]
[set_center_x] : [function: 0x562ba268]
[show] : [function: 0x562b8a68]
[hide] : [function: 0x562ba688]
[selection_color] : [function: 0x562ba7f0]
[mouse_release] : [function: 0x562bb300]
[world_leftbottom] : [function: 0x562b8150]
[direction] : [function: 0x562b8d08]
[set_vertical] : [function: 0x562b88b8]
[set_wrap_mode] : [function: 0x562bb318]
[visible] : [function: 0x562bbab0]
[vertical] : [function: 0x562bbf78]
[key] : [function: 0x562baef8]
[text] : [function: 0x562bb570]
[move] : [function: 0x562b96f8]
[set_alpha] : [function: 0x562b9878]
[set_valign] : [function: 0x562b9230]
[word_wrap] : [function: 0x562b8708]
[set_world_rightbottom] : [function: 0x562bb5d0]
[set_wrap] : [function: 0x562bbd38]
[outside] : [function: 0x562ba7c0]
[wrap] : [function: 0x562babe0]
[world_bottom] : [function: 0x562bb918]
[kern] : [function: 0x562b9800]
[shape] : [function: 0x562b91b8]
[set_monospace] : [function: 0x562b8090]
[monospace] : [function: 0x562bbaf8]
[set_font_size] : [function: 0x562bbc60]
[font] : [function: 0x562b87f8]
[w] : [function: 0x562b8ea0]
[set_rightbottom] : [function: 0x562bb180]
[righttop] : [function: 0x562bbd08]
[set_font_scale] : [function: 0x562b9980]
[font_size] : [function: 0x562baa90]
[script_value] : [false]
[root] : [function: 0x562bb7c8]
[color] : [function: 0x562bb738]
[script] : [function: 0x562b9698]
[set_script] : [function: 0x562b9c98]
[world_top] : [function: 0x562ba838]
[position] : [function: 0x562bae68]
[has_script] : [function: 0x562b98d8]
[set_range_color] : [function: 0x562b8a08]
[set_left] : [function: 0x562ba3d0]
[replace_text] : [function: 0x562b8f00]
[world_layer] : [function: 0x562b86c0]
[tree_visible] : [function: 0x562b89f0]
[alive] : [function: 0x562bba08]
[raw_font_size] : [function: 0x562b8228]
[world_rightbottom] : [function: 0x562b9c20]
[rotate] : [function: 0x562ba070]
[h] : [function: 0x562b9a58]
[button_click] : [function: 0x562b9830]
[selection_rect] : [function: 0x562bafa0]
[right] : [function: 0x562bb360]
[key_press] : [function: 0x562b9ab8]
[set_name] : [function: 0x562b94e8]
[set_render_template] : [function: 0x562ba3b8]
[world_center_x] : [function: 0x562b9d10]
[world_shape] : [function: 0x562bac70]
[grow] : [function: 0x562b9308]
[configure] : [function: 0x562b9848]
[extension] : [function: 0x562b9da0]
[set_lefttop] : [function: 0x562baaa8]
[set_world_bottom] : [function: 0x562bab50]
[set_world_center_y] : [function: 0x562b9290]
[set_world_position] : [function: 0x562bb168]
[set_world_center] : [function: 0x562bae98]
[world_center_y] : [function: 0x562ba430]
[set_size] : [function: 0x562b99f8]
[layer] : [function: 0x562b9ad0]
[center] : [function: 0x562bb6a8]
[world_y] : [function: 0x562b8498]
[set_world_right] : [function: 0x562b8870]
[name] : [function: 0x562ba010]
[set_layer] : [function: 0x562b84e0]
[world_lefttop] : [function: 0x562b94b8]
[set_halign] : [function: 0x562bb888]
[enter_text] : [function: 0x562bb6c0]
[align] : [function: 0x562bae20]
[world_righttop] : [function: 0x562b9b00]
[mouse_double_click] : [function: 0x562b8c90]
[lefttop] : [function: 0x562b9ed8]
[x] : [function: 0x562b9c68]
[set_world_top] : [function: 0x562bb648]
--]]