if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= true; -- HVA Specific
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.ViewModel					= "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel					= "models/weapons/w_shot_xm1014.mdl"

SWEP.HoldType					= "shotgun"

SWEP.Primary.Sound				= Sound( "Weapon_XM1014.Single" );
SWEP.Primary.Recoil				= 10.2;
SWEP.Primary.Damage				= 9;
SWEP.Primary.NumShots			= 8;
SWEP.Primary.Cone				= 0.165;
SWEP.Primary.ClipSize			= 4;
SWEP.Primary.Bullets			= 8;
SWEP.Primary.Delay				= 0.05;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "buckshot";
SWEP.IronsightAccuracy			= 1.0;
SWEP.IronsightsFOV				= 75

SWEP.SingleReload				= true;
SWEP.RequiresPump				= false; // shotguns: requires pumping before shooting?
SWEP.ReloadDelay				= 0.3;
SWEP.ReloadThenPump				= true;

SWEP.HasIronsights				= true;
SWEP.RunArmOffset  				= Vector (-2.5031, 0, 0.8787)
SWEP.RunArmAngle 				= Vector (-23.8028, -21.5022, 14.4954)
SWEP.IronSightsPos = Vector (5.1476, -4.3763, 2.1642)
SWEP.IronSightsAng = Vector (-0.1387, 0.6955, 0)

SWEP.ShellType					= SHELL_12GAUGE;


if( CLIENT ) then

	SWEP.PrintName			= "Benelli M4 Super 90";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 1;
	
	SWEP.IconLetter			= "B";
	killicon.AddFont( "weapon_xm1014", "HVACSKillIcons", SWEP.IconLetter, Color( 200,200,200, 255 ) );
	
end
