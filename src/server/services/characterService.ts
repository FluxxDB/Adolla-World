import { OnInit, Service } from "@rbxts/flamework";
import { Players, Workspace } from "@rbxts/services";
import { server } from "shared/globalEvents";

function clearCharacter(character: Model) {
	for (const child of character.GetChildren()) {
		if (
			child.IsA("CharacterMesh") ||
			child.IsA("LocalScript") ||
			(child.IsA("Accessory") && !child.FindFirstChild("HairAttachment", true))
		) {
			child.Destroy();
		}
	}
}

// function setAppearance(character: Model, data: DefaultData) {
//     const characterData = data.character
//     data.character.skinTone
// }

@Service({
	loadOrder: 0,
})
export class characterService implements OnInit {
	onInit() {
		const entities = Workspace.WaitForChild("Entities");
		const characters = entities.WaitForChild("Characters");

		server.connect("spawn", (player) => {
			const characterInfo = Players.GetHumanoidDescriptionFromUserId(player.UserId);
			const character = Players.CreateHumanoidModelFromDescription(characterInfo, Enum.HumanoidRigType.R6);
			if (!character) return;

			character.Parent = characters;
			player.Character = character;
		});
	}
}
