-- Compiled with roblox-ts v1.1.1
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework_1 = TS.import(script, TS.getModule(script, "flamework").out).Flamework
local _services_0 = TS.import(script, TS.getModule(script, "services"))
local Players = _services_0.Players
local RunService = _services_0.RunService
local Service = TS.import(script, TS.getModule(script, "flamework").out).Service
local ProfileService = TS.import(script, TS.getModule(script, "profileservice").src)
local DEFAULT_DATA = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "globalData").DEFAULT_DATA
local GlobalEvents = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "globalEvents").GlobalEvents
local playerObject = TS.import(script, game:GetService("ServerScriptService"), "TS", "modules", "playerObject").default
local isStudio = RunService:IsStudio()
local events = GlobalEvents.server
local datastore = ProfileService.GetProfileStore("AdollaWorld", DEFAULT_DATA)
local profiles = {}
local function loadData(player)
	local profile
	if isStudio then
		profile = datastore.Mock:LoadProfileAsync("Player_" .. tostring(player.UserId), "ForceLoad")
	else
		profile = datastore:LoadProfileAsync("Player_" .. tostring(player.UserId), "ForceLoad")
	end
	if not profile then
		return player:Kick("Data unable to load.")
	end
	profile:Reconcile()
	profile:ListenToRelease(function()
		if player:IsDescendantOf(Players) then
			player:Kick("Data loaded from somewhere else.")
		end
	end)
	if not player:IsDescendantOf(Players) then
		return profile:Release()
	end
	return profile
end
local MyService
do
	MyService = setmetatable({}, {
		__tostring = function()
			return "MyService"
		end,
	})
	MyService.__index = MyService
	function MyService.new(...)
		local self = setmetatable({}, MyService)
		self:constructor(...)
		return self
	end
	function MyService:constructor()
	end
	function MyService:onInit()
		events:connect("ready", function(player)
			local _1 = profiles
			local _2 = player
			if _1[_2] ~= nil then
				return nil
			end
			local profile = loadData(player)
			if not profile then
				return nil
			end
			local _3 = profiles
			local _4 = player
			local _5 = playerObject.new(player, profile)
			-- ▼ Map.set ▼
			_3[_4] = _5
			-- ▲ Map.set ▲
		end)
		Players.PlayerRemoving:Connect(function(player)
			local _1 = profiles
			local _2 = player
			local playerProfile = _1[_2]
			if not playerProfile then
				return nil
			end
			playerProfile.profile:Release()
			local _3 = profiles
			local _4 = player
			-- ▼ Map.delete ▼
			_3[_4] = nil
			-- ▲ Map.delete ▲
		end)
	end
end
Flamework_1.registerMetadata(MyService, {
	identifier = "N5",
	isExternal = false,
	decorators = { {
		identifier = "$:VW",
		config = {
			type = "Service",
			loadOrder = 0,
		},
	} },
	implements = { "$:Gp" },
})
return {
	profiles = profiles,
	MyService = MyService,
}
