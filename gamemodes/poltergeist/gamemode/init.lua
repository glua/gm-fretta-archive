
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" ) 

include( "shared.lua" )
include( "ply_extension.lua" )
include( "tables.lua" )

function GM:OnRoundResult( t )

	for k,v in pairs( player.GetAll() ) do 
	
		if v:Team() != t then
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.LoseSound .. "\" )" ) 
		else
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.WinSound .. "\" )" )
		end
		
	end

	GAMEMODE:ResetTeams()
	
	//timer.Simple( 35, function() GAMEMODE:EndOfGame( true ) end )

end

function GM:CheckRoundEnd()

	if ( GAMEMODE:AlivePlayers() < 1 and team.NumPlayers( TEAM_GHOST ) > 0 ) then
	
		GAMEMODE:RoundEndWithResult( TEAM_GHOST )
		
	end

end

function GM:AlivePlayers()

	for k,v in pairs( team.GetPlayers( TEAM_HUMAN ) ) do
		if v:Alive() then
			return 1
		end
	end
	return 0

end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	if ( GAMEMODE:AlivePlayers() > 0 ) then 
		GAMEMODE:RoundEndWithResult( TEAM_HUMAN )
	else
		GAMEMODE:RoundEndWithResult( TEAM_GHOST )
	end	

end

function GM:ResetTeams( )

	for k, v in pairs( team.GetPlayers( TEAM_GHOST ) ) do
		v:SetTeam( TEAM_HUMAN )
		v:SetPlayerClass( "Human" )
		v:KillSilent()
	end
	
end

function GM:PlayerSpawn( ply )
	
	self.BaseClass:PlayerSpawn( ply )
	
	if team.NumPlayers( TEAM_HUMAN ) > 1 and team.NumPlayers( TEAM_GHOST ) < 1 then
	
		local randomguy = table.Random( team.GetPlayers( TEAM_HUMAN ) )
		randomguy:SetTeam( TEAM_GHOST )
		randomguy:SetRandomClass()
		randomguy:KillSilent()
		
	end
	
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if not ent:IsPlayer() then 

		if ent:GetOwner() and ent:GetOwner():IsValid() then
		
			if dmginfo:GetAttacker():IsValid() and dmginfo:GetAttacker():IsPlayer() then
			
				ent:EmitSound( Sound( table.Random( GAMEMODE.PropHit ) ) )
				ent:GetOwner():SetHealth( ent:GetOwner():Health() - dmginfo:GetDamage() )
				
				if ent:GetOwner():Health() < 1 then
				
					ent:EmitSound( Sound( table.Random( GAMEMODE.PropDie ) ) )
					ent:GetOwner():Kill()
					
				end
			end
			dmginfo:SetDamage( 0 )
		end
		return
	end
	
	if not ent:Alive() then return end
	
	if string.find( attacker:GetClass(), "prop_phys" ) then
		if attacker:GetOwner() and attacker:GetOwner():IsValid() then
			dmginfo:SetAttacker( attacker:GetOwner() ) 
		end
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CallClassFunction( "OnDeath", attacker, dmginfo )
	ply:AddDeaths( 1 )
	
	if ply:Team() == TEAM_HUMAN then
	
		ply:CreateRagdoll()
		ply:SetTeam( TEAM_GHOST )
		ply:SetRandomClass()
		
	end
	
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
	
end

function GM:PlayerDeathSound()
	return true // disable the BEEP BEEP sound
end