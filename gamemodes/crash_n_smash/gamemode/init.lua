
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_tips.lua" )
AddCSLuaFile( "cl_scores.lua" )
AddCSLuaFile( "cl_targetid.lua" )
AddCSLuaFile( "player_extension.lua" )
AddCSLuaFile( "entity_extension.lua" )

include( "shared.lua" )
include( "sv_commands.lua" )
include( "player_extension.lua" )
include( "entity_extension.lua" )
include( "round_controller.lua" )
include( "powerup.lua" )

GM.NaggedAboutScore = false

/*----------------------------
	Gamemode functions
*/----------------------------

function GM:Initialize()

	// Call Fretta base function
	self.BaseClass:Initialize()

	resource.AddFile("sound/"..MUSIC_ROUNDSTART)
	resource.AddFile("sound/"..MUSIC_ROUNDWIN)
	resource.AddFile("sound/"..MUSIC_ROUNDLOSE)
	
end

function GM:Think()
	
	// Call Fretta base function
	self.BaseClass:Think()
	
	
	local plys = player.GetAll()
	for k, pl in pairs(plys) do
		// Allows players to use the +back bind again while in the air
		if pl:IsOnGround() then
			pl:SetNWBool("tjbreakblock", false)
		end
		
		// Testing purposes
		if pl:IsBot() and not pl.hasSpawned then
			pl:Spawn()
			pl.hasSpawned = true
		end
	end

	// Nag the losing team to get their shit together
	local timeleft = GetGlobalFloat( "RoundEndTime", 0 ) - CurTime()
	if not self.NaggedAboutScore and timeleft < 60 and timeleft > 50 and GAMEMODE:InRound() then
	
		for k, pl in pairs(player.GetAll()) do
			pl:Notify("One minute left!", NOTIFY_GENERIC)
		end
		
		local losingteam = -1
		
		if (teaminfo[TEAM_RED].TotalPropValue >= teaminfo[TEAM_BLUE].TotalPropValue * 1.3) then losingteam = TEAM_BLUE
		elseif (teaminfo[TEAM_BLUE].TotalPropValue >= teaminfo[TEAM_RED].TotalPropValue * 1.3) then losingteam = TEAM_RED
		end
		
		if losingteam != -1 then
			for k, pl in pairs(team.GetPlayers(losingteam)) do
				pl:Notify("Your team is losing badly, start breaking stuff!", NOTIFY_ERROR)
			end
		end

		self.NaggedAboutScore = true
	end
	
	ChainsThink()
end

function GM:PlayerInitialSpawn( pl )
	
	// Call Fretta base function
	self.BaseClass:PlayerInitialSpawn( pl )
	
	pl:SendLua("InitializeRoundScores()")
	pl:UpdatePropCount()
	pl:ResetScores()
end

function GM:PlayerSpawn( pl )

	// When a player gets fired from the player launcher weapon
	// we need to prevent Fretta from re-initializing stuff
	if not pl.HackySpawn then
		// Call Fretta base function
		self.BaseClass:PlayerSpawn( pl )
	end
	
	pl:RemoveTrail()
	pl:RemoveEyeLaser()
	
	if pl:GetPowerup() != "none" and teaminfo[pl:Team()].Powerup != "none" then // double check powerup status
		pl:SetMaterial(self.Powerups[pl:GetPowerup()])
		if pl:GetPowerup() == "invisibility" then
			pl:CreateTrail()
		elseif pl:GetPowerup() == "eyelaser" then
			pl:CreateEyeLaser()
		elseif pl:GetPowerup() == "harden" then
			pl:GodEnable()
		end
	else
		// Just some stuff to make sure no powerup effects are present at start
		pl:SetMaterial( "" )
		pl:GodDisable()
		pl:SetJumpPower( 160 )
	end
	
	pl.HackySpawn = false
	pl:SetNWBool( "DrawRing", true ) // Couldn't find a setting to turn on the ring drawing so I just set it directly...
	
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	function NullifyDamage()
		dmginfo:SetDamage(0)
		dmginfo:SetDamageForce(Vector(0,0,0))
	end

	if attacker:IsPlayer() then
		
		if ent:IsPlayer() and ent:Team() != attacker:Team() and ValidEntity(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():GetClass() == "weapon_crowbar"
			and attacker:GetPowerup() == "crowbarfrenzy" then
			
			ent:SetVelocity((attacker:GetAimVector()*20+Vector(0,0,20)):GetNormal() * 1000)
		end	
	
		if not ent:TeamSide() == attacker:TeamSide() then
			// Players cannot damage props on the other team side when they're standing on their own side
			NullifyDamage()
		else
			// Players cannot damage props on their own team side, or with bullets
			if table.HasValue(propClasses,ent:GetClass()) and (attacker:Team() == ent:TeamSide() or dmginfo:IsBulletDamage()) then
				NullifyDamage()
				
				// Hurr durrrr
				if (attacker:Team() == ent:TeamSide()) then
					attacker.stupiditywarning = attacker.stupiditywarning or 0
					attacker.stupiditywarning = attacker.stupiditywarning + 1
					if (attacker.stupiditywarning == 5) then
						attacker:Notify("You must defend your props, not hit them!", NOTIFY_GENERIC)
					end
					if (attacker.stupiditywarning == 10) then
						attacker:Notify("You're not very bright are you?", NOTIFY_GENERIC)
					end
					if (attacker.stupiditywarning == 15) then
						attacker:Notify("I give up!", NOTIFY_GENERIC)
					end
				end
				
			end
		end
	end
	
	if dmginfo:GetDamageType() == DMG_CRUSH then
		// Physics damage
		NullifyDamage()
	end
	
end

function GM:PlayerDeath( pl, inflictor, attacker ) 

	// Call Fretta base function
	self.BaseClass:PlayerDeath( pl, inflictor, attacker )
	
	pl:RemoveTrail() // remove any powerup trails
	pl:RemoveEyeLaser() // uhhh
	
	if ValidEntity(attacker) and attacker:IsPlayer() then
		attacker:AddFrags(1)
		
		// Make em bleed out of their eyes
		if ValidEntity(attacker:GetActiveWeapon())
			and attacker:GetActiveWeapon():GetClass() == "weapon_crowbar" then
			
			local ragdoll = pl:GetRagdollEntity()
			ParticleEffectAttach( "blood_advisor_puncture_withdraw", PATTACH_POINT_FOLLOW, ragdoll, ragdoll:LookupAttachment("eyes") )
		end
	
	end
	
	pl:Spectate(OBS_MODE_NONE)
	pl:UnSpectate()
	pl:AddDeaths(1)
	
	// Drop any player he might've absorbed
	pl:DropAbsorbedPlayer()
	
	// Break any score chains
	pl:RemoveChain()
	
	// Reset props-broken-in-life chain
	pl:RecordAndResetPropsBrokenChain()
	
end

function GM:PlayerDisconnected( pl )

	// Call Fretta base function
	self.BaseClass:PlayerDisconnected( pl )
	
	// Drop any player he might've absorbed
	pl:DropAbsorbedPlayer()

	// Break any score chains
	pl:RemoveChain()
	
	pl:RemoveTrail() // remove any powerup trails
	pl:RemoveEyeLaser()
end

function GM:PropBreak( attacker, prop ) 
	
	if not GAMEMODE:InRound() then return end
	
	// On smashing a prop we have to spawn a new one at the other team's side

	if not table.HasValue(propClasses,prop:GetClass()) then return end

	local value = prop.Value or GetPropValue( prop )

	if prop.breaking then return end // prevent PropBreak getting called twice on the same prop
	prop.breaking = true
	
	local newside
	if attacker:IsPlayer() then 
	
		newside = attacker:Team() 
		print("Player "..attacker:Name().." ("..team.GetName(attacker:Team())..") broke a prop of value "..value)
		
		attacker:AddPropsBrokenChain( prop ) // props broken this life
		attacker.PropsBroken = attacker.PropsBroken + 1 // props broken in total

		attacker.lastfrenzyattack = attacker.lastfrenzyattack or 0
		
		if ValidEntity(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():GetClass() == "weapon_crowbar" 
			and attacker.lastfrenzyattack < CurTime()-1 and attacker:GetPowerup() == "crowbarfrenzy" then
			
			attacker.lastfrenzyattack = CurTime() // must be some delay inbetween, or we'll cause c stack overflows
			attacker:TraceHullAttack( attacker:GetShootPos(), attacker:GetAimVector() * 120, Vector(-48,-48,-48), Vector(96,96,96), 200, DMG_CLUB, 200, true )
		end

		// Adds score. Is determined by chains 'n stuff
		attacker:AddScore( value )
		
	else // it's unlikely a non-player entity breaks a prop, but lets check it anyway
		if (prop:TeamSide() == TEAM_RED) then 
			newside = TEAM_BLUE 
		else
			newside = TEAM_RED
		end
		print("A "..attacker:GetClass().." entity broke a prop of value "..value)
	end
	
	umsg.Start("notifyscorechange")
		umsg.Short(value)
		umsg.Short(newside)
	umsg.End()
	
	local propspawns = table.filter(teaminfo[newside].PropSpawns, function( ent ) return ent:ValueLevel() == value end )
	if #propspawns != 0 then
	
		// lil' bit of randomness
		local spawn = table.Random(propspawns)
		local spawnpos = spawn:GetPos()
		spawnpos.x = spawnpos.x - 20 + math.random(40)
		spawnpos.y = spawnpos.y - 20 + math.random(40)
		
		local newprop = ents.Create(prop:GetClass())
		newprop:SetPos(spawnpos)
		newprop:SetAngles(prop:GetAngles())
		newprop:SetModel(prop:GetModel())
		newprop:Spawn()
		newprop:EmitSound(table.Random(self.PropSpawnSounds))
		
		ParticleEffect("aurora_shockwave",newprop:GetPos(),Angle(0,0,0),nil)
		
		local eff = EffectData()
			eff:SetEntity( newprop )
		util.Effect( "propspawn", eff )
		
		newprop.Value = GetPropValue( newprop )
		
		
	end
	
	// Update prop data / team score
	timer.Simple(0.1,UpdateTeamsPropCount)
end

function GM:GetFallDamage( pl, flFallSpeed )

	pl.TotalFallDamage = pl.TotalFallDamage + flFallSpeed / 48
	return flFallSpeed / 48
	
end

function GM:CanPlayerSuicide( pl )

	return !pl:IsAbsorbed()

end

function GM:PlayerNoClip( pl )
	// Allow noclip for debug purposes
	return pl:IsListenServerHost()
end

function GM:OnPlayerHitGround( pl )

	if pl:GetVelocity():Length() > 300 and pl:GetPowerup() == "harden" then
		ParticleEffect( "ceiling_dust", pl:GetPos(), Angle(90,0,0), nil )
	end

end

function PlayMusic( music, pl )

	local rp = RecipientFilter()
	if not pl then
		rp:AddAllPlayers()
	elseif type(pl) == "table" then
		for k, v in pairs(pl) do
			rp:AddPlayer(v)
		end
	else
		rp:AddPlayer(pl)
	end
	
	umsg.Start("playmusic", rp)
		umsg.String(music)
	umsg.End()
	
end

/*----------------------------
	Other functions
*/----------------------------

function UpdateTeamsPropCount()

	teaminfo[TEAM_RED].PropCount = 0
	teaminfo[TEAM_BLUE].PropCount = 0
	teaminfo[TEAM_RED].TotalPropValue = 0
	teaminfo[TEAM_BLUE].TotalPropValue = 0
	for k, prop in pairs(GetAllProps()) do
		local count = teaminfo[prop:TeamSide()].PropCount
		local value = teaminfo[prop:TeamSide()].TotalPropValue
		teaminfo[prop:TeamSide()].PropCount =  count + 1 // I really miss a simple increment operator...
		teaminfo[prop:TeamSide()].TotalPropValue =  value + GetPropValue( prop )
	end
	
	// Send!
	umsg.Start("update_propcount")
		umsg.Short(teaminfo[TEAM_RED].PropCount)
		umsg.Short(teaminfo[TEAM_RED].TotalPropValue)
		umsg.Short(teaminfo[TEAM_BLUE].PropCount)
		umsg.Short(teaminfo[TEAM_BLUE].TotalPropValue)
	umsg.End()	
	
	team.SetScore(TEAM_RED, teaminfo[TEAM_RED].TotalPropValue)
	team.SetScore(TEAM_BLUE, teaminfo[TEAM_BLUE].TotalPropValue)
end




