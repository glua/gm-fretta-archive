AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

util.PrecacheModel( "models/healthvial.mdl" )

ENT.PickupSound = Sound( "weapons/physcannon/physcannon_claws_close.wav" )
ENT.HealSound = Sound( "items/medshot4.wav" )

function ENT:Initialize()

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	
	local r = 30
	self.Entity:SetCollisionBounds( Vector(-r,-r,-r), Vector(r,r,r) ) 

	local phys = self.Entity:GetPhysicsObject()
	if ValidEntity( phys ) then
		phys:Wake()
	end
	
	if not self.WepName then
		self.WepName = "health"
		self.Entity:SetModel( "models/healthvial.mdl" )
	end
	
	self.DieTime = CurTime() + 30
	self.PickedUp = false
	
end

function ENT:SetWeapon( name )

	if name == "health" then
		self.WepName = "health"
		self.Entity:SetModel( "models/healthvial.mdl" )
		return
	end

	for k,v in pairs( PickupTypes ) do
		if v.Name == tostring( name ) then
			self.WepName = name
			self.NiceName = v.NiceName
			self.Entity:SetModel( Model( v.Model ) )
			return
		end
	end
	
	self.WepName = "health"
	self.Entity:SetModel( "models/healthvial.mdl" )

end

function ENT:Touch( entity )

	if ( !entity:IsPlayer() or self.PickedUp ) then return end
	
	self.PickedUp = true
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

	if self.WepName == "health" then
	
		self.Entity:EmitSound( self.HealSound )
		
		local hp = math.Clamp( ply:Health() + 50, 1, 100 )
		ply:SetHealth( hp )
		
		ply:Notice( "Picked up a medikit", 3, 255, 255, 100 )

	else
	
		ply:Give( self.WepName )
		ply:Notice( "Picked up the "..self.NiceName, 3, 255, 255, 100 )
	
		self.Entity:EmitSound( self.PickupSound, 100, 200 )
	
	end
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) )
	util.Effect( "weapon_take", ed, true, true )
	
	self.Entity:Remove()
	
end
