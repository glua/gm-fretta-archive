GM:RemoveWeapon(Vector(-2, 4449.63, 28)) // Top Secret Edge
GM:RemoveWeapon(Vector(-14.57, -583.95, -740)) // Middle Secret Edge

// Boulders
GM:AddWeapon(Vector(-1448, -944, -1779.6875))

// Knife
GM:AddWeapon(Vector(-1536, 3152, -1983.96875))
GM:AddWeapon(Vector(-1536, 4016, -1983.96875))

// Bunny Hop
GM:AddWeapon(Vector(-1448.34375, 1023.9375, -2367.96875))

// Teleport fixes -- Remove ChatPrints once done testing
GM:AddTouchEvents(Vector(242, 2545, -2100), 32, function(ply)
	ply:SetPos(Vector(242, 2545, -2223))
	ply:ChatPrint("T1")
end)

GM:AddTouchEvents(Vector(124, 2545, -2100), 32, function(ply)
	ply:SetPos(Vector(124, 2545, -2223))
	ply:ChatPrint("T2")
end)

GM:AddTouchEvents(Vector(17, 2545, -2100), 32, function(ply)
	ply:SetPos(Vector(17, 2545, -2223))
	ply:ChatPrint("T3")
end)

GM:AddTouchEvents(Vector(-99, 2545, -2100), 32, function(ply)
	ply:SetPos(Vector(-99, 2545, -2223))
	ply:ChatPrint("T4")
end)

GM:AddTouchEvents(Vector(242, 2657, -2100), 32, function(ply)
	ply:SetPos(Vector(242, 2657, -2223))
	ply:ChatPrint("T5")
end)

GM:AddTouchEvents(Vector(124, 2657, -2100), 32, function(ply)
	ply:SetPos(Vector(124, 2657, -2223))
	ply:ChatPrint("T6")
end)

GM:AddTouchEvents(Vector(17, 2657, -2100), 32, function(ply)
	ply:SetPos(Vector(17, 2657, -2223))
	ply:ChatPrint("T7")
end)

GM:AddTouchEvents(Vector(-99, 2657, -2100), 32, function(ply)
	ply:SetPos(Vector(-99, 2657, -2223))
	ply:ChatPrint("T8")
end)

hook.Add( "InitPostEntity", "FixEnts", function()
     
    for _,ent in ipairs( ents.FindByClass( "player_speedmod" ) ) do
        ent:SetKeyValue( "spawnflags", "0" )
    end
     
end )