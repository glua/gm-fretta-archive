
if SERVER then
   AddCSLuaFile( "shared.lua" )
end

SWEP.HoldType			= "pistol"

if CLIENT then
   SWEP.PrintName			= "USP45 OIC Mod"
   SWEP.Author				= "Adobe Ninja"
   SWEP.Slot				= 0
   SWEP.SlotPos			= 0
   SWEP.IconLetter			= "f"
   
   killicon.AddFont( "weapon_usp", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "weapon_oic_base_v2"
SWEP.Primary.Recoil	= 0
SWEP.Primary.Damage = 1000
SWEP.Primary.Delay = 0.32
SWEP.Primary.Cone = 0.0
SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = 1
SWEP.Primary.ClipMax = 10
SWEP.Primary.Ammo = "Pistol"



SWEP.ViewModel			= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel			= "models/weapons/w_pist_usp.mdl"

SWEP.Primary.Sound = Sound( "Weapon_USP.SilencedShot" )
SWEP.IronSightsPos = Vector( 4.48, -4.34, 2.75)
SWEP.IronSightsAng = Vector(-0.5, 0, 0)

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED

