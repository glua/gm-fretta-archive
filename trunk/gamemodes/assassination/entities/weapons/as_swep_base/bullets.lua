
function SWEP:ShootBullets( damage, numbullets, aimcone, silenced )

	if( !silenced ) then
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	else
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK_SILENCED )
		damage = damage * self.SilencedDamage;
	end
	
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	local scale = aimcone / ( self.Weapon:GetAccuracyModifier() );
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= math.Round(damage * 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "Tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		self.Weapon:BulletCallback( attacker, tr, dmginfo, 0 )
	end
	
	// Make gunsmoke
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetShootPos() )
		effectdata:SetEntity( self.Weapon )
		effectdata:SetStart( self.Owner:GetShootPos() )
		effectdata:SetNormal( self.Owner:GetAimVector() )
		effectdata:SetAttachment( 1 )
	util.Effect( "gunsmoke", effectdata )
	
	self.Owner:FireBullets( bullet )
	
end

function SWEP:BulletCallback( attacker, tr, dmginfo, bounce )

	if( !self or !ValidEntity( self.Weapon ) ) then return end
	
	self.Weapon:BulletPenetration( attacker, tr, dmginfo, bounce + 1 );
	
	return { damage = true, effect = true, effects = true };
	
end

function SWEP:GetPenetrationDistance( mat_type )

	if ( mat_type == MAT_PLASTIC || mat_type == MAT_WOOD || mat_type == MAT_FLESH || mat_type == MAT_ALIENFLESH || mat_type == MAT_GLASS ) then
		return 64
	end
	
	return 32
	
end

function SWEP:GetPenetrationDamageLoss( mat_type, distance, damage )

	if( mat_type == MAT_GLASS ) then
		return damage;
	elseif ( mat_type == MAT_PLASTIC || mat_type == MAT_WOOD || mat_type == MAT_FLESH || mat_type == MAT_ALIENFLESH || mat_type == MAT_GLASS ) then
		return damage - distance
	elseif( mat_type == MAT_DIRT ) then
		return damage - ( distance * 1.2 );
	end
	
	return damage - ( distance * 1.95 );
end

function SWEP:BulletPenetration( attacker, tr, dmginfo, bounce )

	if ( !self or !ValidEntity( self.Weapon ) ) then return end
	
	// Don't go through more than 3 times
	if ( bounce > 3 ) then return false end
	
	// Direction (and length) that we are gonna penetrate
	local PeneDir = tr.Normal * self:GetPenetrationDistance( tr.MatType )
		
	local PeneTrace = {}
	   PeneTrace.endpos = tr.HitPos
	   PeneTrace.start = tr.HitPos + PeneDir
	   PeneTrace.mask = MASK_SHOT
	   PeneTrace.filter = { self.Owner }
	   
	local PeneTrace = util.TraceLine( PeneTrace ) 
	
	// Bullet didn't penetrate.
	if ( PeneTrace.StartSolid || PeneTrace.Fraction >= 1.0 || tr.Fraction <= 0.0 ) then return false end
	
	local distance = ( PeneTrace.HitPos - tr.HitPos ):Length();
	local new_damage = self:GetPenetrationDamageLoss( tr.MatType, distance, dmginfo:GetDamage() );
	
	if( new_damage > 0 ) then
		local bullet = 
		{	
			Num 		= 1,
			Src 		= PeneTrace.HitPos,
			Dir 		= tr.Normal,	
			Spread 		= Vector( 0, 0, 0 ),
			Tracer		= 1,
			Force		= 5,
			Damage		= new_damage,
			AmmoType 	= "Pistol",
		}
		
		bullet.Callback = function( a, b, c ) if ( self.BulletCallback ) then return self:BulletCallback( a, b, c, bounce + 1 ) end end
		
		local effectdata = EffectData()
		effectdata:SetOrigin( PeneTrace.HitPos );
		effectdata:SetNormal( PeneTrace.Normal );
		util.Effect( "Impact", effectdata ) 
		
		timer.Simple( 0.05, attacker.FireBullets, attacker, bullet, true )
	end
end

