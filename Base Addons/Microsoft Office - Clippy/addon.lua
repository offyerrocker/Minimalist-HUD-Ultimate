--technically his name is "clippit" but that is stupid and i refuse to call him that, except internally
--
local addon_id = "clippit"
return addon_id,{
	name = "Microsoft Office Clippy",
	desc = "The smart assistant from Microsoft Office",
	autodetect_assets = true,
	layer = 1,
	categories = {
		"misc"
	},
	animation_speed = 1000,
	agent_animations = {},
	agent_filepath = "agent.json",
	frame_timer = -1,
	frame_index = 1,
	queued_exit_frame_index = nil,
	action_name = "Greeting",
	clippy_atlas = "guis/textures/mhudu/clippy_atlas",
	clippy_scale = 0.5,
	read_agent = function(addon)
		local path = MHUDUCore:GetAddon("clippit").path .. "\\"
		local agent_data
		local file = io.open(path .. addon.agent_filepath, "r")
		if file then
			agent_data = json.decode(file:read("*all"))
			addon.agent_data = agent_data
			file:close()
		end
		return agent_data
	end,
	get_image = function(addon,action_name,frame_index)
		local agent_data = addon.agent_data
		if agent_data then 
			local action_data = agent_data.animations[action_name]
			local frame_data = action_data.frames[frame_index] or action_data.frames[1]
			local framesize = agent_data.framesize
			local image_data = frame_data and frame_data.images
			local x = image_data and image_data[1] and image_data[1][1] or 0
			local y = image_data and image_data[1] and image_data[1][2] or 0
			local w = framesize and framesize[1] or 100
			local h = framesize and framesize[2] or 100
			local texture_rect = {
				x,
				y,
				w,
				h
			}
			return addon.clippy_atlas,texture_rect
		end
	end,
	create_func = function(addon,parent_panel)
		local clippy_body = parent_panel:bitmap({
			name = "clippy_body",
			texture = addon.clippy_atlas,
			texture_rect = {
				0,0,1,1
			},
			x = 1,
			y = 1,
			w = 0,
			h = 0,
			color = Color.white,
			alpha = 1
		})
		addon.clippy_body = clippy_body
		
		local clippy_text = parent_panel:text({
			name = "clippy_text",
			text = "whomst've",
			color = Color.blue,
			font = "fonts/myriad_pro",
			font_size = 32
		})
		addon.clippy_text = clippy_text
		
	end,
	register_func = function(addon)
		addon.read_agent(addon)
		local agent_data = addon.agent_data
		if agent_data then
			local scale = addon.clippy_scale
			local clippy_body = addon.clippy_body
			if alive(clippy_body) then 
				clippy_body:set_size(agent_data.framesize[1] * scale,agent_data.framesize[2] * scale)
				
				if true then
					local parent = clippy_body:parent()
					clippy_body:set_right(parent:w() - 100)
					clippy_body:set_bottom(parent:h() - 100)
				else
					--todo place above health bar
					
				end
			end
			
			for anim_name,_ in pairs(agent_data.animations) do 
				table.insert(addon.agent_animations,anim_name)
			end
		end
	end,
	destroy_func = function(addon)
		
	end,
	update_func = function(addon,t,dt)
		
		--ANIMATION LOGIC
		local agent_data = addon.agent_data
		if agent_data then 
			local frame_index = addon.frame_index
			
			local frame_timer = addon.frame_timer
			
--			Console:SetTrackerValue("trackera",frame_index)
--			Console:SetTrackerValue("trackerb",frame_counter)
			
			local current_action = addon.action_name
			local action_data = agent_data.animations[current_action]
			local frame_data = action_data.frames[frame_index]
			
			local texture,texture_rect = addon.get_image(addon,current_action,frame_index)
			if alive(addon.clippy_body) then 
				addon.clippy_body:set_image(texture,unpack(texture_rect))
			end
			
			if frame_timer >= frame_data.duration / addon.animation_speed then 
				frame_index = frame_index + 1
				frame_timer = 0
			end
			if not action_data.frames[frame_index] then 
				--choose a new animation
				
				if not FREEZECLIPPY then
					frame_timer = 0
					local new_action_name = table.random(addon.agent_animations) or "Idle1_1"
					addon.action_name = new_action_name
					frame_index = 1
				else
					frame_index = frame_index - 1
				end
--				if frame_data.exit_branch then
--				end
			else
			
			--[[
				local branch_data = frame_data.branching and frame_data.branching.branches
				if branch_data then 
					local weight = 0
					local r = math.random(100)
					for k,branch in ipairs(branch_data) do 
						if branch.weigAht then 
							if r < branch.weight + weight then 
								addon.queued_exit_frame_index = branch.frameIndex --frame_data.exit_branch
--								OffyLib:c_log("Branching to " .. tostring(addon.queued_exit_frame_index))
								break
							else
								weight = weight + branch.weight
--								OffyLib:c_log("Missed the roll")
							end
						else
--							OffyLib:c_log("Frame data for " .. tostring(current_action) .. " does not exist")
						end
					end
				end
				--]]
				
				--continue animation
				if frame_index == addon.queued_exit_frame_index and not FREEZECLIPPY then 
--					OffyLib:c_log("This is my on-ramp...")
					addon.queued_exit_frame_index = nil
					frame_timer = 0
					frame_index = 1
					local new_action_name = table.random(addon.agent_animations) or "Idle1_1"
					addon.action_name = new_action_name
				end
			end
			addon.frame_index = frame_index
			addon.frame_timer = frame_timer + dt
		end
		
		--todo queue clippy point animations
		--also leave, arrive, etc.
		
		
		--make clippy move to areas of interest
		local poi_data = nil
		if poi_data then
			local variant = poi_data.variant
			if variant == "unit" then 
			elseif variant == "hud_position" then 
			elseif variant == "world_position" then 
			end
		end
		
	end
}
