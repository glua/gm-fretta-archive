AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Bounciness 	    	    = 1.05
ENT.HitSound		    	= Sound( "physics/plastic/plastic_box_impact_hard1.wav" )

function ENT:Initialize()

	util.PrecacheModel( "models/dav0r/tnt/tnt.mdl" )
	self.Entity:SetModel( "models/dav0r/tnt/tnt.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS ) 
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:Wake()
	end
	
	self.BurnSound = CreateSound( self.Entity, Sound( "General.BurningObject" ) )
	self.BurnSound:Play()
	
end

function ENT:SetBombTime( num )

	self.BombTime = CurTime() + num

end

function ENT:Think()

	if self.BombTime and self.BombTime < CurTime() then
	
		self.Entity:Explode()
	
	end
	
end

function ENT:Explode()

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "Explosion", ed, true, true )

	if ValidEntity( self.Entity:GetOwner() ) then
		util.BlastDamage( self.Entity, self.Entity:GetOwner(), self.Entity:GetPos(), 300, 50 )
	end
	
	self.Entity:Remove()

end

function ENT:OnRemove()

	self.BurnSound:Stop()
	
end

function ENT:PhysicsCollide( data, physobj )

	if ( data.Speed > 50 && data.DeltaTime > 0.2 ) then
		self.Entity:EmitSound( self.HitSound, 100, math.random(90,110) )
	end

	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * self.Bounciness
	
	physobj:SetVelocity( TargetVelocity )
	
end