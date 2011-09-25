SWEP.Base = "weapon_base";

SWEP.Author			= "Disseminate"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel		= "models/weapons/w_shotgun.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "Pistol"


function SWEP:Initialize()
	
	self:SetWeaponHoldType( "shotgun" );
	
end


function SWEP:Precache()
end


function SWEP:PrimaryAttack()
	
	if ( !self:CanPrimaryAttack() ) then return end
	if ( self.Shot ) then return end
	
	self.Weapon:EmitSound( Sound( "weapons/shotgun/shotgun_dbl_fire7.wav" ) );
	
	local bullet = { };
	bullet.Num 		= 20;
	bullet.Src 		= self.Owner:GetShootPos();
	bullet.Dir 		= self.Owner:GetAimVector();
	bullet.Spread 	= Vector( 0.03, 0.03, 0 );
	bullet.Tracer	= 1;
	bullet.Force	= 1;
	bullet.Damage	= 1;
	bullet.AmmoType = "Buckshot";
	
	self.Shot = true;
	
	local function SendThemFlying( _, tr, _ )
		
		if( SERVER ) then
			
			local trace = { };
			trace.start = self.Owner:GetShootPos();
			trace.endpos = tr.HitPos;
			trace.filter = self.Owner;
			
			local tr = util.TraceLine( trace );
			
			if( tr.Entity and tr.Entity:IsValid() and tr.Entity:IsPlayer() ) then
				
				local pos = tr.Entity:GetPos();
				local dir = ( pos - self.Owner:GetPos() ):Normalize();
				tr.Entity:SetVelocity( dir * 2000 );
				
			end
			
		end
		
	end
	
	bullet.Callback = SendThemFlying;
	
	self.Owner:FireBullets( bullet );
	
	self:ShootEffects();
	
	if( SERVER ) then
		
		self:PostShot();
		
	end

end


function SWEP:PostShot()
	
	timer.Simple( 0.5, function()
		
		if( self and self.Owner and self.Owner:Alive() ) then
			
			self.Owner:StripWeapons();
			
		end
		
	end );
	
end


function SWEP:SecondaryAttack()
end


function SWEP:Reload()
end


function SWEP:Holster( wep )
	return true
end


function SWEP:Deploy()
	
	self:SendWeaponAnim( ACT_VM_DEPLOY );
	return true;
	
end


function SWEP:CanPrimaryAttack()
	
	return true;
	
end

