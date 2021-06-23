import { Profile } from "@rbxts/profileservice/globals";

export default class PlayerObject {
	player: Player;
	profile: Profile<DefaultData>;
	data: DefaultData;

	constructor(player: Player, profile: Profile<DefaultData>) {
		this.player = player;
		this.profile = profile;
		this.data = profile.Data;
	}
}
