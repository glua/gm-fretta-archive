if( SERVER ) then
	AddCSLuaFile( "shared.lua" );
end

SWEP.Base						= "gmdm_csbase";
SWEP.IsCSWeapon					= true;

SWEP.ViewModel					= "models/weapons/v_pist_elite.mdl"
SWEP.WorldModel					= "models/weapons/w_pist_elite.mdl"

SWEP.Primary.Sound				= Sound( "Weapon_Elite.Single" );
SWEP.Primary.Recoil				= 1.2;
SWEP.Primary.Damage				= 35;
SWEP.Primary.NumShots			= 1;
SWEP.Primary.Cone				= 0.01;
SWEP.Primary.ClipSize			= 30;
SWEP.Primary.Delay				= 0.12;
SWEP.Primary.DefaultClip		= 120;
SWEP.Primary.Automatic			= false;
SWEP.Primary.Ammo				= "pistol";

SWEP.IronsightAccuracy			= 1.5;

SWEP.SprayAccuracy				= 1.0;
SWEP.SprayTime					= 0.0;

SWEP.HasIronsights				= false; -- HVA Specific

SWEP.DualRightSeq				=	5;
SWEP.DualLeftSeq				=	2;


SWEP.IronsightsFOV				= 0; -- HVA Specific

-- HVA Run speed stuff
SWEP.WalkSpeed					= 1.0;
SWEP.RunSpeed					= 1.0;
SWEP.IronsightWalkSpeed			= 1.0;
SWEP.IronsightRunSpeed			= 1.0;

if( CLIENT ) then

	SWEP.PrintName			= "M9 Dual Wield";		
	SWEP.Slot				= 1;
	SWEP.SlotPos			= 5;
	
	SWEP.IconLetter			= "s";
	killicon.AddFont( "weapon_dualm9", "HVACSKillIcons", SWEP.IconLetter, Color( 200, 200, 200, 255 ) );
	
end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:GMDMShootBullet( dmg, snd, pitch, yaw, numbul, cone )

	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	local isright = self.Weapon:GetNetworkedBool( "rightgun", true );

	local attach = self.Owner:GetViewModel():LookupAttachment( "1" );
	
	if( !isright ) then
		attach = self.Owner:GetViewModel():LookupAttachment( "2")
	end

	local shootpos = self.Owner:GetViewModel():GetAttachment( attach ).Pos
	
	self.Owner:SetNetworkedInt( "BulletType", 0 ); -- 0 = normal hit (no ricochet or wallbang)

	if( snd != nil ) then
		self.Weapon:EmitSound( snd )
	end
	
	self:GMDMShootBulletEx( dmg, numbul, cone, 1, isright, shootpos )
	
	if( self.Owner:IsPlayer() ) then
		self.Owner:Recoil( pitch, yaw )
	end
	
	// Make gunsmoke
	local effectdata = EffectData()
		effectdata:SetOrigin( shootpos )
		effectdata:SetEntity( self.Weapon )
		effectdata:SetStart( shootpos )
		effectdata:SetNormal( self.Owner:GetAimVector() )
		effectdata:SetAttachment( attach )
	util.Effect( "gunsmoke", effectdata )

	self:NoteGMDMShot()
	
	self.Weapon:SetNetworkedBool( "rightgun", !isright );
	
end

/*---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
---------------------------------------------------------*/
function SWEP:GMDMShootBulletEx( damage, num_bullets, aimcone, tracerfreq, isright, shootpos )
	
	Msg( tostring( damage ) .. "\n" )
	
	if( isright ) then
		self.Owner:GetViewModel():SetSequence( self.DualRightSeq ) // View model animation
	else
		self.Owner:GetViewModel():SetSequence( self.DualLeftSeq )
	end
	
	--self.Owner:MuzzleFlash()							// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )			// 3rd Person Animation
	
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= shootpos			// Source
	bullet.Dir 		= self.Owner:GetAimVector()			// Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )		// Aim Cone
	bullet.Tracer	= tracerfreq						// Show a tracer on every x bullets 
	bullet.Force	= 10								// Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.HullSize	= 4
	bullet.Callback    = function( a, b, c ) return self:RicochetCallback_Redirect( a, b, c ) end
	
	//timer.Simple( 0.01, self.Owner.FireBullets, self.Owner, bullet )
	self.Owner:FireBullets( bullet )
	
end