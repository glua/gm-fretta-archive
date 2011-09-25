_E.SLOT_FISTS	= 0
_E.SLOT_PISTOL	= 1
_E.SLOT_EXTRA	= 2
_E.SLOT_GRENADE = 3
_E.SLOT_SUPER	= 4

AddCSLuaFile("cl_init.lua")
SWEP.Author = "Ghor"
SWEP.Base = "weapon_base"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Primary.Automatic = true
SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Ammo = "pistol"
SWEP.Secondary.Ammo = "none"
SWEP.LastFired = 0
SWEP.Cooldown = 0.1
SWEP.AmmoCost = 0
SWEP.HoldType = "pistol"
SWEP.Slot = SLOT_PISTOL
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

PrecacheParticleSystem("gtv_impact_bullet2")
PrecacheParticleSystem("gtv_bullet")

local effects_onoff = {}

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:IsCooledDown()
	return self.LastFired+self.Cooldown < CurTime()
end

function SWEP:CanFire()
	return (self.LastFired+self.Cooldown < CurTime()) && ((self.Primary.Ammo == "none") || (self:Ammo1() >= self.AmmoCost))
end

function SWEP:SetNextFire()
	self:SetNextPrimaryFire(CurTime()+self.Cooldown)
	self.LastFired = CurTime()
end

local proj = {}
	local Callback = function(self,tr)
						local dmg = DamageInfo()
						dmg:SetDamageType(DMG_BULLET)
						if self:GetOwner():IsValid() then
							dmg:SetAttacker(self:GetOwner())
						end
						if self:GetInflictor():IsValid() then
							dmg:SetInflictor(self:GetInflictor())
						end
						dmg:SetDamage(self.Damage)
						dmg:SetDamageForce(vector_origin*1)
						if (tr.Entity:GetClass() != "func_breakable") then
							tr.Entity:TakeDamageInfo(dmg)
						else
							tr.Entity:TakeDamage(10,dmg:GetAttacker(),dmg:GetInflictor())
						end
					end
	proj = GProjectile()
	proj:SetCallback(Callback)
	proj:SetBBox(Vector(-8,-8,-8),Vector(8,8,8))
	proj:SetPiercing(false)
	proj:SetGravity(vector_origin)
	proj:SetMask(MASK_SHOT)
	proj:SetLifetime(0.25)
	proj.Damage = 10
SWEP.Bullet = proj

function SWEP:PrimaryAttack()
	if !self:CanFire() then
		if self:IsCooledDown() then
			self.Owner:EmitSound("weapons/pistol/pistol_empty.wav",100,150)
			self:SetNextFire()
		end
		return
	end
	if (self.HoldType == "slam") || (self.HoldType == "rpg") || (self.HoldType == "shotgun") then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	self:Shoot()
	self:TakePrimaryAmmo(self.AmmoCost)
	self:SetNextFire()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Equip(pl)
	pl:EmitSound("weapons/shotgun/shotgun_cock.wav")
	if pl.PossessMulti then
		return
	end
	if pl:GetActiveWeapon().Slot == self.Slot then
		pl:SelectWeapon(self:GetClass())
	end
	local hadwep = false
	for k,v in ipairs(pl:GetWeapons()) do
		if (v != self) && (v.Slot == self.Slot) then
			hadwep = v:GetClass()
			v:Remove()
		end
	end
	if hadwep then
		pl:SendNotification("dropped "..weapons.Get(hadwep).PrintName.." for "..self.PrintName||"???")
	else
		pl:SendNotification("picked up "..self.PrintName)
	end
	if (self.AmmoCost > 0) && pl:GetAmmoCount("pistol") < 200 then
		pl:GiveAmmo(math.min(50,200-pl:GetAmmoCount("pistol")),"pistol")
	end
end

function SWEP:EquipAmmo(pl)
	if (self.AmmoCost > 0) && pl:GetAmmoCount("pistol") < 200 then
		pl:GiveAmmo(math.min(50,200-pl:GetAmmoCount("pistol")),"pistol")
	end
end

local pooledsounds = {}

local PLAYER = FindMetaTable("Player")
	function PLAYER:EmitToAllButSelf(sound,vol,pitch)
		local vol = vol || 100
		local pitch = pitch || 100
		local rf = RecipientFilter()
		rf:AddAllPlayers()
		rf:RemovePlayer(self)
		if !table.HasValue(pooledsounds,sound) then
			umsg.PoolString(sound)
			table.insert(pooledsounds,sound)
		end
		umsg.Start("ent_emitsound",rf)
			umsg.Entity(self)
			umsg.String(sound)
			umsg.Char(vol-127)
			umsg.Char(pitch-127)
		umsg.End()
	end

function SWEP:KillEffect()
	if self.toggleeffect then
		timer.Simple(0.1,self.TimerKillEffect,self.toggleeffect)
		effects_onoff[self.toggleeffect] = false
		self.toggleeffect = nil
	end
end

function SWEP.TimerKillEffect(effectno)	
	umsg.Start("effectoff")
		umsg.Short(effectno)
		//print("End: "..effectno)
	umsg.End()
end

function SWEP:AddToggleEffect(name,edata)
	local efindex = self.toggleeffect
	self:KillEffect()
	local tablelength = table.maxn(effects_onoff)
	local pos = tablelength+1
	for i=1,tablelength do
		if (effects_onoff[i] == nil) then
			pos = i
			break
		elseif (effects_onoff[i] == false) then
			effects_onoff[i] = nil
		end
	end
	self.toggleeffect = pos
	effects_onoff[pos] = self.Owner
	edata:SetScale(pos)
	//print("start: "..pos)
	util.Effect(name,edata,nil,true)
end