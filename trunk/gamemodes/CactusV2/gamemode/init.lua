
//Server

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cactus_shd.lua" )
AddCSLuaFile( "cactus_meta.lua" )
AddCSLuaFile( "ply_extension.lua" )
AddCSLuaFile( "ent_extension.lua" )
AddCSLuaFile( "cl_targetid.lua" )
AddCSLuaFile( "cl_hints.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( 'vgui/vgui_hudcactusicon.lua' )

include( "shared.lua" )
include( "tables.lua" )
include( "admin.lua" )
include( "cactus.lua" )
include( "sv_spectator.lua" )
include( "hints.lua" )

//Sounds
// Cactus sounds
resource.AddFile("sound/cactus/5cacti.mp3")
resource.AddFile("sound/cactus/andcactus.mp3")
resource.AddFile("sound/cactus/cactus_low.mp3")
resource.AddFile("sound/cactus/cactus_nerd.mp3")
resource.AddFile("sound/cactus/cactus1.mp3")
resource.AddFile("sound/cactus/cactus2.mp3")
resource.AddFile("sound/cactus/cactus3.mp3")
resource.AddFile("sound/cactus/cactus4.mp3")
resource.AddFile("sound/cactus/cactus5.mp3")
resource.AddFile("sound/cactus/cactus6.mp3")
resource.AddFile("sound/cactus/cactus7.mp3")
resource.AddFile("sound/cactus/cactus8.mp3")
resource.AddFile("sound/cactus/cactus9.mp3")
resource.AddFile("sound/cactus/cactus10.mp3")
resource.AddFile("sound/cactus/cactuscactus.mp3")
resource.AddFile("sound/cactus/evilcactus.mp3")
resource.AddFile("sound/cactus/uhcactus.mp3")
// Vacuum sounds
//resource.AddFile("sound/vacuum/*")

// Materials
/*
resource.AddFile("materials/effects/particles/needle1.vmt")
resource.AddFile("materials/effects/particles/needle1.vtf")

resource.AddFile("materials/effects/particles/pollen_red_1.vmt")
resource.AddFile("materials/effects/particles/pollen_red_1.vtf")
resource.AddFile("materials/effects/particles/pollen_red_2.vmt")
resource.AddFile("materials/effects/particles/pollen_red_2.vtf")
resource.AddFile("materials/effects/particles/pollen_blue_1.vmt")
resource.AddFile("materials/effects/particles/pollen_blue_1.vtf")
resource.AddFile("materials/effects/particles/pollen_blue_2.vmt")
resource.AddFile("materials/effects/particles/pollen_blue_2.vtf")
resource.AddFile("materials/effects/particles/pollen_green_1.vmt")
resource.AddFile("materials/effects/particles/pollen_green_1.vtf")
resource.AddFile("materials/effects/particles/pollen_green_2.vmt")
resource.AddFile("materials/effects/particles/pollen_green_2.vtf")
resource.AddFile("materials/effects/particles/pollen_yellow_1.vmt")
resource.AddFile("materials/effects/particles/pollen_yellow_1.vtf")
resource.AddFile("materials/effects/particles/pollen_yellow_2.vmt")
resource.AddFile("materials/effects/particles/pollen_yellow_2.vtf")*/

resource.AddFile("materials/models/weapons/v_vacuum/unwrap.vmt")
resource.AddFile("materials/models/weapons/v_vacuum/unwrap.vtf")
resource.AddFile("materials/models/weapons/v_vacuum/unwrap2.vmt")
resource.AddFile("materials/models/weapons/v_vacuum/unwrap2.vtf")

resource.AddFile("materials/gui/cactus.vmt")
resource.AddFile("materials/gui/cactus.vtf")

// Models
resource.AddFile("models/weapons/v_vacuum.mdl")
resource.AddFile("models/weapons/v_vacuum.vvd")
resource.AddFile("models/weapons/v_vacuum.sw.vtx")
resource.AddFile("models/weapons/v_vacuum.dx80.vtx")
resource.AddFile("models/weapons/v_vacuum.dx90.vtx")

function GM:Initialize()
	self.BaseClass:Initialize()
end

function GM:Think()
	self.BaseClass:Think()
	for k,v in pairs(player.GetAll()) do
		if v:Alive() then
		end
	end
end


function GM:PlayerCactusThink(ply)
	ply:SetColor(0,0,0,0)
end


function GM:InitPostEntity( )

	self.BaseClass:InitPostEntity( ) --Run default shit
	
	Cactus.Spawns = ents.FindByClass("info_cactus_spawn") or {} --Add all cactus spawns to the Cactus.Spawns table
	
	//Remove all weapons
	local weapons = ents.FindByClass("weapon_*")
	for k,v in pairs(weapons) do
		v:Remove()
	end
	
	//Add cactus spawns if there are none
	if !Cactus.Spawns[1] then
		Cactus.Spawns = {}
		print("not enough cactus spawns")
		for k,v in pairs(ents.FindByClass("info_player_start")) do
			local tr = util.QuickTrace(v:GetPos(),v:GetPos()+vector_up*800,{v})
			local pos = tr.HitPos
			if tr.Hit then
				pos = tr.HitNormal*20
			end
			local cspawn = ents.Create("info_cactus_spawn")
			cspawn:SetPos(pos)
			cspawn:Spawn()
			table.insert(Cactus.Spawns,cspawn)
			MsgN("Adding "..tostring(cspawn).." at "..tostring(pos))
		end
	else
		Cactus.Spawns = ents.FindByClass("info_cactus_spawn") --Add all cactus spawns to the Cactus.Spawns table
	end
	
	//Set up timer based on difficulty
	local default = 30
	local difficulty = GAMEMODE:GetDifficulty()
	local c_time = default-difficulty/2
	
	timer.Create("c_spawntimer", c_time, 0, function() GAMEMODE:SpawnCacti() end) --Create spawn timer
	timer.Stop("c_spawntimer") --Stop spawn timer
	
end

function GM:PlayerInitialSpawn( ply )
	
	self.BaseClass:PlayerInitialSpawn(ply) --Run default shit
	
	ply.CanSpawn = true
	ply:SetTeam(TEAM_SPECTATOR) --Make new players spectators to start
	ply:SetCanSpawnFromSpec(false)
	ply:SetScore(0)				--Start with no score
	ply:SetTotalScore(0)		--Start with no total score
	ply:SetCaught(0)			--Start with no cacti caught
	//Set all caught types to 0
	for k,v in pairs(Cactus.Types) do
		ply:SetCaughtType(v,0)
	end
	ply.GrabberObj = nil
	ply:SetGrabber(false)

	ply.Powerups = {} --Empty powerups table
	
	//Precache sounds
	local k,v
	for k,v in pairs(Cactus.Sounds) do
		util.PrecacheSound(v)
	end

end

//NEED TO REWRITE THIS:
function GM:PlayerSpawn( ply )
	
	self.BaseClass:PlayerSpawn(ply) --Run default shit

	ply:ConCommand("wiggletest")
	
	if ply:IsHuman() then
		// Stop observer mode
		ply:UnSpectate()
		ply.GrabberObj = nil
		ply:SetGrabber(false)
		ply.Powerups = {}
		ply:SetColor(255,255,255,255)
		ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	elseif ply:IsCactus() then
		if !ply:GetCactus() then
			GAMEMODE:BecomeObserver( ply )
			ply:SetSurvivalTime(0)
			ply:Spectate( OBS_MODE_CHASE )
			ply:SpectateEntity( ply )
			ply:SpectateEntity( table.Random( GAMEMODE:GetCactusEntities()) )
		else
			local notify = {} --Hint table
			notify["Type"] = "wiggle" --Type of notification for cactus icon to use
			notify["Urgency"] = 1 --lol
			notify["Time"] = {}
			notify["Time"]["Notify"] = 1 --Time in seconds for notification to stop
			notify["Time"]["Hint"] = 3 --Time in seconds before the hint to goes away
			local ctype = ply:GetCactus():GetCactusType()
			if ctype then 
				local notestring = "You have spawned as a(n) "..ctype.." Cactus!\n"..Cactus.GetType(ctype).SpawnInfo
				GAMEMODE:SendCactusNotification(ply, notestring, notify)
			end
			ply:Spectate( OBS_MODE_NONE )
		end
		ply:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		ply:SetColor(0,0,0,0)
	end
end

function GM:OnRoundStart( )

	self.BaseClass:OnRoundStart()
	GAMEMODE:SpawnCacti()
	for k,v in ipairs(player.GetAll()) do
		if v:IsCactus() then
			v:KillSilent()
			GAMEMODE:BecomeObserver( v ) --Set cactus players to observers so they can choose a cactus
		elseif v:IsHuman() then
			v:SetMoveType(MOVETYPE_WALK)
			v:Freeze(false)
		end
	end
	timer.Start("c_spawntimer") --Start spawn timer
	
end

function GM:OnRoundTimerEnd( )

	self.BaseClass:RoundTimerEnd( )
	
	timer.Stop("c_spawntimer") --Stop spawn timer
	
	//Freeze all players
	for k,v in ipairs(player.GetAll()) do
		v:Freeze(true)
	end
	//Freeze all cactus SENTs
	for k,v in ipairs(GAMEMODE:GetAllCacti()) do
		if v:IsPlayer() then
			v:GetCactus():GetPhysicsObject():Sleep()
		else
			v:GetPhysicsObject():Sleep()
		end
	end
	
end

function GM:OnRoundEnd( ply )

	self.BaseClass:OnRoundEnd()
	
	timer.Stop("c_spawntimer") --Stop spawn timer
	
	game.CleanUpMap()
	
	//Freeze all players
	for k,v in ipairs(player.GetAll()) do
		v:Freeze(true)
	end
	//Freeze all cactus SENTs
	for k,v in ipairs(GAMEMODE:GetAllCacti()) do
		if !v:IsPlayer() then
			v:GetPhysicsObject():Sleep()
		end
	end
	
	local winningTeam
	local teamScores = {}
	teamScores[1] = teamScores[1] or 0
	teamScores[2] = teamScores[2] or 0
	for k,v in pairs(player.GetAll()) do
		teamScores[v:Team()] = teamScores[v:Team()] + v:GetScore()
	end
	
	if teamScores[1] > teamScores[2] then
		team.AddScore(1, 1)
	elseif teamScores[2] > teamScores[1] then
		team.AddScore(2, 1)
	else
		team.AddScore(1, 1)
		team.AddScore(2, 1)
	end
	
	if team.GetScore(1) > team.GetScore(2) then
		winningTeam = "Team "..team.GetName(1).." Wins this round!"
	elseif team.GetScore(2) > team.GetScore(1) then
		winningTeam = "Team "..team.GetName(2).." Wins this round!"
	else
		winningTeam = "It's a Tie!"
	end
	
	for k,v in ipairs(player.GetAll()) do
		v:PrintMessage( HUD_PRINTCENTER, winningTeam )
	end
	
	teamScores[1] = 0
	teamScores[2] = 0
	
end

function GM:OnEndOfGame( )
	
	self.BaseClass:OnEndOfGame( )
	local winningTeam
	local teamScores = {}
	if team.GetScore(1) > team.GetScore(2) then
		winningTeam = "Team "..team.GetName(1).." Wins!!!"
	elseif team.GetScore(2) > team.GetScore(1) then
		winningTeam = "Team "..team.GetName(2).." Wins!!!"
	else
		winningTeam = "It's a Tie!"
	end
	for k,v in ipairs(player.GetAll()) do
		v:PrintMessage( HUD_PRINTCENTER, winningTeam )
	end
	
end

function GM:PlayerDeathSound()

	return true // disable the BEEP BEEP sound
	
end
	
local function LocalDeath(pl)
	pl:SetCactus(NULL) --will this work?
	if pl:IsCactus() then
		GAMEMODE:BecomeObserver(pl)
	end
	pl.CanSpawn = true
	print("u better be able to spawn now!")
end
	
function GM:DoPlayerDeath( ply, attacker, dmginfo )

	self.BaseClass:DoPlayerDeath( ply, attacker, dmginfo )
	ply:SetCactus(NULL)
	
	if attacker != ply and attacker:IsCactus() then
		if attacker:IsPlayer() then
			attacker:AddScore(15)
		elseif attacker:GetPlayerObj():IsValid() then
			attacker:GetPlayerObj():AddScore(5)
		end
	end
	
	if ply:IsHuman() then
		ply.CanSpawn = false
		ply:CreateRagdoll()
	elseif ply:IsCactus() then
		--gibs?
		print("you died!!!")
		if ply:GetRagdollEntity():IsValid() then
			SafeRemoveEntity(ply:GetRagdollEntity())
		end
		
		if ValidEntity(ply:GetCactus()) then
			ply:SetPos(ply:GetCactus():GetPos())
			if ply:GetCactus().CactusType == "explosive" then
				SafeRemoveEntity(ply:GetCactus())
			else
				ply:GetCactus().IsSpamming = true
			end
		end
		
		ply:SpectateEntity( attacker )
		ply:Spectate( OBS_MODE_DEATHCAM )
	end
	
	timer.Simple(GAMEMODE.DeathLingerTime, function() if ValidEntity(ply) then LocalDeath(ply) end end) --changed
	
end

function GM:PlayerDeathThink( ply )

	// We're between min and max death length, player can press a key to spawn.
	// I hate the fretta spawn system, it's not very well isolated.
	// For cacti, Attack1 and Attack2 are to switch between spectator entities
	// Jump is to spawn as the spectated entity
	
	// We're between min and max death length, player can press a key to spawn.
	if !ply.CanSpawn then
		--print("shit")
		return
	end
	if ( ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) ) then
		if ply:IsHuman() then
			ply:Spawn()
			ply:UnSpectate()
		end
	end
end

function GM:GetFallDamage( ply, vel )
 
	return 0 --Disable falldamage and that annoying sound that comes with it
 
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )
	
	self.BaseClass:EntityTakeDamage()
	
	local dmgscale = 1
	
	if attacker:IsCactus() then
		if ValidEntity(attacker:GetPlayerObj()) then
			attacker = attacker:GetPlayerObj()
			print(attacker:Nick().." gave "..tostring(ent).." "..amount.." damage using "..tostring(inflictor))
			dmgscale = 3
		else
			dmgscale = 2
		end
	else
		dmgscale = 1
	end
	
	dmginfo:ScaleDamage( dmgscale )
	
end

function GM:PlayerShouldTakeDamage(victim, attacker)

	self.BaseClass:PlayerShouldTakeDamage(victim, attacker)
	
	--if victim:IsCactus() and victim:IsPlayer() then return false end
	
	if victim:GetInvincible() == true then
		return false
	else
		return true
	end
	
end
