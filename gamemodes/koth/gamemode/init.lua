
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_postprocess.lua" )
AddCSLuaFile( "cl_hud.lua" )

include( "shared.lua" )
include( "tables.lua" )
include( "ply_extension.lua" )

resource.AddFile("sound/koth/heartbeat.wav")
resource.AddFile("materials/kothcrown.vtf")
resource.AddFile("materials/kothcrown.vmt")

function GM:OnPreRoundStart( num )
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
	// Reset hill times
	GAMEMODE:SetTeamTime( TEAM_RED, 0 )
	GAMEMODE:SetTeamTime( TEAM_BLUE, 0 )

end

function GM:OnRoundStart()

	local tbl =  ents.FindByClass( "sent_betsy" )
	table.Add( tbl, ents.FindByClass( "sent_beacon" ) )
	table.Add( tbl, ents.FindByClass( "sent_tesla" ) )
	table.Add( tbl, ents.FindByClass( "sent_droppedgun" ) )

	for k,v in pairs( tbl ) do
		v:Remove()
	end	
	
	GAMEMODE:RelocateHill( false )
	
	UTIL_UnFreezeAllPlayers()
	
end

function GM:OnRoundResult( t )
	
	team.AddScore( t, 1 )
	
	for k,v in pairs( player.GetAll() ) do 
	
		if v:Team() == t then
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.WinSound .. "\" )" )
		else
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.LoseSound .. "\" )" )
		end
		
	end
	
	for k,v in pairs( ents.FindByClass( "func_hill" ) ) do
		v:SetActive( false )
	end
	
end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	if GAMEMODE:GetTeamTime( TEAM_RED ) > GAMEMODE:GetTeamTime( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_RED, "RED TEAM WINS!" )
	elseif GAMEMODE:GetTeamTime( TEAM_RED ) < GAMEMODE:GetTeamTime( TEAM_BLUE ) then
		GAMEMODE:RoundEndWithResult( TEAM_BLUE, "BLUE TEAM WINS!" )
	else
		GAMEMODE:RoundEndWithResult( -1, "TIE GAME!" )
	end

end

function GM:CheckRoundEnd()

	for i = TEAM_RED, TEAM_BLUE do
		GAMEMODE:CheckScore( i )
	end

end

function GM:CheckScore( t )

	local score = GAMEMODE:GetTeamTime( t )
	
	if score >= GAMEMODE.TimeNeeded and GAMEMODE:InRound() then
		if t == TEAM_RED then
			GAMEMODE:RoundEndWithResult( t, "RED TEAM WINS!" )
		else
			GAMEMODE:RoundEndWithResult( t, "BLUE TEAM WINS!" )
		end
	end

end

function GM:InitializeHill()

	GAMEMODE.HillTimer = CurTime() + GAMEMODE.HillMoveTime
	GAMEMODE.LastHill = table.Random( ents.FindByClass( "func_hill" ) )
	GAMEMODE.LastHill:SetActive( true )
		
	if #ents.FindByClass( "func_hill" ) < 1 then
	
		MsgN("ERROR: There are not enough func_hill entities in this map! < MAP NAME: "..game.GetMap().." >")
		GAMEMODE:EndOfGame( true )
		
	end

end

function GM:RelocateHill( msg )

	GAMEMODE.HillTimer = CurTime() + GAMEMODE.HillMoveTime
	GAMEMODE.LastHill:SetActive( false )
	
	local oldhill = GAMEMODE.LastHill
	GAMEMODE.LastHill = table.Random( ents.FindByClass( "func_hill" ) )
		
	while ( GAMEMODE.LastHill == oldhill && table.Count( ents.FindByClass( "func_hill" ) ) > 1 )  do
		GAMEMODE.LastHill = table.Random( ents.FindByClass( "func_hill" ) )
	end
		
	GAMEMODE.LastHill:SetActive( true )
	
	local pos = GAMEMODE.LastHill:LocalToWorld( GAMEMODE.LastHill:OBBCenter() )
	
	for k,v in pairs( player.GetAll() ) do
	
		if msg then
			v:SendLua( "surface.PlaySound( \"" .. GAMEMODE.HillMove .. "\" )" ) 
			v:Notice( "The hill has moved", 3, 100, 255, 255 )
		end
		
		v:SetNWVector( "hill", pos )
		v:SetNWInt( "hillowner", 0 )
		
	end

end

function GM:Think()

	self.BaseClass:Think()

	if not GAMEMODE.HillTimer then
	
		GAMEMODE:InitializeHill()
		
	elseif CurTime() > GAMEMODE.HillTimer then
		
		GAMEMODE:RelocateHill( true )
		
	end
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if not ent:IsPlayer() then return end
	if not ent:Alive() then return end
	
	if attacker:GetClass() == "sent_plasma" or attacker:GetClass() == "sent_beacon" then
		dmginfo:SetDamage( 0 )
	end
	
	if ent:IsPlayer() and attacker:IsPlayer() then
		attacker:CallPowerupFunction( "DamageTaken", ent, dmginfo )
	end
	
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if dmginfo:IsExplosionDamage() then
		ply:SetModel( table.Random( GAMEMODE.Corpses ) )
	end

	ply:Drop()
	ply:AddDeaths( 1 )
	
	if attacker:IsPlayer() and attacker != ply then
		attacker:AddFrags( 1 )
	end
	
	self.BaseClass:DoPlayerDeath( ply, attacker, dmginfo )
	
end

function GM:PlayerDeathSound()
	return true // disable the BEEP BEEP sound
end

function GM:SetTeamTime( t, i ) 
	SetGlobalInt( "TeamScore"..t, i ) 
end

function GM:AddTeamTime( t, i ) 
	SetGlobalInt( "TeamScore"..t, GAMEMODE:GetTeamTime( t ) + i ) 
end

function GM:GetTeamTime( t )
	return GetGlobalInt( "TeamScore"..t )
end

function IncludePowerups()

	local Folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.FindInLua( Folder.."/gamemode/powerups/*.lua" ) ) do
	
		include( Folder.."/gamemode/powerups/"..d )
		AddCSLuaFile( Folder.."/gamemode/powerups/"..d )
		
	end

end

IncludePowerups()	