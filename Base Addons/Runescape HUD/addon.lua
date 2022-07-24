return "runescapeinventory",{
	name = "Runescape - Inventory",
	desc = "Inventory HUD from Runescape",
	autodetect_assets = true,
	layer = 1,
	categories = {
		"mission_equipment"
	},
	bg_texture = "guis/textures/mhudu/runescape_inventory",
	no_animation = true,
	animate_duration = 0.25,
	icon_size = 32,
	font_size = 16,
	columns = 4,
	eq_x = -28,
	eq_y = 200,
	eq_w = 190,
	eq_h = 262,
	item_offset_x = 20,
	item_offset_y = 24,
	x_margin = 8,
	y_margin = 6,
	create_func = function(addon,parent_panel)
		local inventory_panel = parent_panel:panel({
			name = "inventory_panel",
			y = 64
		})
		addon.inventory_panel = inventory_panel
		local equipment_panel = inventory_panel:panel({
			name = "equipment_panel",
			y = addon.eq_y,
			w = addon.eq_w,
			h = addon.eq_h,
			layer = 3
		})
		equipment_panel:set_right(inventory_panel:w() + addon.eq_x)
		addon.equipment_panel = equipment_panel
		local equipment_bg = inventory_panel:bitmap({
			name = "equipment_bg",
			texture = addon.bg_texture,
			visible = true,
			layer = 2
		})
		equipment_bg:set_right(inventory_panel:w())
		addon.equipment_bg = equipment_bg
	end,
	register_func = function(addon)
		MHUDU:AddListener("set_criminal_mission_equipment","runescapeinventory_add_equipment",{callback = function(...) addon.add_mission_equipment(addon,...) end})
		MHUDU:AddListener("set_criminal_mission_equipment_amount","runescapeinventory_set_equipment_amount",{callback = function(...) addon.set_mission_equipment_amount(addon,...) end})
		MHUDU:AddListener("remove_criminal_mission_equipment","runescapeinventory_remove_equipment",{callback = function(...) addon.remove_mission_equipment(addon,...) end})
		MHUDU:AddListener("clear_criminal_mission_equipment","runescapeinventory_clear_equipment",{callback = function(...) addon.clear_mission_equipment(addon,...) end})
	end,
	destroy_func = function(addon)
		MHUDU:RemoveListener("set_criminal_mission_equipment","runescapeinventory_add_equipment")
		MHUDU:RemoveListener("set_criminal_mission_equipment_amount","runescapeinventory_set_equipment_amount")
		MHUDU:RemoveListener("remove_criminal_mission_equipment","runescapeinventory_remove_equipment")
		MHUDU:RemoveListener("clear_criminal_mission_equipment","runescapeinventory_clear_equipment")
	end,
	set_mission_equipment_amount = function(addon,equipment_id,amount)
		return addon.add_mission_equipment(addon,
			{
				equipment_id = equipment_id,
				amount = amount
			}
		)
	end,
	clear_mission_equipment = function(addon,i)
		if i == HUDManager.PLAYER_PANEL then 
			local equipment_panel = addon.equipment_panel
			if alive(equipment_panel) then 
				for i,child in ipairs(equipment_panel:children()) do
					equipment_panel:remove(child)
				end
			end
		end
	end,
	add_mission_equipment = function(addon,i,data)
		if i == HUDManager.PLAYER_PANEL then 
			local equipment_panel = addon.equipment_panel
			if not alive(equipment_panel) then 
				return
			end
			local icon_size = addon.icon_size
			local font_size = addon.font_size
			
			local id = data.id
			
			local amount = data.amount or 1
			if amount == 1 then 
				amount = ""
			end
			local icon = data.icon
			local amount_label
			
			local panel = equipment_panel:child(id)
			local icon_bitmap
			if not alive(panel) then 
				panel = equipment_panel:panel({
					name = id,
--					x = equipment_panel:center_x(), --this breaks the animate function for whatever reason
--					y = equipment_panel:h(),
					w = icon_size,
					h = icon_size,
					layer = 4
				})
				local texture,texture_rect = tweak_data.hud_icons:get_icon_data(icon)		
				icon_bitmap = panel:bitmap({
					name = "icon",
					texture = texture,
					texture_rect = texture_rect,
					layer = 2
				})
				icon_bitmap:set_center(panel:center())
				
				amount_label = panel:text({
					name = "amount",
					text = tostring(amount),
					font = "fonts/font_medium_shadow_mf",
					font_size = font_size,
					color = Color.yellow,
					align = "left",
					vertical = "top",
					layer = 3
				})
			end
			
			addon.layout_mission_equipment(addon)
		end
	end,
	remove_mission_equipment = function(addon,i,id)
		if i == HUDManager.PLAYER_PANEL then 
			local equipment_panel = addon.equipment_panel
			if not alive(equipment_panel) then 
				return
			end
			
			local panel = id and equipment_panel:child(id)
			if alive(panel) then 
				equipment_panel:remove(panel)
			end
			
			addon.layout_mission_equipment(addon)
		end
	end,
	layout_mission_equipment = function(addon)
		local equipment_panel = addon.equipment_panel
		local columns = addon.columns
		local x_margin = addon.x_margin
		local y_margin = addon.y_margin
		local icon_size = addon.icon_size
		local instant = addon.no_animation
		local animate_duration = addon.animate_duration
		local item_offset_x = addon.item_offset_x
		local item_offset_y = addon.item_offset_y
		
		if alive(equipment_panel) then 
			for i,child in ipairs(equipment_panel:children()) do 
				local j = i - 1
				local column = j % columns
				local row = math.floor(j / columns)
				local x = column * (icon_size + x_margin)
				x = x + item_offset_x
				local y = row * (icon_size + y_margin)
				y = y + item_offset_y
				MHUDU:animate_stop(child)
				if instant then 
					child:set_position(x,y)
				else
					MHUDU:animate(child,"animate_move_sq",nil,animate_duration,child:x(),x,child:y(),y)
				end
			end
		end
	end

}