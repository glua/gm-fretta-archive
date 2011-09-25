if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= true;
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.HoldType					= "pistol"

SWEP.ViewModel					= "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_fiveseven.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_FiveSeven.Single" );
SWEP.Primary.Recoil				= 0.8;
SWEP.Primary.Damage				= 11;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.026;
SWEP.Primary.ClipSize			= 12;
SWEP.Primary.Delay				= 0.11;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 1.5;

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= true; -- HVA Specific


SWEP.IronSightsPos = Vector (4.492, -1.9525, 3.3454)
SWEP.IronSightsAng = Vector (-0.4148, -0.2109, 0)


SWEP.IronsightsFOV				= 0; -- HVA Specific
SWEP.ShellType					= SHELL_57;

if( CLIENT ) then

	SWEP.PrintName			= "Five Seven";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "u";
	killicon.AddFont( "weapon_five_seven", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end
