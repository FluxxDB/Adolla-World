-- Compiled with roblox-ts v1.1.1
local PlayerObject
do
	PlayerObject = setmetatable({}, {
		__tostring = function()
			return "PlayerObject"
		end,
	})
	PlayerObject.__index = PlayerObject
	function PlayerObject.new(...)
		local self = setmetatable({}, PlayerObject)
		self:constructor(...)
		return self
	end
	function PlayerObject:constructor(player, profile)
		self.player = player
		self.profile = profile
		self.data = profile.Data
	end
end
return {
	default = PlayerObject,
}
