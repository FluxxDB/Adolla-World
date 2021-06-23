-- Compiled with roblox-ts v1.1.1
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Networking_1 = TS.import(script, TS.getModule(script, "flamework").out).Networking
local t_1 = TS.import(script, TS.getModule(script, "t").lib.ts).t
local GlobalEvents = Networking_1.createEvent({
	hit = { t_1.instanceIsA("Humanoid") },
	ready = {},
}, {
	stateUpdate = { t_1.string, t_1.intersection(t_1.any, t_1.none) },
})
return {
	GlobalEvents = GlobalEvents,
}
