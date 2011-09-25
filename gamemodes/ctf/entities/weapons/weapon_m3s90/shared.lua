if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= true; -- HVA Specific
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.ViewModel					= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel					= "models/weapons/w_shot_m3super90.mdl"

SWEP.HoldType					= "shotgun"

SWEP.Primary.Sound				= Sound( "Weapon_M3.Single" );
SWEP.Primary.Recoil				= 26.3;
SWEP.Primary.Damage				= 12;
SWEP.Primary.NumShots			= 5;
SWEP.Primary.Cone				= 0.125;
SWEP.Primary.Bullets			= 8;
SWEP.Primary.ClipSize			= 7;
SWEP.Primary.Delay				= 1.2;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "buckshot";
SWEP.IronsightAccuracy			= 1.0;
SWEP.IronsightsFOV				= 80;

SWEP.SingleReload				= true;
SWEP.RequiresPump				= false; // shotguns: requires pumping before shooting?
SWEP.ReloadDelay				= 0.45;
SWEP.ReloadThenPump				= true;

SWEP.HasIronsights				= true;
SWEP.IronSightsPos 				= Vector (5.7266, -2.9373, 3.3522)
SWEP.IronSightsAng 				= Vector (0.1395, -0.0055, -0.4603)

SWEP.RunArmOffset  				= Vector (-2.5031, 0, 0.8787)
SWEP.RunArmAngle 				= Vector (-23.8028, -21.5022, 14.4954)

SWEP.ShellType					= SHELL_12GAUGE;

if( CLIENT ) then

	SWEP.PrintName			= "Benelli M3 Super 90";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "k";
	killicon.AddFont( "weapon_m3s90", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end

