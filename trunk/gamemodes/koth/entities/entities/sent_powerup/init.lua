AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

ENT.Model = Model( "models/roller.mdl" )

function ENT:Initialize()

	self.Entity:SetModel( self.Model )

	self.Entity:PhysicsInitSphere( 40 )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )

	local phys = self.Entity:GetPhysicsObject()
	if ValidEntity( phys ) then
		phys:Wake()
	end
	
	local power = powerup.RandomPowerup() 

	self.PowerupType = power.Type
	self.Color = power.Color
	self.DisplayName = power.DisplayName
	
	self.DieTime = CurTime() + 60
	self.PickedUp = false
	
	self.Entity:SetNetworkedVector( "Color", Vector( self.Color.r, self.Color.g, self.Color.b ) )
	self.Entity:SetColor( self.Color.r, self.Color.g, self.Color.b, self.Color.a )
	
end

function ENT:Touch( entity )

	if ( !entity:IsPlayer() or self.PickedUp ) then return end
	
	self.Entity:DoPickup( entity )
	
end

function ENT:Think()
	
	if self.DieTime < CurTime() then
		self.Entity:Remove()
	end
	
end

function ENT:PhysicsCollide( data, phys )
	
end

function ENT:DoPickup( ply )

	if ply:GetNWString( "Powerup", "null" ) != "null" then return end

	self.PickedUp = true

	ply:SetPowerup( self.PowerupType )
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) )
	ed:SetStart( Vector( self.Color.r, self.Color.g, self.Color.b ) )
	util.Effect( "powerup_take", ed, true, true )
	
	self.Entity:Remove()
	
end
