if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= false;
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.ViewModel					= "models/weapons/v_rif_famas.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_famas.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Famas.Single" );
SWEP.Primary.Recoil				= 1.35;
SWEP.Primary.Damage				= 17;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.02;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.075;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.5;

-- firemodes
SWEP.MultipleFiremodes			= true;
SWEP.DefaultFiremode			= AF_AUTOMATIC;
SWEP.SupportedFiremodes			= { AF_AUTOMATIC, AF_BURSTFIRE };

SWEP.Primary[ AF_AUTOMATIC ] = {}
SWEP.Primary[ AF_AUTOMATIC ].Cone				= 0.02;
SWEP.Primary[ AF_AUTOMATIC ].Damage				= 20;
SWEP.Primary[ AF_AUTOMATIC ].Delay				= 0.075;

SWEP.Primary[ AF_BURSTFIRE ] = {}
SWEP.Primary[ AF_BURSTFIRE ].Cone				= 0.025;
SWEP.Primary[ AF_BURSTFIRE ].Damage				= 18;
SWEP.Primary[ AF_BURSTFIRE ].Delay				= 0.15;

SWEP.SprayAccuracy				= 0.65;
SWEP.SprayTime					= 0.7;

SWEP.HasIronsights				= false; -- HVA Specific

SWEP.RunArmOffset = Vector (0.8129, 0, 3.6122)
SWEP.RunArmAngle = Vector (-22.188, 39.0871, 0)

SWEP.ShellType					= SHELL_556;


if( CLIENT ) then

	SWEP.PrintName			= "FAMAS";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "t";
	killicon.AddFont( "weapon_famas", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end
