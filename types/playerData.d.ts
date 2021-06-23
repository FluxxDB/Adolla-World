interface DefaultData {
	techniqueSpins: number;
	combatTechnique: string;
	generation: number;
	options: {
		sfx: number;
		music: number;
		ui: number;
	};
	character: {
		hairColor: {
			r: number;
			g: number;
			b: number;
		};
		face: string;
		clothing: number;
		bodyAccessory: number;
		skinTone: number;
		lastName: string;
		headAccessory: number;
	};
	generationSpins: number;
	combatEXP: number;
	faction: number;
	reputation: number;
	yen: number;
	rank: string;
	faceSpins: number;
	stats: {
		stamina: number;
		physicalStrength: number;
		speed: number;
		control: number;
		endurance: number;
	};
}
