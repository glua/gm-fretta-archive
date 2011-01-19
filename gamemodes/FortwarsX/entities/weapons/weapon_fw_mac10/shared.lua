

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "ar2"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "Mac10"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 4
	SWEP.IconLetter			= "l"
	
	killicon.AddFont( "weapon_fw_mac10", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end


SWEP.Base				= "weapon_fw_base"

SWEP.ViewModel			= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" )
SWEP.Primary.Recoil			= 6
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.06
SWEP.Primary.ClipSize		= 25
SWEP.Primary.Delay			= 0.08
SWEP.Primary.DefaultClip	= 75
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.ShellType		= SHELL_9MM

SWEP.IronSightsPos = Vector( 6.6623, -2.2254, 2.773 )
SWEP.IronSightsAng = Vector( 1.7544, 4.6799, 6.4257 )
