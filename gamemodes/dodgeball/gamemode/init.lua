/*	By: Termy58
	Feel free to use anything with credit
*/
include('shared.lua')
include('gravgun.lua')
include('player.lua')
include('rounds.lua')
include('player_pup.lua')
include('powerups.lua')
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile('cl_postprocess.lua')
AddCSLuaFile("player.lua")
AddCSLuaFile("gravgun.lua")

resource.AddFile("materials/sprites/ball/sent_ball0.vmt")
resource.AddFile("materials/sprites/ball/sent_ball0.vtf")
resource.AddFile("materials/sprites/ball/sent_ball1.vmt")
resource.AddFile("materials/sprites/ball/sent_ball1.vtf")
resource.AddFile("materials/sprites/ball/sent_ball2.vmt")
resource.AddFile("materials/sprites/ball/sent_ball2.vtf")
resource.AddFile("materials/sprites/ball/sent_ball3.vmt")
resource.AddFile("materials/sprites/ball/sent_ball3.vtf")
resource.AddFile("materials/sprites/ball/sent_ball4.vmt")
resource.AddFile("materials/sprites/ball/sent_ball4.vtf")
resource.AddFile("materials/sprites/ball/sent_ball5.vmt")
resource.AddFile("materials/sprites/ball/sent_ball5.vtf")

resource.AddFile("materials/freezescreen.vtf")
resource.AddFile("materials/freezescreen.vmt")
resource.AddFile("materials/ice.vtf")
resource.AddFile("materials/ice.vmt")

function GM:PlayerLoadout( ply )
	if ply:Team() == 1 or ply:Team() == 2 then
		ply:Give( "weapon_physcannon" )
	else
		ply:StripWeapons()
	end
end

function GM:InitPostEntity( )
	self.Spawns = {}
	self.Spawns[TEAM_RED] = {}
	self.Spawns[TEAM_RED].play = ents.FindByClass( "gmod_redstart" )
	self.Spawns[TEAM_RED].jail = ents.FindByClass( "gmod_bluejail" )
	self.Spawns[TEAM_BLUE] = {}
	self.Spawns[TEAM_BLUE].play = ents.FindByClass( "gmod_bluestart" )
	self.Spawns[TEAM_BLUE].jail = ents.FindByClass( "gmod_redjail" )
	self.Spawns[TEAM_SPECTATOR] = ents.FindByClass( "gmod_redstart" )
end

function GM:Alert( str )
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	
	umsg.Start("DBAlert", rp)
		umsg.String( str )
	umsg.End() 
end

function GM:OnPlayerChangedTeam( ply, oldteam, newteam )
	ply:PutInPlayer( true )
	
	PrintMessage( HUD_PRINTTALK, Format( "%s joined '%s'", ply:Nick(), team.GetName( newteam ) ) )
end

function GM:PlayerSelectSpawn( ply ) --New player joined, real players never die
	local spwn = ply:GetSpawn( self:InRound() )
	ply:SnapEyeAngles( spwn:GetAngles() )
	return spwn
end

function GM:PlayerDeath( ply, inflictor, killer )
	ply:Jail( killer )
end

function GM:CanPlayerSuicide( ply )
	return false
end
