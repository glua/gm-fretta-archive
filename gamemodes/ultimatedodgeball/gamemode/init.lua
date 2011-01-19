
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "admin.lua" )

include( "shared.lua" )
include( "admin.lua" )
include( "ply_extension.lua" )
include( "tables.lua" )
include( "balls.lua" )

function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()
	
	for k,v in pairs( player.GetAll() ) do 
		v:ResetScore()
	end

end

function GM:OnRoundResult( t )
	
	team.AddScore( t, 1 )
	
	local maxscore = GetConVar( "ud_maxscore" ):GetInt()
	
	for k, v in pairs( player.GetAll() ) do 
	
		if v:Team() == t then
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.WinSound .. "\" )" )
		else
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.LoseSound .. "\" )" )
		end
		
	end
	
	if team.GetScore( t ) >= maxscore then
	
		timer.Simple( 5, function() GAMEMODE:EndOfGame( true ) end )
		
	end
	
end

function GM:CheckRoundEnd()

	if #player.GetAll() < 2 then return end
	
	local alive, dead = GAMEMODE:SortPlayers( TEAM_RED )

	if #alive == 0 then
		GAMEMODE:RoundEndWithResult(TEAM_BLUE)
	end
	
	local alive, dead = GAMEMODE:SortPlayers( TEAM_BLUE )
	
	if #alive == 0 then
		GAMEMODE:RoundEndWithResult(TEAM_RED)
	end

end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	local alive, dead = GAMEMODE:SortPlayers( TEAM_RED )

	if #alive == 0 then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE )
		return
	end
	
	local alive, dead = GAMEMODE:SortPlayers( TEAM_BLUE )
	
	if #alive == 0 then
		GAMEMODE:RoundEndWithResult( TEAM_RED )
		return
	end
	
	GAMEMODE:RoundEndWithResult( ROUND_RESULT_DRAW )

end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if not ent:IsPlayer() then return end
	if not ent:Alive() then return end
	
	if string.find(attacker:GetClass(),"ball") then
		dmginfo:SetDamage(0) //manually set the damage in the ball collide hooks
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	self.BaseClass:DoPlayerDeath( ply, attacker, dmginfo )
	
	ply:Flashlight(false)
	ply:Freeze(false)
	
	if attacker:IsPlayer() and attacker != ply then
	
		attacker:UpgradeBalls( attacker:Frags() )
	
		if math.fmod( attacker:Frags(), 2 ) == 0 then
		
			GAMEMODE:ResurrectPlayer( attacker:Team() )
			attacker:SetHealth( math.Clamp( attacker:Health() + 50, 1, 100 ) )
			attacker:EmitSound( GAMEMODE.HealSound )
			
		end
		
	end
	
end

function GM:SortPlayers( t )

	local alive = {}
	local dead = {}
	
	for k,v in pairs( team.GetPlayers( t ) ) do
		if v:Alive() then
			table.insert( alive, v )
		else
			table.insert( dead, v )
		end
	end
	
	return alive, dead
	
end

function GM:ResurrectPlayer( t )

	local alive, dead = GAMEMODE:SortPlayers( t )
	
	if #dead == 0 then return end
	
	local ply = table.Random(dead)
	ply:Resurrect()
	
end