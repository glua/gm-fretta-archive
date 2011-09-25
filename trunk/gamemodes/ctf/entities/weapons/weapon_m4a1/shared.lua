if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	SWEP.HoldType = "ar2"
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= true; -- HVA Specific
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;
	
SWEP.ViewModel					= "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_m4a1.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_M4A1.Single" );
SWEP.Primary.Recoil				= 4.85;
SWEP.Primary.Damage				= 32;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.08;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.5;

SWEP.SupportsSilencer			= true;
SWEP.SilencedAccuracy			= 0.7;
SWEP.SilencedSound				= Sound( "weapon_m4a1.silenced" );
SWEP.SilencedDamage				= 0.7;

SWEP.SprayAccuracy				= 0.65;
SWEP.SprayTime					= 0.7;

SWEP.VMPlaybackRate				= 10.0

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (6.024, 0.4309, 0.8493)
SWEP.IronSightsAng = Vector (3.028, 1.3759, 3.5968)

SWEP.RunArmOffset  = Vector (-2.5031, 0, 0.8787)
SWEP.RunArmAngle = Vector (-23.8028, -21.5022, 14.4954)

SWEP.IronsightsFOV				= 65; -- HVA Specific

-- firemodes
SWEP.MultipleFiremodes			= true;
SWEP.DefaultFiremode			= AF_AUTOMATIC;
SWEP.SupportedFiremodes			= { AF_AUTOMATIC, AF_BURSTFIRE, AF_SEMIAUTOMATIC };

SWEP.Primary[ AF_AUTOMATIC ] = {}
SWEP.Primary[ AF_AUTOMATIC ].Cone				= 0.03;
SWEP.Primary[ AF_AUTOMATIC ].Damage				= 28;
SWEP.Primary[ AF_AUTOMATIC ].Delay				= 0.08;

SWEP.Primary[ AF_SEMIAUTOMATIC ] = {}
SWEP.Primary[ AF_SEMIAUTOMATIC ].Cone			= 0.015;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Damage			= 32;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Delay			= 0.09;

SWEP.Primary[ AF_BURSTFIRE ] = {}
SWEP.Primary[ AF_BURSTFIRE ].Cone				= 0.05;
SWEP.Primary[ AF_BURSTFIRE ].Damage				= 24;
SWEP.Primary[ AF_BURSTFIRE ].Delay				= 0.35;

SWEP.ShellType									= SHELL_556;

if( CLIENT ) then

	SWEP.PrintName			= "M4A1";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "w";
	killicon.AddFont( "weapon_m4a1", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end
