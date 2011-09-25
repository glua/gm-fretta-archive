if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= false;
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.HoldType					= "crossbow"

SWEP.ViewModel					= "models/weapons/v_mach_m249para.mdl"
SWEP.WorldModel					= "models/weapons/w_mach_m249para.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_M249.Single" );
SWEP.Primary.Recoil				= 3.95;
SWEP.Primary.Damage				= 25;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.084;
SWEP.Primary.ClipSize			= 100;
SWEP.Primary.Delay				= 0.085;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.5;

SWEP.SprayAccuracy				= 0.93;
SWEP.SprayTime					= 0.2;

SWEP.HasIronsights				= true; -- HVA Specific
SWEP.IronSightsPos 				= Vector (-4.3798, -1.8776, 1.8157)
SWEP.IronSightsAng 				= Vector (0.9423, 0.2617, 0.2333)
SWEP.IronsightsFOV				= 75; -- HVA Specific

SWEP.RunArmOffset = Vector (4.3993, -3.5007, 3.6905)
SWEP.RunArmAngle = Vector (-12.5777, 55.7671, 18.7486)

SWEP.PenetrationMax = 128;
SWEP.PenetrationMaxWood = 256;

SWEP.ReloadSpeed		= 2.0;

SWEP.ShellType					= SHELL_556;

if( CLIENT ) then

	SWEP.PrintName			= "M249 SAW";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "z";
	killicon.AddFont( "weapon_m249", "HVACSKillIcons", SWEP.IconLetter, Color( 200,200,200, 255 ) );
	
end
