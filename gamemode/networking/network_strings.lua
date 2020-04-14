util.AddNetworkString("fn_mainmenu")

net.Receive("fn_mainmenu", function(len, ply)
    ply.InMainMenu = net.ReadBool()
end)