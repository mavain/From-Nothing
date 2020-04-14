local backHUDEmitterModel = ClientsideModel("models/props_combine/tprotato1.mdl")
backHUDEmitterModel:SetNoDraw(true)
backHUDEmitterModel:SetModelScale(0.1)

hook.Add("PostPlayerDraw", "DrawBodyHUDEmitter", function(ply)

    local boneMatrix = ply:GetBoneMatrix(ply:LookupBone("ValveBiped.Bip01_Spine2"))

    local offsetvec = Vector( 3, -3.5, 0 )
    local offsetang = Angle( 180, 90, -90 )

    local modelPos, modelAng = LocalToWorld(offsetvec, offsetang, boneMatrix:GetTranslation(), boneMatrix:GetAngles())

    backHUDEmitterModel:SetPos(modelPos)
    backHUDEmitterModel:SetAngles(modelAng)
    backHUDEmitterModel:SetupBones()
    backHUDEmitterModel:DrawModel()

end)

surface.CreateFont("HUDFontHealth", {
    font = "Verdana Bold",
    extended = false,
    size = 20,
    weight = 500,
    antialias = true,
    scanlines = 2.3
})

hook.Add("PostDrawTranslucentRenderables", "DrawBodyHUD", function(drawDepth, drawSkybox)

    local ply = LocalPlayer()

    if not ply:Alive() then return end

    local spinePos, spineAng = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine2"))

    spineAng:RotateAroundAxis(spineAng:Up(), -80)
    spineAng:RotateAroundAxis(spineAng:Right(), -90)

    spinePos = spinePos + spineAng:Up() * 6.5 - spineAng:Right() * 8

    cam.Start3D2D(spinePos, spineAng, 0.05)

        local health = ply:Health() / ply:GetMaxHealth()

        local width = 100 * 2

        local color = LerpVector(math.random(), Vector(50, 230, 255), Vector(100, 255, 255))
        local alpha = Lerp(math.random(), 100, 150) * 0.05
        local glitchx = math.random() * 2 - 1
        local glitchy = math.random() * 2 - 1

        if health <= 0.5 then
            local mult = 1 + ((1 - health) - 0.5) * 10
            glitchx = glitchx * mult
            glitchy = glitchy * mult
        end

        --Draw health background
        surface.SetDrawColor( color.x, color.y, color.z, alpha )
        surface.DrawRect( -width / 2, -5, width, 40 )
        surface.DrawRect( -width / 2 + glitchx, -5 + glitchy, width, 40 )
        
        local alphaIntensityModifier = 10

        local healthColor = Vector(50, 230, 255)
        if health < 0.8 and health >= 0.5 then
            healthColor = LerpVector((health - 0.5) * 4, Vector(255, 255, 0), Vector(50, 230, 255))
        end
        if health < 0.5 then
            healthColor = LerpVector((health - 0.3) * 5, Vector(255, 0, 0), Vector(255, 255, 0))
        end
        if health <= 0.3 then
            healthColor = Vector(255, 0, 0)
            local i = math.cos(RealTime() * 5) * 0.5 + 0.5
            alphaIntensityModifier = 10 + 30 * i
        end

        --Draw health
        surface.SetDrawColor(healthColor.x, healthColor.y, healthColor.z, alpha * alphaIntensityModifier)
        surface.DrawRect(-width / 2 + 5, 0, (width - 10) * health, 30)
        surface.DrawRect(-width / 2 + 5 + glitchx, glitchy, (width - 10) * health, 30)

        if health <= 0.3 then
            draw.SimpleText("HEALTH CRITICAL", "HUDFontHealth", glitchx, 15 + glitchy, Color(255,255,255,alpha * alphaIntensityModifier), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            local current = ply:Health()
            local max = ply:GetMaxHealth()
            local str = "HEALTH: " .. current .. "/" .. max
            draw.SimpleText(str, "HUDFontHealth", glitchx, 15 + glitchy, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

    cam.End3D2D()

end)

local hiddenElements = {
    ["CHudBattery"] = true,
    ["CHudHealth"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudCrosshair"] = true
}

hook.Add("HUDShouldDraw", "HideDefaultHud", function(name)
    if hiddenElements[name] then return false end
end)