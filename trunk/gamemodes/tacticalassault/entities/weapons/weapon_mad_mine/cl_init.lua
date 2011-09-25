include('shared.lua')

SWEP.PrintName			= "ANTI-PERSONAL MINES"				// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 4							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_mine.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_mine")
end

language.Add("Undone_Anti-Personal Mine", "Undone Anti-Personal Mine")
language.Add("Cleanup_Anti-Personal Mine", "Clean Up Anti-Personal Mine")
language.Add("Cleaned_Anti-Personal Mine", "Cleaned Anti-Personal Mine")