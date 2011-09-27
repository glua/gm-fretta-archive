AddCSLuaFile("shared.lua")

SWEP.Author			= "mahalis"
SWEP.Contact		= "mahalis@gmail.com"
SWEP.Purpose		= "Shoot blobs of plasma at things"
SWEP.Instructions	= "Point and click"

if CLIENT then

SWEP.PrintName = "Plasma gun"
SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = false
SWEP.BounceWeaponIcon = false
--SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" )

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self.Weapon:GetNetworkedInt("ammo")
	
	return self.AmmoDisplay
end

end

SWEP.ViewModel		= "models/weapons/v_irifle.mdl"
SWEP.WorldModel		= "models/weapons/w_irifle.mdl"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo	= "none"

SWEP.ChargeStartedTime = 0
SWEP.ChargeLoad = 0
SWEP.ChargeLastTookTime = 0

if SERVER then
	SWEP.LastGaveAmmo = 0
end

function SWEP:Think()

	if CLIENT then return end
	
	local amm = self:GetNetworkedInt("ammo")
	
	if self.Owner:KeyDown(IN_ATTACK2) then
		if !self.Weapon:GetNetworkedBool("charging") then
			self.ChargeStartedTime = CurTime()
			self.ChargeLoad = 0
		end
		if CurTime() > self.ChargeLastTookTime + .2 and amm > 1 and self.ChargeLoad < 15 then
			amm = amm - 1
			self.ChargeLoad = self.ChargeLoad + 1
			self.ChargeLastTookTime = CurTime()
			self:SetNetworkedInt("ammo",amm,true)
		end
		self.Weapon:SetNetworkedBool("charging",true,false)
	else
		if self:GetNetworkedBool("charging") then
			--  release blob
			self:Blob(self.ChargeLoad)
			umsg.Start("Mutant_GunBlob",self.Owner)
				umsg.Entity(self)
				umsg.Short(self.ChargeLoad)
			umsg.End()
			self.ChargeLoad = 0
			self:SetNetworkedBool("charging",false,true)
		end
		
		if CurTime() > self.LastGaveAmmo + 0.5 and amm < 30 then
			self.Weapon:SetNetworkedInt("ammo",amm + 1)
			self.LastGaveAmmo = CurTime()
		end
	end
	
end

function SWEP:Blob(size)
	self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self.Weapon:EmitSound(Sound("weapons/airboat/airboat_gun_energy" .. tostring(math.random(1,2)) .. ".wav"),70,120)
	
	self:SetNextPrimaryFire(CurTime() + 0.4)
	
	if CLIENT then return end
	
	self.LastGaveAmmo = CurTime()
	
	local blob = self:SpawnProjectile()
	blob.Damage = blob.Damage + 1.5*size
	blob:SetNetworkedInt("size",size,true)
end

local function ClientBlob(um)
	um:ReadEntity():Blob(um:ReadShort())
end
usermessage.Hook("Mutant_GunBlob",ClientBlob)

function SWEP:Initialize()
	self.Weapon:SetNetworkedInt("ammo",30,true)
end

function SWEP:PrimaryAttack()
	if self.Weapon:GetNetworkedInt("ammo") <= 0 or self:GetNetworkedBool("charging") then return false end
	self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound(Sound("weapons/airboat/airboat_gun_energy" .. tostring(math.random(1,2)) .. ".wav"),70,120)
	
	self:SetNextPrimaryFire(CurTime() + 0.2)
	
	if CLIENT then return end
	self.LastGaveAmmo = CurTime()
	self.Weapon:SetNetworkedInt("ammo",self.Weapon:GetNetworkedInt("ammo") - 1,true)
	
	self:SpawnProjectile()
end

function SWEP:SpawnProjectile()
	local projClass = "mt_projectile"

	if self.Owner:IsMutant() then projClass = "mt_projectile_mutant" end
	
	local plas = ents.Create(projClass)
	plas:SetPos(self.Owner:GetShootPos() + self.Owner:GetAimVector() * 20)
	plas:SetOwner(self.Owner)
	plas.Weapon = self
	local eAng = self.Owner:EyeAngles()
	eAng:RotateAroundAxis(eAng:Right(),-90)
	plas:SetAngles(eAng)
	plas:Spawn()

	local phy = plas:GetPhysicsObject()
	if phy:IsValid() then
		phy:ApplyForceCenter(560 * self.Owner:GetAimVector())
	end
	return plas
end

function SWEP:SecondaryAttack()

end
