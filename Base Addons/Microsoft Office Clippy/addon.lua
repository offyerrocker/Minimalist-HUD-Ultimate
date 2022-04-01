--technically his name is "clippit" but that is stupid and i refuse to call him that, except internally
--
local addon_id = "clippit"
return addon_id,{
	name = "Microsoft Office Clippy",
	desc = "The virtual assistant from Microsoft Office",
	autodetect_assets = true,
	layer = 999,
	categories = {
		"misc"
	},
	font_name = "fonts/arial24",
	font_size = 24,
	default_position = {0,0},
	animation_speed = 1000,
	agent_animations = {},
	speech_bg_texture = "mhudu/clippy_speech_bg",
	animation_exits = { --at exit, this frame can transition to any animation that matches this state
		Idle1_1 = "standard",
		Greeting = "standard",
		Congratulate = "standard",
		GetTechy = "standard", --atomic
		LookUpRight = "standard",
		Print = "standard",
		Show = "standard", --grow popup
		GetWizardy = "standard", --checkmark but buggy?
		CheckingSomething = "standard", --reading paper
		Hearing_1 = "standard", --listening to music
		LookDown = "empty",
		Thinking = "standard", --atomic but again 
		Processing = "standard", --shoveling through data
		Explain = "standard", --brief eyebrow raise
		GetArtsy = "standard", --become mobile sculpture
		LookLeft = "standard",
		LookUp = "standard",
		IdleSideToSide = "standard",
		Writing = "standard", --take paper and write on it
		IdleFingerTap = "standard",
		LookDownRight = "standard",
		LookDownLeft = "standard",
		GestureLeft = "standard", --this gestures to the viewer's right actually lol
		IdleEyeBrowRaise = "standard", --same as explain
		Searching = "standard", --telescope paper
		IdleSnooze = "standard", --taking a nap
		EmptyTrash = "empty", --whirlwind/flush
		IdleHeadScratch = "standard",
		IdleAtom = "standard", --atomic but again
		Save = "standard", --make a box and put stuff in it
		RestPose = "standard", --completely idle standstill i guess
		GestureRight = "standard", --again, flipped. this points screen left
		SendMail = "empty", --leave on a paper airplane
		GestureDown = "standard", --point downward
		GetAttention = "standard", --look close up to screen and tap
		GestureUp = "standard", --point up
		LookRight = "standard",
		IdleRopePile = "standard", --falling asleep into a rope pile
		Wave = "standard", --wave, tap screen, become exclamation point
		Hide = "empty", --shrink away, opposite of Show
		Alert = "standard", --shorter version of Hearing_1
		LookUpLeft = "standard",
		GoodBye = "empty" --turn into bike and leave
	},
	animation_enters = { --at start, the frame can transition from any animation that matches this state
		standard = {
			"Idle1_1",
			"Congratulate",
			"LookUpRight",
			"GetTechy",
			"Print",
--			"GetWizardy",
			"CheckingSomething",
			"Hearing_1",
			"LookDown",
			"Thinking",
			"Processing",
			"Explain",
			"GetArtsy",
			"LookLeft",
			"RestPose",
			"IdleSideToSide",
			"Writing",
			"IdleFingerTap",
			"LookDownRight",
			"LookDownLeft",
			"GestureLeft",
			"IdleEyeBrowRaise",
			"Searching",
			"IdleSnooze",
			"EmptyTrash",
			"IdleHeadScratch",
			"IdleAtom",
			"Save",
			"GoodBye",
			"GestureRight",
			"SendMail",
			"LookUp",
			"GetAttention",
			"Alert",
			"Hide",
			"IdleRopePile",
			"Wave",
			"LookRight",
			"GestureUp",
			"GestureDown",
			"LookUpLeft"
		},
		empty = {
			"Greeting",
			"Show"
		}
	},
	animation_categories = {
		idle = {
			"Idle1_1",
			"Congratulate",
			"GetTechy",
			"Print",
--			"GetWizardy",
			"CheckingSomething",
			"Hearing_1",
			"LookDown",
			"Thinking",
			"Processing",
			"Explain",
			"GetArtsy",
			"RestPose",
			"IdleSideToSide",
			"Writing",
			"IdleFingerTap",
			"IdleEyeBrowRaise",
			"Searching",
			"IdleSnooze",
			"EmptyTrash",
			"IdleHeadScratch",
			"IdleAtom",
			"Save",
			"LookUp",
			"GetAttention",
			"Alert",
			"IdleRopePile",
			"Wave"
		},
		look = {
			down = "LookDown",
			downleft = "LookDownLeft",
			downright = "LookDownRight",
			right = "LookRight",
			upright = "LookUpRight",
			up = "LookUp",
			upleft = "LookUpLeft",
			left = "LookLeft"
		},
		gesture = {
			down = "GestureDown",
			left = "GestureLeft",
			right = "GestureRight",
			up = "GestureUp"
		},
		leave = {
			"SendMail",
			"GoodBye"
		},
		arrive = {
			"Greeting"
		}
	},
	poi_data = nil,
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
		
		local speech_panel = parent_panel:panel({
			name = "speech_panel",
			layer = 2,
			visible = false
		})
		local speech_bg = speech_panel:bitmap({
			name = "speech_bg",
			texture = addon.speech_bg_texture,
			layer = 3
		})
		
		local clippy_text = speech_panel:text({
			name = "clippy_text",
			text = "whomst've",
			wrap = true,
			color = Color.blue,
			font = addon.font_name,
			font_size = addon.font_size
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
					clippy_body:set_right(parent:w() - 200)
					clippy_body:set_bottom(parent:h() - 200)
					addon.default_position = {clippy_body:position()}
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
		local clippy_body = addon.clippy_body
		
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
			if alive(clippy_body) then 
				clippy_body:set_image(texture,unpack(texture_rect))
			end
			
			if frame_timer >= frame_data.duration / addon.animation_speed then 
				frame_index = frame_index + 1
				frame_timer = 0
			end
			if not action_data.frames[frame_index] then 
				--choose a new animation
				
				if not FREEZECLIPPY then
					frame_timer = 0
					local new_action_name = table.random(addon.animation_categories.idle)
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
					local new_action_name = table.random(addon.animation_categories.idle)
					addon.action_name = new_action_name
				end
			end
			addon.frame_index = frame_index
			addon.frame_timer = frame_timer + dt
		end
		
		--todo queue clippy point animations
		--also leave, arrive, etc.
		
		
		--make clippy move to areas of interest
		local poi_data = addon.poi_data
		if poi_data then
			
			--position data
			--speech data
			--aim data
			
			local to_x
			local to_y
			local ws = MHUDU._ws
			
			local variant = poi_data.variant
			if variant == "unit" or variant == "world_position" then 
				local tg_pos
				if variant == "unit" then 
					tg_pos = unit:position()
				elseif variant == "world_position" then 
					tg_pos = poi_data.position
				end
				if tg_pos then 
					local to_pos = ws:world_to_screen(managers.viewport:get_current_camera(),tg_pos)
					to_x = to_pos.x
					to_y = to_pos.y
				end
			elseif variant == "hud_position" then 
				--data should already be there
				to_x = addon.default_position[1]
				to_y = addon.default_position[2]
			end
			if to_x and to_y then 
				local hor_side = 0 --0 left, 1 right
				local ver_side = 0 --0 top, 1 bottom
				
				local from_x,from_y = clippy_body:position()
				
				local d_x = to_x - from_x
				local d_y = to_y - from_y
				
				local speed = dt * 1
				local x_speed = d_x * speed
				local y_speed = d_y * speed
				if math.abs(x_speed) < 1 then 
					x_speed = d_x
				end
				if math.abs(y_speed) < 1 then 
					y_speed = d_y
				end
				
				clippy_body:move(x_speed,y_speed)
			end
--			if not poi_data.started then 
				
				--MHUDU:animate(clippy_body,"animate_move_sq",nil,1.5,clippy_body:x(),to_x,clippy_body:y(),to_y)
				--poi_data.started = true
--			end
			
		end
	end,
	set_speech_bubble = function(addon)
		local spl = string.split("Hello! I hear you're bad at video games. May I suggest that you git gud?"," ")
		addon.clippy_text:set_text("")
		MHUDU:animate(addon.clippy_text,"animate_text_word_chunks",nil,#spl / 3,spl)
	end,
	animate_move_to = function(addon)
		
	end
}
