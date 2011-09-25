
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 80
	SWEP.PrintName			= "Artic Warfare Magnum";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 6;
	SWEP.ViewModelFlip		= true;
	
	SWEP.IconLetter			= "r";
	killicon.AddFont( "weapon_awp", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end

SWEP.Base						= "as_swep_base";
SWEP.IsCSWeapon					= true;
SWEP.ViewModel					= "models/weapons/v_snip_awp.mdl"
SWEP.WorldModel					= "models/weapons/w_snip_awp.mdl"
SWEP.HoldType					= "crossbow"

SWEP.HasIronsights				= true
SWEP.ScopedWeapon				= true;
SWEP.StopIronsightsAfterShot	= true;

SWEP.Primary.ClipSize			= 5;
SWEP.Primary.Recoil				= 10.95;
SWEP.Primary.Damage				= 95;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.038;
SWEP.Primary.Delay				= 1.0;

SWEP.IronsightAccuracy			= 10.0; -- what to divide spread by to increase accuracy
SWEP.IronsightsFOV				= 15; -- HVA Specific

SWEP.Primary.Sound				= Sound( "Weapon_AWP.Single" );

SWEP.IronSightsPos = Vector (5.5815, -6.6874, 2.0943)
SWEP.IronSightsAng = Vector (-0.1534, -0.7161, 0)


SWEP.RunArmOffset = Vector (-4.436, -2.7145, -0.3405)
SWEP.RunArmAngle = Vector (-8.0181, -53.2216, 7.3013)

SWEP.ShellType					= SHELL_338MAG;
