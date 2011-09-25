SWEP.IsCSWeapon					= false;
SWEP.Base						= "as_swep_base";

if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	SWEP.HoldType = "smg"
end

SWEP.ViewModel					= "models/weapons/v_rif_galil.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_galil.mdl"

SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.Primary.Sound				= Sound( "Weapon_Galil.Single" );
SWEP.Primary.Recoil				= 2.35;
SWEP.Primary.Damage				= 15;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.05;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.05;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 4.4;

SWEP.SprayAccuracy				= 0.65;
SWEP.SprayTime					= 0.7;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (-5.154, -5.1506, 2.256)
SWEP.IronSightsAng = Vector (-0.0459, 0.082, 0.2265)

-- firemodes
SWEP.MultipleFiremodes			= true;
SWEP.DefaultFiremode			= AF_AUTOMATIC;
SWEP.SupportedFiremodes			= { AF_AUTOMATIC, AF_SEMIAUTOMATIC };

SWEP.Primary[ AF_AUTOMATIC ] = {}
SWEP.Primary[ AF_AUTOMATIC ].Cone				= 0.05;
SWEP.Primary[ AF_AUTOMATIC ].Damage				= 15;
SWEP.Primary[ AF_AUTOMATIC ].Delay				= 0.075;
SWEP.Primary[ AF_AUTOMATIC ].Recoil				= 2.35;

SWEP.Primary[ AF_SEMIAUTOMATIC ] = {}
SWEP.Primary[ AF_SEMIAUTOMATIC ].Cone			= 0.015;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Damage			= 28;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Delay			= 0.23;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Recoil			= 3.5;


SWEP.IronsightsFOV				= 75; -- HVA Specific

SWEP.RunArmOffset = Vector (3.6879, 0.7372, 1.3623)
SWEP.RunArmAngle = Vector (-23.0292, 31.9094, -22.2724)

SWEP.ShellType					= SHELL_556;

if( CLIENT ) then

	SWEP.PrintName			= "Galil";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 1;
	SWEP.ViewModelFlip		= false;
	
	SWEP.IconLetter			= "v";
	killicon.AddFont( "weapon_galil", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end
