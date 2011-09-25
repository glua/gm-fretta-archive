
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

util.PrecacheModel( "models/props/cs_assault/money.mdl" )
util.PrecacheModel( "models/props/cs_assault/dollar.mdl" )

function ENT:Initialize()
	
	self.Entity:DrawShadow( false )
	self.Entity:SetModel( table.Random{ "models/props/cs_assault/money.mdl", "models/props/cs_assault/dollar.mdl"} )
	
	self.Entity:PhysicsInitBox( Vector(-5,-5,-5), Vector(5,5,5) )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetTrigger( true )
	self.Entity:SetCollisionBounds( Vector(-50,-50,-50), Vector(50,50,50) ) 
		
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		
		local vel = VectorRand() * 200
		vel.z = 200
		
		phys:Wake()
		phys:SetDamping( 0, 100 )
		phys:SetVelocity( vel )
		
	end
	
	self.PickupSound = Sound( table.Random( GAMEMODE.CashTake ) )
	self.RemoveTime = CurTime() + 60
	
end

function ENT:Touch( entity )

	if ( !entity:IsPlayer() || self.TakeOnce ) then return end
	
	self.TakeOnce = true
	
	self.Entity:DoPickup( entity ) 
	
end

function ENT:Think()

	if self.RemoveTime < CurTime() then
		self.Entity:Remove()
	end
	
end
 
function ENT:DoPickup( ply )
	
	ply:AddCash( 100 )
	
	umsg.Start( "DrawPrice", ply )
	umsg.Vector( Vector(0,0,0) )
	umsg.String( "" )
	umsg.Short( 100 )
	umsg.End()
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) )
	util.Effect( "cash_take", ed, true, true )
	
	self.Entity:EmitSound( self.PickupSound )
	self.Entity:Remove()
	
end
 
function ENT:OnTakeDamage( dmg )
	
end

function ENT:PhysicsCollide( data, phys )

end
