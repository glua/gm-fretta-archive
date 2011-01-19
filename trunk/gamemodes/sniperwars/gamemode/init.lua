
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_postprocess.lua" )
AddCSLuaFile( "cl_hud.lua" )

include( "shared.lua" )
include( "ply_extension.lua" )
include( "tables.lua" )

resource.AddFile("materials/gmod/scope.vtf")
resource.AddFile("materials/gmod/scope.vmt")

function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()

end

function GM:OnRoundResult( t )
	
	team.AddScore( t, 1 )
	
	SetGlobalInt( "TopDist", 0 )
	SetGlobalString( "TopPlayer", "Nobody" )
	
	for k,v in pairs( player.GetAll() ) do 
	
		if v:Team() == t then
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.WinSound .. "\" )" )
		else
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.LoseSound .. "\" )" )
		end
		
	end
	
	if team.GetScore( t ) >= 3 then
		timer.Simple( 5, function() GAMEMODE:EndOfGame( true ) end )
	end
	
end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end

	if team.GetScore( TEAM_RED ) < team.GetScore( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE )
	elseif team.GetScore( TEAM_RED ) > team.GetScore( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_RED )
	else
		GAMEMODE:RoundEndWithResult( ROUND_RESULT_DRAW )
	end

end

function GM:CheckRoundEnd()

	for t=1,2 do
	
		if team.TotalFrags( t ) >= 30 and GAMEMODE:InRound() then
	
			GAMEMODE:RoundEndWithResult( t )
		
			for k,v in pairs( team.GetPlayers( t ) ) do
				v:SetFrags( 0 )
			end
		
		end
	
	end

end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	self.BaseClass:DoPlayerDeath( ply, attacker, dmginfo )
	
	if dmginfo:IsExplosionDamage() then
		ply:SetModel( table.Random( GAMEMODE.Corpses ) )
	end
	
	if not ValidEntity( attacker ) or not attacker:IsPlayer() or attacker == ply then 
	
		ply:SetDeathCamTarget( ply )
		return 
		
	end
	
	ply:SetDeathCamTarget( attacker )
	
	if ply:GetPos():Distance( attacker:GetPos() ) > ( GetGlobalInt( "TopDist" ) or 0 ) then
	
		attacker:AddFrags( 1 )
		SetGlobalInt( "TopDist", math.floor( ply:GetPos():Distance( attacker:GetPos() ) ) )
		SetGlobalString( "TopPlayer", attacker:Nick() )
	
	end
	
end
