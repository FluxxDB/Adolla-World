import { OnInit, Service } from "@rbxts/flamework";
import { Debris, Players, ReplicatedStorage, Workspace } from "@rbxts/services";
import { server } from "shared/globalEvents";
import { profiles } from "./playerService";

function grabOrCreate<T extends keyof CreatableInstances>(instanceClass: T, parent: Instance): CreatableInstances[T] {
	let child = parent.FindFirstChildOfClass(instanceClass) as CreatableInstances[T];

	if (!child) {
		child = new Instance(instanceClass);
		child.Parent = parent;
	}

	return child;
}

function weldAttachments(attach1: Attachment, attach2: Attachment) {
	const joint = new Instance("Weld");
	joint.Part0 = attach1.Parent as BasePart;
	joint.Part1 = attach2.Parent as BasePart;
	joint.C0 = attach1.CFrame;
	joint.C1 = attach2.CFrame;
	joint.Parent = attach1.Parent;

	return joint;
}

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

	const headMesh = character.WaitForChild("Head").FindFirstChildOfClass("SpecialMesh");
	if (headMesh) {
		headMesh.MeshId = "";
		headMesh.MeshType = Enum.MeshType.Head;
		headMesh.Scale = new Vector3(1.25, 1.25, 1.25);
	}
}

function setAppearance(player: Player, character: Model, data: DefaultData) {
	const characterData = data.character;
	const humanoid = character.FindFirstChildOfClass("Humanoid");
	if (humanoid) {
		humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None;
	}
	character.Name = `${player.DisplayName} ${characterData.lastName}`;

	const shirt = grabOrCreate("Shirt", character);
	const pants = grabOrCreate("Pants", character);
	shirt.ShirtTemplate = characterData.shirt;
	pants.PantsTemplate = characterData.pants;

	const bodyColors = grabOrCreate("BodyColors", character);
	const skinColor = new BrickColor(characterData.skinTone);
	bodyColors.HeadColor = skinColor;
	bodyColors.LeftArmColor = skinColor;
	bodyColors.LeftLegColor = skinColor;
	bodyColors.RightArmColor = skinColor;
	bodyColors.RightLegColor = skinColor;
	bodyColors.TorsoColor = skinColor;

	const hairColor = characterData.hairColor;
	const hairBrickColor = new BrickColor(hairColor.r, hairColor.g, hairColor.b);
	for (const hairAccessory of character.GetChildren()) {
		if (hairAccessory.IsA("Accessory")) {
			const mesh = hairAccessory.FindFirstChild("Mesh", true);
			const handle = hairAccessory.FindFirstChildOfClass("Part");
			if (!mesh || !mesh.IsA("SpecialMesh") || !handle) return;
			handle.BrickColor = hairBrickColor;
			mesh.TextureId = "";
		}
	}

	const head = character.FindFirstChild("Head");
	if (!head) return;

	const fakeHead = new Instance("Part");
	const specialMesh = new Instance("SpecialMesh");
	const headWeld = new Instance("Weld");
	specialMesh.MeshType = Enum.MeshType.Head;
	specialMesh.Scale = new Vector3(1.25, 1.25, 1.25);
	specialMesh.Parent = fakeHead;
	fakeHead.Size = new Vector3(2, 1, 1);
	fakeHead.Transparency = 1;
	headWeld.Part0 = fakeHead;
	headWeld.Part1 = head as BasePart;
	headWeld.Parent = fakeHead;
	fakeHead.Parent = head;

	const face = head.FindFirstChildOfClass("Decal");
	if (!face) return;
	face.Texture = characterData.face;
	face.Parent = fakeHead;

	const assets = ReplicatedStorage.WaitForChild("Assets");
	const headAccessories = assets.WaitForChild("HeadAccessory");
	const bodyAccessories = assets.WaitForChild("BodyAccessory");
	if (characterData.headAccessory !== "0") {
		let accessory = headAccessories.FindFirstChild(characterData.headAccessory);
		if (!accessory) return;

		const handle = accessory.FindFirstChildOfClass("Part");
		if (!handle) return;

		const attachment1 = handle.FindFirstChildOfClass("Attachment");
		if (!attachment1) return;

		const attachment2 = head.FindFirstChild(attachment1.Name);
		if (!attachment2 || !attachment2.IsA("Attachment")) return;

		accessory = accessory.Clone();
		weldAttachments(attachment1, attachment2);
		accessory.Parent = character;
	}

	if (characterData.bodyAccessory !== "0") {
		let accessory = bodyAccessories.FindFirstChild(characterData.bodyAccessory);
		if (!accessory) return;

		const handle = accessory.FindFirstChildOfClass("Part");
		if (!handle) return;

		const attachment1 = handle.FindFirstChildOfClass("Attachment");
		if (!attachment1) return;

		const bodyPart = character.FindFirstChild(attachment1.GetAttribute("bodyPart") as string);
		if (!bodyPart || !bodyPart.IsA("Part")) return;

		const attachment2 = bodyPart.FindFirstChild(attachment1.Name);
		if (!attachment2 || !attachment2.IsA("Attachment")) return;

		accessory = accessory.Clone();
		weldAttachments(attachment1, attachment2);
		accessory.Parent = character;
	}
}

@Service({
	loadOrder: 0,
})
export class characterService implements OnInit {
	onInit() {
		const map = Workspace.WaitForChild("Map");
		const spawns = map.WaitForChild("Spawns");
		const entities = Workspace.WaitForChild("Entities");
		const characters = entities.WaitForChild("Characters");
		const rng = new Random();

		server.connect("spawn", (player) => {
			const playerObject = profiles.get(player);
			if (!playerObject) return;

			const characterInfo = Players.GetHumanoidDescriptionFromUserId(player.UserId);
			const character = Players.CreateHumanoidModelFromDescription(characterInfo, Enum.HumanoidRigType.R6);
			if (!character) return;

			const humanoidRootPart = character.WaitForChild("HumanoidRootPart") as Part;
			if (!humanoidRootPart) return;

			const randomSpawn = spawns.GetChildren()[rng.NextInteger(1, spawns.GetChildren().size()) - 1];
			if (!randomSpawn || !randomSpawn.IsA("SpawnLocation")) return;

			const forceField = new Instance("ForceField");
			humanoidRootPart.CFrame = randomSpawn.CFrame.add(new Vector3(0, 2, 0));
			forceField.Parent = character;
			Debris.AddItem(forceField, randomSpawn.Duration);

			clearCharacter(character);
			setAppearance(player, character, playerObject.data);

			character.Parent = characters;
			player.Character = character;
		});
	}
}
