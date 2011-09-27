-- INIT --
-- Useful link: http://luabin.foszor.com/code/gamemodes/fretta/gamemode

-- Load lua files.
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

resource.AddFile("sound/rocketball/critical.wav")
util.PrecacheSound("rocketball/critical.wav")

-- Send content to players.
-- resource.AddFile("path/to/file.extension")

------------------------------------
-- Create variables and Initialize.
------------------------------------
local PowerupTbl = {}
local LastPowerup = nil
local rocketball = nil

function GM:Initialize()
	self.BaseClass:Initialize()
	SetGlobalString("CustomHudText", "Waiting for players")
	
	PowerupTbl[1] = power_boost
	PowerupTbl[2] = power_newball
	PowerupTbl[3] = power_revive
	PowerupTbl[4] = power_necksnap
	PowerupTbl[5] = power_health
	PowerupTbl[6] = power_slow
	PowerupTbl[7] = power_dodge
end

function GM:Think()
	self.BaseClass:Think()
end

------------------------------------
-- Round Functions.
-- Useful to call:
-- GAMEMODE:AddRoundTime( extra_time )
-- GAMEMODE:RoundEndWithResult( winner, text )
------------------------------------
function GM:CanStartRound( round_number )
	if #player.GetAll() > 1 then
		return true
	else
		return false
	end
end

function GM:OnPreRoundStart( round_number )
	self.BaseClass:OnPreRoundStart( round_number )
	SetGlobalString("CustomHudText", "Get Ready!")
	UTIL_UnFreezeAllPlayers()
end

function GM:OnRoundStart( round_number )
	self.BaseClass:OnRoundStart( round_number )
	SetGlobalString("CustomHudText", "ROCKETBAAALLL!!")
	timer.Simple( 2, function() SetGlobalString("CustomHudText", "") end )
	GAMEMODE:SpawnRocketball()
end

function GM:OnRoundEnd( round_number )
	self.BaseClass:OnRoundEnd( round_number )
end

function GM:RoundTimerEnd()
	self.BaseClass:RoundTimerEnd()
end

function GM:CheckRoundEnd()
	self.BaseClass:CheckRoundEnd()
end

function GM:CheckPlayerDeathRoundEnd()
	self.BaseClass:CheckPlayerDeathRoundEnd()
end

------------------------------------
-- Player Functions.
------------------------------------
function GM:PlayerConnect( pl, ip )
end

function GM:PlayerAuthed( pl, steam_id, unique_id )
end

function GM:PlayerReconnected( pl )
end

function GM:PlayerInitialSpawn( pl )
	self.BaseClass:PlayerInitialSpawn( pl )
end

function GM:PlayerDisconnected( pl )
	self.BaseClass:PlayerDisconnected( pl )
end

function GM:PlayerDeath( victim, attacker, dmginfo )
	self.BaseClass:PlayerDeath( victim, attacker, dmginfo )
end

function GM:PlayerDeathSound()
	-- Return true to disable the default death sound,
	-- then play your custom sound in GM:PlayerDeath()
	return false
end

function GM:GravGunPickupAllowed( ply, ent )
	return false
end

function GM:KeyPress( pl, key )
	--self.BaseClass:KeyPress( pl, key )
	if key == IN_ATTACK2 then
		print( math.random(1,6) )
	end
end

function GM:GravGunPunt( pl, ent )
	local dist = ent:GetPos():Distance( pl:EyePos() )
	--Send distance to client for lag compensation.
	local rp = RecipientFilter()
	rp:AddPlayer( pl )               
	umsg.Start("OnServerPunt", rp)
		umsg.Float( dist )
	umsg.End()
		
	if ent:GetClass() == "sent_rocketball" and dist < GAMEMODE.PuntLength then
		ent:OnPunt( pl )
		power_checknecksnap( pl, ent )
		SetGlobalString("CustomHudText", "")
		
		if GAMEMODE.DebugMode then
			pl:PrintMessage( HUD_PRINTTALK, "Server: "..dist )
		end
		
		if dist > GAMEMODE.PuntPowerMin and dist < GAMEMODE.PuntPowerMax then 
			GAMEMODE:Powerup( pl, ent, math.random(1,6) )
		end
		
		return true
	else
		return false
	end
end

function GM:SpawnRocketball()
	if not GAMEMODE:InRound() then return end
	
	local spawnpoints = {}
	for k,v in pairs( ents.FindByClass("fa_dodgeball_spawner") ) do
		table.insert(spawnpoints, v)
	end
	
	local ent = ents.Create( "sent_rocketball" )
	if #spawnpoints > 0 then
		local spawnpoint = spawnpoints[ math.random(#spawnpoints) ]
		ent:SetPos( spawnpoint:GetPos() )
		ent:SetAngles( spawnpoint:GetAngles() )
	else
		ent:SetPos( Vector(0,0,200) )
		ent:SetAngles( Angle(0,0,0) )
	end
	ent:Spawn()
	ent:Activate()
	
	rocketball = ent
	return ent
end

function GM:PreSpawnRocketball()
	timer.Simple( 1, self.SpawnRocketball, self )
end

function GM:Powerup( pl, ball, rand )
	local func = PowerupTbl[ math.random(#PowerupTbl) ]
	ball:EmitSound( "rocketball/critical.wav", 100, 100 )
	LastPowerUp = func

	func( pl, ball )
end

function power_boost( pl, ball )
	ball.Speed = ball.Speed + 5
	SetGlobalString("CustomHudText", "BOOSTBALL!")
end

function power_newball( pl, ball )
	local ent = GAMEMODE:SpawnRocketball()
	ent:SetRandomTarget( pl:Team() )
	ent.CanRespawn = false
	SetGlobalString("CustomHudText", "BRAND NEW BALL!")
end

function power_revive( pl, ball )
	local teammates = {}
	for k,v in pairs( player.GetAll() ) do
		if v:Team() == pl:Team() and !v:Alive() then
			table.insert( teammates, v )
		end
	end
	
	if #teammates > 0 then
		local mate = teammates[ math.random(#teammates) ]
		mate:Spawn()
		SetGlobalString("CustomHudText", "REVIVED "..mate:GetName().."!")
	else
		GAMEMODE:Powerup( pl, ball )
	end
end

function power_necksnap( pl, ball )
	ball.SnapNeck = true
	SetGlobalString("CustomHudText", "NECK SNAPPER!")
end

function power_checknecksnap( pl, ent )
	if ent.SnapNeck then
		ent.SnapNeck = false
		pl:SetEyeAngles( pl:EyeAngles() + Angle(0,0,30) )
	end
end

function power_health( pl, ball )
	pl:SetHealth( 500 )
	SetGlobalString("CustomHudText", pl:GetName().." IS HEALTHY!")
end

function power_slow( pl, ball )
	ball.Speed = 1
	SetGlobalString("CustomHudText", "SLOW THE BALL!")
end

function power_dodge( pl, ball )
	pl:SetWalkSpeed( 1000 )
	timer.Simple(5, function() pl:SetWalkSpeed( 400 ) end )
	SetGlobalString("CustomHudText", "DODGE!")
end

------------------------------------
-- Entity Functions.
------------------------------------
function GM:EntityTakeDamage( ent, inflictor, attacker, damage_amount, damage_info )
end