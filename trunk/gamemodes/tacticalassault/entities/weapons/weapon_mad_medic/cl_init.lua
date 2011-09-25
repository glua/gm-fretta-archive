include('shared.lua')

SWEP.PrintName			= "MEDIC KIT"					// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 4							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_medic.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_medic")
end

language.Add("Undone_Medic Kit", "Undone Medic Kit")
language.Add("Cleanup_Medic Kit", "Clean Up Medic Kit")
language.Add("Cleaned_Medic Kit", "Cleaned Medic Kit")