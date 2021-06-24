local Knit = _G.Knit

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService

local RemoteEvent = require(Knit.Util.Remote.RemoteEvent)

local assets = ReplicatedStorage:WaitForChild("Assets")
local clothingsFolder = assets:WaitForChild("Clothing")
local skinTones = assets:WaitForChild("SkinTone")

local customizeEvent = RemoteEvent.new()
local profiles

local CustomizationService = Knit.CreateService{
    Name = "CustomizationService";
    
    Client = {
        Customize = customizeEvent;
    }
}

function CustomizationService.KnitInit()
    PlayerService = Knit.Services.PlayerService
    profiles = PlayerService.profiles
end

function CustomizationService.KnitStart()
    customizeEvent:Connect(function(player, pathString)
        local characterData =  profiles[player].data.character
        if not characterData then return end 

        local parent = string.match(pathString, "%a+")
        local index = string.match(pathString, "%d+")
        if index == "0" and (parent == "bodyAccessory" or parent == "headAccessory") then
            characterData[parent] = index
            return
        end

        local folder = assets:FindFirstChild(parent)
        if not folder or folder.Name == "Gacha" then return end
        local object = folder:FindFirstChild(index)
        if not object then return end

        if parent == "hairColor" then
            local hairColor = characterData.hairColor
            hairColor.r = object.Value.R
            hairColor.g = object.Value.G
            hairColor.b = object.Value.B
            return
        end

        if parent == "clothing" then
            characterData.Shirt = clothingsFolder:FindFirstChild(index).Shirt.ShirtTemplate
            characterData.Pants = clothingsFolder:FindFirstChild(index).Pants.PantsTemplate
        end

        if parent == "skinTone" then
            characterData.skinTone = skinTones:FindFirstChild(index).Value
        end

        characterData[parent] = index
    end)
end

return CustomizationService