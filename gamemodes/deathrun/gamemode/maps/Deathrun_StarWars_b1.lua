
GM:AddWeapon(Vector(2362.0640, -1001.3624, -595.0938))
GM:AddWeapon(Vector(4205.3486, 431.1343, 96.9433))

GM:AddTouchEvents(Vector(4203.5034, 432.2567, 67.0313), 64, function(ply)
	if(ply:Team() == TEAM_RUNNER) then
		ply:SetPos(Vector(4094.6521, 274.8124, 94.1212))
	end
end)