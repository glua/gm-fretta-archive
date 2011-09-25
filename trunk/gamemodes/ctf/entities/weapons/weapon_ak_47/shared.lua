SWEP.IsCSWeapon					= true;
SWEP.Base						= "as_swep_base";

if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	SWEP.HoldType = "ar2"
end

SWEP.ViewModelFlip				= true; -- HVA Specific
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.ViewModel					= "models/weapons/v_rif_ak47.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_ak47.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_AK47.Single" );
SWEP.Primary.Recoil				= 6.25;
SWEP.Primary.Damage				= 37;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.02;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.09;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.4;

SWEP.VMPlaybackRate				= 6.0

SWEP.SprayAccuracy				= 0.45;
SWEP.SprayTime					= 0.7;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (6.0826, -6.62, 2.4372)
SWEP.IronSightsAng = Vector (2.4946, -0.1113, -0.0844)

SWEP.IronsightsFOV				= 65; -- HVA Specific

//SWEP.RunArmOffset = Vector (-1.6219, -1.356, -2.5605)
//SWEP.RunArmAngle = Vector (-10.1816, -51.6568, 35.715)
SWEP.RunArmOffset  = Vector (-2.5031, 0, 0.8787)
SWEP.RunArmAngle = Vector (-23.8028, -21.5022, 14.4954)

-- firemodes
SWEP.MultipleFiremodes			= true;
SWEP.DefaultFiremode			= AF_AUTOMATIC;
SWEP.SupportedFiremodes			= { AF_AUTOMATIC, AF_SEMIAUTOMATIC };

SWEP.Primary[ AF_AUTOMATIC ] = {}
SWEP.Primary[ AF_AUTOMATIC ].Cone				= 0.028;
SWEP.Primary[ AF_AUTOMATIC ].Damage				= 26;
SWEP.Primary[ AF_AUTOMATIC ].Delay				= 0.09;

SWEP.Primary[ AF_SEMIAUTOMATIC ] = {}
SWEP.Primary[ AF_SEMIAUTOMATIC ].Cone			= 0.012;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Damage			= 33;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Delay			= 0.2;

if( CLIENT ) then

	SWEP.PrintName			= "AK-47";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "b";
	killicon.AddFont( "weapon_ak_47", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 )  );
	
end
