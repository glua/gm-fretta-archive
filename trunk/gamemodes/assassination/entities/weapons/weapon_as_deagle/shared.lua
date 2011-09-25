if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "pistol";
end

if( CLIENT ) then
	SWEP.PrintName				= "Desert Eagle";
	
	SWEP.Slot					= 1;
	SWEP.SlotPos				= 0;
	SWEP.ViewModelFOV			= 74.0;
	
	SWEP.ViewModelFlip			= true;
	SWEP.CSMuzzleFlashes		= true;
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_pist_deagle.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_pist_deagle.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_Deagle.Single" );
SWEP.Primary.ReloadSound		= Sound( "Weapon_Deagle.Reload" );
SWEP.Primary.Recoil				= 7.75;
SWEP.Primary.Damage				= 40;
SWEP.Primary.Cone				= 0.039;
SWEP.Primary.Automatic			= false;
SWEP.Primary.ClipSize			= 7;
SWEP.Primary.Delay				= 0.2;
SWEP.Primary.Ammo				= "357"; 
SWEP.Primary.DefaultClip		= 500;

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;
SWEP.RunArmOffset 				= Vector (-3.448, 0, -0.7646)
SWEP.RunArmAngle 				= Vector (-18.4912, -29.8594, 18.1858)

SWEP.IronSightsTime				= 0.25;

SWEP.HasIronsights 				= true;

SWEP.IronSightsPos 				= Vector (5.1378, -2.6955, 2.6575)
SWEP.IronSightsAng 				= Vector (0.3551, -0.1281, 0.4)


SWEP.IronsightsFOV				= 0;
SWEP.IronsightAccuracy			= 2.5;

