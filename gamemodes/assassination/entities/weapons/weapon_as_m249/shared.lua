if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "smg";
end

if( CLIENT ) then
	SWEP.PrintName				= "M249\nSquad Automatic Weapon";
	SWEP.ViewModelFlip			= false;
	SWEP.CSMuzzleFlashes		= true;
	SWEP.ViewModelFOV			= 74;
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_mach_m249para.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_mach_m249para.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_M249.Single" );
SWEP.Primary.Recoil				= 5.95;
SWEP.Primary.Damage				= 30;
SWEP.Primary.Cone				= 0.095;
SWEP.Primary.Automatic			= true;
SWEP.Primary.ClipSize			= 100;
SWEP.Primary.Delay				= 0.05;
SWEP.Primary.Ammo				= "pistol"; 
SWEP.Primary.DefaultClip		= 500;

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;


SWEP.RunArmOffset 				= Vector (4.3993, -3.5007, 3.6905)
SWEP.RunArmAngle 				= Vector (-12.5777, 55.7671, 18.7486)

SWEP.IronSightsTime				= 0.5;

SWEP.HasIronsights 				= true;
SWEP.IronSightsPos 				= Vector (-4.3798, -1.8776, 1.8157)
SWEP.IronSightsAng 				= Vector (0.9423, 0.2617, 0.2333)
SWEP.IronsightsFOV				= 55;
SWEP.IronsightAccuracy			= 2.5;

SWEP.Primary.ReloadSpeed		= 3;