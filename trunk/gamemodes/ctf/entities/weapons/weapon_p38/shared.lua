SWEP.IsCSWeapon					= true;
SWEP.Base						= "gmdm_dodbase";

if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	SWEP.HoldType = "pistol"
end

SWEP.ViewModel					= "models/weapons/v_p38.mdl"
SWEP.WorldModel					= "models/weapons/w_p38.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_MP40.Shoot" );
SWEP.Primary.Recoil				= 1.2;
SWEP.Primary.Damage				= 25;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.052;
SWEP.Primary.ClipSize			= 8;
SWEP.Primary.Delay				= 0.1;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 2.4;

SWEP.SprayAccuracy				= 0.65;
SWEP.SprayTime					= 0.7;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.RunArmOffset = Vector (6.5247, 0, -4.0158)
SWEP.RunArmAngle = Vector (-18.4765, 31.8551, -36.4007)

SWEP.ViewModelFOV = 45


SWEP.IronSightsPos = Vector (-5.6905, -6.6519, 4.0258)
SWEP.IronSightsAng = Vector (-0.0508, -0.0327, -0.2537)

SWEP.IronsightsFOV				= 0; -- HVA Specific

if( CLIENT ) then

	SWEP.PrintName			= "Walther P38";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 1;
	
	SWEP.FlipViewModel		= false
	
	SWEP.IconLetter			= "b";

end
