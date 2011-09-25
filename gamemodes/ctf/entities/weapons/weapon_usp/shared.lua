if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= true;
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.ViewModel					= "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_usp.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_USP.Single" );
SWEP.Primary.Recoil				= 0.55;
SWEP.Primary.Damage				= 7;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.ClipSize			= 12;
SWEP.Primary.Delay				= 0.15;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 1.5;

SWEP.HoldType					= "pistol"

SWEP.SupportsSilencer			= true;
SWEP.SilencedSound				= Sound( "Weapon_USP.SilencedShot" );
SWEP.SilencedAccuracy			= 2.0;
SWEP.SilencedDamage				= 0.6;

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (4.473, -2.2303, 2.7239)
SWEP.IronSightsAng = Vector (-0.2771, 0.0702, 0)

SWEP.RunArmOffset = Vector (-3.448, 0, -0.7646)
SWEP.RunArmAngle = Vector (-18.4912, -29.8594, 18.1858)

SWEP.IronsightsFOV				= 0; -- HVA Specific

if( CLIENT ) then

	SWEP.PrintName			= "Heckler & Koch USP";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "a";
	killicon.AddFont( "weapon_usp", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end
