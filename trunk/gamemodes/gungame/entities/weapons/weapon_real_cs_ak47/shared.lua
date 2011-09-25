-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "ar2"
end

if (CLIENT) then
	SWEP.PrintName 		= "KALASHNIKOV AK-47"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "b"

	killicon.AddFont("weapon_real_cs_ak47", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
end

SWEP.EjectDelay			= 0.05

SWEP.Instructions 		= "Damage: 33% \nRecoil: 10% \nPrecision: 77% \nType: Automatic \nRate of Fire: 600 rounds per minute \n\nChange Mode: E + Right Click"

SWEP.Base 				= "weapon_real_base_rifle"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel 			= "models/weapons/w_rif_ak47.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil 		= 1
SWEP.Primary.Damage 		= 33
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.023
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.Delay 		= 0.1
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

SWEP.Secondary.ClipSize 	= -1
SWEP.Secondary.DefaultClip 	= -1
SWEP.Secondary.Automatic 	= false
SWEP.Secondary.Ammo 		= "none"

SWEP.IronSightsPos 		= Vector (6.0816, -7.8745, 2.5074)
SWEP.IronSightsAng 		= Vector (2.4511, -0.0486, 0)