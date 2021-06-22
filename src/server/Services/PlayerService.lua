local Knit = _G.Knit

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local isStudio = RunService:IsStudio()
local global = require(Knit.Shared.globalData)
local RemoteEvent = require(Knit.Util.Remote.RemoteEvent)

local PlayerObject = require(Knit.Modules.playerObject)
local ProfileService = require(Knit.Modules.ProfileService)
local datastore = ProfileService.GetProfileStore("Data"..global.DATA_VERSION, global.DEFAULT_DATA)

local profiles = {}
local readyPlayers = {}
local readyEvent = RemoteEvent.new()
local updateEvent = RemoteEvent.new()

local PlayerService = Knit.CreateService{
    Name = "PlayerService";
    profiles = profiles;

    Client = {
        Ready = readyEvent;
        Update = updateEvent;
    }
}


function loadData(player)
    local profile

    if isStudio then
        profile = datastore.Mock:LoadProfileAsync("Player_"..player.UserId, "ForceLoad")
    else
        profile = datastore:LoadProfileAsync("Player_"..player.UserId, "ForceLoad")
    end

    if not profile then
        return player:Kick("Data unable to load. Contact devs.")
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

function PlayerService.KnitInit()
    readyEvent:Connect(function(player)
        if table.find(readyPlayers, player) then return end
        table.insert(readyPlayers, player)

        local profile = loadData(player)
        if not profile then return end

        local playerProfile = PlayerObject.new(player, profile)
        profiles[player] = playerProfile
        readyEvent:Fire(player, playerProfile.data)
    end)

    Players.PlayerRemoving:Connect(function(player)
        local playerProfile = profiles[player]
        if playerProfile then
            playerProfile.profile:Release()
            table.remove(readyPlayers, table.find(readyPlayers, player))
        end
    end)
end

return PlayerService