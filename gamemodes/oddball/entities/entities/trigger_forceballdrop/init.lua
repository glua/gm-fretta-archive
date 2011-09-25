ENT.Type = "brush"

function ENT:Touch( ent )
end

function ENT:StartTouch( ent )
	if ent:IsPlayer() and ent:Alive() then
		GAMEMODE:DropBall(ent)
	end
end

function ENT:EndTouch( ent )
end
