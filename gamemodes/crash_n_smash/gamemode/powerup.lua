
GM.Powerups = {
	["highjump"] = { mat = "models/shiny", trail = { mat = "trails/smoke.vmt", color = Color(255,255,255) } },
	["eyelaser"] = { mat = "models/props_combine/stasisshield_sheet", trail = { mat = "trails/laser.vmt", color = Color(0,255,255) } },
	["invisibility"] = { mat = "models/shadertest/shader3", trail = { mat = "trails/tube.vmt", color = Color(255,255,255) } },
	["crowbarfrenzy"] = { mat = "models/props_lab/tank_glass001", trail = { mat = "trails/smoke.vmt", color = Color(255,150,0) } },
	["harden"] = { mat = "brick/brick_model", trail = { mat = "trails/smoke.vmt", color = Color(140, 50,0) } }
}

function GM:CreatePowerup( type )

	local pos = self.PowerupSpawn:GetPos()
	local pick = ""
	
	if type and self.Powerups[type] then
		pick = type
	else
		local randpow = table.Random(self.Powerups)
		for k, v in pairs(self.Powerups) do
			if v == randpow then
				pick = k
				break
			end
		end
	end
	
	local powerup = self.Powerups[pick]

	print("Spawning powerup "..pick)
	
	local ent = ents.Create("cns_powerup")
	ent:SetPos( pos )
	ent:Spawn()
	ent:SetPowerupType( pick )
	
	ent.trail = util.SpriteTrail( ent, 0, powerup.trail.color, false, 16, 0, 5, 1/32 , powerup.trail.mat )
	ent:SetMaterial(powerup.mat)
	ent:SetParticleColor( powerup.trail.color )

	self.CurrentPowerup = ent

	for k, v in pairs(player.GetAll()) do
		if not v.powerupnoted then
			v:Notify("A powerup appeared in the center!", NOTIFY_GENERIC)
			v.powerupnoted = true
		end
	end
	
end

function GM:ActivatePowerup( type, tm, duration, no_reset )

	print("Activating powerup "..type.." for "..team.GetName(tm).."!")

	local length = duration or 20
	local powerup = self.Powerups[type]
	
	teaminfo[tm].Powerup = type
	
	if type == "invisibility" then
	
		for k, pl in pairs(team.GetPlayers(tm)) do
			if pl:Alive() then 
				pl:SetPowerup( type )
				pl:SetWalkSpeed( 350 )
				pl:SetRunSpeed( 350 )
				pl:Notify("INVISIBILITY POWER for "..length.." seconds!", NOTIFY_CLEANUP)
				pl:SetMaterial(powerup.mat)
				if not pl:IsAbsorbed() then
					pl:CreateTrail()
				end
			end
		end	
		
		timer.Simple(length,function( tm )
			for k, pl in pairs(team.GetPlayers(tm)) do
				if pl:GetPowerup() != "none" then
					pl:SetPowerup( "none" )
					pl:Notify("Power expired!", NOTIFY_UNDO)
					pl:SetWalkSpeed( 300 )
					pl:SetRunSpeed( 300 )
					pl:SetMaterial("")
					pl:RemoveTrail()
				end
			end
			teaminfo[tm].Powerup = "none"
		end, tm)
		
	elseif type == "eyelaser" then

		for k, pl in pairs(team.GetPlayers(tm)) do
			if pl:Alive() then 
				pl:SetPowerup( type )
				pl:Notify("EYE LASER POWER for "..length.." seconds!", NOTIFY_CLEANUP)
				pl:SetMaterial(powerup.mat)
				if not pl:IsAbsorbed() then
					pl:CreateEyeLaser()
				end
			end
		end	
		
		timer.Simple(length,function( tm )
			for k, pl in pairs(team.GetPlayers(tm)) do
				if pl:GetPowerup() != "none" then
					pl:SetPowerup( "none" )
					pl:SetMaterial("")
					pl:Notify("Power expired!", NOTIFY_UNDO)
					pl:RemoveEyeLaser()
				end
			end
			teaminfo[tm].Powerup = "none"
		end, tm)
		 
	elseif type == "highjump" then
	
		for k, pl in pairs(team.GetPlayers(tm)) do
			if pl:Alive() then 
				pl:SetPowerup( type )
				pl:SetMaterial(powerup.mat)
				pl:Notify("JUMP POWER for "..length.." seconds!", NOTIFY_CLEANUP)
				pl:SetJumpPower( 450 )
			end
		end	
		
		timer.Simple(length,function( tm )
			for k, pl in pairs(team.GetPlayers(tm)) do
				if pl:GetPowerup() != "none" then
					pl:SetPowerup( "none" )
					pl:SetMaterial( "" )
					pl:Notify("Power expired!", NOTIFY_UNDO)
					pl:SetJumpPower( 160 )
				end
			end
			teaminfo[tm].Powerup = "none"
		end, tm)
		
	elseif type == "harden" then
	
		for k, pl in pairs(team.GetPlayers(tm)) do
			if pl:Alive() then 
				pl:SetPowerup( type )
				pl:Notify("HARDEN POWER for "..length.." seconds!", NOTIFY_CLEANUP)
				pl:SetMaterial( powerup.mat )
				pl:GodEnable()
			end
		end	
		
		timer.Simple(length,function( tm )
			for k, pl in pairs(team.GetPlayers(tm)) do
				if pl:GetPowerup() != "none" then
					pl:SetPowerup( "none" )
					pl:Notify("Power expired!", NOTIFY_UNDO)
					pl:SetMaterial( "" )
					pl:GodDisable()
				end
			end
			teaminfo[tm].Powerup = "none"
		end, tm)
		
	elseif type == "crowbarfrenzy" then
	
		for k, pl in pairs(team.GetPlayers(tm)) do
			if pl:Alive() then 
				pl:SetPowerup( type )
				pl:SetMaterial(powerup.mat)
				pl:Notify("CROWBAR FRENZY POWER for "..length.." seconds!", NOTIFY_CLEANUP)
				pl:SetWalkSpeed( 400 )
				pl:SetRunSpeed( 400 )
			end
		end	
		
		timer.Simple(length,function( tm )
			for k, pl in pairs(team.GetPlayers(tm)) do
				if pl:GetPowerup() != "none" then
					pl:SetPowerup( "none" )
					pl:SetMaterial( "" )
					pl:Notify("Power expired!", NOTIFY_UNDO)
					pl:SetWalkSpeed( 300 )
					pl:SetRunSpeed( 300 )
				end
			end
			teaminfo[tm].Powerup = "none"
		end, tm)

	end
	
	if not no_reset then
		timer.Destroy("powerupspawn")
		timer.Create("powerupspawn", 45+math.random(0,15), 1, GAMEMODE.CreatePowerup, GAMEMODE)
	end
	
end


