MHUDU = MHUDU or {}
MHUDU._core = MHUDUCore

MHUDU.listeners = {
	--[[ example:
	[key] = {
		callback = [function],
		key = key
	}
	--]]
}

-- Listener system
function MHUDU:RegisterListener(event)
	self.listeners[event] = self.listeners[event] or {}
end

function MHUDU:AddListener(event,key,data)
	self:RegisterListener(event)
	self.listeners[event][key] = data
end

function MHUDU:RemoveListener(event,key,...)
	local data = self.listeners[event][key]
	self.listeners[event][key] = nil
	if data.remove_callback then 
		data.remove_callback(...)
	end
end

function MHUDU:CallListeners(event,event_data,...)
	if self.listeners[event] then
		for key,data in pairs(self.listeners[event]) do 
			data.callback(event_data,...)
		end
	end
end

function MHUDU:CreateHUD(parent)
	local panel
	if alive(parent) then 
		panel = parent:panel({
			name = "mhudu_main"
		})
	else
		self._ws = managers.gui_data:create_fullscreen_workspace()
		panel = self._ws:panel():panel({
			name = "mhudu_main"
		})
	end
	self._panel = panel
end

function MHUDU:CreateAddonHUDs()
	local mhudu_panel = self._panel
	if not alive(mhudu_panel) then 
		self:Log("ERROR: No parent panel")
		return
	end
	
	for addon_id,addon_data in pairs(self._core._addons) do 
		if addon_data.user_data.create_func then 
			local addon_panel = mhudu_panel:panel({
				name = "addon_panel_" .. tostring(addon_id),
				visible = false
			})
			addon_data.panel = addon_panel
			addon_data.user_data.create_func(addon_data.user_data,addon_panel)
		end
	end
end





--incoming information is hooked to these "feed" functions across various other PAYDAY 2 class files 
--these functions receive that information and call the appropriate hud information setters

function MHUDU:teammate_remove_panel(id,...)
	self:CallListeners("remove_teammate_panel",id,...)
end

function MHUDU:teammate_add_panel(id,...)
	self:CallListeners("add_teammate_panel",id,...)
end


function MHUDU:feed_criminal_name(i,name,...)
	self:CallListeners("set_criminal_name",i,name,...)
end

function MHUDU:feed_criminal_health(i,data,...)
	self:CallListeners("set_criminal_health",i,data,...)
	--current,total,data
end

function MHUDU:feed_criminal_armor(i,data,...)
	--current,total
	self:CallListeners("set_criminal_armor",i,data,...)
end

function MHUDU:feed_deployable_amount(i,deployable_index,data,...)
	self:CallListeners("set_criminal_deployable_amount",i,deployable_index,data,...)
end

function MHUDU:feed_grenades_amount(i,data,...)
	self:CallListeners("set_criminal_grenades_amount",i,data,...)
end

function MHUDU:feed_ammo_data(i,...)
	self:CallListeners("set_criminal_ammo_data",i,...)
end