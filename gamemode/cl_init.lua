include("shared.lua")

include("hud/hud.lua")
include("hud/view.lua")

include("menu/main_menu.lua")

function GM:PlayerSpawn(ply)

    ply.InMainMenu = false
    ply.LookingOverRightShoulder = false

end