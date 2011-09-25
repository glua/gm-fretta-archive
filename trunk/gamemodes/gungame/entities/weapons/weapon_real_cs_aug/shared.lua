-- Read the weapon_real_base if you really want to know what each action does

if (SERVER) then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType 		= "ar2"
end

if (CLIENT) then
	SWEP.PrintName 		= "STEYR AUG A1"
	SWEP.Slot 			= 3
	SWEP.SlotPos 		= 1
	SWEP.IconLetter 		= "e"

	killicon.AddFont("weapon_real_cs_aug", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

/*---------------------------------------------------------
Muzzle Effect + Shell Effect
---------------------------------------------------------*/
SWEP.MuzzleEffect			= "rg_muzzle_rifle" -- This is an extra muzzleflash effect
-- Available muzzle effects: rg_muzzle_grenade, rg_muzzle_highcal, rg_muzzle_hmg, rg_muzzle_pistol, rg_muzzle_rifle, rg_muzzle_silenced, none

SWEP.ShellEffect			= "rg_shelleject_rifle" -- This is a shell ejection effect
-- Available shell eject effects: rg_shelleject, rg_shelleject_rifle, rg_shelleject_shotgun, none

SWEP.MuzzleAttachment		= "1" -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment	= "2" -- Should be "2" for CSS models or "1" for hl2 models
/*-------------------------------------------------------*/

SWEP.Instructions 		= "Damage: 22% \nRecoil: 12% \nPrecision: 93% \nType: Automatic \nRate of Fire: 650 rounds per minute \n\nChange Mode: E + Right Click"

SWEP.Base 				= "weapon_real_cs_sg550"

SWEP.Spawnable 			= true
SWEP.AdminSpawnable 		= true

SWEP.ViewModel 			= "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel 			= "models/weapons/w_rif_aug.mdl"

SWEP.Primary.Sound 		= Sound("Weapon_Aug.Single")
SWEP.Primary.Damage 		= 22
SWEP.Primary.Recoil 		= 1.2
SWEP.Primary.NumShots 		= 1
SWEP.Primary.Cone 		= 0.0007
SWEP.Primary.ClipSize 		= 30
SWEP.Primary.Delay 		= 0.09
SWEP.Primary.DefaultClip 	= 30
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo 		= "smg1"

---------------------------
-- Ironsight/Scope --
---------------------------
-- IronSightsPos and IronSightsAng are model specific paramaters that tell the game where to move the weapon viewmodel in ironsight mode.

SWEP.IronSightsPos 			= Vector (5.656, -6.6379, 1.5765)
SWEP.IronSightsAng 			= Vector (0, 0, 54.0713)
SWEP.IronSightZoom			= 1.3 -- How much the player's FOV should zoom in ironsight mode. 
SWEP.UseScope				= true -- Use a scope instead of iron sights.
SWEP.ScopeScale 				= 0.4 -- The scale of the scope's reticle in relation to the player's screen size.
SWEP.ScopeZooms				= {4} -- The possible magnification levels of the weapon's scope.   If the scope is already activated, secondary fire will cycle through each zoom level in the table.
SWEP.DrawParabolicSights		= false -- Set to true to draw a cool parabolic sight (helps with aiming over long distances)