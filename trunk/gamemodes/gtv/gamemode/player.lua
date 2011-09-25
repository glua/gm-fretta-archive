local neutralang = Angle(0,0,0)

/*---------------------------------------------------------
   Name: gamemode:SetupMove( player, movedata )
   Desc: Allows us to change stuff before the engine 
		  processes the movements
---------------------------------------------------------*/
local ang = Angle(0,90,0)

function GM:SetupMove(pl,movedata)
	if (pl:GetInfoNum("cam_relative") == 0) && (pl:Team() != TEAM_SPECTATOR) then
		movedata:SetMoveAngles(ang)
	end
end

function GM:PlayerSpawn(pl)
	pl:SetNWString("pl_color",pl:GetInfo("cl_playercolor")) --network player colors
	self.BaseClass:PlayerSpawn(pl)
end




/*---------------------------------------------------------
   Name: gamemode:SetupPlayerVisibility()
   Desc: Add extra positions to the player's PVS
---------------------------------------------------------*/

	local refoffset = Vector(0,0,GM.MaxCameraHeight)
	local tracetabpv = {}
	tracetabpv.mask = CONTENTS_SOLID
	tracetabpv.mins = Vector(-16,-16,-16)
	tracetabpv.maxs = Vector(16,16,16)

	function GM:SetupPlayerVisibility( pl, pViewEntity )
		if !pViewEntity:IsValid() then
			pViewEntity = pl
		end
		tracetabpv.start = pViewEntity:OBBCenter()
		tracetabpv.endpos = pViewEntity:OBBCenter()+refoffset
		local tr = util.TraceHull(tracetabpv)
		AddOriginToPVS(tr.HitPos)
	end

function GM:OnDamagedByExplosion(pl,dmginfo)
end

local suicidemessages = {"uh oh","Whoops!","Excellent show!"}

function GibPlayer(pl,force,pos)
	local edata = EffectData()
	if pos then
		edata:SetOrigin(pos)
	else
		edata:SetOrigin(pl:GetPos())
	end
	edata:SetEntity(pl)
	if force then
		edata:SetStart(force)
	end
	SuppressHostEvents(NULL)
	util.Effect("ef_playergib",edata)
end

function GM:DoPlayerDeath( pl, attacker, dmginfo )
	pl:EmitSound("physics/body/body_medium_break3.wav")
	if pl:GetActiveWeapon():IsValid() && pl:GetActiveWeapon().ItemType then
		local wep = ents.Create("gtv_item")
		wep:SetPos(pl:GetPos())
		wep.dt.ItemType = pl:GetActiveWeapon().ItemType
		wep:Spawn()
		wep:Fire("Kill",0,15)
	end
	if dmginfo:IsDamageType(DMG_BLAST) || dmginfo:IsDamageType(DMG_ENERGYBEAM) || pl.GibOnDeath || (attacker:GetClass() == "func_door") then
		GibPlayer(pl,dmginfo:GetDamageForce()/100)
		pl.GibOnDeath = false
	elseif !pl.NoRagdoll then
		pl:CreateRagdoll()
	end
	pl.NoRagdoll = false
	if (!attacker || !attacker:IsValid() || !attacker:IsPlayer()) && pl.ThrownBy && pl.ThrownBy:IsValid() then
		attacker = pl.ThrownBy
	end
	pl.KillingProjectile = s_proj.CurrentProjectile --s_proj.CurrentProjectile is always nil except when executing the projectile processing. If it's not nil and we're in a player death hook we can assume that the player death hook is on the same stack. We've arrived here from the execution of a projectile callback.
	local Inflictor = dmginfo:GetInflictor()
	
	if( Inflictor == attacker and ( attacker:IsPlayer() or attacker:IsNPC() ) ) then
		Inflictor = attacker:GetActiveWeapon()
	end
	
	if( Inflictor.WeaponKilledPlayer != nil ) then
		Inflictor:WeaponKilledPlayer( pl, dmginfo )
	end
	
	
	// Increment death counter
	pl:AddDeaths(1)
	
	// Add frag to killer
	if ( attacker:IsValid() && attacker:IsPlayer() ) then
	
		if ( attacker == pl ) then
			pl:AddFrags(-1000)
			pl:PrintMessage(HUD_PRINTCENTER,table.Random(suicidemessages))
		else
			local score = 1000+attacker.KillsThisLife*250
			attacker.KillsThisLife = attacker.KillsThisLife+1
			local pos = pl:GetPos()
			pos.z = pos.z+100
			attacker:SendPointNotification(pos,score)
			attacker:AddFrags(score)
			attacker:SendNotification("You killed "..pl:Nick())
			pl:SendNotification("You were killed by "..attacker:Nick())
			//attacker:PrintMessage( HUD_PRINTCENTER, "You killed " .. pl:Name() )
			//pl:PrintMessage( HUD_PRINTCENTER, "You were killed by " .. attacker:Name() )
		end
		
	else
		pl:AddFrags(-1000)
		pl:PrintMessage(HUD_PRINTCENTER,table.Random(suicidemessages))
	end
	pl:SetParent()
end

/*---------------------------------------------------------
   Name: gamemode:PlayerDeath( )
   Desc: Called when a player dies. --modified from base to work with the projectile system
---------------------------------------------------------*/
function GM:PlayerDeath( Victim, Inflictor, Attacker )
	// Don't spawn for at least 2 seconds
	Victim.NextSpawnTime = CurTime() + 2
	Victim.DeathTime = CurTime()
	// Convert the inflictor to the weapon that they're holding if we can.
	// This can be right or wrong with NPCs since combine can be holding a 
	// pistol but kill you by hitting you with their arm.
	if (!Attacker || !Attacker:IsValid() || !Attacker:IsPlayer()) && Victim.ThrownBy && Victim.ThrownBy:IsValid() then
		Attacker = Victim.ThrownBy
		Victim.ThrownBy = nil
	end
	if Inflictor:IsValid() && (Inflictor:GetClass() == "entityflame") && Victim.IgnitedBy && Victim.IgnitedBy:IsValid() then
		Attacker = Victim.IgnitedBy
		Victim.IgnitedBy = nil
	end
	local stringinflictor = "NULL"
	if Victim.KillingProjectile && Victim.KillingProjectile.InflictorName && (!Inflictor || !Inflictor:IsValid()) then
		stringinflictor = Victim.KillingProjectile.InflictorName
		Victim.KillingProjectile = nil
	elseif ( Inflictor && Inflictor == Attacker && (Inflictor:IsPlayer() || Inflictor:IsNPC()) ) then
	
		Inflictor = Inflictor:GetActiveWeapon()
		if ( !Inflictor || Inflictor == NULL ) then Inflictor = Attacker end
		stringinflictor = Inflictor:GetClass()
	elseif Inflictor:IsValid() then
		stringinflictor = Inflictor:GetClass()
	end
	
	
	if (Attacker == Victim) then
		umsg.Start( "PlayerKilledSelf" )
			umsg.Entity( Victim )
		umsg.End()
		
		MsgAll( Attacker:Nick() .. " suicided!\n" )	
	return end
	if ( Attacker:IsPlayer() ) then
		umsg.Start( "PlayerKilledByPlayer" )
		
			umsg.Entity( Victim )
			umsg.String( stringinflictor )
			umsg.Entity( Attacker )
		
		umsg.End()	
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using " .. stringinflictor .. "\n" )		
	return end
	umsg.Start( "PlayerKilled" )
	
		umsg.Entity( Victim )
		umsg.String( stringinflictor )
		umsg.String( Attacker:GetClass() )

	umsg.End()
	MsgAll( Victim:Nick() .. " was killed by " .. Attacker:GetClass() .. "\n" )
end


/*---------------------------------------------------------
   Name: gamemode:PlayerSelectSpawn( player )
   Desc: Find a spawn point entity for this player
---------------------------------------------------------*/
function GM:IsSpawnpointSuitable( pl, spawnpointent, bMakeSuitable )
	local Pos = spawnpointent:GetPos()
	
	// Note that we're searching the default hull size here for a player in the way of our spawning.
	// This seems pretty rough, seeing as our player's hull could be different.. but it should do the job
	// (HL2DM kills everything within a 128 unit radius)
	local Ents = ents.FindInBox( Pos + Vector( -16, -16, 0 ), Pos + Vector( 16, 16, 64 ) )
	
	local Blockers = 0
	
	for k, v in pairs( Ents ) do
		if ( IsValid( v ) && v:GetClass() == "player" && v:Alive() ) then
		
			Blockers = Blockers + 1
			
			if ( bMakeSuitable ) then
				v:Kill()
			end
			
		end
	end
	
	if ( bMakeSuitable ) then return true end
	if ( Blockers > 0 ) then return false end
	return true

end

/*---------------------------------------------------------
   Name: gamemode:PlayerSelectSpawn( player )
   Desc: Find a spawn point entity for this player
---------------------------------------------------------*/
function GM:PlayerSelectSpawn( pl )

	// Save information about all of the spawn points
	// in a team based game you'd split up the spawns
	if ( !IsTableOfEntitiesValid( self.SpawnPoints ) ) then
		gamemode.Call("BuildSpawnPointList")
	end
	
	local Count = table.Count( self.SpawnPoints )
	
	if ( Count == 0 ) then
		Msg("[PlayerSelectSpawn] Error! No spawn points!\n")
		return nil 
	end
	
	local ChosenSpawnPoint = nil
	
	// Try to work out the best, random spawnpoint (in 6 goes)
	for i=0, 6 do
		ChosenSpawnPoint = table.Random( self.SpawnPoints )
		
		if ( ChosenSpawnPoint &&
			ChosenSpawnPoint:IsValid() &&
			ChosenSpawnPoint:IsInWorld() &&
			ChosenSpawnPoint != pl:GetVar( "LastSpawnpoint" ) &&
			ChosenSpawnPoint != self.LastSpawnPoint &&
			ChosenSpawnPoint.Enabled != false) then
			
			if ( GAMEMODE:IsSpawnpointSuitable( pl, ChosenSpawnPoint, i==6 ) ) then
				self.LastSpawnPoint = ChosenSpawnPoint
				pl:SetVar( "LastSpawnpoint", ChosenSpawnPoint )
				if (pl:Team() != TEAM_SPECTATOR) && ChosenSpawnPoint:GetParent() && ChosenSpawnPoint:GetParent().AutoDisable then --for toggleable spawn points
					local spawn = ChosenSpawnPoint:GetParent()
					spawn:RemoveChild()
					//print(pl)
					return spawn
				end
				return ChosenSpawnPoint
			
			end
			
		end
			
	end
	if (pl:Team() != TEAM_SPECTATOR) && ChosenSpawnPoint && ChosenSpawnPoint:IsValid() && ChosenSpawnPoint:GetParent() && ChosenSpawnPoint:GetParent().AutoDisable then --for toggleable spawn points
		local spawn = ChosenSpawnPoint:GetParent()
		spawn:RemoveChild()
		return spawn
	end
	return ChosenSpawnPoint
	
end

function GM:BuildSpawnPointList()
		self.LastSpawnPoint = 0
		self.SpawnPoints = ents.FindByClass( "info_player_start" )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_deathmatch" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_combine" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_rebel" ) )
		
		// CS Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_counterterrorist" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_terrorist" ) )
		
		// DOD Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_axis" ) )
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_allies" ) )

		// (Old) GMod Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "gmod_player_start" ) )
		
		// TF Maps
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "info_player_teamspawn" ) )

		// Garry TV Toggleable Spawn
		self.SpawnPoints = table.Add( self.SpawnPoints, ents.FindByClass( "gtv_tspawn" ) )
		
		// If any of the spawnpoints have a MASTER flag then only use that one.
		for k, v in pairs( self.SpawnPoints ) do
		
			if ( v:HasSpawnFlags( 1 ) ) then
			
				self.SpawnPoints = {}
				self.SpawnPoints[1] = v
			
			end
		
		end
end

function GM:PlayerDeathThink( pl )

	pl.DeathTime = pl.DeathTime or CurTime()
	local timeDead = CurTime() - pl.DeathTime
	
	// If we're in deathcam mode, promote to a generic spectator mode
	if ( GAMEMODE.DeathLingerTime > 0 && timeDead > GAMEMODE.DeathLingerTime && ( pl:GetObserverMode() == OBS_MODE_FREEZECAM || pl:GetObserverMode() == OBS_MODE_DEATHCAM ) ) then
		GAMEMODE:BecomeObserver( pl )
	end
	
	// If we're in a round based game, player NEVER spawns in death think
	if ( GAMEMODE.NoAutomaticSpawning ) then return end
	
	// The gamemode is holding the player from respawning.
	// Probably because they have to choose a class..
	if ( !pl:CanRespawn() ) then return end

	// Don't respawn yet - wait for minimum time...
	if ( GAMEMODE.MinimumDeathLength ) then 
	
		pl:SetNWFloat( "RespawnTime", pl.DeathTime + GAMEMODE.MinimumDeathLength )
		
		if ( timeDead < pl:GetRespawnTime() ) then
			return
		end
		
	end

	// Force respawn
	if ( pl:GetRespawnTime() != 0 && GAMEMODE.MaximumDeathLength != 0 && timeDead > GAMEMODE.MaximumDeathLength ) then
		pl:Spawn()
		return
	end

	// We're between min and max death length, player can press a key to spawn.
	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
		pl:Spawn()
	end
	
end


/*---------------------------------------------------------
   Name: gamemode:OnPlayerHitGround()
		Return true to disable default action
---------------------------------------------------------*/
function GM:OnPlayerHitGround( ply, bInWater, bOnFloater, flFallSpeed )
	
	// Apply damage and play collision sound here
	// then return true to disable the default action
	//MsgN( ply, bInWater, bOnFloater, flFallSpeed )
	//return true
	ply.ThrownBy = nil
end

function GM:PlayerDeathSound()
	return true 
end

function SendPlayerUpdateForScoreBoard(pl)
	umsg.Start("gtv_sb_udpl")
		umsg.Entity(pl)
	umsg.End()
end

local function delayudpl(pl)
	timer.Simple(0.1,SendPlayerUpdateForScoreBoard,pl)
end														

hook.Add("Think","playershit",function() for k,v in ipairs(player.GetAll()) do if (v:GetGroundEntity() != NULL) then v.ThrownBy = nil end end end)

hook.Add("PlayerInitialSpawn","test",delayudpl)
hook.Add("PlayerDisconnected","test",delayudpl)
hook.Add("PlayerSpawn","test",delayudpl)
hook.Add("PlayerSilentDeath","test",delayudpl)
hook.Add("PlayerDeath","test",delayudpl)