if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
else
	SWEP.ViewModelFOV		= 74
	SWEP.ViewModelFlip		= true;
end

SWEP.Base						= "as_swep_base";

SWEP.HasIronsights				= true

SWEP.HoldType					= "pistol"

SWEP.ViewModel					= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_glock18.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Glock.Single" );
SWEP.Primary.Recoil				= 0.9;
SWEP.Primary.Damage				= 12;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.03;
SWEP.Primary.ClipSize			= 15;
SWEP.Primary.Delay				= 0.18;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";
SWEP.IronsightAccuracy			= 1.5;

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.IronSightsPos = Vector (4.3618, -1.7181, 2.8266)
SWEP.IronSightsAng = Vector (0.4921, 0.0041, 0)


SWEP.IronsightsFOV				= 0; -- HVA Specific

-- firemodes
SWEP.MultipleFiremodes			= true;
SWEP.DefaultFiremode			= AF_BURSTFIRE;
SWEP.SupportedFiremodes			= { AF_BURSTFIRE, AF_SEMIAUTOMATIC };

SWEP.Primary[ AF_SEMIAUTOMATIC ] = {}
SWEP.Primary[ AF_SEMIAUTOMATIC ].Cone			= 0.03;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Damage			= 12;
SWEP.Primary[ AF_SEMIAUTOMATIC ].Delay			= 0.18;

SWEP.Primary[ AF_BURSTFIRE ] = {}
SWEP.Primary[ AF_BURSTFIRE ].Cone				= 0.035;
SWEP.Primary[ AF_BURSTFIRE ].Damage				= 8.5;
SWEP.Primary[ AF_BURSTFIRE ].Delay				= 0.46;

SWEP.Primary.BurstDelay			= 0.05;

SWEP.ShellType					= SHELL_9MM;

if( CLIENT ) then

	SWEP.PrintName			= "Glock-18";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "c";
	killicon.AddFont( "weapon_glock18", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end
