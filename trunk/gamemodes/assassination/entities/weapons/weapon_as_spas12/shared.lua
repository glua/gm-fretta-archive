if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "shotgun";
end

if( CLIENT ) then
	SWEP.PrintName				= "Franchi SPAS-12";
	SWEP.ViewModelFOV			= 54.0;
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_shotgun.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_shotgun.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_Shotgun.Single" );
SWEP.Primary.Recoil				= 3.95;
SWEP.Primary.Damage				= 15;
SWEP.Primary.Cone				= 0.27;
SWEP.Primary.Automatic			= false;
SWEP.Primary.ClipSize			= 8;
SWEP.Primary.Delay				= 0.3;
SWEP.Primary.Ammo				= "buckshot"; 
SWEP.Primary.DefaultClip		= 500;
SWEP.Primary.Bullets			= 8;

SWEP.SingleReload				= true;
SWEP.ReloadSound				= Sound( "Weapon_Shotgun.Reload" );

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;

SWEP.RunArmOffset				= Vector (-0.299, -4.6042, 3.1531)
SWEP.RunArmAngle 				= Vector (-22.0353, 23.3159, -23.6556)

SWEP.IronSightsTime				= 0.25;

SWEP.HasIronsights 				= true;
SWEP.IronSightsPos 				= Vector (-8.9669, -5.8436, 4.3035)
SWEP.IronSightsAng 				= Vector (-0.285, 0.1577, -0.0805)
SWEP.IronsightsFOV				= 75;
SWEP.IronsightAccuracy			= 1.5;

SWEP.RequiresPump				= true; // shotguns: requires pumping before shooting?
SWEP.AutomaticPump				= true; // set to false if primary attack should pump the shotgun instead of doing it automatically
SWEP.PumpSound					= Sound( "Weapon_Shotgun.Special1" );
SWEP.NeedsPumpAfterReload		= true;