
function GM:OnSpawnMenuOpen()

    if not LocalPlayer():Alive() then return end

    gui.EnableScreenClicker(true)

    net.Start("fn_mainmenu")
    net.WriteBool(true)
    net.SendToServer()

    LocalPlayer().InMainMenu = true

    LocalPlayer():EmitSound("ambient/machines/wall_loop1.wav", 25, 150)
end

function GM:OnSpawnMenuClose()

    gui.EnableScreenClicker(false)

    net.Start("fn_mainmenu")
    net.WriteBool(false)
    net.SendToServer()

    LocalPlayer().InMainMenu = false

    LocalPlayer():StopSound("ambient/machines/wall_loop1.wav")
end

hook.Add("PostDrawTranslucentRenderables", "DrawMainMenu", function(drawDepth, drawSkybox)

    if not LocalPlayer().InMainMenu then return end

    if drawSkybox then return end

    local accentColor = Color(255, 150, 0, 50)

    local ply = LocalPlayer()

    local headPos, headAng = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1"))

    local fov = ply:GetFOV()
    local scale = 0.1 * fov / 100

    local panelPos = headPos + (EyeAngles():Forward() * 20 - EyeAngles():Right() * 70 + EyeAngles():Up() * 40) * scale * 10
    if ply.LookingOverRightShoulder then
        panelPos = headPos + (EyeAngles():Forward() * 30 + EyeAngles():Up() * 40) * scale * 10
    end

    local panelAng = Angle(EyeAngles())
    panelAng:RotateAroundAxis(panelAng:Forward(), 90)
    panelAng:RotateAroundAxis(panelAng:Right(), 80)
    if ply.LookingOverRightShoulder then
        panelAng:RotateAroundAxis(panelAng:Right(), 20)
    end

    local cursorToHolo = Matrix()
    cursorToHolo:Rotate(panelAng)
    cursorToHolo:Translate(panelPos)

    local mouseX, mouseY = gui.MousePos()
    local cursorVec = gui.ScreenToVector(mouseX, mouseY)


    cam.Start3D2D(panelPos, panelAng, scale)

        local glitchx = (math.random() * 2 - 1) * 5
        local glitchy = (math.random() * 2 - 1) * 5
        
        surface.SetDrawColor(accentColor.r, accentColor.g, accentColor.b, accentColor.a)
        surface.DrawRect(0, 0, 700, 300)
        surface.DrawRect(0 + glitchx, 0 + glitchy, 700, 300)

        local secondPanelOffset = 0
        if ply.LookingOverRightShoulder then secondPanelOffset = 400 end

        surface.DrawRect(secondPanelOffset, 310, 300, 300)
        surface.DrawRect(secondPanelOffset + glitchx, 310 + glitchy, 300, 300)

        local str = "MINERALS - " .. ply:GetNWInt("Minerals")

        draw.SimpleText(str, "HUDFontHealth", 10 + glitchx * 0.2, 10 + glitchy * 0.2, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        local holoCursorWorld = util.IntersectRayWithPlane(EyePos(), cursorVec, panelPos, panelAng:Up())
        if not holoCursorWorld then return end

        local holoCursorPos, holoCursorAng = WorldToLocal(holoCursorWorld, Angle(0, 0, 0), panelPos, panelAng)
        holoCursorPos = holoCursorPos * Vector(1, -1, 0)  / scale

        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawRect(holoCursorPos.x - 5 + glitchx * 0.2, holoCursorPos.y - 5 + glitchy * 0.2, 10, 10)
        

    cam.End3D2D()

end)