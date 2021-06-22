local ReplicatedStorage = game:GetService("ReplicatedStorage")

local characterAssets = require(ReplicatedStorage.Shared:WaitForChild("characterAssets"))
local weightedPick = require(ReplicatedStorage.Shared:WaitForChild("weightedPick"))
--local inventory = require(script:WaitForChild("Inventory"))

local assets = ReplicatedStorage:WaitForChild("Assets")
local clothingsFolder = assets:WaitForChild("Clothing"):GetChildren()
local skinTonesFolder = assets:WaitForChild("SkinTone"):GetChildren()
local random = Random.new(os.clock())

local playerObject = {}
playerObject.__index = playerObject

function playerObject.new(player, profile)
    local data = profile.Data
    local self = {
        player = player;
        profile = profile;
        data = data;

        --inventory = inventory.new(data)
    }

    local characterData = data.character
    if characterData.lastName == "" then
        characterData.lastName = weightedPick(characterAssets.lastNames)
        characterData.face = weightedPick(characterAssets.faces)
        characterData.clothing = random:NextInteger(1, #clothingsFolder)
        characterData.skinTone = random:NextInteger(1, #skinTonesFolder)
    end

    return setmetatable(self, playerObject)
end


return playerObject