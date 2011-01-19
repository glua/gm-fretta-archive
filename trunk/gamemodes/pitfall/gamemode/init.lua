AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )
include( "downloads.lua" )

if file.Exists("../"..GM.Folder.."/gamemode/maps/"..game.GetMap()..".lua") then
	include("maps/"..game.GetMap()..".lua")
	print( "Included map file" )
end

local LOSS_SOUNDS = { "vo/announcer_failure.wav", "vo/announcer_you_failed.wav" }
local VICTORY_SOUNDS = {"vo/announcer_success.wav","vo/announcer_victory.wav","vo/announcer_we_succeeded.wav" }

function GM:OnPreRoundStart()

	game.CleanUpMap()
	self:ClearLevel()
	self:PitFallOnRoundStart() --Spawn the platforms at the position specified in the map file
	
	for k,v in pairs(player.GetAll()) do
		if v:Team() == TEAM_FALLEN then
			v:SetTeam(TEAM_SURVIVORS)
		end
		
		if v:Team() == TEAM_SURVIVORS then
			v:Spawn()
		end
	end
	
	UTIL_FreezeAllPlayers()
end


function GM:PlayerSelectSpawn( pl )
	pl.LastPunchedMe = nil
	pl.LastPlatformTouched = nil

	local spawns = ents.FindByClass( "info_player_start" )
	if(#spawns <= 0) then return false end
	
	for k,v in pairs(spawns) do
		if v.spawnUsed == false then
			v.spawnUsed = true
			return v
		end
	end
	
	for k,v in pairs(spawns) do
		v.spawnUsed = false
	end
	
	return self:PlayerSelectSpawn(pl)
	
end

function GM:OnRoundStart( num )
	UTIL_UnFreezeAllPlayers()
end

function GM:PlayerDeath( ply, attacker, dmginfo )
	local plat = ply.LastPlatformTouched
	local lastattacker = nil
	local lastpunchedme = nil
	
	if IsValid( plat ) then
		lastattacker = plat.LastAttacker
		lastpunchedme = ply.LastPunchedMe
	end
	
	if IsValid( lastattacker ) and lastattacker:IsPlayer() and lastattacker != ply then
	
		//lastattacker:GiveMoney( 5 )
		lastattacker:AddFrags( 1 )
		
		umsg.Start( "PlayerFallKiller" )
			umsg.Entity( lastattacker )
			umsg.String( "shot out the platform beneath" )
			umsg.Entity( ply )
		umsg.End()
		
		MsgAll( lastattacker:Nick() .. " shot out the platform beneath "..ply:Nick().."!\n" )
		
		timer.Simple(2, function()
			if IsValid( ply ) and IsValid( lastattacker ) and lastattacker:Alive() and ply != attacker then
				ply:ConCommand("play misc/freeze_cam.wav")
				ply:SpectateEntity(lastattacker)
				ply:Spectate(OBS_MODE_FREEZECAM)
			end
		end)
		
		--ply:ChatPrint( lastattacker:Nick() .. " shot out the platform beneath you!" )
		--lastattacker:ChatPrint( "You shot out the platform beneath " .. ply:Nick().. "!" )
		ply.LastPlatformTouched.LastAttacker = nil
		
	elseif IsValid( lastpunchedme ) and lastpunchedme:IsPlayer() and lastpunchedme != ply then
	
		lastpunchedme:GiveMoney( 5 )
		lastpunchedme:AddFrags( 1 )
		
		umsg.Start( "PlayerFallKiller" )
			umsg.Entity( lastpunchedme )
			umsg.String( "pushed" )
			umsg.Entity( ply )
		umsg.End()
		
		MsgAll( lastpunchedme:Nick() .. " pushed "..ply:Nick().." to death!\n" )
		
		timer.Simple(2, function()
			if IsValid( ply ) and IsValid( lastpunchedme ) and lastpunchedme:Alive() and ply != attacker then
				ply:ConCommand("play misc/freeze_cam.wav")
				ply:SpectateEntity(lastpunchedme)
				ply:Spectate(OBS_MODE_FREEZECAM)
			end
		end)
		
		--ply:ChatPrint( lastpunchedme:Nick() .. " punched you to your death!" )
		--lastpunchedme:ChatPrint( "You punched " .. ply:Nick().. " to his death!" )
		ply.LastPunchedMe = nil
		
	else
	
		umsg.Start( "PlayerFallNoKiller" )
			umsg.Entity( ply )
		umsg.End()
		
		MsgAll( ply:Nick() .. " fell to death!\n" )
		
	end
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:CreateRagdoll()
	ply:SetTeam( TEAM_FALLEN )
	
	if self:InRound() then
	
		ply:AddDeaths( 1 )
		local randomlosssound = table.Random( LOSS_SOUNDS )
		ply:SendLua( "surface.PlaySound( \"" .. randomlosssound .. "\" )" )
		
	end
end

function GM:Think()

	self.BaseClass:Think()
	
	local numsurvivors = #team.GetPlayers(TEAM_SURVIVORS)
	local numfallen = #team.GetPlayers(TEAM_FALLEN)

	if numsurvivors <= 1 and numfallen > 0 and self:InRound() then
		local ply = team.GetPlayers(TEAM_SURVIVORS)[1]
		self:RoundEnd(ply)
	elseif numsurvivors <= 0 and numfallen > 0 and self:InRound() then
		self:RoundEnd()
	elseif numsurvivors <= 1 and numfallen == 0 and self:InRound() then
		local ply = team.GetPlayers(TEAM_SURVIVORS)[1]
		if ply and !ply:Alive() then
			self:RoundEnd()
		end
	end
end

function GM:GetFallDamage( ply, vel ) -- REAL realisic fall damage. Silly garry
	if self.RealisticFallDamage then
		vel = vel - 526.5
		return vel*(100/(922.5-526.5))
	else
		return 10
	end
	return 10
end

function GM:RoundTimerEnd()

	if ( !self:InRound() ) then return end

	self:RoundEndWithResult( -1, "Time Up" )
	
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint("Time up!")
		v:StripWeapons()
	end
		
	self:ClearLevel()
end

function GM:RoundEnd(ply)

	self.BaseClass:RoundEnd()
	
	if IsValid( ply ) then 
		ply:AddFrags( 1 )
		//ply:GiveMoney( 35 )
		//ply:ChatPrint( "You received 35 rupees for winning the round!" )
		//ply:GiveWin()
		ply:StripWeapons()
		local randomwinsound = table.Random( VICTORY_SOUNDS )
		ply:SendLua("surface.PlaySound( \"" .. randomwinsound .. "\" )") 
		
		for k,v in pairs( player.GetAll() ) do	
			if v != ply then
				v:ChatPrint(ply:Name().." won the round!")
			end
		end
	end
end

function GM:InitPostEntity( )
	self.BaseClass:InitPostEntity()
	self:ClearLevel()
end

function GM:ClearLevel()
	for k,v in pairs(ents.FindByClass( "pf_platform" )) do
		v:Remove()
	end
	for k,v in pairs(ents.FindByClass( "info_player_start" )) do
		v:Remove()
	end
	for k,v in pairs(ents.FindByClass( "gmod_player_start" )) do
		v:Remove()
	end
	for k,v in pairs(ents.FindByClass( "info_player_terrorist" )) do
		v:Remove()
	end
	for k,v in pairs(ents.FindByClass( "info_player_counterterrorist" )) do
		v:Remove()
	end
end

function GM:SpawnPlatforms(center)

	local numplayers = team.NumPlayers(TEAM_SURVIVORS)+team.NumPlayers(TEAM_FALLEN)
	local sqrtplayers = math.ceil(math.sqrt(numplayers))
	
	ServerLog( "Need "..sqrtplayers.."x"..sqrtplayers.." platforms!" )
	
	local posX = center.x
	local posY = center.y
	local posZ = center.z
	
	for row=1, sqrtplayers do
		posY = center.y
		for col=1, sqrtplayers do
			self:SpawnPlatform(Vector(posX, posY, posZ))
			posY = posY + 350
		end
		posX = posX + 300
	end
end

function GM:SpawnPlatform(pos)
	local prop = ents.Create( "pf_platform" )
	if ( !prop ) then return end
	--prop:SetAngles( Angle( -90.000, -180.000, 180.000 ) )
	prop:SetAngles( Angle( 0, 0, 0 ) )
	prop:SetPos( pos )
	prop:Spawn()
	prop:Activate()

	local spawn = ents.Create("info_player_start")
	if ( !spawn ) then return end
	
	local center = prop:GetCenter()
	center.z = center.z + 15
	spawn:SetPos(center)
	spawn.spawnUsed = false
	--prop:Spawn()
	--prop:Activate()
end
