/*
THIS CONTENT WAS MADE BY BLACKOPS7799

IF THIS CONTENT IS IN ANY OTHER PACK THAT IS NOT RELEASED BY ME IT IS STOLEN

PLEASE DONT USE MY STUFF FOR YOUR MODS.
*/

if ( SERVER ) then
	SWEP.HoldType			= "melee"
end

if ( CLIENT ) then
	SWEP.PrintName		= "OddBall"
	SWEP.Author		= "Blackops7799"
	SWEP.Contact		= "blackops7799@gmail.com"
	SWEP.Purpose		= ""
	SWEP.ViewModelFOV	= "65"
	SWEP.Instructions	= "RUN AWAY!"
	SWEP.Slot = 1
	SWEP.Slotpos = 0
	SWEP.CSMuzzleFlashes	= true
end

SWEP.Category = "Halo"

SWEP.HoldType			= "melee"

SWEP.data = {}
SWEP.data.newclip = false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_oddball.mdl"
SWEP.WorldModel			= "models/weapons/w_oddball.mdl"
SWEP.ViewModelFlip		= false

SWEP.Drawammo = false
SWEP.DrawCrosshair = false 

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound		= Sound( "" )
SWEP.Primary.Recoil		= 0
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone		= 0
SWEP.Primary.ClipSize		= 0
SWEP.Primary.Delay		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= 1
SWEP.Secondary.DefaultClip	= 1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

function SWEP:Initialize()
	if (SERVER) then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:PrimaryAttack()
	return
end

function SWEP:Reload()
	return
end

function SWEP:Deploy()
end

if SERVER then
	function SWEP:Holster( wep )
		local ply = self.Owner

		if ply and ply:IsValid() then
			GAMEMODE:DropBall(ply)
		end

		return true
	end

	SWEP.PointsDelay = 0
	function SWEP:Think()
		local ply = self.Owner
		if ply and ply:GetNWBool("HasOddBall",false) == true and CurTime() >= self.PointsDelay then

			GAMEMODE:DoBallPoints(ply:Team())
			ply:SetNWInt("Time",ply:GetNWInt("Time",0)+1)

			self.PointsDelay = CurTime() + 1
		end
	end
end