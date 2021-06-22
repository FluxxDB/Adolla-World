local Knit = _G.Knit

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PlayerService

local RemoteEvent = require(Knit.Util.Remote.RemoteEvent)
local characterAssets = require(ReplicatedStorage.Shared:WaitForChild("characterAssets"))
local weightedPick = require(ReplicatedStorage.Shared:WaitForChild("weightedPick"))
local productIds = require(ReplicatedStorage.Shared:WaitForChild("productIds"))

local spinEvent = RemoteEvent.new()
local profiles, updateRemote
local spinTypes = {
    ["faces"] = 1183328433;
    ["generations"] = 1183328381;
    ["techniques"] = 1183328565;
}
local spinData = {
    ["faces"] = "faceSpins";
    ["generations"] = "generationSpins";
    ["techniques"] = "techniqueSpins";
}
local statData = {
    ["faces"] = "face";
    ["generations"] = "generation";
    ["techniques"] = "combatTechnique";
}

local MarketService = Knit.CreateService{
    Name = "MarketService";

    Client = {
        Spin = spinEvent;
    }
}

function PurchaseIdCheckAsync(profile, purchase_id, grant_product_callback) --> Enum.ProductPurchaseDecision
	-- Yields until the purchase_id is confirmed to be saved to the profile or the profile is released
	if profile:IsActive() ~= true then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	else
		local meta_data = profile.MetaData
        local local_purchase_ids = meta_data.MetaTags.ProfilePurchaseIds
		if local_purchase_ids == nil then
			local_purchase_ids = {}
			meta_data.MetaTags.ProfilePurchaseIds = local_purchase_ids
		end

        -- Granting product if not received:

        if table.find(local_purchase_ids, purchase_id) == nil then
			while #local_purchase_ids >= 50 do
				table.remove(local_purchase_ids, 1)
			end
			table.insert(local_purchase_ids, purchase_id)
			coroutine.wrap(grant_product_callback)()
		end

        -- Waiting until the purchase is confirmed to be saved:

        local result = nil
        local function check_latest_meta_tags()
			local saved_purchase_ids = meta_data.MetaTagsLatest.ProfilePurchaseIds
			if saved_purchase_ids ~= nil and table.find(saved_purchase_ids, purchase_id) ~= nil then
				result = Enum.ProductPurchaseDecision.PurchaseGranted
			end
		end

        check_latest_meta_tags()

        local release_connection = profile:ListenToRelease(function()
			result = result or Enum.ProductPurchaseDecision.NotProcessedYet
		end)

        local meta_tags_connection = profile.MetaTagsUpdated:Connect(function()
			check_latest_meta_tags()
		end)

        while result == nil do
			RunService.Heartbeat:Wait()
		end

        release_connection:Disconnect()
		meta_tags_connection:Disconnect()

        return result
	end
end

local function GrantProduct(player, profile, product_id)
	-- We shouldn't yield during the product granting process!
	local product_function = productIds[product_id]
	if product_function ~= nil then
		product_function(player, profile, updateRemote)
	else
		warn("ProductId " .. tostring(product_id) .. " has not been defined in Products table")
	end
end

local function ProcessReceipt(receipt_info)
	local player = Players:GetPlayerByUserId(receipt_info.PlayerId)
	if player == nil then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local playerObject = profiles[player]
    if not playerObject then
		return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local profile = playerObject.profile
	if playerObject.profile ~= nil then
		return PurchaseIdCheckAsync(
			profile,
			receipt_info.PurchaseId,
			function()
				GrantProduct(player, profile, receipt_info.ProductId)
			end
		)
	else
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end

function MarketService.KnitInit()
    PlayerService = Knit.Services.PlayerService
    profiles = PlayerService.profiles
    updateRemote = PlayerService.Client.Update
end

function MarketService.KnitStart()
    local debounces = {}

    spinEvent:Connect(function(player, spinType)
        local debounce = debounces[player]
        if debounce and debounce[spinType] then return end

        local playerData = profiles[player].data
        if not playerData then return end
        if not spinTypes[spinType] then return end
        local spinName = spinData[spinType]
        if playerData[spinName] > 0 then
            if not debounce then
                debounce = {}
                debounces[player] = debounce
            end

            debounce[spinType] = true
            delay(6, function()
                debounce[spinType] = nil
            end)

            local randomPick = weightedPick(characterAssets[spinType])
            playerData[spinName] = playerData[spinName] - 1
            if spinType == "faces" then
                playerData.character[statData[spinType]] = randomPick
            else
                playerData[statData[spinType]] = randomPick
            end

            spinEvent:Fire(player, spinType, randomPick)
        end
    end)

    MarketplaceService.ProcessReceipt = ProcessReceipt
end

return MarketService