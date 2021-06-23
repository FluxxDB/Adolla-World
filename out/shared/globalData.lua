-- Compiled with roblox-ts v1.1.1
local DATA_VERSION = "v001"
local GAME_VERSION = "v0.1"
local DEFAULT_DATA = {
	techniqueSpins = 0,
	combatTechnique = "Hobo",
	generation = 1,
	options = {
		sfx = 1,
		music = 1,
		ui = 1,
	},
	character = {
		hairColor = {
			r = 0,
			g = 0,
			b = 0,
		},
		face = "",
		clothing = 1,
		bodyAccessory = 0,
		skinTone = 1,
		lastName = "",
		headAccessory = 0,
	},
	generationSpins = 0,
	combatEXP = 0,
	faction = 0,
	reputation = 0,
	yen = 0,
	rank = "",
	faceSpins = 0,
	stats = {
		stamina = 1,
		physicalStrength = 1,
		speed = 1,
		control = 1,
		endurance = 1,
	},
}
return {
	DATA_VERSION = DATA_VERSION,
	GAME_VERSION = GAME_VERSION,
	DEFAULT_DATA = DEFAULT_DATA,
}
