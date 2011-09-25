if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "as_swep_base";

SWEP.ViewModelFlip				= true;
SWEP.CSMuzzleFlashes			= true;
SWEP.ViewModelFOV				= 74;

SWEP.HoldType					= "pistol"

SWEP.ViewModel					= "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel					= "models/weapons/w_smg_mac10.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_mac10.Single" );
SWEP.Primary.Recoil				= 2.85;
SWEP.Primary.Damage				= 13.5;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.098;
SWEP.Primary.ClipSize			= 32;
SWEP.Primary.Delay				= 0.048;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= true;
SWEP.Primary.Ammo				= "smg1";
SWEP.IronsightAccuracy			= 2.3;

SWEP.SprayAccuracy				= 0.9;
SWEP.SprayTime					= 0.3;

SWEP.HasIronsights				= true; -- HVA Specific

SWEP.VMPlaybackRate				= 6.0

SWEP.IronSightsPos = Vector (6.9362, -0.151, 2.812)
SWEP.IronSightsAng = Vector (1.0483, 5.2515, 6.6932)

SWEP.IronsightsFOV				= 75; -- HVA Specific
SWEP.ShellType					= SHELL_9MM;

if( CLIENT ) then

	SWEP.PrintName			= "MAC-10";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 2;
	
	SWEP.IconLetter			= "l";
	killicon.AddFont( "weapon_uzi", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end
