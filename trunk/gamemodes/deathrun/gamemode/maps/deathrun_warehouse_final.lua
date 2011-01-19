
GM:AddTouchEvents(Vector(3198.5625, -402.65625, 51.65625), 64, function(ply)
	ply:SetPos(Vector(3232.8125, -1131.5625, 1.5))
end)

GM:AddTouchEvents(Vector(3237.71875, -402.75, 51.6875), 64, function(ply)
	ply:SetPos(Vector(3232.8125, -1131.5625, 1.5))
end)

GM:AddTouchEvents(Vector(-5460, -1094, 10), 64, function(ply)
	if(ply:Team() == TEAM_DEATH) then
		ply:SetPos(Vector(-4638, -1104, 0.0313))
	end
end)

GM:AddTouchEvents(Vector(-5460, -1094, 50), 64, function(ply)
	if(ply:Team() == TEAM_DEATH) then
		ply:SetPos(Vector(-4638, -1104, 0.0313))
	end
end)

hook.Add("OnRoundChange", "DoorDestroyer", function()
	for k,v in pairs(ents.FindInSphere(Vector(2925.4897460938, -496.20233154297, 0.03125), 256)) do
		if(v:GetClass() == "func_door") then
			v:Remove()
		end
	end
end)
