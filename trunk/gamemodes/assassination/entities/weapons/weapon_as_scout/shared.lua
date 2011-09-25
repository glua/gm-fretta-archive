if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

if( CLIENT ) then
	SWEP.PrintName				= "Scout";
	SWEP.ViewModelFlip			= true;
	SWEP.CSMuzzleFlashes		= true;
	SWEP.ViewModelFOV			= 74;
end

SWEP.Base						= "as_sniper_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_snip_scout.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_snip_scout.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_Scout.Single" );
SWEP.Primary.Recoil				= 12.95;
SWEP.Primary.Damage				= 80;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.Automatic			= false;
SWEP.Primary.ClipSize			= 10;
SWEP.Primary.Delay				= 0.8;
SWEP.Primary.Ammo				= "pistol"; 
SWEP.Primary.DefaultClip		= 500;

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;

SWEP.HasIronsights 				= true;
SWEP.IronsightsFOV				= 30;

SWEP.IronSightsPos 				= Vector (4.959, -10.2188, 2.4821)
SWEP.IronSightsAng 				= Vector (0, 0, 0)

SWEP.RunArmOffset 				= Vector (-4.436, -2.7145, -0.3405)
SWEP.RunArmAngle 				= Vector (-8.0181, -53.2216, 7.3013)

SWEP.ShellType					= SHELL_556;