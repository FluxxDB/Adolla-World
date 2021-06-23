import { Players, RunService } from "@rbxts/services";
import { OnInit, Service } from "@rbxts/flamework";
import ProfileService from "@rbxts/profileservice";
import { DEFAULT_DATA } from "shared/globalData";
import { GlobalEvents } from "shared/globalEvents";
import playerObject from "../modules/playerObject";

const isStudio = RunService.IsStudio();
const events = GlobalEvents.server;
const datastore = ProfileService.GetProfileStore("AdollaWorld", DEFAULT_DATA);

export const profiles = new Map<Player, playerObject>();

function loadData(player: Player) {
	let profile;

	if (isStudio) {
		profile = datastore.Mock.LoadProfileAsync(`Player_${player.UserId}`, "ForceLoad");
	} else {
		profile = datastore.LoadProfileAsync(`Player_${player.UserId}`, "ForceLoad");
	}

	if (!profile) {
		return player.Kick("Data unable to load.");
	}

	profile.Reconcile();
	profile.ListenToRelease(() => {
		if (player.IsDescendantOf(Players)) {
			player.Kick("Data loaded from somewhere else.");
		}
	});

	if (!player.IsDescendantOf(Players)) {
		return profile.Release();
	}

	return profile;
}

@Service({
	loadOrder: 0,
})
export class MyService implements OnInit {
	onInit() {
		events.connect("ready", (player) => {
			if (profiles.has(player)) return;
			const profile = loadData(player);
			if (!profile) return;
			profiles.set(player, new playerObject(player, profile));
		});

		Players.PlayerRemoving.Connect((player) => {
			const playerProfile = profiles.get(player);
			if (!playerProfile) return;
			playerProfile.profile.Release();
			profiles.delete(player);
		});
	}
}
