_G.MHUDUCore = MHUDUCore or {}

--init mod values
do 
	local settings_file_name = "minimalist_hud_ultimate.txt"
	local modpath = MHUDUCore:GetPath()
	MHUDUCore._mod_path = modpath
	MHUDUCore._save_path = SavePath .. settings_file_name
	MHUDUCore._assets_folder_name = "assets"
	MHUDUCore._base_addons_path = modpath .. "Base Addons/"
	MHUDUCore._addons_path = SavePath .. "MHUDU Addons/"
	MHUDUCore._default_localization_path = "localization/en.json"
	MHUDUCore._menu_path = modpath .. "menu/options.json"
--	MHUDUCore._localization
	MHUDUCore._addons = {} --see included addons for templates/examples
	MHUDUCore.default_settings = {
		minimalism_countdown_interval = 300, --5min
		minimalism_countdown_enabled = false,
		addon_save_data = {},
		enabled_addons = {}
	}
	MHUDUCore.menu_data = {
		menu_ids = {
			main = "mhudu_menu_main",
			addons = "mhudu_addon_list"
		},
		addon_generated_submenus = {
		
		}
	}
	MHUDUCore._timer = false
	MHUDUCore._timer_paused = false
	MHUDUCore.settings = table.deep_map_copy(MHUDUCore.default_settings)
	
	MHUDUCore.file_util = _G.FileIO
	MHUDUCore.path_util = BeardLib.Utils.Path
end



-- I/O
function MHUDUCore:LoadSettings()
	local file = io.open(self._save_path, "r")
	if (file) then
		for k, v in pairs(json.decode(file:read("*all"))) do
			if type(v) == "table" then 
				self.settings[k] = self.settings[k] or {}
				for i,j in pairs(v) do 
					self.settings[k][i] = j
				end
			else
				self.settings[k] = v
			end
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


-- Menu management

Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_MHUDU", function(menu_manager)
	BeardLib:AddUpdater("MHUDU_Update",callback(MHUDUCore,MHUDUCore,"Update"))
	
	
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
	
	--load addons from user and from base mhudu
	MHUDUCore:LoadAddons()
	
	MHUDUCore:LoadSettings()
--	MenuHelper:LoadFromJsonFile(MHUDUCore._menu_path, MHUDUCore, MHUDUCore.settings)
end)

Hooks:Add("MenuManagerSetupCustomMenus", "MenuManagerSetupCustomMenus_MHUDU", function(menu_manager, nodes)
	MenuHelper:NewMenu(MHUDUCore.menu_data.menu_ids.main)
	MenuHelper:NewMenu(MHUDUCore.menu_data.menu_ids.addons)
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "MenuManagerPopulateCustomMenus_MHUDU", function(menu_manager, nodes)

	for addon_id,addon_data in pairs(MHUDUCore._addons) do 
		local user_data = addon_data.user_data
		local addon_menu_id = "mhudu_addon_submenu_" .. tostring(addon_id)
		MenuHelper:NewMenu(addon_menu_id)
		MHUDUCore.menu_data.addon_generated_submenus[addon_id] = addon_menu_id
		
		local callback_name = "callback_mhudu_addon_enable_" .. tostring(addon_id)
		MenuCallbackHandler[callback_name] = function(self,item)
			local enabled = item:value() == "on"
			MHUDUCore.settings.enabled_addons[addon_id] = enabled
			MHUDUCore:SaveSettings()
		end
		MenuHelper:AddToggle({
			id = "mhudu_addon_enable_" .. addon_id,
			title = "menu_mhudu_addon_enable_generic_title",
			desc = "menu_mhudu_addon_enable_generic_desc",
			callback = callback_name,
			value = MHUDUCore.settings.enabled_addons[addon_id] and true or false,
			menu_id = addon_menu_id
		})
		
	end
end)

Hooks:Add("MenuManagerBuildCustomMenus", "MenuManagerBuildCustomMenus_MHUDU", function( menu_manager, nodes )
	do 
		local menu_id = MHUDUCore.menu_data.menu_ids.main
		local title = "menu_mhudu_main_title"
		local desc = "menu_mhudu_main_desc"
		nodes[menu_id] = MenuHelper:BuildMenu(menu_id)
		MenuHelper:AddMenuItem(nodes.blt_options,menu_id,title,desc)
	end
	do 
		local menu_id = MHUDUCore.menu_data.menu_ids.addons
		local title = "menu_mhudu_addons_title"
		local desc = "menu_mhudu_addons_desc"
		nodes[menu_id] = MenuHelper:BuildMenu(menu_id)
		MenuHelper:AddMenuItem(nodes[MHUDUCore.menu_data.menu_ids.main],menu_id,title,desc)
	end
	
	for addon_id,menu_id in pairs(MHUDUCore.menu_data.addon_generated_submenus) do 
		local addon_data = MHUDUCore._addons[addon_id]
		local title = addon_data.name_id
		local desc = addon_data.desc_id
		nodes[menu_id] = MenuHelper:BuildMenu(menu_id)
		MenuHelper:AddMenuItem(nodes[MHUDUCore.menu_data.menu_ids.addons],menu_id,title,desc)
	end
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


function MHUDUCore:Log(a,...)
	return Console and Console:Log("[MINIMALIST HUD ULTIMATE] " .. tostring(a),...)
end




-- Timer system

function MHUDUCore:IsMinimalismCountdownEnabled()
	--should be an instanced setting to avoid conflicts mid-heist?
	return self.settings.minimalism_countdown_enabled
end

--starts the timer for adding the next addon
function MHUDUCore:StartMinimalismCountdown()
	self._timer = (self._timer or 0) + self:GetMinimalismCountdownInterval()
	self._timer_paused = false
end

function MHUDUCore:PauseMinimalismCountdown()
	self._timer_paused = true
end

function MHUDUCore:GetMinimalismCountdownInterval()
	return self.settings.minimalism_countdown_interval
end

function MHUDUCore:Update(t,dt)
	if not self._timer_paused then 
		if self._timer then 
			if self._timer <= 0 then 
				local next_addon
					--effective one-frame delay after timer hits 0;
					--check for next hud element here
				if next_addon then 
		--			next_addon.data:register_func(addon.data)
					self._timer = false
					self:StartMinimalismCountdown()
				end
			else 
				self._timer = self._timer - dt
			end
		end
	end
	
	--todo if actually ingame
	
	for id,addon_data in pairs(self._addons) do 
		if addon_data.active then
			if addon_data.user_data.update_func then 
				addon_data.user_data.update_func(addon_data.user_data,t,dt)
			end
		end
	end
end

--[[
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

--]]

--returns true if the user has enabled the setting that allows this addon to be used
function MHUDUCore:IsAddonEnabled(id)
	if id then 
		return self.settings.enabled_addons[id]
	end
end

function MHUDUCore:IsAddonActive(id)
	if id and self._addons[id] then
		return self._addons[id].active
	end
end

function MHUDUCore:ActivateAddon(id)
	if id and self._addons[id] then
		local addon_data = self._addons[id]
		addon_data.active = true
		addon_data.panel:show()
		if addon_data.user_data.register_func then 
			addon_data.user_data.register_func(addon_data.user_data)
		end
	end
end

--[[
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
--]]


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
			
			local readme_text = managers.localization:text("menu_mhudu_readme_desc")
			
			file:write(readme_text)
			file:flush()
			file:close()
		end
	end
end


--recursively search a given path for assets and load them with their given extension and directory structure
function MHUDUCore.recursive_search_addons_assets(root_path,path,file_func)
--	MHUDUCore:Log("Recursive path checking " .. tostring(path) .. " in " .. tostring(root_path))
	if type(file_func) ~= "function" then 
--		MHUDUCore:Log("ERROR: Bad iteration function to recursive_search_addons_assets(" .. tostring(path) .. "," .. tostring(file_func) .. ")")
		return
	end
	local path_util = MHUDUCore.path_util
	local file_util = MHUDUCore.file_util
	local search_path = path_util:Combine(root_path,path)
	for _,filename in pairs(file_util:GetFiles(search_path)) do 
--		MHUDUCore:Log("Found file " .. tostring(filename) .. " at path " .. tostring(path))
		file_func(root_path,path_util:Combine(path,filename))
--		MHUDUCore:Log("Found file " .. tostring(filename_no_extension) .. " at path " .. tostring(path) .. ", extension " .. tostring(extension))
--		add_asset(path_util:Combine(path,filename),assets_path .. path .. filename,extension)
	end
	
	for _,foldername in pairs(file_util:GetFolders(search_path)) do 
		local new_path = path_util:Combine(path,foldername)
--		MHUDUCore:Log("Found subpath at " .. new_path)
		MHUDUCore.recursive_search_addons_assets(root_path,new_path,file_func)
	end
end


Hooks:Register("MinimalistHUDUltimate_LoadAddons")
function MHUDUCore:LoadAddons()
	local path_util = self.path_util
	local file_util = self.file_util
	local stock_addons_path = Application:nice_path(self._base_addons_path,true)
	local user_addons_path = Application:nice_path(self._addons_path,true)
	
	local function load_addon(addons_folder_path,folder_name)
		local combined_addon_path = path_util:Combine(addons_folder_path,folder_name,"addon.lua")
		if file_util:FileExists(Application:nice_path(combined_addon_path)) then 
			local run_addon_func,s_error = blt.vm.loadfile(combined_addon_path)
			if s_error then 
				self:Log("FATAL ERROR: LoadAddons(): " .. tostring(s_error),{color=Color.red})
			else
				local addon_id,user_data = run_addon_func()
				if addon_id then 
					local addon_data = {
						active = false,
						id = addon_id,
						user_data = user_data,
						path = addons_folder_path .. folder_name
					}
					self._addons[addon_id] = addon_data
					self.settings.addon_save_data[addon_id] = self.settings.addon_save_data[addon_id] or {}
					--automatic localization
					local loc_strings = {}
					local name_loc = user_data.name
					local desc_loc = user_data.desc
					if name_loc then 
						local name_id = "mhudu_addon_" .. addon_id .. "_name_id"
						loc_strings[name_id] = name_loc
						addon_data.name_id = name_id
					else
						addon_data.name_id = "menu_mhudu_addon_generic_unknown_name"
					end
					if desc_loc then 
						local desc_id = "mhudu_addon_" .. addon_id .. "_desc_id"
						loc_strings[desc_id] = desc_loc
						addon_data.desc_id = desc_id
					else
						addon_data.desc_id = "menu_mhudu_addon_generic_unknown_desc"
					end
					managers.localization:add_localized_strings(loc_strings)
					
					local potential_funcs = {
						"create_func",
						"register_func",
						--"update_func", --optional, so it does not warrant a warning if missing
						"destroy_func"
					}
					
					local missing_funcs = {}
					for _,func_name in ipairs(potential_funcs) do 
						if type(user_data[func_name]) ~= "function" then 
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
	--users who want more complex addon behavior may wish to execute their code via SBLT Hooks instead

				
	local cached_extensions = {}
	local function add_asset(root_path,file_path)
		local find_ext_1,find_ext_2 = string.find(file_path,"%.")
		if find_ext_1 and find_ext_2 then 
			local file_path_no_extension = string.sub(file_path,1,find_ext_1 - 1)
			local extension = string.sub(file_path,find_ext_2 + 1)
			
			local ext_ids = cached_extensions[extension] or Idstring(extension)
			cached_extensions[extension] = cached_extensions[extension] or ext_ids
--			self:Log("Added: " .. tostring(extension) .. " " .. tostring(file_path_no_extension) .. " " .. tostring(root_path) .. " " .. tostring(file_path))


			--BLT.AssetManager:CreateEntry(Idstring(file_path_no_extension),ext_ids,root_path .. file_path) --alt loading method
			BeardLib.managers.file:AddFile(ext_ids,Idstring(file_path_no_extension),root_path .. file_path)
			
			if extension == "font" then 
				managers.dyn_resource:load(ext_ids, Idstring(file_path_no_extension), DynamicResourceManager.DYN_RESOURCES_PACKAGE,
					function()
--						self:Log("Force loaded " .. tostring(file_path_no_extension))
					end
				)
			end
			
			
		else
--			self:Log("Error: add_asset(" .. tostring(file_path) .. ") invalid parse at positions " .. tostring(find_ext_1) .. "," .. tostring(find_ext_2))
		end
	end
			
	for id,addon_data in pairs(self._addons) do 
		local user_data = addon_data.user_data
		local addon_path = addon_data.path
		if user_data.autodetect_assets then 
--			self:Log("Checking asset loading for addon " .. tostring(id))
			local assets_folder_name = user_data.assets_folder_name or self._assets_folder_name
			
			local assets_path = path_util:Combine(addon_path,assets_folder_name .. "/") --root assets path
			
--			self:Log("Checking auto-generate assets at path: " .. assets_path)

			
			--recursively check each folder 
			--then get file extension, name, and path,
			--and load the asset into the game

			if file_util:DirectoryExists(Application:nice_path(assets_path)) then 
				
				--manually run the recursive searches on the first level,
				--so that we can separate the assets root folder to pass to the asset loading function
				for _,filename in pairs(file_util:GetFiles(assets_path)) do 
					add_asset(assets_path,filename)
				end
				
				for _,foldername in pairs(file_util:GetFolders(assets_path)) do 
					MHUDUCore.recursive_search_addons_assets(assets_path,foldername,add_asset)
				end
				
			else
				self:Log("No assets directory found at " .. assets_path)
			end
		end
	end
end


