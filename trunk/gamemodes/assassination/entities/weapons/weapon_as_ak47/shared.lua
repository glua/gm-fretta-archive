if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "smg";
end

if( CLIENT ) then
	SWEP.PrintName				= "AK-47";
	SWEP.ViewModelFlip			= true;
	SWEP.CSMuzzleFlashes		= true;
	SWEP.ViewModelFOV			= 74;
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_rif_ak47.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_rif_ak47.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_AK47.Single" );
SWEP.Primary.Recoil				= 4.20; // smoke weed erryday
SWEP.Primary.Damage				= 40;
SWEP.Primary.Cone				= 0.045;
SWEP.Primary.Automatic			= true;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.1;
SWEP.Primary.Ammo				= "pistol"; 
SWEP.Primary.DefaultClip		= 500;
SWEP.VMPlaybackRate				= 4.5; // during ironsights

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;


SWEP.RunArmOffset 				= Vector (-1.6219, -1.356, -2.5605)
SWEP.RunArmAngle 				= Vector (-10.1816, -51.6568, 35.715)

SWEP.IronSightsTime				= 0.33;

SWEP.HasIronsights 				= true;
SWEP.IronSightsPos 				= Vector (6.0826, -6.62, 2.4372)
SWEP.IronSightsAng 				= Vector (2.4946, -0.1113, -0.0844)
SWEP.IronsightsFOV				= 55;
SWEP.IronsightAccuracy			= 2.65;

