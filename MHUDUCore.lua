_G.MHUDUCore = MHUDUCore or {}

--init mod values
do 
	local settings_file_name = "minimalist_hud_ultimate.txt"
	local modpath = MHUDUCore:GetPath()
	MHUDUCore._mod_path = modpath
	MHUDUCore._save_path = SavePath .. settings_file_name
	MHUDUCore._base_addons_path = modpath .. "Base Addons/"
	MHUDUCore._addons_path = SavePath .. "MHUDU Addons/"
	MHUDUCore._default_localization_path = "localization/en.json"
	MHUDUCore._menu_path = modpath .. "menu/options.json"
--	MHUDUCore._localization
	MHUDUCore._addons = {} --see included addons for templates/examples
	MHUDUCore.default_settings = {
		
	}
	MHUDUCore.settings = table.deep_map_copy(MHUDUCore.default_settings)
end



-- I/O
function MHUDUCore:LoadSettings()
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

function MHUDUCore:SaveSettings()
	local file = io.open(self._save_path,"w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
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
	
	MHUDUCore:CheckCreateAddonFolder()
	
	MHUDUCore:LoadAddons()
	
	MHUDUCore:LoadSettings()
	MenuHelper:LoadFromJsonFile(MHUDUCore._menu_path, MHUDUCore, MHUDUCore.settings)
end)


--[[
	"health_own",
	"armor_own",
	"grenades_own",
	"health_team",
	"armor_team",
	"grenades_team"
--]]

MHUDUCore.inactive_elements = {
	
}

MHUDUCore.active_elements = {

}


function MHUDUCore:Log(...)
	return Console and Console:Log(...)
end


--finds the rarest type of element
--and returns the id of a random inactive element of that type
--if there are no inactive elements or each type of element is equally rare, returns nil
function MHUDUCore:GetRarestElement()
	local recorded = {}
	for id,data in pairs(self.inactive_elements) do 
		for _,element_type in pairs (data.types) do
			recorded[element_type] = recorded[element_type] or {}
			table.insert(recorded[element_type],id)
		end
	end
	for id,data in pairs(self.active_elements) do 
		for _,element_type in pairs(data.types) do 
			recorded[element_type] = recorded[element_type] or {}
			table.insert(recorded[element_type],id)
		end
	end

	
	
end

--returns a random hud element that isn't already added
--if there are no inactive hud elements, returns nil
function MHUDUCore:GetRandomElement()
	local eligible = {}
	for id,data in pairs(self.inactive_elements) do 
		if not self:IsAddonEnabled(id) then 
			table.insert(eligible,id)
		end
	end
	return eligible[math.random(#eligible)]
--	return table.random(self.inactive_elements)
end

function MHUDUCore:IsAddonEnabled(id)
	if id then 
		return self.settings.enabled_addons[id]
	end
end

function MHUDUCore:SelectRandomHUDElement()
	local id
	if distributed_rarity then 
		id = self:GetRarestElement()
	end
	id = id or self:GetRandomElement()
	
	self:ActivateHUDElement(id)
end

function MHUDUCore:ActivateHUDElement(id)
	local new_element = self.inactive_elements[id]
	self.inactive_elements[id] = nil
	self.active_elements[id] = new_element
	
	--new_element.callback_init(Application:time())
end

function MHUDUCore:CreateHUDElement(id)
	--create hud element for this particular addon
end

--starts the timer for adding the next addon
function MHUDUCore:StartTimer()
	
end


-- Create MHUDUAddons folder
function MHUDUCore:CheckCreateAddonFolder()
	--make addons folders
	local file_util = _G.FileIO
	local addons_path_saves = self._addons_path
	if not file_util:DirectoryExists(Application:nice_path(addons_path_saves,true)) then 
		file_util:MakeDir(addons_path_saves)
		local file = io.open(addons_path_saves .. "README.txt","w+")
		if file then
			--this is executed on startup, before localizationmanager is loaded
--			local readme = string.gsub(AdvancedCrosshair.addons_readme_txt,"$LINK",AdvancedCrosshair.url_ach_github)
			
			local readme_text = managers.localization:text("mhudu_readme_desc")
			
			file:write(readme_text)
			file:flush()
			file:close()
		end
		--[[
		for addon_type,paths_tbl in pairs(AdvancedCrosshair.ADDON_PATHS) do 
			for _,path in pairs(paths_tbl) do 
				if not file_util:DirectoryExists(path) then 
					file_util:MakeDir(path)
				end
			end
		end
		--]]
	end
end

Hooks:Register("MinimalistHUDUltimate_LoadAddons")
function MHUDUCore:LoadAddons()
	local file_util = _G.FileIO
	local path_util = BeardLib.Utils.Path
	local stock_addons_path = Application:nice_path(self._base_addons_path,true)
	local addons_path = Application:nice_path(self._addons_path,true)
	
	local function load_addon(addons_folder_path,folder_name)
		local combined_addon_path = path_util:Combine(addons_folder_path,folder_name,"addon.lua")
		if file_util:FileExists(Application:nice_path(combined_addon_path)) then 
			local run_addon_func,s_error = blt.vm.loadfile(combined_addon_path)
			if s_error then 
				self:log("FATAL ERROR: LoadCrosshairAddons(): " .. tostring(s_error),{color=Color.red})
			else
				local addon_id,addon_data = run_addon_func()
				if addon_id then 
					self._addons[addon_id] = {
						id = addon_id,
						user_data = addon_data
					}
					
					local potential_funcs = {
						"create_func",
						"register_func",
						--"update_func", --optional, so it does not warrant a warning if missing
						"destroy_func"
					}
					
					local missing_funcs = {}
					for _,func_name in ipairs(potential_funcs) do 
						if type(addon_data[func_name]) ~= "function" then 
							table.insert(missing_funcs,func_name)
						end
					end
					
					if #missing_funcs > 0 then 
						self:Log("CAUTION! No valid functions defined for addon " .. tostring(addon_id) .. " (" .. tostring(folder_name) .. "): " .. tostring(table.concat(missing_funcs,",")) .. ". Your addon may not work properly without them!")
					end
					
					self:Log("Loaded addon: " .. tostring(folder_name))
				else
					self:Log("ERROR: Invalid addon data returned from " .. tostring(combined_addon_path))
				end
			end
		end
	end
	
	for _,parent_addon_folder in ipairs({stock_addons_path,user_addons_path}) do 
		--load data
		--do not create hud elements- this will be done after the main hud is created
		for _,addon_folder_name in pairs(file_util:GetFolders(parent_addon_folder)) do 
			load_addon(parent_addon_folder,addon_folder_name)
		end
	end
	
	Hooks:Call("MinimalistHUDUltimate_LoadAddons",self)
end
