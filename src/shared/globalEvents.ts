import { Flamework } from "@rbxts/flamework";

interface ServerEvents {
	hit(humanoid: Humanoid): void;
	ready(): void;
}

interface ClientEvents {
	stateUpdate(key: string, value: unknown): void;
}

export const GlobalEvents = Flamework.createEvent<ServerEvents, ClientEvents>();
