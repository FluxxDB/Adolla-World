/* eslint-disable prefer-const */
import { Controller, OnStart } from "@rbxts/flamework";
import { Players, Workspace } from "@rbxts/services";
import { client } from "shared/globalEvents";

const player = Players.LocalPlayer;
const camera = Workspace.CurrentCamera;

@Controller({
	loadOrder: 0,
})
export class characterController implements OnStart {
	onStart() {
		client.ready();
		client.connect("stateUpdate", (key, data) => {
			if (key !== "dataReady") return;
			client.spawn();
			player.CharacterAdded.Connect((character) => {
				const humanoid = character.FindFirstChildOfClass("Humanoid");
				if (!humanoid || !camera) return;

				camera.CameraSubject = humanoid;
				camera.CameraType = Enum.CameraType.Custom;

				let died: RBXScriptConnection;
				died = humanoid.Died.Connect(() => {
					died.Disconnect();
					delay(6, () => {
						client.spawn();
					});
				});
			});
		});
	}
}
