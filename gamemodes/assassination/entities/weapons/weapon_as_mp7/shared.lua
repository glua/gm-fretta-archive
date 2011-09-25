if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "smg";
end

if( CLIENT ) then
	SWEP.PrintName				= "H&K MP7";
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_SMG1.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_SMG1.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_SMG1.Single" );
SWEP.Primary.Recoil				= 1.95;
SWEP.Primary.Damage				= 20;
SWEP.Primary.Cone				= 0.09;
SWEP.Primary.Automatic			= true;
SWEP.Primary.ClipSize			= 40;
SWEP.Primary.Delay				= 0.06;
SWEP.Primary.Ammo				= "pistol"; 
SWEP.Primary.DefaultClip		= 500;

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;

SWEP.RunArmAngle  				= Angle( 0, -50, 12 );
SWEP.RunArmOffset 				= Vector( 4, 1, 10 );

SWEP.ViewModelFOV				= 54.0;

SWEP.IronSightsTime				= 0.25;

SWEP.HasIronsights 				= true;
SWEP.IronSightsPos 				= Vector (-6.5761, -1.4939, 2.516)
SWEP.IronSightsAng 				= Vector (0.0131, -0.4037, -0.2629)
SWEP.IronsightsFOV				= 65;
SWEP.IronsightAccuracy			= 2.5;

