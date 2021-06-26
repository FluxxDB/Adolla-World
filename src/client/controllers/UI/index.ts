import { Controller, OnStart } from "@rbxts/flamework";
import { client } from "shared/globalEvents";

@Controller({
	loadOrder: 1,
})
export class e implements OnStart {
	onStart() {}
}
