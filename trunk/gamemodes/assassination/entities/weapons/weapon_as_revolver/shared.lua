if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "pistol";
end

if( CLIENT ) then
	SWEP.PrintName				= "Revolver";
	SWEP.ViewModelFOV				= 54.0;
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_357.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_357.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_357.Single" );
SWEP.Primary.Recoil				= 10.95;
SWEP.Primary.Damage				= 40;
SWEP.Primary.Cone				= 0.05;
SWEP.Primary.Automatic			= false;
SWEP.Primary.ClipSize			= 7;
SWEP.Primary.Delay				= 0.5;
SWEP.Primary.Ammo				= "357"; 
SWEP.Primary.DefaultClip		= 500;
SWEP.Primary.ReloadSpeed		= 1.5;

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.75;
SWEP.SprayTime					= 0.25;
SWEP.CanRunAndShoot				= false;

SWEP.RunArmOffset				= Vector (0.3337, 2.4061, 10.8715)
SWEP.RunArmAngle 				= Vector (-38.8555, -0.9025, 0)

SWEP.IronSightsTime				= 0.25;

SWEP.HasIronsights 				= true;
SWEP.IronSightsPos 				= Vector (-5.6509, -8.5018, 2.6222)
SWEP.IronSightsAng 				= Vector (0.1385, -0.3078, 1.2868)
SWEP.IronsightsFOV				= 0;
SWEP.IronsightAccuracy			= 3.5;

