
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "vgui_playername.lua" )
AddCSLuaFile( "vgui_playerlist.lua" )
AddCSLuaFile( "skin.lua" )

include( 'shared.lua' )

local sndCheckPoint = Sound( "buttons/button17.wav" )

/*---------------------------------------------------------
   Name: gamemode:PlayerLoadout( )
---------------------------------------------------------*/
function GM:PlayerLoadout( pl )
	
	// We don't want the player to have anything.
	
end


/*---------------------------------------------------------
   Name: gamemode:PlayerAuthed( )
---------------------------------------------------------*/
function GM:PlayerAuthed( pl, SteamID, UniqueID )

	//
	// PData uses the player's uniqueid, so we fill in their wins 
	//  after they have definitiely have a SteamID
	//

	pl.Wins = pl:GetPData( "MelonRacerWins", 0 )
	pl:SetNWInt( "wins", pl.Wins )
	
	pl.Losses = pl:GetPData( "MelonRacerLosses", 0 )
	pl:SetNWInt( "losses", pl.Losses )

end

/*---------------------------------------------------------
   Name: gamemode:PlayerInitialSpawn( pl )
---------------------------------------------------------*/
function GM:PlayerInitialSpawn( pl )

	pl.NextCheckPoint = 1
	pl.PrevCheckPoint = 0
	pl.LastCheckPointTime = 0
	pl.Laps = 0
	pl.Wins = pl.Wins or 0
	pl.Losses = pl.Losses or 0
	
	self.BaseClass:PlayerInitialSpawn( pl );
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerSpawn( pl )
---------------------------------------------------------*/
function GM:PlayerSpawn( pl )

	local bFirstSpawn = pl.m_bFirstSpawn
	self.BaseClass:PlayerSpawn( pl );
	
	if ( bFirstSpawn ) then return end
	if ( IsValid( pl.Melon ) ) then
		pl.Melon:Remove()
	end

	pl.Melon = ents.Create( "player_melon" )
		
		pl.Melon:SetPlayer( pl )
		pl.Melon:SetPos( pl:GetPos() + Vector( 0, 0, 16 ) )
		
	pl.Melon:Spawn()
	pl:SetNWEntity( "melon", pl.Melon )
	
	pl:SpectateEntity( pl.Melon )
	pl:Spectate( OBS_MODE_CHASE )
	
	pl.NextCheckPoint = 1
	pl.PrevCheckPoint = 0
	
	if ( self.State == "countdown" ) then
	
		pl.Melon:GetPhysicsObject():EnableMotion( false )
		pl:Freeze( true )
		
	elseif ( self.State == "waiting" ) then
	
		self:StartCountdown()
		
	end
	
	self:UpdatePositions()
	
end


/*---------------------------------------------------------
   Name: gamemode:GetCheckpoint( num )
---------------------------------------------------------*/
function GM:GetCheckpoint( num )

	local checkpoints = ents.FindByClass( "checkpoint" )
	for k, v in pairs( checkpoints ) do
		if ( v:GetNumber() == num ) then
			return v
		end
	end
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerHitCheckpoint( melon, cpnum )
---------------------------------------------------------*/
function GM:LastCheckpoint()

	if ( self.m_iLastCP ) then return self.m_iLastCP end
	
	self.m_iLastCP = 1

	local checkpoints = ents.FindByClass( "checkpoint" )
	for k, v in pairs( checkpoints ) do
		self.m_iLastCP = math.max( self.m_iLastCP, v:GetNumber() )
	end

	SetGlobalInt( "NumCheckpoints", self.m_iLastCP )
	
	return self.m_iLastCP
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerHitCheckpoint( melon, cpnum )
---------------------------------------------------------*/
function GM:PlayerHitCheckpoint( melon, cpnum )

	if ( self.State != "racing" ) then return end

	local ply = melon:GetPlayer()

	if ( cpnum == ply.PrevCheckPoint ) then return end
	
	if ( cpnum != ply.NextCheckPoint ) then
		ply:SendLua( "WrongWay( 'melonracer/wrongway' )" )
		return
	end
	
	ply.PrevCheckPoint = ply.NextCheckPoint
	if ( ply.NextCheckPoint == cpnum ) then
		
		ply.NextCheckPoint = ply.NextCheckPoint + 1
		ply.LastCheckPointTime = CurTime()
				
		if ( ply.NextCheckPoint > self:LastCheckpoint() ) then
			ply.NextCheckPoint = 1
		end
		
		ply.CheckpointPitch = ply.CheckpointPitch or 50
		ply.CheckpointPitch = ply.CheckpointPitch + 5
		
		melon:EmitSound( sndCheckPoint, 100, ply.CheckpointPitch )
		local Checkpoint = self:GetCheckpoint( ply.NextCheckPoint )
		if ( IsValid( Checkpoint ) ) then
			ply:SetNWVector( "CPDir", Checkpoint:OBBCenter() )
		end
		
	end
	
	if ( ply.PrevCheckPoint == self:LastCheckpoint() && ply.NextCheckPoint == 1 ) then
		ply.Laps = ply.Laps + 1
		ply:AddFrags(1)
		ply:SendLua( "FireCountdown( 'melonracer/lap' )" )
	end
	
	self:UpdatePositions()
	
	if ( ply.Laps == self:GetNumLaps() ) then
		self:AnnounceWinner()
	end

end

/*---------------------------------------------------------
   Name: gamemode:PlayerHitCheckpoint( melon, cpnum )
---------------------------------------------------------*/
function GM:UpdatePositions()

	local Places = {}
	for k, ply in pairs( player.GetAll() ) do
		
		if ( ply:IsConnected() and ply:Team() == TEAM_UNASSIGNED ) then
			table.insert( Places, { Player = ply, Lap = ply.Laps, CheckPoint = ply.NextCheckPoint, CPTime = ply.LastCheckPointTime } )
		end
		
	end
	
	table.sort( Places, function( a, b ) 

								if ( b == nil ) then return false end
								if (a.Lap<b.Lap) then return false end
								if (a.Lap>b.Lap) then return true end
								if (a.CheckPoint<b.CheckPoint) then return false end
								if (a.CheckPoint>b.CheckPoint) then return true end						
		
								return a.CPTime<b.CPTime
						
					end )

	for k, v in ipairs( Places ) do
	
		v.Player:SetNWInt( "place", k )
		v.Player:SetNWInt( "lap", v.Lap )
		v.Player:SetNWInt( "checkpoint", v.CheckPoint )
		SetGlobalEntity( "Pos"..k, v.Player )
	
	end
	
	self.CurrentPlaces = Places
	
end

/*---------------------------------------------------------
   Name: gamemode:PlayerHitCheckpoint( melon, cpnum )
---------------------------------------------------------*/
function GM:StartCountdown()

	self.State = "countdown"

	for k, ply in pairs( player.GetAll() ) do
		
		ply:Spawn()
		ply:Freeze( true )
				
	end
	
	self:UpdatePositions()

	timer.Simple( 2, function() BroadcastLua( "FireCountdown( 'melonracer/3' )" ) end )
	timer.Simple( 3, function() BroadcastLua( "FireCountdown( 'melonracer/2' )" ) end )
	timer.Simple( 4, function() BroadcastLua( "FireCountdown( 'melonracer/1' )" ) end )
	timer.Simple( 5, self.Go, self )
	
	BroadcastLua( Format( "PreStart( %f )", CurTime() + 2 ) )
	
end

/*---------------------------------------------------------
   Name: Go
---------------------------------------------------------*/
function GM:Go()

	BroadcastLua( "FireGo( 'melonracer/go' )" )

	for k, ply in pairs( player.GetAll() ) do
		
		ply:Freeze( false )
		
		if ( IsValid( ply.Melon ) ) then
			ply.Melon:GetPhysicsObject():EnableMotion( true )
		end
		
	end
	
	self.State = "racing"

end

/*---------------------------------------------------------
   Name: ResetGame
---------------------------------------------------------*/
function GM:ResetGame()

	for k, ply in pairs( player.GetAll() ) do
		
		ply.NextCheckPoint = 1
		ply.PrevCheckPoint = 0
		ply.LastCheckPointTime = 0
		ply.Laps = 0
		ply.CheckpointPitch = 50
		
		ply:SetNWVector( "CPDir", Vector(0,0,0) )
				
	end
	
	self:StartCountdown()
	
end

local CheerSounds = {}

table.insert( CheerSounds, Sound( "vo/coast/odessa/female01/nlo_cheer01.wav" ) )
table.insert( CheerSounds, Sound( "vo/coast/odessa/female01/nlo_cheer02.wav" ) )
table.insert( CheerSounds, Sound( "vo/coast/odessa/female01/nlo_cheer03.wav" ) )
table.insert( CheerSounds, Sound( "vo/coast/odessa/male01/nlo_cheer01.wav" ) )
table.insert( CheerSounds, Sound( "vo/coast/odessa/male01/nlo_cheer02.wav" ) )
table.insert( CheerSounds, Sound( "vo/coast/odessa/male01/nlo_cheer03.wav" ) )
table.insert( CheerSounds, Sound( "vo/coast/odessa/male01/nlo_cheer04.wav" ) )
table.insert( CheerSounds, Sound( "vo/npc/female01/nice01.wav" ) )
table.insert( CheerSounds, Sound( "vo/npc/female01/nice02.wav" ) )
table.insert( CheerSounds, Sound( "vo/npc/female01/thislldonicely01.wav" ) )
table.insert( CheerSounds, Sound( "vo/npc/male01/nice.wav" ) )
table.insert( CheerSounds, Sound( "vo/eli_lab/al_gooddoggie.wav" ) )
table.insert( CheerSounds, Sound( "vo/k_lab/kl_mygoodness01.wav" ) )
table.insert( CheerSounds, Sound( "vo/k_lab2/al_goodboy.wav" ) )
table.insert( CheerSounds, Sound( "vo/npc/female01/goodgod.wav" ) )
table.insert( CheerSounds, Sound( "vo/npc/male01/goodgod.wav" ) )
table.insert( CheerSounds, Sound( "vo/coast/bugbait/vbaittrain_great.wav" ) )
table.insert( CheerSounds, Sound( "vo/k_lab2/kl_greatscott.wav" ) )

/*---------------------------------------------------------
   Name: AnnounceWinner
---------------------------------------------------------*/
function GM:AnnounceWinner()

	local ShowWinnerScreenForSeconds = 10
	local Winner = self.CurrentPlaces[ 1 ].Player
	
	Winner.Wins = Winner.Wins + 1
	Winner:SetNWInt( "wins", Winner.Wins )
	Winner:SetPData( "MelonRacerWins", Winner.Wins )

	SendUserMessage( "PlayerWin", nil, 
						CurTime() + ShowWinnerScreenForSeconds, 
						Winner:Nick(), 
						Winner.Wins )
						
	self.State = "finished"
	
	for k, ply in pairs( player.GetAll() ) do
		
		if ( IsValid( ply.Melon ) && Winner != ply ) then
			ply.Melon:GetPhysicsObject():EnableMotion( false )
			
			ply.Losses = ply.Losses + 1
			ply:SetNWInt( "losses", ply.Losses )
			ply:SetPData( "MelonRacerLosses", ply.Losses )
	
		end
		
		if ( IsValid( Winner ) ) then
			ply:SpectateEntity( Winner.Melon )
			ply:Spectate( OBS_MODE_CHASE )
		end
		
		ply:SetNWVector( "CPDir", Vector(0,0,0) )
		
	end
	
	timer.Simple( ShowWinnerScreenForSeconds, self.ResetGame, self )
	
	local NumSounds = table.Count( CheerSounds )
	for i = 0, ShowWinnerScreenForSeconds*3 do
	
		local s = CheerSounds[ math.random( 1, NumSounds ) ]
		timer.Simple( ((i/(ShowWinnerScreenForSeconds*3))^2.0)*ShowWinnerScreenForSeconds*0.8, function() WorldSound( s, Winner:GetPos() + VectorRand() * 400 ) end )
		
	end

end
