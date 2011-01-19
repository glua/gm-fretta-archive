GM:AddWeapon(Vector(-767.8, 127.7, 10), "weapon_crowbar")

GM:RemoveWeapon(Vector(-734.96, 490.59, 148.24)) //Behind first trap

GM:AddTouchEvents(Vector(-688.21875, 478.59375, 32.03125), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(-740.84375, 476.46875, 32.03125), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(-769.78125, 476, 32.03125), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(-804.75, 475.40625, 32.03125), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(-839.65625, 474.84375, 32.03125), 64, function(ply)
	ply:Kill()
end)

GM:AddTouchEvents(Vector(-748.4375, 539.4375, 32.0313), 64, function(ply)
	ply:Kill()
end)