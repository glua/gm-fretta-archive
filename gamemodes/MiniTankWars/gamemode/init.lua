/*
MiniTank Wars
Copyright (c) 2010 BMCha
This gamemode is licenced under the MIT License, reproduced in shared.lua
------------------------
init.lua
	-Gamemode serverside init
*/

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function GM:ChatBroadcast(text)
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint(text)
	end
end

PowerupEnts = {}
PowerupEnts[0]="Powerup_SpeedBoost"
PowerupEnts[1]="Powerup_SpeedBoost"
PowerupEnts[2]="Powerup_Repair"
PowerupEnts[3]="Powerup_Repair"
PowerupEnts[4]="Powerup_Ammo"
PowerupEnts[5]="Powerup_Ammo"
PowerupEnts[6]="Powerup_AP"
PowerupEnts[7]="Powerup_QuickReload"
function GM:PowerupSpawn()
	if GetGlobalInt("ActivePowerups") < 12 then
		local PU = ents.Create(table.Random(PowerupEnts)) 
		local SpawnLoc=table.Random(ents.FindByClass("Powerup_Spawn")):GetPos()
		PU:SetPos(SpawnLoc)
		PU:SetAngles(Angle(0, math.random(359), 0))
		PU:SetVelocity(Vector(math.random(1000)-500, math.random(1000)-500, -5))
		PU:Spawn()
		SetGlobalInt("ActivePowerups",GetGlobalInt("ActivePowerups")+1)
	end
end

function GM:InitPostEntity()
	SetGlobalInt("ActivePowerups",0)
	GAMEMODE:PowerupSpawn()
	timer.Create("PowerupSpawnTimer", 8, 0, function() GAMEMODE:PowerupSpawn() end)
end

// This is called every second to see if we can end the round
function GM:CheckRoundEnd()
	if ( !GAMEMODE:InRound() ) then return end 
	if team.GetScore(TEAM_USA) >= 40 then
		GAMEMODE:RoundEndWithResult( TEAM_USA )
	elseif team.GetScore(TEAM_USSR) >= 40 then
		GAMEMODE:RoundEndWithResult(TEAM_USSR)
	end
end

// Called when the round ends
function GM:OnRoundEnd( num )
	if !(team.GetScore(TEAM_USA) >= 40 or team.GetScore(TEAM_USSR) >= 40) then
		if team.GetScore(TEAM_USA) > team.GetScore(TEAM_USSR) then
			GAMEMODE:RoundEndWithResult( TEAM_USA )
		elseif team.GetScore(TEAM_USA) < team.GetScore(TEAM_USSR) then
			GAMEMODE:RoundEndWithResult( TEAM_USA )
		else  //tie!?!?
			GAMEMODE:RoundEnd()
		end
	end
	
	for k,v in pairs( player.GetAll() ) do
		 v:SetFrags( 0 ) // Reset their frags for next round
	end
	team.SetScore(TEAM_USA, 0)
	team.SetScore(TEAM_USSR, 0)
	SetGlobalInt("ActivePowerups",0)
	game.CleanUpMap()
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )
	ply:CreateRagdoll()
	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:AddDeaths( 1 )	
	if ( attacker:IsValid() && attacker:IsPlayer() ) then	
		if ( attacker == ply ) then		
			if ( GAMEMODE.TakeFragOnSuicide ) then
							attacker:AddFrags( -1 )			
				if ( GAMEMODE.TeamBased && GAMEMODE.AddFragsToTeamScore ) then
					team.AddScore( attacker:Team(), -1 )
				end		
			end			
		else		
			attacker:AddFrags( 1 )			
			if ( GAMEMODE.TeamBased && GAMEMODE.AddFragsToTeamScore ) then
				team.AddScore( attacker:Team(), 1 )
			end		
		end		
	end	
	if ( GAMEMODE.EnableFreezeCam && IsValid( attacker ) && attacker != ply ) then	
		ply:SpectateEntity( attacker )
		ply:Spectate( OBS_MODE_FREEZECAM )		
	end
end