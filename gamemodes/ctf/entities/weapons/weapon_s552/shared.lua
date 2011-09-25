
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 80
	SWEP.PrintName			= "Sig 552";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 6;
	SWEP.ViewModelFlip		= true;
	
	SWEP.IconLetter			= "A";
	killicon.AddFont( "weapon_s552", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end

SWEP.Base						= "gmdm_sniperbase";
SWEP.IsCSWeapon					= true;
SWEP.ViewModel					= "models/weapons/v_rif_sg552.mdl"
SWEP.WorldModel					= "models/weapons/w_rif_sg552.mdl"

SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Recoil				= 2.35;
SWEP.Primary.Damage				= 20;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.02;
SWEP.Primary.Delay				= 0.1;
SWEP.StopIronsightsAfterShot	= false;

SWEP.Primary.Automatic			= true;

SWEP.ScopeTime					= 0.2;

SWEP.IronsightAccuracy			= 2.2; -- what to divide spread by to increase accuracy

SWEP.Primary.Sound				= Sound( "Weapon_SG552.Single" );

SWEP.IronSightsPos = Vector (4.959, -10.2188, 2.4821)
SWEP.IronSightsAng = Vector (0, 0, 0)

SWEP.RunArmOffset = Vector (-4.436, -2.7145, -0.3405)
SWEP.RunArmAngle = Vector (-8.0181, -53.2216, 7.3013)

SWEP.ShellType					= SHELL_556;