include('shared.lua')

SWEP.PrintName			= "FISTS OF DEATH"						// 'Nice' Weapon name (Shown on HUD)	
SWEP.Slot				= 0							// Slot in the weapon selection menu
SWEP.SlotPos			= 1							// Position in the slot

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_fists.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_fists")
end

/*---------------------------------------------------------
   Name: SWEP:DrawHUD()
   Desc: You can draw to the HUD here. It will only draw when
	   the client has the weapon deployed.
---------------------------------------------------------*/
function SWEP:DrawHUD()
end