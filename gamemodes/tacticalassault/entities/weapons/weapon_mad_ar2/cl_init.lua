include('shared.lua')

SWEP.PrintName			= "AR-2 PULSE-RIFLE"				// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 3							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_ar2.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_ar2")
end