
if (SERVER) then
	AddCSLuaFile( "shared.lua" )
end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 75
	SWEP.PrintName			= "Scout";		
	SWEP.Slot				= 0;
	SWEP.SlotPos			= 1;
	SWEP.ViewModelFlip		= true;
	
	SWEP.IconLetter			= "n";
	killicon.AddFont( "weapon_scout", "HVACSKillIcons", SWEP.IconLetter, Color( 175, 175, 175, 255 ) );
end

SWEP.Base						= "as_swep_base";
SWEP.IsCSWeapon					= true;
SWEP.ViewModel					= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel					= "models/weapons/w_snip_scout.mdl"

SWEP.HasIronsights				= true
SWEP.ScopedWeapon				= true;
SWEP.StopIronsightsAfterShot	= true;

SWEP.HoldType					= "ar2"

SWEP.Primary.ClipSize			= 8;
SWEP.Primary.Recoil				= 0.85;
SWEP.Primary.Damage				= 75;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.Delay				= 1.5;
SWEP.IronsightsFOV				= 25; -- HVA Specific

SWEP.IronsightAccuracy			= 3.5; -- what to divide spread by to increase accuracy

SWEP.Primary.Sound				= Sound( "Weapon_Scout.Single" );

SWEP.IronSightsPos = Vector (4.959, -10.2188, 2.4821)
SWEP.IronSightsAng = Vector (0, 0, 0)

SWEP.RunArmOffset = Vector (-4.436, -2.7145, -0.3405)
SWEP.RunArmAngle = Vector (-8.0181, -53.2216, 7.3013)

SWEP.ShellType					= SHELL_556;