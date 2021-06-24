local ReplicatedStorage = game:GetService("ReplicatedStorage")

local characterAssets = require(ReplicatedStorage.Shared:WaitForChild("characterAssets"))
local weightedPick = require(ReplicatedStorage.Shared:WaitForChild("weightedPick"))
--local inventory = require(script:WaitForChild("Inventory"))

local assets = ReplicatedStorage:WaitForChild("Assets")
local clothingsFolder = assets:WaitForChild("Clothing")
local skinTonesFolder = assets:WaitForChild("SkinTone")
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

        local randomClothings = random:NextInteger(1, #clothingsFolder:GetChildren())
        characterData.shirt = clothingsFolder:FindFirstChild(randomClothings).Shirt.ShirtTemplate
        characterData.pants = clothingsFolder:FindFirstChild(randomClothings).Pants.PantsTemplate
        characterData.skinTone = skinTonesFolder:FindFirstChild(random:NextInteger(1, #skinTonesFolder:GetChildren())).Value
    end

    return setmetatable(self, playerObject)
end


return playerObject