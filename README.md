# PD2-Minimalist-HUD-Ultimate
	Minimalist HUD Ultimate, a HUD mod for PAYDAY 2 for April Fool's Day.
	A sequel to Minimalist HUD Pro.
	Unlike the original, it was designed to be modular, and allows the user to enable or disable elements as they please. (Requires a restart to disable elements.)
	In addition, it introduces an optional mechanic where new HUD elements are introduced at regular intervals, inspired by the video "Mario Speedrun, but every 5 minutes the HUD gets worse": https://www.youtube.com/watch?v=jAymJW63PLk
	Addons are, as mentioned, very modular. More can be easily added, and there are several utilities included in MHUDU to facilitate creation and use.
WARNING: Not intended for serious play. This mod has the potential to severely impede your gameplay by obscuring your visual field with HUD elements and more!

All code used in all listed addons was written by Offyerrocker.
Asset sources vary.

HUD Element Sources:

	- Dark Souls Death Screen
		Source:
			Dark Souls
		Details:
			When the player dies, this popup appears. Due to the difficulty of the game, longtime players will become very familiar with this particular HUD element.
		MHUDU Proc circumstances:
			This animation and text will appear whenever the player goes down or is incapacitated (tased down/cloaker kicked)
		Assets from:
			Recreated using PAYDAY 2 assets, animated with code. Vertical gradient and Times New Roman (Bold).
				
	- Destiny 2 Menagerie Popup
		Source:
			Destiny 2
		Details:
			While in the Season of Opulence 6-player activity, The Menagerie, the popup message "Chalice Requires Runes" would constantly appear at ~2-second intervals at the bottom of the screen if the player had not yet used a certain object in their inventory to receive rewards.
		MHUDU Proc circumstances: 
			Upon activation, this popup will appear at semi-random intervals at the bottom of the screen.
		Assets from:
			Recreated from scratch using Photoshop, animated with code.
			Font is Neue Haas Grotesk, along with Display variant.
			
	- DOOM HUD
		Source:
			DOOM (1993) and DOOM II
		Details:
			This is a relatively faithful recreation of the heads-up display from the first two DOOM games. 
			DOOM HUD also appeared in Minimalist HUD Pro, the first version of Minimalist HUD.
		MHUDU Proc circumstances:
			Player health, armor, magazine and reserve ammo, and grenades count are indicated on the HUD. 
		Assets from:
			Main HUD Spritesheet (including bitmap fonts) ripped for TSR (The Spriter's Resource) by:
				ULTIMECIA
				HYLIANSONIC
				Hax4Ever
				SUPERDAVE938
				SuperPiter
			Doomguy face spritesheet recreated from screenshots. See Minimalist HUD Pro credits.
		
	- Fallout 3 VATS
		Source:
			Fallout 3
		Details:
			A recreation of the V.A.T.S. (Vault-Tec Assisted Targeting System) mechanic's HUD element from Fallout 3.
		MHUDU Proc circumstances:
			This HUD element appears when the player aims at an enemy. The readout accuracy stat for each body part depends on the player's weapon accuracy stat, distance, and angle to target. All accuracy approximations are essentially made up.
		Assets from:
			All textures recreated from scratch in Photoshop by Offyerrocker.
			Font is Monofonto, which is 100% free. https://www.dafont.com/monofonto.font Monofonto is the font originally used in Fallout 3's VATS screen, as well as for most of its UI.
			
	- FFXIV Map
		Source:
			Final Fantasy XIV
		Details:
			Final Fantasy XIV has an extremely in-depth HUD customization system, including a windows manager. Windows can be moved or scaled, and their contents can often be customized, or at least their transparency. These windows can be visible during essentially any point in gameplay, except during cutscenes, and the player can make as cluttered a HUD as they like. In some ways, Final Fantasy XIV is a better Minimalist HUD than I'll ever be able to make.
		MHUDU Proc circumstances:
			This is a map of one of the major locations, Limsa Lominsa, rendered at low transparency on the screen. It provides no useful information whatsoever. Unless you need to know where the Aetheryte Plaza is.
		Assets from: 
			Texture is directly taken from an in-game screenshot of mine.
			
	- FTL HUD
		Source:
			FTL: Faster Than Light
		Details:
			FTL is an indie top-down strategy game. Up to eight crew members can be recruited; their names, racial portrait and health bar are visible in a list on the left side of the screen.
		MHUDU Proc circumstances:
			One FTL crewmember HUD element is generated for each player or Team AI in the game. Health does not display for Team AI, due to differences in their code compared to a player, but your own health and the health of your player-controlled teammates will be visible as a health bar indicator.
		Assets from:
			Racial portraits taken from the FTL wiki at ftl.wikia.com.
			The font is Coder's Crux which is free for personal use. https://www.dafont.com/coders-crux.font 
			Coder's Crux is not the font originally used in FTL: Faster Than Light, and is the closest matching look-alike I could find.
	- Halo 3 Cortana
		Source:
			Halo 3
		Details:
			Throughout Halo 3, the Master Chief's AI companion, Cortana, telepathically communicates with him, sending him somewhat brief but quite opaque messages. At times, however, this telepathic link is hijacked by the Gravemind, who is in possession of Cortana, and the Gravemind speaks to the Master Chief instead, incurring a slowdown and screen effects, and playing voicelines.
		MHUDU Proc circumstances:
			This is a conversion of an existing mod of mine from last year's April Fool's 2021: https://modworkshop.net/mod/31552
			At semi-random intervals, the player will be slowed, and several on-screen effects will play, emulating the original "Gravemind Moments" in Halo 3. Unlike in Halo 3, however, the player will not have invulnerability while these moments are occurring.
		Assets from:
			Voicelines are extracted edited from a YouTube video: 
				https://www.youtube.com/watch?v=ppDUa9O7Eek
			Textures (overlays, vignette, colors, animations) were all created from scratch in Photoshop/coded by Offyerrocker.
	- Halo CE HUD
		Source:
			Halo: Combat Evolved
		Details: 
			Yes, I'm a Bungie game enjoyer.
			Though Halo: Reach HUD (aka NobleHUD) was featured in Minimalist HUD Pro's promotional content, it was not formally part of Minimalist HUD Pro. Halo CE HUD takes its place in Minimalist HUD Ultimate, though it is decidedly less fully-featured.
		MHUDU Proc circumstances: 
			This is a recreation of Halo CE's HUD. Health, magazine/reserve ammo, and grenade count are shown, as well as an MA5B Assault Rifle crosshair. Low Ammo/No Ammo/No Grenades/Reload indicators also flash at appropriate times. No sounds are included.
		Assets from:
			Textures were ripped by Shadowth117.
				https://www.spriters-resource.com/fullview/23454/
		
	- LEGO Character HUD
		Source:
			LEGO video game franchise (mainly LEGO Star Wars)
		Details:
			An original 
		MHUDU Proc circumstances:
			This is an element from Minimalist HUD Pro, re-added in Minimalist HUD Ultimate. No modifications were made, as much as I wanted to.
		Assets from:
			Most assets were from the wiki, with two notable exceptions:
				- Dante from the Devil May Cry Series
				- Weiss Schnee from RWBY
				
	- Microsoft Office Clippy
		Source:
			Windows XP Microsoft Office
		Details:
			Clippy, officially named Clippit, was a digital assistant for Microsoft's rich-text editor. Clippy had some sounds (not included here) and text suggestions for helping with the user's document editing. 
		MHUDU Proc circumstances: 
			- Clippy is always watching. Waiting.
			- Clippy currently constantly plays random animations in his sprite sheet.
		Assets from:
			Spritesheet atlas and animation js file taken from here: https://github.com/smore-inc/clippy.js
			All code, including animation logic, written from scratch by Offyerrocker.
	
	- Noita HUD
		Source:
			Noita
		Details:
			Just a favored game of mine that I happened to have screenshots of. 
		MHUDU Proc circumstances:
			Static image, no additional functionality or information.
		Assets from:
			Texture is taken directly from an in-game screenshot of mine.
		
	- Pokémon Mystery Dungeon Info
		Source:
			Pokémon Mystery Dungeon Red Rescue Team/Pokémon Mystery Dungeon Blue Rescue Team
		Details:
			This is the text log that displays any in-game battle information, as well as speech from NPCs. 
		MHUDU Proc circumstances: 
			Many actions will send a message to the battle log, including when an enemy takes damage or dies, or when a player goes down, etc. 
		Assets from:
			Font is a fan recreation, available at https://www.dafont.com/pkmn-mystery-dungeon.font
			Text box texture recreated from scratch in Photoshop.
		
	- Rocket League Boost
		Source: 
			Rocket League
		Details:
			This is a recreation of the boost meter in Rocket League. It is an elemeny from Minimalist HUD Pro, re-added in Minimalist HUD Ultimate.
		MHUDU Proc circumstances:
			This element shows the current percentage amount of stamina that the player has.
		Assets from:
			Textures were recreated from scratch in Photoshop. (I'm quite proud of it.)
			Font is Eurostile Extended, which is included in PAYDAY 2's files and is not part of either Minimalist HUD.
			
	- Runescape: 
		Source:
			Runescape Old-School
		Details: 
			This sort of dates me, doesn't it?
			The inspiration for adding this specific image was from the aforementioned speedrun video.
		MHUDU Proc circumstances:
			This element shows the mission equipment that the player has (eg. meth ingredients, crowbars, planks, blowtorches, etc.)
		Assets from:
			Texture was edited together from the following source images:
			https://www.rune-server.ee/runescape-development/rs2-client/downloads/340037-317-client-loading-original-317-cache.html
			https://runescape.wiki/w/Old_School_RuneScape#/media/File:Old_School_HUD.png
	
	- Shigeru Miyamoto
		Source:
			He's a dude in real life
		Details:
			The inspiration for adding this specific image was from the aforementioned speedrun video.
		MHUDU Proc circumstances:
			This is a static image, which has no additional functionality or information.
		Assets from:
			Google Images. Unfortunately, I can't find the proper source; it's likely a press image.
		
	- Space Engineers HUD
		Source:
			Space Engineers
		Details:
			Just another favored game of mine that I happened to have screenshots of. 
		MHUDU Proc circumstances:
			Static image, no additional functionality or information.
		Assets from:
			Texture is taken directly from an in-game screenshot of mine.
	
	- Subnautica HUD
		Source:
			Subnautica: Below Zero
		Details:
			Yet another favored game of mine that I happened to have screenshots of. 
		MHUDU Proc circumstances:
			Static image, no additional functionality or information.
		Assets from:
			Texture is taken directly from an in-game screenshot of mine.
	
	- Super Mario 64 HUD
		Source:
			Super Mario 64
		Details:
			The inspiration for adding this specific image was from the aforementioned speedrun video.
			It fits pretty well, though. 
		MHUDU Proc circumstances:
			This element displays the number of revives the player has, as well as the number of secured mission bags and the number of secured optional bags.
		Assets from:
			All textures and fonts ripped by:
				Megadardery, KoopaTroopa76, LewisTehCat28
				https://www.spriters-resource.com/nintendo_64/supermario64/
	- Team Fortress 2 HUD
		Source:
			Team Fortress 2
		Details:
			Another holdover from Minimalist HUD Pro, with a couple of fixes and improvements.
		MHUDU Proc circumstances:
			This element displays the player's health and ammo. The health and ammo elements also flash when each respective resource is low.
		Assets from:
			Fonts are TF2 Build and TF2, included in Team Fortress 2's game files.
			Textures were taken from the official wiki, wiki.teamfortress.com, and edited. 
	
	- Terraria HUD
		Source:
			Terraria
		Details:
			A static texture of Terraria's item hotbar. Another element from Minimalist HUD Pro. 
		MHUDU Proc circumstances:
			Static image, no additional functionality or information.
		Assets from:
			Texture is taken directly from an in-game screenshot of mine.