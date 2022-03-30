if Gravemind then 
	log("Loading MHUDU addon- wait. wow. you, uh. you already have gravemind installed. i... huh. you know you don't need both, right? yeah, i'm just gonna... disable this addon for you. you take care now.")
	log("...psychopath.")
	return
end

blt.xaudio.setup()

Gravemind = {}

Gravemind.assets = {
	overlay = {
		extension = "texture",
		path = "guis/textures/mhudu/gravemind_overlay"
	},
	vignette = {
		extension = "texture",
		file_type = "png",
		path = "guis/textures/mhudu/gravemind_vignette"
	},
	tentacles_1 = {
		extension = "texture",
		file_type = "png",
		path = "guis/textures/mhudu/gravemind_tentacles_1"
	},
	tentacles_2 = {
		extension = "texture",
		file_type = "png",
		path = "guis/textures/mhudu/gravemind_tentacles_2"
	}
}

--i'm aware that these are not in the same order as they appear in the game, or even ordered according to their filenames
--this is mainly so that the "of course you came for her" line could be played first as a gag

--sounds from https://www.youtube.com/watch?v=ve9iRKOKHbw
Gravemind.voice_lines = {
	{
		id = "salvation",
		extension = ".ogg",
		file_name = "g01",
		duration = 10.5,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 0.75,
			camera_attack = 0.5,
			camera_sustain = 8,
			camera_decay = 1
		},
		subtitle_data = {
			text = "Do not be afraid. I am peace; I am salvation.",
			duration = 8.21
		}
	},
	{
		id = "everlasting",
		extension = ".ogg",
		file_name = "g02",
		duration = 16, --14.26
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 1,
			camera_attack = 0.5,
			camera_sustain = 13,
			camera_decay = 2
		},
		subtitle_data = {
			text = "I am a timeless chorus; a sweet unity of purpose. Join your voice with mine, and sing victory everlasting.",
			duration = 14.26
		}
	},
	{
		id = "sins",
		extension = ".ogg",
		file_name = "g04",
		duration = 14,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 1,
			camera_attack = 0.75,
			camera_sustain = 10,
			camera_decay = 3
		},
		subtitle_data = {
			text = "Child of my enemy, why have you come? I offer no forgiveness; a father's sins pass to his son.",
			duration = 12.24
		}
	},
	{
		id = "her",
		extension = ".ogg",
		file_name = "g05",
		duration = 9,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 2,
			camera_attack = 3,
			camera_sustain = 3,
			camera_decay = 2
		},
		subtitle_data = {
			text = "Of course, you came for... HER. But there is nothing left.",
			duration = 7.03
		}
	},
	{
		id = "together",
		extension = ".ogg",
		file_name = "g07",
		duration = 10,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 1.5,
			camera_attack = 0.75,
			camera_sustain = 7,
			camera_decay = 2
		},
		subtitle_data = {
			text = "We exist together now... two corpses in one grave.",
			duration = 8.20
		}
	},
	{
		id = "echo",
		extension = ".ogg",
		file_name = "g08",
		duration = 15,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 0.75,
			camera_attack = 0.75,
			camera_sustain = 12,
			camera_decay = 2
		},
		subtitle_data = {
			text = "Her cries are but an echo; wind rattling an empty cage. And yet, perhaps a part of her remains.",
			duration = 12.26
		}
	},
	{
		id = "patience",
		extension = ".ogg",
		file_name = "g09",
		duration = 15,
		shaker_data = {
			camera_multiplier = 2,
			camera_amplitude = 3,
			camera_attack = 8.5,
			camera_sustain = 3,
			camera_decay = 3
		},
		subtitle_data = {
			text = "TIME HAS TAUGHT ME PATIENCE... BUT BASKING IN NEW FREEDOM, I WILL KNOW ALL THAT I POSSESS!",
			duration = 13.68
		}
	},
	{
		id = "bones",
		extension = ".ogg",
		file_name = "g10",
		duration = 19,
		shaker_data = {
			camera_multiplier = 2,
			camera_amplitude = 3,
			camera_attack = 1,
			camera_sustain = 15,
			camera_decay = 3
		},
		subtitle_data = {
			text = "SUBMIT! END HER TORMENT AND MY OWN! YOU WILL SHOW ME WHAT SHE HIDES... OR I SHALL FEAST UPON YOUR BONES!",
			duration = 16.29
		}
	},
	{
		id = "secret",
		extension = ".ogg",
		file_name = "g11",
		duration = 22,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 2,
			camera_attack = 4,
			camera_sustain = 15,
			camera_decay = 2
		},
		subtitle_data = {
			text = "Now... at last, I see! Her secret is revealed! The spike you would drive in my heart is key to that infernal wheel!",
			duration = 19.28
		}
	},
	{
		id = "scream1",
		extension = ".ogg",
		file_name = "g03",
		duration = 11,
		shaker_data = {
			camera_multiplier = 4,
			camera_amplitude = 2,
			camera_attack = 1,
			camera_sustain = 5,
			camera_decay = 3
		},
		subtitle_data = {
			text = "[roars in anger]",
			duration = 9.14
		}
	},
	{
		id = "defeated",
		extension = ".ogg",
		file_name = "g12",
		duration = 8,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 4,
			camera_attack = 2,
			camera_sustain = 3,
			camera_decay = 2.5
		},
		subtitle_data = {
			text = "DID YOU THINK ME DEFEATED?",
			duration = 5.00
		}
	},
	{
		id = "fleets",
		extension = ".ogg",
		file_name = "g13",
		duration = 12,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 3,
			camera_attack = 2.5,
			camera_sustain = 7,
			camera_decay = 2
		},
		subtitle_data = {
			text = "I... have beaten fleets of THOUSANDS! Consumed a galaxy of flesh and mind and bone!",
			duration = 10.22
		}
	},
	{
		id = "life",
		extension = ".ogg",
		file_name = "g06",
		duration = 8.5,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 1,
			camera_attack = 0.75,
			camera_sustain = 5,
			camera_decay = 2
		},
		subtitle_data = {
			text = "Do I take life, or give it? Who is victim, and who... is foe?",
			duration = 7.27
		}
	},
	{
		id = "resignation",
		extension = ".ogg",
		file_name = "g14",
		duration = 22,
		shaker_data = {
			camera_multiplier = 3,
			camera_amplitude = 1,
			camera_attack = 1,
			camera_sustain = 19,
			camera_decay = 1
		},
		subtitle_data = {
			text = "Resignation is my virtue. Like water, I ebb and flow. Defeat is simply the addition of time to a sentence I never deserved... but you imposed.",
			duration = 20.06
		}
	},
	mex_comment = {
		id = "cave",
		index = 99,
		extension = ".ogg",
		file_name = "c01",
		subtitle_data = {
			text = "This cave is not a natural formation. Someone built it... so it must lead somewhere.",
			color = Color("d600ff"),
			name = "Cortana",
			duration = 8
		}
	}
}

Gravemind.voice_lines_by_id = {} --only a reverse lookup index; populated on load. this should only be used for indirect reference


Gravemind.WRAP_LINES = false
Gravemind.modpath = ModPath --don't believe his lies
--Gravemind.assets_path = Gravemind.modpath .. "assets/"
Gravemind.UPDATER_ID = "Gravemind_Update_FX_start"
Gravemind.gravemind_name = "Gravemind"
Gravemind.TINT_COLOR = Color("96b45e") --Color("99bd60")
Gravemind.TINT_ALPHA = 0.5
Gravemind.VIGNETTE_ALPHA = 0.95
Gravemind.OVERLAY_ALPHA_MIN = 0.8
Gravemind.OVERLAY_ALPHA = 1
Gravemind.OVERLAY_OSCILLATE_FREQUENCY = 60
Gravemind.TENTACLES_OSCILLATE_FREQUENCY = 30
Gravemind.TENTACLES_2_ALPHA_MIN = 0.6
Gravemind.TENTACLES_2_ALPHA = 0.8
Gravemind.TENTACLES_1_ALPHA_MIN = 0.6
Gravemind.TENTACLES_1_ALPHA = 0.95

Gravemind.min_moment_interval = 30
Gravemind.max_moment_interval = 30

Gravemind._mex_objective_id = "heist_mex8"
Gravemind._next_moment_t = nil
Gravemind.LIMP_SPEED = 20
Gravemind.FOV_FADEIN_SPEED = 6
Gravemind.FOV_FADEOUT_SPEED = 5
Gravemind.CONTRACTION_FOV = 140
Gravemind.orig_fov = 75 --set on load
Gravemind.HUD_FADEIN_TIME = 0.5
Gravemind.HUD_FADEOUT_TIME = 0.33
Gravemind.is_in_moment = false
Gravemind.current_line = 0

function Gravemind:Animator()
	return MHUDUCore._animator
end

function Gravemind:log(a,...)
	if Console then 
		Console:Log("GRAVEMIND: " .. tostring(a),...)
	else
		log("GRAVEMIND: " .. tostring(a),...)
	end
end

function Gravemind:LoadBuffers(local_assets_path)
	local function load_buffer(index,data)
		local id = data.id
		local file_name = data.file_name or id
		if data.buffer and not data.buffer._closed then 
			data.buffer:close()
		end
		local snd_path = local_assets_path .. "sound/" .. (file_name or id) .. (data.extension or ".ogg")
		
		self.voice_lines_by_id[id] = {
			id = id,
			index = index
		}
		
		if SystemFS and SystemFS:exists(Application:nice_path(snd_path,true)) then
			data.buffer = XAudio.Buffer:new(snd_path)
		else
			self:log("ERROR: Could not load buffer for file at " .. tostring(snd_path) .. "!")
		end
	end
	
	for i,data in pairs(Gravemind.voice_lines) do
		load_buffer(i,data)
	end
end

function Gravemind:OnLoadComplete() 
--	self:SetNextMomentTime(Application:time())
	self:LoadBuffers()
	
	self.orig_fov = (managers.user:get_setting("fov_standard") or 75) * (managers.user:get_setting("fov_multiplier") or 1)
	self._ws = MHUDU._ws
	self._panel = self._ws:panel()

	self:CreateHUD()
end

function Gravemind:CreateHUD()
	local black = Color.black
	local panel = self._panel
	
	local visible = true
	
	if alive(panel:child("gravemind_panel")) then 
		panel:remove(panel:child("gravemind_panel"))
	end
	
	local gravemind_panel = panel:panel({
		name = "gravemind_panel",
		layer = 2552,
		alpha = 0
	})
	
	
	local screen_w,screen_h = panel:size()
	local visible = true
	
	local tint = gravemind_panel:rect({
		name = "tint",
		color = self.TINT_COLOR,
		blend_mode = "add",
		alpha = self.TINT_ALPHA,
		layer = 1,
		visible = visible
	})
	local vignette = gravemind_panel:bitmap({
		name = "vignette",
		texture = Gravemind.assets.vignette.path,
		w = screen_w,
		h = screen_h,
		color = black,
		alpha = self.VIGNETTE_ALPHA,
		layer = 2,
		visible = true
	})
	local overlay = gravemind_panel:bitmap({
		name = "overlay",
		texture = Gravemind.assets.overlay.path,
		w = screen_w,
		h = screen_h,
		color = black,
		alpha = self.OVERLAY_ALPHA,
--		blend_mode = "mul",
		layer = 3,
		visible = visible
	})
	local blur = gravemind_panel:bitmap({
		name = "blur",
		texture = Gravemind.assets.vignette.path,
		w = screen_w,
		h = screen_h,
		render_template = "VertexColorTexturedBlur3D",
		layer = 4,
		visible = visible
	})
	
	
	local tentacles_2 = gravemind_panel:bitmap({
		name = "tentacles_2",
		texture = Gravemind.assets.tentacles_2.path,
		w = screen_w,
		h = screen_h,
		alpha = self.TENTACLES_2_ALPHA,
		layer = 5,
		visible = visible
	})
	local tentacles_1 = gravemind_panel:bitmap({
		name = "tentacles_1",
		texture = Gravemind.assets.tentacles_1.path,
		w = screen_w,
		h = screen_h,
		alpha = self.TENTACLES_1_ALPHA,
		layer = 6,
		visible = visible
	})
end

function Gravemind:CheckPerformMoment(t)
	if self._next_moment_t then 
		if t and self._next_moment_t <= t then 
			self:StartNextMoment(t)
		end
	elseif self._next_moment_t == nil then
		self:SetNextMomentTime(t or 0) 
	--elseif false (set by completing the entire line-set), ignore
	end
end

function Gravemind:SetNextMomentTime(offset)
	self._next_moment_t = offset + self.min_moment_interval + math.random(self.max_moment_interval - self.min_moment_interval)
end

function Gravemind:IsInMoment()
	return self.is_in_moment
end

function Gravemind:GetShakerParams(params)
	return {
		"camera_shake",
		"multiplier",
		params.camera_multiplier or 10, --camera_shake_mul
		"camera_shake",
		"amplitude",
		params.camera_amplitude or 0.75,
		"camera_shake",
		"attack",
		params.camera_attack or 0.05,
		"camera_shake",
		"sustain",
		params.camera_sustain or 0.95,
		"camera_shake",
		"decay",
		params.camera_decay or 0.15,
		"rumble",
		"multiplier_data",
		1,
		"rumble",
		"peak",
		0.5,
		"rumble",
		"attack",
		0.05,
		"rumble",
		"sustain",
		0.15,
		"rumble",
		"release",
		0.5
	}
end

function Gravemind:DoFOVChange(reset)
	local player = managers.player:local_player()
	if alive(player) then 
		if reset then 
			player:camera():camera_unit():base():animate_fov(self.orig_fov,self.FOV_FADEOUT_SPEED)
		else
			player:camera():camera_unit():base():animate_fov(self.CONTRACTION_FOV,self.FOV_FADEIN_SPEED)
		end
	end
end

function Gravemind:DoShaker(params)
	params = params or {}
	local player = managers.player:local_player()
	if alive(player) then 
		local feedback = managers.feedback:create("mission_triggered")
		feedback:set_unit(player)
		feedback:set_enabled("camera_shake", not params.disabled_camera_shake)
		feedback:set_enabled("rumble",not params.disabled_rumble) --haha controller users
		feedback:set_enabled("above_camera_effect",not params.disabled_above_camera_effect)
		feedback:play(unpack(self:GetShakerParams(params)))
	end
end

function Gravemind:PlaySoundAndShake(snd_data)
	self:PlaySound(snd_data)
	
	self:DoShaker(snd_data.shaker_data)
end

function Gravemind:PlaySoundByID(snd_id)
	local snd_index = self.voice_lines_by_id[snd_id] and self.voice_lines_by_id[snd_id].index
	local snd_data = snd_index and self.voice_lines[snd_index]
	if snd_data then 
		self:PlaySound(snd_data)
	else
		self:log("ERROR: No sound found with snd_id (" .. tostring(snd_id))
	end
end

function Gravemind:PlaySound(snd_data)
	XAudio.UnitSource:new(XAudio.PLAYER,snd_data.buffer)
	local sd = snd_data.subtitle_data
	if ClosedCaptions and sd then 
		local color = snd_data.color or Color.green
		local t = Application:time()
		local speaker_name = snd_data.name or self.gravemind_name 
		local data = {
			name = speaker_name,
			text_color = color,
			position = nil,
			unit = nil,
			sound_source = nil,
			loop_data = nil,
			loop_visible = nil,
			sound_id = snd_data.id, --not valid technically but oh well
			priority = 1,
			max_distance = 1,
			variation_data = nil,
			is_recombinable = false,
			start_t = t,
			is_locationless = true,
			expire_t = t + sd.duration
		}
		if ClosedCaptions:UseCapitalNames() then 
			speaker_name = utf8.to_upper(speaker_name)
		end
		ClosedCaptions:_add_line(speaker_name .. ": " .. sd.text,speaker_name .. "_" .. snd_data.id,color,data)
	end
end

function Gravemind:StartNextMoment(t)
	self.current_line = self.current_line + 1
	if self.current_line > #self.voice_lines then 
		if self.WRAP_LINES then 
			self.current_line = 1
		else
			self._next_moment_t = false
		end
	end
	
	local data = self.voice_lines[self.current_line]
	if data then 
		self:SetNextMomentTime((t or 0) + data.duration)
		self:StartMoment(data)
	end
end

function Gravemind:StartMoment(snd_data)
	local player = managers.player:local_player()
	if not alive(player) then 
		return
	end
	
	if self.is_in_moment then 
		self:log("Already in moment!")
		return
	end
	self.is_in_moment = true
	
	local state = player:movement():current_state()
	if state:in_steelsight() then 
		state:_end_action_steelsight(Application:time())
	end
	self:DoFOVChange(false)
	
	local animator = self:Animator()
	if not animator then 
		self:log("ERROR: No animator found! Zhis is actually very bad!")
		return
	end
	
	
	local gravemind_panel = self._panel:child("gravemind_panel")
	
	animator:animate(gravemind_panel,"animate_fadein",
		function(o)
--			callback(self,self,"PlaySoundAndShake",snd_data)
			self:PlaySoundAndShake(snd_data)
			animator:animate(o:child("overlay"),"animate_oscillate_alpha",nil,0,self.OVERLAY_OSCILLATE_FREQUENCY,self.OVERLAY_ALPHA_MIN,self.OVERLAY_ALPHA)
			animator:animate(o:child("tentacles_1"),"animate_oscillate_alpha",nil,0.5,self.TENTACLES_OSCILLATE_FREQUENCY,self.TENTACLES_1_ALPHA_MIN,self.TENTACLES_1_ALPHA)
			animator:animate(o:child("tentacles_2"),"animate_oscillate_alpha",nil,0,self.TENTACLES_OSCILLATE_FREQUENCY,self.TENTACLES_2_ALPHA_MIN,self.TENTACLES_2_ALPHA)
		end	
	,self.HUD_FADEIN_TIME,1)
	
	animator:animate_wait(snd_data.duration,callback(self,self,"FinishMoment",snd_data))
end

function Gravemind:FinishMoment(snd_data)
	if not self.is_in_moment then 
		self:log("ERROR: Not in a moment!")
		return
	end
	self:DoFOVChange(true)
	local animator = self:Animator()
	local gravemind_panel = self._panel:child("gravemind_panel")
	
	animator:animate(gravemind_panel,"animate_fadeout",function(o)
		self.is_in_moment = false
		
		local overlay = o:child("overlay")
		animator:animate_stop(overlay)
		overlay:set_alpha(self.OVERLAY_ALPHA)
		
		local tentacles_1 = o:child("tentacles_1")
		animator:animate_stop(tentacles_1)
		tentacles_1:set_alpha(self.TENTACLES_1_ALPHA)
		
		local tentacles_2 = o:child("tentacles_2")
		animator:animate_stop(tentacles_2)
		tentacles_2:set_alpha(self.TENTACLES_2_ALPHA)
		
	end,self.HUD_FADEOUT_TIME,gravemind_panel:alpha())
end

for id,asset in pairs(Gravemind.assets) do
--	BLT.AssetManager:CreateEntry(asset.path,Idstring(asset.extension),Gravemind.assets_path .. asset.path .. "." .. (asset.file_type or asset.extension))
end







local mvec3_normalize = mvector3.normalize
local mvec3_dot = mvector3.dot

local addon_id = "cortana"
return addon_id,{
	name = "Halo 3 - Cortana",
	desc = "Adds helpful and relevant voicelines from \"Cortana\" from Halo 3.",
	autodetect_assets = true,
	layer = 777,
	categories = {
		"misc"
	},
	create_func = function(addon,parent_panel)
		
		local assets_path = MHUDUCore:GetAddon("cortana").path .. "/assets/"
		Gravemind:LoadBuffers(assets_path)
		
		
		local black = Color.black
		local panel = parent_panel
		
		local visible = true
		
		if alive(panel:child("gravemind_panel")) then 
			panel:remove(panel:child("gravemind_panel"))
		end
		
		local gravemind_panel = panel:panel({
			name = "gravemind_panel",
			layer = 2552,
			alpha = 0
		})
		Gravemind._panel = panel
		
		local screen_w,screen_h = panel:size()
		local visible = true
		
		local tint = gravemind_panel:rect({
			name = "tint",
			color = Gravemind.TINT_COLOR,
			blend_mode = "add",
			alpha = Gravemind.TINT_ALPHA,
			layer = 1,
			visible = visible
		})
		local vignette = gravemind_panel:bitmap({
			name = "vignette",
			texture = Gravemind.assets.vignette.path,
			w = screen_w,
			h = screen_h,
			color = black,
			alpha = Gravemind.VIGNETTE_ALPHA,
			layer = 2,
			visible = true
		})
		local overlay = gravemind_panel:bitmap({
			name = "overlay",
			texture = Gravemind.assets.overlay.path,
			w = screen_w,
			h = screen_h,
			color = black,
			alpha = Gravemind.OVERLAY_ALPHA,
	--		blend_mode = "mul",
			layer = 3,
			visible = visible
		})
		local blur = gravemind_panel:bitmap({
			name = "blur",
			texture = Gravemind.assets.vignette.path,
			w = screen_w,
			h = screen_h,
			render_template = "VertexColorTexturedBlur3D",
			layer = 4,
			visible = visible
		})
		
		local tentacles_2 = gravemind_panel:bitmap({
			name = "tentacles_2",
			texture = Gravemind.assets.tentacles_2.path,
			w = screen_w,
			h = screen_h,
			alpha = Gravemind.TENTACLES_2_ALPHA,
			layer = 5,
			visible = visible
		})
		local tentacles_1 = gravemind_panel:bitmap({
			name = "tentacles_1",
			texture = Gravemind.assets.tentacles_1.path,
			w = screen_w,
			h = screen_h,
			alpha = Gravemind.TENTACLES_1_ALPHA,
			layer = 6,
			visible = visible
		})
		
	end,
	register_func = function(addon)
		Gravemind.orig_fov = (managers.user:get_setting("fov_standard") or 75) * (managers.user:get_setting("fov_multiplier") or 1)
		
		
		--playerstandard hooks
		local mvec3_dis_sq = mvector3.distance_sq
		local mvec3_set = mvector3.set
		local mvec3_set_z = mvector3.set_z
		local mvec3_sub = mvector3.subtract
		local mvec3_add = mvector3.add
		local mvec3_mul = mvector3.multiply
		local mvec3_norm = mvector3.normalize

		local temp_vec1 = Vector3()

		local tmp_ground_from_vec = Vector3()
		local tmp_ground_to_vec = Vector3()
		local up_offset_vec = math.UP * 30
		local down_offset_vec = math.UP * -40
		local win32 = SystemInfo:platform() == Idstring("WIN32")

		local mvec_pos_new = Vector3()
		local mvec_achieved_walk_vel = Vector3()
		local mvec_move_dir_normalized = Vector3()

		PlayerStandard.orig_standard_get_max_walk_speed = PlayerStandard._get_max_walk_speed
		function PlayerStandard:_get_max_walk_speed(...)
			if Gravemind:IsInMoment() then 
				return Gravemind.LIMP_SPEED
			end
			return self:orig_standard_get_max_walk_speed(...)
		end
		
		PlayerCarry.orig_carry_get_max_walk_speed = PlayerCarry._get_max_walk_speed
		function PlayerCarry:_get_max_walk_speed(...)
			if Gravemind:IsInMoment() then 
				return Gravemind.LIMP_SPEED
			end
			return self:orig_carry_get_max_walk_speed(...)
		end

		PlayerStandard.orig_check_action_steelsight = PlayerStandard._check_action_steelsight
		function PlayerStandard:_check_action_steelsight(...)
			if Gravemind:IsInMoment() then 
				self._steelsight_wanted = false
				return
			end
			return self:orig_check_action_steelsight(...)
		end
		
		PlayerMovementState.orig_update = PlayerMovementState.update
		function PlayerMovementState:update(t,...)
			if not Gravemind:IsInMoment() then 
				Gravemind:CheckPerformMoment(t,...)
			end
			return self:orig_update(t,...)
		end
		
	
	--playercamera hooks
		--this is only here to enable the screen shaking effect from this mod, even if "No Screen Shake" https://modworkshop.net/mod/22471 is installed
		--this does not completely disable No Screen Shake- only when this mod is experiencing an effect

		PlayerCamera.orig_play_shaker = PlayerCamera.play_shaker
		function PlayerCamera:play_shaker(effect, amplitude, frequency, offset,...)
			if _G.IS_VR then
				return
			end
			if Gravemind:IsInMoment() then 
				return self._shaker:play(effect, amplitude or 1, frequency or 1, offset or 0,...)
			else
				return self:orig_play_shaker(effect,amplitude,frequency,offset,...)
			end
		end
		
	--fpcameraplayerbase hooks
		FPCameraPlayerBase.orig_set_stance_fov_instant = FPCameraPlayerBase.set_stance_fov_instant
		function FPCameraPlayerBase:set_stance_fov_instant(...)
			if Gravemind:IsInMoment() then 
				return 
			end
			return self:orig_set_stance_fov_instant(...)
		end

		FPCameraPlayerBase.orig_set_fov_instant = FPCameraPlayerBase.set_fov_instant
		function FPCameraPlayerBase:set_fov_instant(...)
			if Gravemind:IsInMoment() then 
				return 
			end
			return self:orig_set_fov_instant(...)
		end

		Hooks:PostHook(FPCameraPlayerBase,"clbk_stance_entered","gravemind_stop_fov",function(self,...)
			if Gravemind:IsInMoment() then 
				if self._fov.transition then 
					self._fov.transition = nil
		--			self._fov.transition.end_fov = self._fov.transition.end_fov + 140
				end
			end
		end)
		
	--elementobjective hooks (technically active even if gravemind is not activated yet)
		Hooks:PreHook(ElementObjective,"on_executed","cortana_recognizes_that_this_cave_is_not_a_natural_formation",function(self,instigator)
			if self:value("objective") == Gravemind._mex_objective_id then 
				Gravemind:PlaySoundByID("cave")
			end
		end)
		
		
		--Gravemind:OnLoadComplete()
		
	end,
	destroy_func = function(addon)
	end,
	update_func = function(addon,t,dt)
		Gravemind:CheckPerformMoment(t)
	end
}
