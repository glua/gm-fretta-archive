//GM:Add3D2DScoreboard(Vector(-174.6,-678.1,190), Angle(0,-90,0))

GM:RemoveWeapon(Vector(-247, -1186, 408)) //Starting area ledge weapon
GM:RemoveWeapon(Vector(-4094.05, 2392.8, 209)) //Weapon on pole
GM:RemoveWeapon(Vector(-3735.68, 5208.03, 245.3)) //Room with squares on floor
GM:RemoveWeapon(Vector(-4305.9, 9906.4, 132.8)) //Breakable platform on corner
GM:RemoveWeapon(Vector(690.5, 11946.15, 205.5)) //Hovering hallway
GM:RemoveWeapon(Vector(-4040.9, 13807.05, 423.17)) //Weapons room -- CSS Weapons
GM:RemoveWeapon(Vector(-4040.5, 13515, 430)) //Weapons room -- CSS Weapons

//Death's Pole trap exploit
GM:AddTouchEvents(Vector(-4138.22, 2262.17, 461.7), 64, function(ply)
	ply:SetPos(Vector(-4223.67, 2129.04, 324.82))
end)

GM:AddTouchEvents(Vector(-4229.85, 2351.18, 461.7), 64, function(ply)
	ply:SetPos(Vector(-4223.67, 2129.04, 324.82))
end)

GM:AddTouchEvents(Vector(-4142.86, 2221.57, 461.7), 64, function(ply)
	ply:SetPos(Vector(-4223.67, 2129.04, 324.82))
end)

GM:AddTouchEvents(Vector(-4140.9, 2348.8, 461.7), 64, function(ply)
	ply:SetPos(Vector(-4223.67, 2129.04, 324.82))
end)