local ReplicatedStorage = game:GetService("ReplicatedStorage")

return {
    [1183328433] = function(player, profile, updateRemote)
        local data = profile.Data
        data["faceSpins"] = data["faceSpins"] + 1
        updateRemote:Fire(player, data)
    end,

    [1183328381] = function(player, profile, updateRemote)
        local data = profile.Data
        data["generationSpins"] = data["generationSpins"] + 1
        updateRemote:Fire(player, data)
        print(data)
    end,

    [1183328565] = function(player, profile, updateRemote)
        local data = profile.Data
        data["techniqueSpins"] = data["techniqueSpins"] + 1
        updateRemote:Fire(player, data)
        print(data)
    end,


    [1183565642] = function(player, profile, updateRemote)
        local data = profile.Data
        data["faceSpins"] = data["faceSpins"] + 3
        updateRemote:Fire(player, data)
    end,

    [1183567986] = function(player, profile, updateRemote)
        local data = profile.Data
        data["generationSpins"] = data["generationSpins"] + 3
        updateRemote:Fire(player, data)
    end,

    [1183573020] = function(player, profile, updateRemote)
        local data = profile.Data
        data["techniqueSpins"] = data["techniqueSpins"] + 3
        updateRemote:Fire(player, data)
    end,


    [1183565791] = function(player, profile, updateRemote)
        local data = profile.Data
        data["faceSpins"] = data["faceSpins"] + 6
        updateRemote:Fire(player, data)
    end,

    [1183568207] = function(player, profile, updateRemote)
        local data = profile.Data
        data["generationSpins"] = data["generationSpins"] + 6
        updateRemote:Fire(player, data)
    end,

    [1183573175] = function(player, profile, updateRemote)
        local data = profile.Data
        data["techniqueSpins"] = data["techniqueSpins"] + 6
        updateRemote:Fire(player, data)
    end,
}