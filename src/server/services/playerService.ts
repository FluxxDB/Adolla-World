import { Players, RunService } from "@rbxts/services";
import { OnInit, Service } from "@rbxts/flamework";
import { DATA_VERSION, DEFAULT_DATA } from "shared/globalData";
import { server } from "shared/globalEvents";
import ProfileService from "@rbxts/profileservice";
import playerObject from "../modules/playerObject";

const isStudio = RunService.IsStudio();
const datastore = ProfileService.GetProfileStore(`Data${DATA_VERSION}`, DEFAULT_DATA);

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
export class playerService implements OnInit {
	onInit() {
		server.connect("ready", (player) => {
			if (profiles.has(player)) return;

			const profile = loadData(player);
			if (!profile) return;

			profiles.set(player, new playerObject(player, profile));
			server.stateUpdate(player, "dataReady", profile.Data);
		});

		Players.PlayerRemoving.Connect((player) => {
			const playerProfile = profiles.get(player);
			if (!playerProfile) return;

			playerProfile.profile.Release();
			profiles.delete(player);
		});
	}
}
