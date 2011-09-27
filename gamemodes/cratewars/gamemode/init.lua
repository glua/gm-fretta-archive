AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_points.lua" )
AddCSLuaFile( "cl_flag.lua" )
AddCSLuaFile('resources.lua')
AddCSLuaFile('cl_deathnotice.lua')
AddCSLuaFile('vgui/vgui_gamenotice.lua')

include( "shared.lua" )
include( "round_controller.lua" )
include( "class_red.lua" )
include( "class_blue.lua" )
include( "points.lua" )
include( "crates.lua" )
include( "flag.lua" )
include('resources.lua')
include('stats.lua')
include('capture.lua')

function GM:Think()
	for k,v in pairs( player.GetAll() ) do
		if ( !v:Alive() ) then
			if((v:Team() == TEAM_RED) || (v:Team() == TEAM_BLUE))then
				v:Spawn()
			end
		end
	end
end

function regen()
	for _, ply in pairs( player.GetAll() ) do
		if(ply.DamageTime+5 <= CurTime())then
			if(ply:Health() < 100)then
				ply:SetHealth(ply:Health()+0.65)
				if(ply:Health() > 100)then
					ply:SetHealth(100)
				end
			end
		end
	end
end
timer.Create("regentimer", 0.1, 0, regen)

function GM:PlayerInitialSpawn( pl )

	pl:SetTeam( TEAM_UNASSIGNED )
	pl:SetPlayerClass( "Spectator" )
	pl.m_bFirstSpawn = true
	pl:UpdateNameColor()
	pl.DamageTime = CurTime()
	GAMEMODE:CheckPlayerReconnected( pl )
	GAMEMODE:resetStats(pl)
end

function GM:CheckPlayerReconnected( pl )

	for _, info in pairs(GAMEMODE.ReconnectedPlayers)do
		if(pl:UniqueID() == info[1])then
			pl:SetFrags(info[2])
			pl:SetDeaths(info[3])
			pl.points = info[4]
		end
	end
	
end

function GM:PlayerDisconnected( pl )

	table.insert( GAMEMODE.ReconnectedPlayers, {pl:UniqueID(), pl:Frags(), pl:Deaths(), pl.points} )
	
	self.BaseClass:PlayerDisconnected( pl )

end

function GM:PlayerSpawn( ply )
	self.BaseClass:PlayerSpawn( ply )
	if(ply:Team() != TEAM_UNASSIGNED) and (ply:Team() != TEAM_SPECTATOR)then
		ply:Give( "weapon_crater" )
		ply:Give( "weapons_box" )
	end
end

function GM:PlayerShouldTakeDamage( victim, pl )
	if(pl:IsPlayer()) then
		if(victim:Team() == pl:Team()) then return false end
	end
	victim.DamageTime = CurTime()
	return true
end

function GM:VoteForChange( ply )

	if ( GetConVarNumber( "fretta_voting" ) == 0 ) then return end
	if ( ply:GetNWBool( "WantsVote" ) ) then return end
	
	ply:SetNWBool( "WantsVote", true )
	
	local VotesNeeded = GAMEMODE:GetVotesNeededForChange()
	local NeedTxt = "" 
	if ( VotesNeeded > 0 ) then NeedTxt = ", Color( 80, 255, 50 ), [[ (need "..VotesNeeded.." more) ]] " end
	
	if ( CurTime() < GetConVarNumber( "fretta_votegraceperiod" ) ) then // can't vote too early on
		local timediff = math.Round( GetConVarNumber( "fretta_votegraceperiod" ) - CurTime() );
		BroadcastLua( "chat.AddText( Entity("..ply:EntIndex().."), Color( 255, 255, 255 ), [[ voted to change the gamemode, press F1 to vote]] )" )
	else
		BroadcastLua( "chat.AddText( Entity("..ply:EntIndex().."), Color( 255, 255, 255 ), [[ voted to change the gamemode, press F1 to vote]] "..NeedTxt.." )" )
	end
	
	Msg( ply:Nick() .. " voted to change the gamemode\n" )
	
	timer.Simple( 5, function() GAMEMODE:CountVotesForChange() end )

end

concommand.Add( "VoteForChange", function( pl, cmd, args ) GAMEMODE:VoteForChange( pl ) end )
timer.Create( "VoteForChangeThink", 10, 0, function() if ( GAMEMODE ) then GAMEMODE.CountVotesForChange( GAMEMODE ) end end )