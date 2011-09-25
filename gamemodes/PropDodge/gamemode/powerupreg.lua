//Powerup register file
//powerup:Register( id, texture, function on_spawn, function on_touch )

resource.AddFile( "materials/powerups/speedup.vmt" )
resource.AddFile( "materials/powerups/flight.vmt" )
resource.AddFile( "materials/powerups/gravity.vmt" )
resource.AddFile( "materials/powerups/melons.vmt" )

function pu_SpeedUp( ent, ply )

	GAMEMODE:SetPlayerSpeed(ply, 500, 700)
	ply:PrintMessage( HUD_PRINTTALK, "You have gained the power of speed for 10 seconds!" )
	
	timer.Simple( 10, function() GAMEMODE:SetPlayerSpeed(ply, 250, 500)
	ply:PrintMessage( HUD_PRINTTALK, "You have lost the power of speed." ) end )

end

function pu_revSpeedUp( ent, ply, att )

	GAMEMODE:SetPlayerSpeed( ply, 150, 250 )
	ply:PrintMessage( HUD_PRINTTALK, att:Name() .. " hit you with a speed powerup! You are now slower!" )
	att:PrintMessage( HUD_PRINTTALK, ply:Name() .. " was hit with your speed powerup! They are now slower!" )
	
	timer.Simple( 10, function() GAMEMODE:SetPlayerSpeed(ply, 250, 500)
	ply:PrintMessage( HUD_PRINTTALK, "Your speed is normal again." ) end )
	
end

powerup:Register( 1, "powerups/speedup", nil, pu_SpeedUp, pu_revSpeedUp )

function pu_Flight( ent, ply )

	ply:SetMoveType(MOVETYPE_FLY)
	
	ply:PrintMessage( HUD_PRINTTALK, "You have gained the power of flight for 10 seconds!" )
	
	timer.Simple( 10, function() ply:SetMoveType(MOVETYPE_WALK) 
	ply:PrintMessage( HUD_PRINTTALK, "You have lost the power of flight." ) end )

end

function pu_revFlight( ent, ply, att )

	ply:SetJumpPower( 0 )
	ply:PrintMessage( HUD_PRINTTALK, att:Name() .. " hit you with a flight powerup! You can't jump!" )
	att:PrintMessage( HUD_PRINTTALK, ply:Name() .. " was hit with your flight powerup! They can't jump!" )
	
	timer.Simple( 10, function() ply:SetJumpPower( 160 )
	ply:PrintMessage( HUD_PRINTTALK, "Your jumping is normal again." ) end )
	
end

powerup:Register( 2, "powerups/flight", nil, pu_Flight, pu_revFlight )

function pu_Melon( ent, ply )
	
	ply:PrintMessage( HUD_PRINTTALK, "You have gained melons!" )
	
	for i=1,10 do
		SpawnProp(ply, 12)
	end

end

function pu_revMelon( ent, ply, att )

	ply:PrintMessage( HUD_PRINTTALK, att:Name() .. " hit you with a melon powerup! You're a melon!" )
	att:PrintMessage( HUD_PRINTTALK, ply:Name() .. " was hit with your melon powerup! They're a melon!" )
	
	local melon = ents.Create("prop_physics")
	melon:SetPos(ply:GetPos() + Vector(0,0,25))
	melon:SetAngles(ply:EyeAngles())
	melon:SetModel("models/props_junk/watermelon01.mdl")
	melon:Spawn()
	melon:Activate()
	melon:GetPhysicsObject():Wake()
	
	ply:SpectateEntity(melon)
	ply:Spectate(OBS_MODE_CHASE)
	
	timer.Simple( 10, function() 
		ply:UnSpectate()
		ply:Spawn()
		ply:PrintMessage( HUD_PRINTTALK, "Your back to normal." ) 
	end )
	
end

powerup:Register( 4, "powerups/flight", nil, pu_Melon, pu_revMelon )

function pu_Gravity( ent, ply )

	ply:SetGravity( 0.5 )
	ply:PrintMessage( HUD_PRINTTALK, "You now have low gravity for 10 seconds!" )
	
	timer.Simple( 10, function() ply:SetGravity( 1 )
	ply:PrintMessage( HUD_PRINTTALK, "Your gravity is now normal." ) end )

end

function pu_revGravity( ent, ply, att )

	ply:SetGravity( 2 )
	ply:PrintMessage( HUD_PRINTTALK, att:Name() .. " hit you with a gravity powerup! Your gravity is very high!" )
	att:PrintMessage( HUD_PRINTTALK, ply:Name() .. " was hit with your gravity powerup! Their gravity is very high!" )
	
	timer.Simple( 10, function() ply:SetGravity( 1 )
	ply:PrintMessage( HUD_PRINTTALK, "Your gravity is now normal." ) end )

end

powerup:Register( 3, "powerups/gravity", nil, pu_Gravity, pu_revGravity )

function pu_Melon( ent, ply )
	
	ply:PrintMessage( HUD_PRINTTALK, "You have gained melons!" )
	
	for i=1,10 do
		SpawnProp(ply, 12)
	end

end

function pu_revMelon( ent, ply, att )

	ply:PrintMessage( HUD_PRINTTALK, att:Name() .. " hit you with a melon powerup! You're a melon!" )
	att:PrintMessage( HUD_PRINTTALK, ply:Name() .. " was hit with your melon powerup! They're a melon!" )
	
	local melon = ents.Create("prop_physics")
	melon:SetPos(ply:GetPos() + Vector(0,0,25))
	melon:SetAngles(ply:EyeAngles())
	melon:SetModel("models/props_junk/watermelon01.mdl")
	melon:Spawn()
	melon:Activate()
	melon:GetPhysicsObject():Wake()
	
	ply:SpectateEntity(melon)
	ply:Spectate(OBS_MODE_CHASE)
	ply:StripWeapons()
	
	timer.Simple( 10, function() 
		ply:UnSpectate()
		ply:Spawn()
		ply:PrintMessage( HUD_PRINTTALK, "Your back to normal." ) 
	end )
	
end

powerup:Register( 4, "powerups/melons", nil, pu_Melon, pu_revMelon )