_G.MHUDU = MHUDU or {}

do 
	local settings_file_name = "minimalist_hud_ultimate.txt"
	local modpath = MHUDU:GetPath()
	MHUDU._mod_path = modpath
	MHUDU._save_path = SavePath .. settings_file_name
	MHUDU._default_localization_path = "localization/en.json"
	MHUDU._menu_path = modpath .. "menu/options.json"
	MHUDU._localization
	
	MHUDU.default_settings = {
		
	}
	MHUDU.settings = table.deep_map_copy(MHUDU.default_settings)
	
	MHUDU.listeners = {
		--[[ example:
		[key] = {
			callback = [function],
			key = key
		}
		--]]
	}
end



-- I/O
function MHUDU:LoadSettings()
	local file = io.open(self._save_path, "r")
	if (file) then
		for k, v in pairs(json.decode(file:read("*all"))) do
			self.settings[k] = v
		end
	else
--		self.settings = table.deep_map_copy(self.default_settings)
		self:SaveSettings()
	end
end

function MHUDU:SaveSettings()
	local file = io.open(self._save_path,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end



-- Listener system
function MHUDU:RegisterListener(event)
	self.listeners[event] = self.listeners[event] or {}
end

function MHUDU:AddListener(event,key,data)
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
	for key,data in pairs(self.listeners[event]) do 
		data.callback(event_data,...)
	end
end




-- Menu initialization

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_MHUDU", function(menu_manager)
--[[
	MenuCallbackHandler.callback_modtemplate_toggle = function(self,item)
		local value = item:value() == "on"
		MyNewModGlobal.settings.toggle_setting = value
		MyNewModGlobal:Save()
	end

	MenuCallbackHandler.callback_modtemplate_slider = function(self,item)
		MyNewModGlobal.settings.slider_setting = tonumber(item:value())
		MyNewModGlobal:Save()
	end

	MenuCallbackHandler.callback_modtemplate_multiplechoice = function(self,item)
		MyNewModGlobal.settings.multiplechoice_setting = tonumber(item:value())
		MyNewModGlobal:Save()
	end

	MenuCallbackHandler.callback_modtemplate_button = function(self,item)
		--on menu button click: do nothing in particular
	end
	
	MenuCallbackHandler.callback_modtemplate_keybind_2 = function(self)
		--on keybind press: do nothing in particular
	end	
	
	MenuCallbackHandler.callback_modtemplate_back = function(this)
		--on menu exit: do nothing in particular
	end
	--]]
	MenuHelper:LoadFromJsonFile(MHUDU._menu_path, MHUDU, MHUDU.settings)
end)


--[[
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_MHUDU", function( loc )
	if not BeardLib then
		local localization_path = MHUDU._default_localization_path
		loc:load_localization_file( localization_path )
	end
end)
--]]