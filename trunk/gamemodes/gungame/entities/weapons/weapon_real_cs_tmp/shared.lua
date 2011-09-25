-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "smg"
end

if (CLIENT) then
	SWEP.PrintName 		= "STEYR TMP"
	SWEP.Slot 			= 2
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "d"

	killicon.AddFont("weapon_real_cs_tmp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

/*---------------------------------------------------------
Muzzle Effect + Shell Effect
---------------------------------------------------------*/
SWEP.MuzzleEffect			= "rg_muzzle_silenced" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "rg_shelleject" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models
/*-------------------------------------------------------*/

SWEP.Instructions 		= "Damage: 12% \nRecoil: 4% \nPrecision: 72% \nType: Automatic \nRate of Fire: 850 rounds per minute \n\nChange Mode: E + Right Click"

SWEP.Base 				= "weapon_real_base_special_aim"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_smg_tmp.mdl"
SWEP.WorldModel 			= "models/weapons/w_smg_tmp.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_TMP.Single")
SWEP.Primary.Recoil 		= .4
SWEP.Primary.Damage 		= 12
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.028
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.Delay 		= 0.07
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "pistol"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector (3.963, -3.271, 1.7058)
SWEP.IronSightsAng 		= Vector (1.5025, 0.6891, 0)

SWEP.data 				= {}
SWEP.mode 				= "auto"

SWEP.data.semi 			= {}

SWEP.data.auto 			= {}

/*---------------------------------------------------------
SecondaryAttack
---------------------------------------------------------*/
function SWEP:SecondaryAttack()

	if self.Owner:KeyDown(IN_USE) then
		if self.mode == "semi" then
			self.mode = "auto"
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		else
			self.mode = "semi"
			self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
		end
		self.data[self.mode].Init(self)
		
		if self.mode == "auto" then
			self.Weapon:SetNetworkedInt("csef",1)
		elseif self.mode == "semi" then
			self.Weapon:SetNetworkedInt("csef",3)
		end

	elseif SERVER then
		end
end