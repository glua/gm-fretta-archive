if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType				= "pistol";
end

if( CLIENT ) then
	SWEP.PrintName				= "Barrel Shoota";
	SWEP.Slot					= 0;
	SWEP.SlotPos				= 0;
	
end

SWEP.Base						= "weapon_base";

SWEP.Contact					= "" 
SWEP.Purpose					= "Use this to kill those damn barrels." 
SWEP.Instructions				= "" 
 
SWEP.ViewModel					= Model( "models/weapons/v_pistol.mdl"  )
SWEP.WorldModel					= Model( "models/weapons/w_pistol.mdl"  ) 

SWEP.Primary.Sound				= Sound( "Weapon_Pistol.Single" );
SWEP.Primary.Recoil				= 3.5;
SWEP.Primary.Damage				= 100;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.Automatic			= false;
SWEP.Primary.ClipSize			= 1;
SWEP.Primary.Ammo				= "pistol"; 

SWEP.Secondary.ClipSize			= -1 
SWEP.Secondary.DefaultClip		= -1 
SWEP.Secondary.Automatic		= false 
SWEP.Secondary.Ammo				= "none" 

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	if ( !self:CanPrimaryAttack() ) then return end

	self.Weapon:EmitSound( self.Primary.Sound )
	self:ShootBullet( self.Primary.Damage, 1, self.Primary.Cone )
	self:TakePrimaryAmmo( 1 )
	self.Owner:ViewPunch( Angle( -self.Primary.Recoil, 0, 0 ) )

end

function SWEP:SecondaryAttack()

end
