
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_spawnmenu.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "lists/props.lua" )

include( "shared.lua" )
include("lists/props.lua")

local Nouns = {}
local PropList = {}
local chosenNoun = ""
local chosenPlayer = nil
local PropCount = 0
local RoundIsWon = false
local WinningPlayer = nil

function Init()
	addProps()
	local txt = file.Read("../gamemodes/PropIt/gamemode/lists/nouns2.txt")
	Nouns = string.Explode("\n",txt)
end
hook.Add( "Initialize", "PropIt_init2", Init )

function GM:PlayerInitialSpawn( pl )
		pl:SetTeam( TEAM_GUESSERS )
        pl:SetPlayerClass( "Spectator" )
        pl.m_bFirstSpawn = true
        pl:UpdateNameColor()
       
        GAMEMODE:CheckPlayerReconnected( pl )
end

function PlayerDisconnected( ply )
	GAMEMODE:RoundEndWithResult( -1, "Prop maker disconnected, pfft drop-out.")
end
hook.Add("PlayerDisconnected", "PropIt_PlayerDisconnected", PlayerDisconnected)

function addProp( model )
	table.insert( PropList, model )
end

function GM:CanStartRound(iNum)
	chosenNoun  = table.Random( Nouns )
	
	if(WinningPlayer) then
		chosenPlayer = WinningPlayer
	else
		chosenPlayer = table.Random( player.GetAll() )
	end
	
	for k,v in pairs(player.GetAll()) do
		v:SetTeam( TEAM_GUESSERS )
	end
	chosenPlayer:SetTeam( TEAM_PROPPER )
	
	local rp = RecipientFilter()
	rp:AddPlayer( chosenPlayer )
	umsg.Start("PropIt_PreRound", rp)
	umsg.String(chosenNoun)
	umsg.End()
	
	rp:RemoveAllPlayers()
	for k,v in pairs(player.GetAll()) do
		if(v:Team() == TEAM_GUESSERS) then
			rp:AddPlayer(v)
		end
	end
	umsg.Start("PropIt_PreRound", rp)
	umsg.String("")
	umsg.End()
	
	WinningPlayer = nil
	PropCount = 0
	RoundIsWon = false
	
	return true
end

function GM:OnRoundStart(iNum)
	local rp = RecipientFilter()     -- Grab a CRecipientFilter object
	rp:AddAllPlayers()               -- Send to all players!
	umsg.Start("PropIt_OnRoundStart", rp)
	umsg.End()
	
	UTIL_UnFreezeAllPlayers()
end

function GM:OnRoundEnd(iNum)
	local rp = RecipientFilter()     -- Grab a CRecipientFilter object
	rp:AddAllPlayers()               -- Send to all players!
	umsg.Start("PropIt_OnRoundEnd", rp)
	umsg.End()
	
	if(!RoundIsWon) then
		GAMEMODE:SetRoundResult( -1, "Time's up! Answer was: "..chosenNoun)
		for k,v in pairs(player.GetAll()) do
			if(v:Team() == TEAM_PROPPER) then
				v:StripWeapons()
			else
				v:Give("weapon_crowbar")
			end
		end
	else
		WinningPlayer:Give("weapon_crowbar")
		chosenPlayer:StripWeapons()
		chosenPlayer:Give("weapon_crowbar")
		WinningPlayer:AddFrags(2)
		chosenPlayer:AddFrags(2)
	end
end


function SpawnProp( ply, commands, args )
	if( ply:Team() != TEAM_PROPPER or !GAMEMODE.InRound() ) then
		return false
	end
	
	if(PropCount > 100) then
		ply:PrintMessage(HUD_PRINTCENTER, "You have hit the prop limit!")
		return false
	end
	
	local model = args[1]
	
	if(!PropIsOnList(model)) then
		return false
	end
	
	local ptype = ""
	if( util.IsValidProp(model) ) then ptype = "prop_physics" end
	if( util.IsValidRagdoll(model) ) then ptype = "prop_ragdoll" end
	local prop = ents.Create(ptype)
	prop:SetModel(model)
	prop:SetCollisionGroup( COLLISION_GROUP_WORLD )
	prop.CollisionGroup = COLLISION_GROUP_WORLD
	
	local trace = ply:GetEyeTrace()
	local normal = trace.Normal
	local ang = normal:Angle()
	prop:SetAngles( Angle( 0, ang.y, 0 ) )
	local hitpos = trace.HitPos + (normal*-100)
	
	prop:SetPos( hitpos )
	prop:Spawn()
	prop:Activate()
	
	PropCount = PropCount + 1

end
concommand.Add( "PropIt_SpawnProp", SpawnProp )

function PropIsOnList( model )
	for k,v in pairs(PropList) do
		if(v == model) then
			return true
		end
	end
end

function PlayerChat( ply, strText, bTeamOnly, bPlayerIsDead )
	if(GAMEMODE.InRound()) then
		if( ply:Team() == TEAM_PROPPER ) then
			return ""
		else
			strText = string.lower(strText)
			if( strText == chosenNoun ) then
				DoWinRound( ply )
				return "I WIN!"
			elseif( strText == "I WIN!" ) then
				return ""
			else
				return strText
			end
		end
	end
end
hook.Add( "PlayerSay", "PropIt_PlayerSay", PlayerChat )

function DoWinRound( ply )
	RoundIsWon = true
	WinningPlayer = ply
	GAMEMODE:RoundEndWithResult( ply, ply:GetName().." guessed correctly. It was: "..chosenNoun )
end