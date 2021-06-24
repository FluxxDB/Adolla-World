import { Flamework } from "@rbxts/flamework";

interface ServerEvents {
	hit(humanoid: Humanoid): void;
	ready(): void;
	spawn(): void;
}

interface ClientEvents {
	stateUpdate(key: string, value: unknown): void;
}

const GlobalEvents = Flamework.createEvent<ServerEvents, ClientEvents>();

export const server = GlobalEvents.server;
export const client = GlobalEvents.client;
