if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "shotgun";
end

if( CLIENT ) then
	SWEP.PrintName				= "Benelli M4 Super 90";
	
	SWEP.ViewModelFlip			= true;
	SWEP.CSMuzzleFlashes		= true;
	SWEP.ViewModelFOV			= 74;
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_shot_xm1014.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_shot_xm1014.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_XM1014.Single" );
SWEP.Primary.Recoil				= 2.95;
SWEP.Primary.Damage				= 35;
SWEP.Primary.Cone				= 0.19;
SWEP.Primary.Automatic			= false;
SWEP.Primary.ClipSize			= 4;
SWEP.Primary.Delay				= 0.1;
SWEP.Primary.Ammo				= "buckshot"; 
SWEP.Primary.DefaultClip		= 500;
SWEP.Primary.Bullets			= 8;

SWEP.SingleReload				= true;

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;

SWEP.RunArmOffset				= Vector (0.299, -4.6042, 3.1531)
SWEP.RunArmAngle 				= Vector (-22.0353, -23.3159, -23.6556)

SWEP.IronSightsTime				= 0.25;

SWEP.HasIronsights 				= true;
SWEP.IronSightsPos 				= Vector (5.1476, -4.3763, 2.1642)
SWEP.IronSightsAng 				= Vector (-0.1387, 0.6955, 0)
SWEP.IronsightsFOV				= 65;
SWEP.IronsightAccuracy			= 2.5;

