
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 80
	SWEP.PrintName			= "Sig 550";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 1;
	SWEP.ViewModelFlip		= true;
	
	SWEP.IconLetter			= "o";
	killicon.AddFont( "weapon_sig550", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end

SWEP.Base						= "gmdm_sniperbase";
SWEP.IsCSWeapon					= true;
SWEP.ViewModel					= "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel					= "models/weapons/w_snip_sg550.mdl"

SWEP.Primary.ClipSize			= 20;
SWEP.Primary.Recoil				= 1.55;
SWEP.Primary.Damage				= 45;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.09;
SWEP.Primary.Delay				= 0.1;
SWEP.StopIronsightsAfterShot	= false;

SWEP.ScopeTime					= 0.35;

SWEP.IronsightAccuracy			= 8.5; -- what to divide spread by to increase accuracy

SWEP.Primary.Sound				= Sound( "Weapon_SG550.Single" );


SWEP.IronSightsPos = Vector (5.5538, -6.2544, 1.8809)
SWEP.IronSightsAng = Vector (0, 0, 0.0395)

SWEP.RunArmOffset = Vector (-4.436, -2.7145, -0.3405)
SWEP.RunArmAngle = Vector (-8.0181, -53.2216, 7.3013)

SWEP.ShellType					= SHELL_556;