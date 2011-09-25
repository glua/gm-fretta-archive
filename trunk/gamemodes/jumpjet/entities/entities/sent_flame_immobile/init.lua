AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

ENT.Damage = 5
ENT.Bound = 150
ENT.Shadow = {}

function ENT:Initialize()

	self.Entity:SetModel( "models/Roller.mdl" )
	
	self.Entity:PhysicsInitBox( Vector( -self.Bound, -self.Bound, -self.Bound ), Vector( self.Bound, self.Bound, self.Bound ) )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_BBOX )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -self.Bound, -self.Bound, -self.Bound ), Vector( self.Bound, self.Bound, self.Bound ) )
	self.Entity:SetTrigger( true )
	self.Entity:DrawShadow( false )
	
	self.DieTime = CurTime() + self.LifeTime 
	self.BurnSound = Sound( "fire_medium" )
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector( 0, 0, -500 )
	
	local tr = util.TraceLine( trace )
	
	self.Entity:SetPos( tr.HitPos )
	self.Entity:EmitSound( self.BurnSound )
	
end

function ENT:Think() 

	if self.DieTime < CurTime() then 
	
		self.Entity:StopSound( self.BurnSound )
		self.Entity:Remove()
		
	end

end

function ENT:StartTouch( ent )

	if not ValidEntity( self.Entity:GetOwner() ) then
	
		self.Entity:Remove()
		return
	
	end

	if ValidEntity( ent ) and ent:IsPlayer() and ( ent == self.Entity:GetOwner() or ent:Team() != self.Entity:GetOwner():Team() ) then

		ent:TakeDamage( self.Damage, self.Entity:GetOwner(), self.Entity )
		ent:DoIgnite( self.Entity:GetOwner() )
	
	end

end


