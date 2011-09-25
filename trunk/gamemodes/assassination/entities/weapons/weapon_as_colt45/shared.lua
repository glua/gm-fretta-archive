if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "pistol";
end

if( CLIENT ) then
	SWEP.PrintName				= "Colt 1911";
	
	SWEP.Slot					= 1;
	SWEP.SlotPos				= 0;
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_colt45.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_colt45.mdl"  ) 

SWEP.Primary.Sound				= Sound( "weapons/colt1911/pistol_fire2.wav" );
SWEP.Primary.ReloadSound		= Sound( "weapons/colt1911/pistol_reload1.wav" );
SWEP.Primary.Recoil				= 1.25;
SWEP.Primary.Damage				= 40;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.Automatic			= false;
SWEP.Primary.ClipSize			= 8;
SWEP.Primary.Delay				= 0.1;
SWEP.Primary.Ammo				= "357"; 
SWEP.Primary.DefaultClip		= 500;

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;

SWEP.RunArmOffset				= Vector (2.4702, -2.8634, 1.2694)
SWEP.RunArmAngle				= Vector (-20.2139, 25.6592, -18.5775)


SWEP.IronSightsTime				= 0.25;

SWEP.HasIronsights 				= true;

SWEP.IronSightsPos = Vector (-3.8232, -8.5966, 2.0313)
SWEP.IronSightsAng = Vector (0.1298, -0.1182, -0.0127)

SWEP.IronsightsFOV				= 0;
SWEP.IronsightAccuracy			= 2.5;

