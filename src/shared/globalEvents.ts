import { Flamework } from "@rbxts/flamework";

interface ServerEvents {
	ready(): void;
	spawn(): void;
}

interface ClientEvents {
	stateUpdate(key: string, value: DefaultData): void;
}

const GlobalEvents = Flamework.createEvent<ServerEvents, ClientEvents>();

export const server = GlobalEvents.server;
export const client = GlobalEvents.client;
