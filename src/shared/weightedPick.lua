local Rng = Random.new()

local Max = Rng:NextInteger(1, 75)
local Count = 0

return function (LootTable, Multiplier)
    Multiplier = Multiplier or 1
    Count += 1

    if Count >= Max then
        Count = 0
        Max = Rng:NextInteger(1, 75)
        Rng = Random.new(os.time() + Rng:NextInteger(0, 0xFFFFFFFF))
    end

    local TotalWeight = 0
    for Index, Weight in pairs(LootTable) do
        if Index == 0 or Weight == 1 then
            TotalWeight += Weight
        else
            TotalWeight += Weight * Multiplier
        end
    end

    local RandomWeight = Rng:NextNumber(0, TotalWeight)
    for Index, Weight in pairs(LootTable) do
        if RandomWeight <= Weight then
            return Index
        else
            RandomWeight -= Weight
        end
    end
end