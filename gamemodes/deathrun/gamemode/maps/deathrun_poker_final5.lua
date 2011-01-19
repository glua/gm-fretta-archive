
GM:AddWeapon(Vector(1421.28125, -1633.25, 780.03125))
GM:AddWeapon(Vector(1420.53125, -1596.625, 780.03125))
GM:AddWeapon(Vector(1417.78125, -1659.1875, 780.03125))
GM:AddWeapon(Vector(1349.4375, -1659.15625, 784.03125))
GM:AddWeapon(Vector(1349.4375, -1622.5, 784.03125))
GM:AddWeapon(Vector(1349.46875, -1580.6875, 784.03125))

GM:AddTouchEvents(Vector(1453.34375, -1629.875, 776.03125), 256, function(ply)
	ply:Give("weapon_smg1")
	ply:SetPos(Vector(1803.78125, -1547.21875, 774.03125))
end)

GM:AddTouchEvents(Vector(1445, 47, 937), 64, function(ply)
	ply:SetPos(Vector(1420, 224, 937))
end)

GM:AddTouchEvents(Vector(883.0625, -314.5313, 704.0313), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(916.5625, -234.9688, 704.0313), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(953.5000, -142.7500, 704.0313), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(810.6875, -434.6563, 704.0313), 64, function(ply)
	ply:SetPos(Vector(1015.6875, -548.2188, 704.03136))
end)
