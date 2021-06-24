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
		shirt: string;
		pants: string;
		bodyAccessory: number;
		skinTone: BrickColorsByNumber[keyof BrickColorsByNumber];
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
