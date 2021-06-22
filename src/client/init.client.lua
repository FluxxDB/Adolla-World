local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local Knit = require(Shared:WaitForChild("Knit"))
Knit.Shared = Shared
Knit.Modules = script:WaitForChild("Modules", 5)
_G.Knit = Knit

for _, Module in ipairs(script:WaitForChild("Controllers", 5):GetChildren()) do
    if Module:IsA("ModuleScript") then
        require(Module)
    end
end

local Components = script:WaitForChild("Components", 5)
if Components then
    require(Knit.Util.Component).Auto(Components)
end

ReplicatedStorage:WaitForChild("Loaded", 60)

Knit.Start():andThen(function()
    print("[Knit Client]: Started")
end):catch(function(err)
    warn("[Knit Client]: Failed to initialize")
    warn(tostring(err))
end)