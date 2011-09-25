
//Server

function GM:GravGunOnPickedUp( ply, ent )
	
	if ent:GetClass() != "sent_cactus" then return false end
	
	--if ply:GetCanAutoGrab() == false then
		if ValidEntity(ent) then
			
			timer.Simple(0.5, function() GAMEMODE:CaughtCactus(ply,ent) end)
		end
	--elseif ply:GetCanAutoGrab() == true then
		--return false
	--end
	
	return true
	
end

function GM:GravGunPunt( ply, ent )
	
	if ent:GetClass() != "sent_cactus" then return end
	
	/*if ent:GetCactusType() != "explosive" then
		if ply:GetCanAutoGrab() == false then
			if SERVER then DropEntityIfHeld( ent ) ent:SetColor(0,0,0,0) SafeRemoveEntity(ent.Trail) end
			return false
		end
	else
		ent:SetOwner(ply)
	end*/
	return true
	
end

