AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("hud/hud.lua")
AddCSLuaFile("hud/view.lua")

AddCSLuaFile("menu/main_menu.lua")

include("shared.lua")

include("networking/network_strings.lua")

function GM:PlayerSpawn(ply)
    ply:Give("weapon_ar2")
    ply:Give("weapon_pistol")
    ply:Give("weapon_physgun")
    ply:Give("weapon_pickaxe")
    ply:Give("weapon_rpg")
    ply:Give("weapon_smg")

    ply:SetModel("models/player/Group02/male_04.mdl")

    ply:SetupHands()

    ply:SetNWInt("Minerals", 0)

    ply.InMainMenu = false
end

function GM:PlayerSetHandsModel(ply, ent)
    
    local plyModelName = player_manager.TranslateToPlayerModelName(ply:GetModel())
    local info = player_manager.TranslatePlayerHands(plyModelName)

    if info then
        ent:SetModel(info.model)
        ent:SetSkin(info.skin)
        ent:SetBodyGroups(info.body)
    end

end