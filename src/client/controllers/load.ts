import { Controller, OnStart } from "@rbxts/flamework";
import { client } from "shared/globalEvents";

@Controller({
	loadOrder: 0,
})
export class load implements OnStart {
	onStart() {
		wait(1);
		client.ready();
		client.spawn();
	}
}
