-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType		= "pistol"
end

if (CLIENT) then
	SWEP.PrintName 		= "FN FIVE-SEVEN"
	SWEP.ViewModelFOV		= 70
	SWEP.Slot 			= 1
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "u"

	killicon.AddFont("weapon_real_cs_five-seven", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ))
end

SWEP.EjectDelay			= 0.05

SWEP.Instructions 		= "Damage: 10% \nRecoil: 6% \nPrecision: 89% \nType: Semi-Automatic"

SWEP.Base 				= "weapon_real_base_pistol"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel 			= "models/weapons/w_pist_fiveseven.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_FiveSeven.Single")
SWEP.Primary.Recoil 		= 0.6
SWEP.Primary.Damage 		= 10
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.011
SWEP.Primary.ClipSize 		= 20
SWEP.Primary.Delay 		= 0.13
SWEP.Primary.DefaultClip 	= 20
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo 		= "pistol"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector (4.5282, -4.7373, 3.3248)
SWEP.IronSightsAng 		= Vector (-0.4139, 0.0182, 0)