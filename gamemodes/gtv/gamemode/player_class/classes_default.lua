
local CLASS = {}

CLASS.DisplayName			= "Default"
CLASS.WalkSpeed 			= 310
CLASS.CrouchedWalkSpeed 	= 0
CLASS.RunSpeed				= 150
CLASS.DuckSpeed				= 0
CLASS.JumpPower				= 0
CLASS.DrawTeamRing			= true
CLASS.DrawViewModel			= false
CLASS.MaxHealth				= 200
CLASS.StartHealth			= 100
CLASS.Description			= ""
CLASS.Selectable			= false

function CLASS:Loadout( pl )
	pl:RemoveAllAmmo()
	local j = math.random(0,3)
	pl:Give("weapon_gtv_fists")
	pl:Give("weapon_gtv_pistol")
	if j == 0 then 
		pl:Give("weapon_gtv_grenade_force")
	elseif j == 1 then
		pl:Give("weapon_gtv_grenade_frag")
	elseif j == 2 then
		pl:Give("weapon_gtv_grenade_incendiary")
	elseif j == 3 then
		pl:Give("weapon_gtv_grenade_shrapnel")
	end
	//pl:GiveAmmo(50,"pistol")
	pl:SelectWeapon("weapon_gtv_pistol")
end

local neutralang = Angle(0,0,0)
function CLASS:OnSpawn( pl )
	pl:Extinguish()
	pl:SetParent()
	pl:Freeze(false)
	pl:EmitSound("ambient/levels/citadel/weapon_disintegrate3.wav")
	pl:SetDuckSpeed(999)
	pl.LifeNumber = (pl.LifeNumber||0)+1
	pl.AwaitingUnSpectate = false
	if pl.LastRagdoll && pl.LastRagdoll:IsValid() then
		pl.LastRagdoll.Owner = nil
		pl.LastRagdoll = NULL
	end
	SuppressHostEvents(NULL)
	ParticleEffect("gtv_playerteleport",pl:GetPos(),neutralang,Entity(0))
	pl.KillsThisLife = 0
end

function CLASS:Move( pl, mv )

	
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

player_class.Register( "default_gtv", CLASS )

if SERVER then

	util.PrecacheModel("models/Gibs/HGIBS.mdl")
	util.PrecacheModel("models/Gibs/Antlion_gib_medium_2.mdl")
	util.PrecacheModel("models/Gibs/Antlion_gib_Large_1.mdl")
	util.PrecacheModel("models/Gibs/Antlion_gib_medium_1.mdl")
	util.PrecacheModel("models/props_junk/watermelon01_chunk02a.mdl")

end

function CLASS:ShouldDrawLocalPlayer( pl )
	return true
end

--overwriting frag functions to use NWVars so they don't break from using high point values
local PLAYER = FindMetaTable("Player")
function PLAYER:SetFrags(frags)
	self:SetNWInt("frags",frags)
	if frags > self:GetNWInt("HighScore") then
		self:SetNWInt("HighScore",frags)
	end
end
function PLAYER:AddFrags(frags)
	self:SetFrags(self:GetNWInt("frags")+frags)
end
function PLAYER:Frags()
	return self:GetNWInt("frags")
end
function PLAYER:HighScore()
	return self:GetNWInt("HighScore")
end

if SERVER then
	function PLAYER:SendPointNotification(pos,value)
		umsg.Start("gtv_score",self)
			umsg.Vector(pos)
			umsg.Short(value)
		umsg.End()
	end
	
	function PLAYER:SendNotification(text)
		umsg.Start("gtv_msg",self)
			umsg.String(text)
		umsg.End()
	end
else
	usermessage.Hook("gtv_msg",function(um) local label = GAMEMODE.NotificationPanel label:SetText(um:ReadString()) label.LastMsgTime = CurTime() label:PerformLayout() end)
end