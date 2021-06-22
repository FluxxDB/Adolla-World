local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local Knit = require(Shared:WaitForChild("Knit"))
Knit.Shared = Shared
Knit.Modules = script:WaitForChild("Modules", 5)
_G.Knit = Knit

for _, Module in ipairs(script:WaitForChild("Services", 5):GetChildren()) do
    if Module:IsA("ModuleScript") then
        require(Module)
    end
end

local Components = script:FindFirstChild("Components")
if Components then
    require(Knit.Util.Component).Auto(Components)
end

Knit.Start():andThen(function()
    print("[Knit Server]: Started")
    local Loaded = Instance.new("BoolValue")
    Loaded.Name = "Loaded"
    Loaded.Parent = ReplicatedStorage
end):catch(function(err)
    warn("[Knit Server]: Failed to initialize")
    warn(tostring(err))
end)