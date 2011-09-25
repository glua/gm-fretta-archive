AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

ENT.Damage = 250
ENT.Alpha = 255
ENT.HitFlesh = Sound( "ambient/machines/slicer2.wav" )
ENT.HitWorld = Sound( "weapons/knife/knife_hitwall1.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/weapons/w_knife_t.mdl" )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		phys:SetVelocityInstantaneous( self.Entity:GetAngles():Forward():Normalize() * 800 )
		
		local ang = self.Entity:GetAngles()
		
		phys:AddAngleVelocity( Angle( 0, ang.y * 100, 0 ) )
	
	end
	
end

function ENT:Think() 

	if self.Dead then
	
		self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		self.Entity:SetColor( 255, 255, 255, self.Alpha )
		
		self.Alpha = self.Alpha - 2
	
	end
	
	if self.Alpha < 1 then
		
		self.Entity:Remove()
		
	end

end

function ENT:PhysicsCollide( data, phys )

	if self.Dead then return end
	
	self.Dead = true

	if not ValidEntity( self.Entity:GetOwner() ) then
	
		self.Entity:Remove()
		return
	
	end
	
	if data.HitEntity:IsPlayer() and data.HitEntity:Team() != self.Entity:GetOwner():Team() then
	
		data.HitEntity:TakeDamage( self.Damage, self.Entity:GetOwner(), self.Entity )
		data.HitEntity:EmitSound( self.HitFlesh, 100, math.random(90,110) )
		
		local ed = EffectData()
		ed:SetOrigin( self.Entity:GetPos() )
		ed:SetNormal( data.HitNormal )
		ed:SetMagnitude( 80 )
		util.Effect( "blood_splat", ed, true, true )
	
	elseif data.HitEntity:IsWorld() then
	
		self.Entity:EmitSound( self.HitWorld, 100, 130 )
	
	end
	
end

