if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "pistol";
end

if( CLIENT ) then
	SWEP.PrintName				= "USP Match";
	
	SWEP.Slot					= 1;
	SWEP.SlotPos				= 0;
	SWEP.ViewModelFOV			= 54.0;
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_pistol.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_pistol.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_USP.Single" );
SWEP.Primary.ReloadSound		= Sound( "Weapon_Pistol.Reload" );
SWEP.Primary.Recoil				= 0.95;
SWEP.Primary.Damage				= 23;
SWEP.Primary.Cone				= 0.015;
SWEP.Primary.Automatic			= false;
SWEP.Primary.ClipSize			= 12;
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


SWEP.IronSightsPos = Vector (-5.767, -9.1901, 4.0012)
SWEP.IronSightsAng = Vector (0.5005, -0.9511, 0.1712)



SWEP.IronsightsFOV				= 0;
SWEP.IronsightAccuracy			= 2.5;

