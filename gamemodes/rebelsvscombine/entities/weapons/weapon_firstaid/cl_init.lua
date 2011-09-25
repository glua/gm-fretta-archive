include('shared.lua')

SWEP.PrintName			= "MedKit"					// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 5							// Slot in the weapon selection menu
SWEP.SlotPos			= 3	                        // Position in the slot
SWEP.DrawCrosshair		= true
SWEP.DrawAmmo 			= true;
// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_medic.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_medic")
end
