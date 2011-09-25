//resource.AddFile("particles/gtv.pcf")

-- Clientside Files
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_splashscreen.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_radar.lua")
AddCSLuaFile("cl_scoreboard.lua")

-- Includes
include( "projectiles.lua")
include( "shared.lua" )
//include("Excitement.lua")
include("sv_spectator.lua")
include("player.lua")
include("resources.lua")

PrecacheParticleSystem("gtv_smokeburst")
PrecacheParticleSystem("gtv_lightburst")

--Dev cheats
hook.Add("PlayerSpawn","cheats1",function(pl) pl.PossessMulti = false end)
concommand.Add("rtkfa",function(pl,cmd,args)
	if GetConVarNumber("sv_cheats") == 0 then
		return
	end
	
	pl.PossessMulti = true
	
	pl:GiveAmmo(200-pl:GetAmmoCount("pistol"),"pistol")
	
	pl:Give("weapon_gtv_pistol")
	pl:Give("weapon_gtv_machinegun")
	pl:Give("weapon_gtv_shotgun")

	pl:Give("weapon_gtv_minigun")
	pl:Give("weapon_gtv_rocketlauncher")
	pl:Give("weapon_gtv_seeker")
	pl:Give("weapon_gtv_flamethrower")
	pl:Give("weapon_gtv_beegun")
	
	pl:Give("weapon_gtv_grenade_frag")
	pl:Give("weapon_gtv_grenade_incendiary")
	pl:Give("weapon_gtv_grenade_force")
	pl:Give("weapon_gtv_grenade_shrapnel")
end)

PrecacheParticleSystem("gtv_confetti")
PrecacheParticleSystem("gtv_money")
PrecacheParticleSystem("gtv_bloodburst")
PrecacheParticleSystem("gtv_playerteleport")
local neutralang = Angle(0,0,0)

function GM:OnRoundStart( num )
	for k,v in ipairs(player.GetAll()) do
		v:SetViewEntity(v)
		v:SetFrags(0)
		v:SetDeaths(0)
	end
	UTIL_UnFreezeAllPlayers()
end

local poffset = Vector(0,0,600)

function GM:OnRoundEnd( num )
	local highestscore = 0
	local firstplace
	local players = player.GetAll()
	for k,v in ipairs(players) do
		if v:Frags() > highestscore then
			highestscore = v:Frags()
			firstplace = v
		end
	end
	if firstplace then
		ParticleEffect("gtv_confetti",firstplace:GetPos()+poffset,neutralang,Entity(0))
		ParticleEffect("gtv_money",firstplace:GetPos()+poffset,neutralang,Entity(0))
		for k,v in ipairs(players) do
			v:SetViewEntity(firstplace)
		end
	end
	local rf = RecipientFilter()
	rf:AddAllPlayers()
	ClientCallGamemode(rf,"OnRoundEnd")
end

/*---------------------------------------------------------
   Name: gamemode:EntityTakeDamage( entity, inflictor, attacker, amount, dmginfo )
   Desc: The entity has received damage	 
---------------------------------------------------------*/

local edata = EffectData()
function GM:EntityTakeDamage(ent,inflictor,attacker,amount,dmginfo)
	if !ent:IsWorld() && (ent:Health() > 1) && (ent:GetClass() != "func_door") then
		edata:SetEntity(ent)
		edata:SetOrigin(ent:GetPos())
		util.Effect("ef_gtv_playerhit",edata)
		if ent:IsPlayer() then
			ParticleEffect("gtv_bloodburst",ent:GetShootPos(),neutralang,Entity(0))
		end
	end
end