
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( 'player_extension.lua' )
AddCSLuaFile( 'cl_scores.lua' )

include( "shared.lua" )
include( "sv_spectator.lua" )
include( "round_controller.lua" )

function GM:Initialize()

	if ( GAMEMODE.GameLength > 0 ) then
		timer.Simple( GAMEMODE.GameLength * 60, function() GAMEMODE:EndOfGame( true ) end )
	end
	
	// If we're round based, wait 5 seconds before the first round starts
	if ( GAMEMODE.RoundBased ) then
		timer.Simple( 10, function() GAMEMODE:StartRoundBasedGame() end )
	end
	
end

function GM:InitPostEntity( )
    
    for  k, v in pairs( ents.FindByClass("item_*") ) do
    	v:Remove()
    end
    for  k, v in pairs( ents.FindByClass("weapon_*") ) do
    	v:Remove()
    end

end

function GM:PlayerDeathThink( pl )

	pl.DeathTime = pl.DeathTime or CurTime()
	local timeDead = CurTime() - pl.DeathTime
	
	// If we're in deathcam mode, promote to a generic spectator mode
	if ( GAMEMODE.DeathLingerTime > 0 && timeDead > GAMEMODE.DeathLingerTime && ( pl:GetObserverMode() == OBS_MODE_FREEZECAM || pl:GetObserverMode() == OBS_MODE_DEATHCAM ) ) then
		GAMEMODE:BecomeObserver( pl )
	end
	
	if ( pl:Team() == TEAM_HIDERS ) then return end
	
	// The gamemode is holding the player from respawning.
	// Probably because they have to choose a class..
	if ( !pl:CanRespawn() ) then return end

	// Don't respawn yet - wait for minimum time...
	if ( GAMEMODE.MinimumDeathLength ) then 
	
		pl:SetNWFloat( "RespawnTime", pl.DeathTime + GAMEMODE.MinimumDeathLength )
		
		if ( timeDead < pl:GetRespawnTime() ) then
			return
		end
		
	end

	// Force respawn
	if ( pl:GetRespawnTime() != 0 && GAMEMODE.MaximumDeathLength != 0 && timeDead > GAMEMODE.MaximumDeathLength ) then
		pl:Spawn()
		return
	end

	// We're between min and max death length, player can press a key to spawn.
	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
		pl:Spawn()
	end
	
end

function GM:GetFallDamage( ply, flFallSpeed )
	
	return 0
	
end

