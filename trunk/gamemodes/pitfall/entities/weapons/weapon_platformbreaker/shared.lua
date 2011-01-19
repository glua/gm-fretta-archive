SWEP.Author = "BlackOps"
SWEP.Contact = ""
SWEP.Purpose = "Hurt a platform or push the nearest person"
SWEP.Instructions = "Primary to attack a platform, Secondary to punt people close to you"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Primary.Recoil			= 0.25
SWEP.Primary.Damage 		=1
SWEP.Primary.BulletForce	= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone		= 0.01
SWEP.Primary.ClipSize		= -1
SWEP.Primary.Delay		= 0.15
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"
 
SWEP.Secondary.ClipSize		= 9999
SWEP.Secondary.DefaultClip	= 9999
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= 9999
SWEP.Secondary.Delay		= 3
SWEP.Secondary.NextUse		= 0
SWEP.Secondary.Recoil = 2

function SWEP:PrimaryAttack()
	self.Weapon:EmitSound("Weapon_AR2.Single")
	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	if CLIENT then
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - self.Primary.Recoil/1.5
		
		self.Owner:SetEyeAngles( eyeang )
	end
	self.Owner:ViewPunch( Angle( -self.Primary.Recoil, math.Rand(-1,1)*self.Primary.Recoil, 0))
	self:SetNextPrimaryFire(CurTime()+ self.Primary.Delay)
end

function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return end
	self.Weapon:EmitSound("AlyxEMP.Discharge")
	self:SecondaryShootBullets( )
	self.Owner:ViewPunch( Angle( -2, 0, 0 ) )
	self:SetNextSecondaryFire(CurTime()+ self.Secondary.Delay)
end

function SWEP:SecondaryShootBullets()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 )
	tr.filter = { self.Owner }
	
	for k,v in pairs(ents.FindByClass( "pf_platform" )) do
		table.insert(tr.filter,v)
	end
	tr.mask = MASK_SHOT
	
	local trace = util.TraceLine( tr )	
	
	local effectdata = EffectData()
	effectdata:SetStart( tr.start )
	effectdata:SetEntity( self.Weapon )
	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetAttachment( 1 )
	util.Effect( "punch_tracer", effectdata )
	
	if ( trace.Hit and trace.Entity and trace.Entity:IsPlayer() ) then
		local dist = self.Owner:GetPos():Distance(trace.Entity:GetPos())
		if(dist < 100) then
			if SERVER then
				--trace.Entity:SetGroundEntity(NULL)
				if trace.Entity:Crouching() then
					trace.Entity:SetVelocity(trace.Entity:GetVelocity() + (self.Owner:GetAimVector() * 700) )
				else
					trace.Entity:SetVelocity(trace.Entity:GetVelocity() + (self.Owner:GetAimVector() * 500) )
				end
				
				trace.Entity:SetNWBool("BlackAndWhite",true)
				trace.Entity.LastPunchedMe = self.Owner
				
				timer.Simple(5, function()
					if IsValid( trace.Entity ) then
						trace.Entity.LastPunchedMe = nil
						trace.Entity:SetNWBool("BlackAndWhite",false)
					end
				end )
			end
		end
	end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
end