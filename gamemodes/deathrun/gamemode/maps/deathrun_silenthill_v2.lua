
GM:RemoveWeapon(Vector(1774, -12, 104))
GM:RemoveWeapon(Vector(1758, 35, 104))
GM:RemoveWeapon(Vector(1820, -15, 104))
GM:RemoveWeapon(Vector(1821, 35, 104))

-- Gay People get the gun here and act cool
GM:AddTouchEvents(Vector(1774, -12, 104), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(1758, 35, 104), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(1820, -15, 104), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(1821, 35, 104), 64, function(ply)
	ply:Kill()
end)

-- Gay People stand here and act cool
GM:AddTouchEvents(Vector(1761, -60, 48), 64, function(ply)
	ply:Kill()
end)

-- First
GM:AddTouchEvents(Vector(855, -89, 40), 64, function(ply)
	ply:SetPos(Vector(979, -92, 40))
end)

-- Second
GM:AddTouchEvents(Vector(1696, -1108, 40), 64, function(ply)
	ply:SetPos(Vector(1691, -1233, 40))
end)

-- Third w/ Wooden door + laser
GM:AddTouchEvents(Vector(1699, -1883, 40), 64, function(ply)
	ply:SetPos(Vector(1696, -1937, 40))
end)

-- Fourth
GM:AddTouchEvents(Vector(-814, -2115, -600), 64, function(ply)
	ply:SetPos(Vector(-821, -2029, -600))
end)
