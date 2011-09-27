

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "FiveSeven"			
	SWEP.Slot				= 1
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "u"
	
	killicon.AddFont( "weapon_fw_fiveseven", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end


SWEP.Base				= "weapon_fw_base"

SWEP.HoldType			= "pistol"

SWEP.ViewModel			= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_fiveseven.mdl"

SWEP.Primary.Sound			= Sound( "Weapon_FiveSeven.Single" )
SWEP.Primary.Recoil			= 8
SWEP.Primary.Damage			= 32
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.ClipSize		= 21
SWEP.Primary.Delay			= 0.05
SWEP.Primary.DefaultClip	= 21
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.ShellType		= SHELL_9MM

SWEP.IronSightsPos = Vector( 4.5426, -3.4253, 3.2709 )
