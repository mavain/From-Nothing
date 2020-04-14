
local oldPos = Vector(0, 0, 0)
local oldAngles = Angle(0, 0, 0)

function GM:CalcView(ply, pos, angles, fov, znear, zfar)
    
    local view = {}

    local headPos, headAng = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))

    local shoulderOffset = angles:Right() * 15
    if ply.LookingOverRightShoulder then
        shoulderOffset = -shoulderOffset
    end
    local desiredPos = headPos - angles:Forward() * 30 - shoulderOffset + angles:Up() * 5

    local delta = math.Clamp(RealFrameTime() * 15, 0, 1)

    local newPos = LerpVector(delta, oldPos, desiredPos)

    view.origin = newPos
    view.angles = angles
    view.fov = fov
    view.drawviewer = true

    oldPos = newPos
    oldAngles = newAngles

    return view

end

hook.Add("PlayerBindPress", "DrawViewOverRightShoulder", function(ply, bind, pressed)
    if bind == "gmod_undo" or bind == "undo" then
        ply.LookingOverRightShoulder = not ply.LookingOverRightShoulder
    end
end)