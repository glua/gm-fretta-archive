if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= true; -- HVA Specific
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.HoldType					= "pistol"

SWEP.ViewModel					= "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_deagle.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Deagle.Single" );
SWEP.Primary.Recoil				= 3.82;
SWEP.Primary.Damage				= 20;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.065;
SWEP.Primary.ClipSize			= 7;
SWEP.Primary.Delay				= 0.12;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 1.1;

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (5.1378, -2.6955, 2.6575)
SWEP.IronSightsAng = Vector (0.3551, -0.1281, 0.4)

SWEP.RunArmOffset = Vector (-3.448, 0, -0.7646)
SWEP.RunArmAngle = Vector (-18.4912, -29.8594, 18.1858)

SWEP.IronsightsFOV				= 0; -- HVA Specific
SWEP.ShellType					= SHELL_338MAG;

if( CLIENT ) then

	SWEP.PrintName			= "Desert Eagle";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "f";
	killicon.AddFont( "weapon_deserteagle", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end
