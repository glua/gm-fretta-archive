if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
	
	SWEP.HoldType				= "ar2";
end

if( CLIENT ) then
	SWEP.PrintName				= "M4A1 Carbine"; // make it HL universe :rolleyes:
	SWEP.ViewModelFlip			= true;
	SWEP.CSMuzzleFlashes		= true;
	SWEP.ViewModelFOV			= 74;
end

SWEP.Base						= "as_swep_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "" 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_rif_m4a1.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_rif_m4a1.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_M4A1.Single" );
SWEP.Primary.Recoil				= 2.0;
SWEP.Primary.Damage				= 35;
SWEP.Primary.Cone				= 0.035;
SWEP.Primary.Automatic			= true;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.08;
SWEP.Primary.Ammo				= "pistol"; 
SWEP.Primary.DefaultClip		= 500;
SWEP.VMPlaybackRate				= 4.5; // during ironsights

SWEP.Secondary.ClipSize			= -1;
SWEP.Secondary.DefaultClip		= -1;
SWEP.Secondary.Automatic		= false; 
SWEP.Secondary.Ammo				= "none"; 

SWEP.SprayAccuracy				= 0.55;
SWEP.SprayTime					= 0.15;
SWEP.CanRunAndShoot				= false;

SWEP.RunArmOffset  = Vector (-2.5031, 0, 0.8787)
SWEP.RunArmAngle = Vector (-23.8028, -21.5022, 14.4954)

SWEP.IronSightsTime				= 0.33;

SWEP.HasIronsights 				= true;
SWEP.IronSightsPos = Vector (6.024, 0.4309, 0.8493)
SWEP.IronSightsAng = Vector (3.028, 1.3759, 3.5968)
SWEP.IronsightsFOV				= 55;
SWEP.IronsightAccuracy			= 2.5;

SWEP.SupportsSilencer			= true;
SWEP.SilencedSound				= Sound( "Weapon_M4A1.Silenced" );
SWEP.SilencedAccuracy			= 2;
SWEP.SilencedDamage				= 0.7;

-- firemodes
SWEP.MultipleFiremodes			= true;
SWEP.DefaultFiremode			= AF_AUTOMATIC;
SWEP.SupportedFiremodes			= { AF_AUTOMATIC, AF_BURSTFIRE, AF_SEMIAUTOMATIC };

SWEP.Primary[ AF_AUTOMATIC ] = {}
SWEP.Primary[ AF_AUTOMATIC ].Cone				= 0.035;
SWEP.Primary[ AF_AUTOMATIC ].Damage				= 35;
SWEP.Primary[ AF_AUTOMATIC ].Delay				= 0.06;

SWEP.Primary[ AF_SEMIAUTOMATIC ] = {}
SWEP.Primary[ AF_SEMIAUTOMATIC ].Cone			= 0.015;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Damage			= 38;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Delay			= 0.08;

SWEP.Primary[ AF_BURSTFIRE ] = {}
SWEP.Primary[ AF_BURSTFIRE ].Cone				= 0.05;
SWEP.Primary[ AF_BURSTFIRE ].Damage				= 30;
SWEP.Primary[ AF_BURSTFIRE ].Delay				= 0.35;
