
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if( CLIENT ) then
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 6;
	
	SWEP.PrintName			= "P90";	
	SWEP.IconLetter			= "m";
	killicon.AddFont( "weapon_p90", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
end

SWEP.Base						= "as_swep_base";
SWEP.Category					= "Combat CTF";
SWEP.HoldType					= "smg"

SWEP.ViewModelFlip				= true;
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.ViewModel					= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel					= "models/weapons/w_smg_p90.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_P90.Single" );
SWEP.Primary.Recoil				= 2.0;
SWEP.Primary.Damage				= 5.0;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.029;
SWEP.Primary.ClipSize			= 50;
SWEP.Primary.Delay				= 0.045;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 1.2;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.3;

SWEP.HasIronsights				= false; -- HVA Specific

SWEP.RunArmOffset  = Vector (-2.5031, 0, 0.8787)
SWEP.RunArmAngle = Vector (-23.8028, -21.5022, 14.4954)

SWEP.ShellType					= SHELL_57;