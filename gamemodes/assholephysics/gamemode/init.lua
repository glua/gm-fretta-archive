
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "props.lua" )
AddCSLuaFile( "gibs.lua" )

include( "shared.lua" )
include( "ply_extension.lua" )
include( "tables.lua" )
include( "props.lua" )
include( "gibs.lua" )

function GM:AddTeamCash( teamnum, num )
	SetGlobalInt( "TeamCash"..teamnum, GetGlobalInt( "TeamCash"..teamnum ) + num )
end

function GM:GetTeamCash( teamnum )
	return GetGlobalInt( "TeamCash"..teamnum )
end

function GM:ResetTeamCash()

	SetGlobalInt( "TeamCash1", 0 )
	SetGlobalInt( "TeamCash2", 0 )
	
	for k,v in pairs( player.GetAll() ) do
		v:SetCash( 0 )
	end
	
end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end

	if GAMEMODE:GetTeamCash( TEAM_RED ) < GAMEMODE:GetTeamCash( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE )
	elseif GAMEMODE:GetTeamCash( TEAM_RED ) > GAMEMODE:GetTeamCash( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_RED )
	else
		GAMEMODE:RoundEndWithResult( ROUND_RESULT_DRAW )
	end

end

function GM:CheckRoundEnd()

end

function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()
	
	GAMEMODE:ResetTeamCash()

end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if not string.find( ent:GetClass(), "prop_phys" ) then return end
	
	ent.HP = ent.HP - dmginfo:GetDamage()
	ent:SetPhysicsAttacker( attacker )
	
	if ent.HP < 1 and attacker:IsPlayer() then
		
		attacker:DrawPrice( ent )
		ent:Break()
		
	end

end

function GM:GetFallDamage( ply, flFallSpeed )

	return flFallSpeed / 10
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if dmginfo:IsExplosionDamage() then
		ply:SetModel( table.Random( GAMEMODE.Corpses ) )
	end
	
	if attacker:IsPlayer() then
		attacker:HospitalBills( ply )
	end

	ply:CreateRagdoll()
	ply:AddDeaths( 1 )

end