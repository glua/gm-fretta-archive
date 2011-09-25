// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Serverside functions and methods for the gamemode.

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_scores.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("skin.lua")
AddCSLuaFile("entities/effects/ShieldShatter/init.lua")

// VGUI
local strpath = "lasertag/gamemode/vgui"
for k,v in ipairs(file.FindInLua(strpath.."/*.lua")) do
	AddCSLuaFile(strpath.."/"..v)
end

/*
AddCSLuaFile("vgui/vgui_hudlayout.lua")
AddCSLuaFile("vgui/vgui_hudelement.lua")
AddCSLuaFile("vgui/vgui_hudupelement.lua")
AddCSLuaFile("vgui/vgui_hudbase.lua")
AddCSLuaFile("vgui/vgui_hudcommon.lua")
*/

function ShareResources(folder)
	for _,f in ipairs(file.Find("../"..folder.."/*")) do
		if string.sub(f,-4) == ".vtf" or string.sub(f,-4) == ".vmt" then
			resource.AddFile(folder.."/"..f)
		end
	end
end

ShareResources("materials/LaserTag")
ShareResources("materials/LaserTag/HUD")
resource.AddFile("resources/fonts/Dodger.TTF")

resource.AddFile("materials/maps/lt_saon.vtf")
resource.AddFile("materials/maps/lt_saon.vmt")

include( "shared.lua" )

/*-------------------------------------------------------------------
	[ DevMode ] 
	Developmental feature that freezes all players except the user
	and gives the user noclip mode. Primarily used to test effects
	on bots without them walking all over.
-------------------------------------------------------------------*/
_DEVMODE = false
function GM:DevMode(ply,cmd,args)
	if not ply:IsAdmin() then return ply:PrintMessage(HUD_PRINTTALK,"DevMode is an admin-only feature.") end
	
	for _,t in ipairs(player.GetAll()) do
		if t ~= ply and not _DEVMODE then t:Freeze(true) else t:Freeze(false) end
	end
	
	if not _DEVMODE then
		ply:SetMoveType(MOVETYPE_NOCLIP)
		PrintMessage(HUD_PRINTCENTER,"DevMode ENABLED - "..ply:GetName())
	else
		ply:SetMoveType(MOVETYPE_WALK)
		PrintMessage(HUD_PRINTCENTER,"DevMode DISABLED - "..ply:GetName())
	end
	
	_DEVMODE = !_DEVMODE
end
concommand.Add("devmode",function(...) GAMEMODE:DevMode(unpack(arg)) end)


/*-------------------------------------------------------------------
	[ AssimilatePlayer ]
	Swaps a player to the attacker's team and checks if the win
	conditions have been met.
-------------------------------------------------------------------*/
function GM:AssimilatePlayer(ply,attacker)
	if not SERVER then return end
	
	local pretm 	= ply:Team()
	local tm 		= attacker:Team()
	local pclass 	= ply:GetPlayerClass()
	
	ply:SetTeam(tm)
	pclass:SetShield(ply,pclass.ShieldMax)
	
	ply:AddDeaths(1)
	attacker:AddFrags(1)
	
	self:CheckPlayerDeathRoundEnd() // Use this to check if a team has won. (by assimilating all players)
	
	// Send tag notify
	umsg.Start("LaserTag-Notify")
		umsg.Entity(attacker)
		umsg.Short(tm)
		umsg.Entity(ply)
		umsg.Short(pretm)
	umsg.End()
end

/*-------------------------------------------------------------------
	[ SplashDamage ]
	Causes splash damage at the origin pos.
-------------------------------------------------------------------*/
function GM:SplashDamage(attacker,origin,radius,damage,filter)
	local affected = ents.FindInSphere(origin,radius)
	damage = damage or 100
	
	if attacker and attacker:IsValid() then wep = attacker:GetActiveWeapon() end
	
	for _,ent in ipairs(affected) do
		if not table.HasValue(filter,ent) then
			local pos = ent:GetPos()
			local hit = false
			
			if ent:IsPlayer() then
				local TraceLines = {}
				table.insert(TraceLines,pos)
				table.insert(TraceLines,ent:EyePos())
				
				pos = pos + Vector(0,0,32)
				table.insert(TraceLines,pos)
				
				for i=1,#TraceLines do
					local tr = util.TraceLine({
						start = origin,
						endpos = TraceLines[i],
						filter = filter
					})
					
					if tr.Hit and tr.Entity == ent then hit = true break end
				end
				
				if hit then
					local dist = origin:Distance(pos)
					local factor = (1 - dist/radius)
					local dmg = damage * factor
					local force = 10 * factor
					
					// TODO: Team avoidance. Don't run effect and don't damage shield on players of the same team, but do punt.
					
					if wep then // Apply via weapon to allow powerups to influence damage etc.
						wep:OnSplashPlayer(ent,dmg)
					else ent:GetPlayerClass():DamageShield(ent,dmg,attacker) end // Apply damage standard.
					
					ent:SetGroundEntity(NULL) // Unground the player (gives more consistent forcing)
					ent:SetVelocity((pos - origin) * force) // Apply knockback.
					
					// Shield flicker effects.
					local fx = EffectData()
						fx:SetOrigin(ent:GetPos())
						fx:SetEntity(ent)
					util.Effect("ShieldFlicker",fx,true,true)
				end
			elseif ent:GetPhysicsObject():IsValid() and ent:GetClass() ~= "lt_powerup" then
				local tr = util.TraceLine({
					start = origin,
					endpos = pos,
					filter = filter
				})
				
				if tr.Hit and tr.Entity == ent then
					local phys = ent:GetPhysicsObject()
					local dist = origin:Distance(pos)
					local factor = (1 - dist/radius)
					local dmg = damage * factor
					local force = phys:GetMass() * 100 * factor
					ent:GetPhysicsObject():ApplyForceCenter((pos - origin) * force)
					ent:TakeDamage(dmg,attacker,attacker)
				end
			end
		end
	end
	
	// TODO: No teamdamage. Player & prop knockback. Viewpunch.
end

function PullKey(tbl) 
	local remaining = {}
	
	
	return res
end

/*-------------------------------------------------------------------
	[ OnPreRoundStart ]
	Automatically swap players to appropriate teams after a round ends.
-------------------------------------------------------------------*/
function GM:OnPreRoundStart()
	print("Reassigning players...")
	// TODO: Consider using automatic assigners based on skill, that way we don't get 90% of the rounds where the good players are lumped together on the same team.
	local curteam = 1
	local players = {}
	
	for _,ply in ipairs(player.GetAll()) do // Very bad way of randomising, but using table.sort and a randomise sort function seems to make it break.
		table.insert(players,{Ply=ply,ID=math.random(1,100)})
	end
	
	table.SortByMember(players,"ID")
	
	
	// Assign them in an orderly fashion to each team.
	for _,v in ipairs(players) do
		ply = v.Ply
		
		if ply:Team() >= 1 and ply:Team() <= 4 then
			print("Send "..ply:Name().." to "..team.GetName(curteam))
			ply:SetTeam(curteam)
			self:StatsReset(ply)
			
			curteam = curteam + 1
			if curteam > 4 then curteam = 1 end
		end
	end
	
	return self.BaseClass:OnPreRoundStart()
end

function GM:OnRoundEnd()
	/*
	for k,v in pairs( player.GetAll() ) do

		v:Freeze(true)
		v:ConCommand( "+showscores" )
		
	end
	*/
	
	self:CalculateStats()
	
end


/*-------------------------------------------------------------------
	[ Think]
-------------------------------------------------------------------*/
function GM:Think()
	self.BaseClass:Think()
	self:StatThink()
end

