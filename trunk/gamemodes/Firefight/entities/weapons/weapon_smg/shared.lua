
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType			= "smg"
	
end

if ( CLIENT ) then

	SWEP.PrintName			= "SMG"			
	SWEP.Author				= "Carnag3"
	SWEP.Slot				= 2
	SWEP.SlotPos			= 3
	
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
 
		draw.SimpleText( "x", "CSKillIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
 
	end
	
	killicon.AddFont( "weapon_smg", "CSKillIcons", "x", Color( 255, 80, 0, 255 ) )
	
end


SWEP.Base				= "weapon_cs_base" -- using cs base for easyness.
SWEP.Category			= "Carnag3"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.ViewModelFlip 		= false

SWEP.Primary.Sound			= Sound( "Weapon_MP5Navy.Single" )
SWEP.Primary.Recoil			= 0.2
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.12
SWEP.Primary.ClipSize		= 24
SWEP.Primary.Delay			= 0.1
SWEP.Primary.DefaultClip	= 48
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos 		= Vector( -6, -6.8, 2 )
