export const DATA_VERSION = "v001";
export const GAME_VERSION = "v0.1";

export const DEFAULT_DATA: DefaultData = {
	techniqueSpins: 0,
	combatTechnique: "Hobo",
	generation: 1,
	options: { sfx: 1, music: 1, ui: 1 },
	character: {
		hairColor: { r: 0, g: 0, b: 0 },
		face: "",
		clothing: 1,
		bodyAccessory: 0,
		skinTone: 1,
		lastName: "",
		headAccessory: 0,
	},
	generationSpins: 0,
	combatEXP: 0,
	faction: 0,
	reputation: 0,
	yen: 0,
	rank: "",
	faceSpins: 0,
	stats: { stamina: 1, physicalStrength: 1, speed: 1, control: 1, endurance: 1 },
};
