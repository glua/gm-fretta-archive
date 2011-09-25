if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	SWEP.HoldType = "smg"
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= true;
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.ViewModel					= "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel					= "models/weapons/w_smg_mp5.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_MP5Navy.Single" );
SWEP.Primary.Recoil				= 2.25;
SWEP.Primary.Damage				= 15.6;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.086;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.081;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 1.6;
SWEP.Primary.BurstDelay			= 0.1;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.3;

SWEP.HasIronsights				= true; -- HVA Specific
SWEP.IronSightsPos 				= Vector (4.7375, -3.0969, 1.7654)
SWEP.IronSightsAng 				= Vector (1.541, -0.1335, -0.144)
SWEP.IronsightsFOV				= 75; -- HVA Specific

SWEP.RunArmOffset = Vector (-2.4334, -0.2952, 2.3752)
SWEP.RunArmAngle = Vector (-23.4847, -9.6809, 0.1712)

-- firemodes
SWEP.MultipleFiremodes			= true;
SWEP.DefaultFiremode			= AF_AUTOMATIC;
SWEP.SupportedFiremodes			= { AF_AUTOMATIC, AF_SEMIAUTOMATIC };

SWEP.Primary[ AF_AUTOMATIC ] = {}
SWEP.Primary[ AF_AUTOMATIC ].Cone				= 0.086;
SWEP.Primary[ AF_AUTOMATIC ].Damage				= 15.6;
SWEP.Primary[ AF_AUTOMATIC ].Delay				= 0.081;

SWEP.Primary[ AF_SEMIAUTOMATIC ] = {}
SWEP.Primary[ AF_SEMIAUTOMATIC ].Cone			= 0.066;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Damage			= 22;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Delay			= 0.1;

SWEP.ShellType					= SHELL_9MM;

if( CLIENT ) then

	SWEP.PrintName			= "MP5 Navy";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "x";
	killicon.AddFont( "weapon_mp5n", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end
