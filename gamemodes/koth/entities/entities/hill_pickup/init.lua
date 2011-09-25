
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.PickupType = "normal"
ENT.RespawnTime = 10
ENT.PickupSound = Sound( "weapons/physcannon/physcannon_claws_close.wav" )
ENT.RespawnSound = Sound( "HL1/FVOX/fuzz.wav" )

function ENT:Initialize()

	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionBounds( Vector( -30, -30, -30 ), Vector( 30, 30, 0 ) )
	self.Entity:PhysicsInitBox( Vector( -30, -30, -30 ), Vector( 30, 30, 0 ) )
	
	local phys = self.Entity:GetPhysicsObject()
	if ValidEntity( phys ) then
		phys:EnableCollisions( false )		
	end
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetActiveTime( 0 )
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,-100)
	trace.filter = self.Entity
	local tr = util.TraceLine(trace)
	
	self.GroundPos = tr.HitPos
	self.Entity:SetPos( self.GroundPos + Vector(0,0,25) )
	
	self.Center = self.Entity:GetPos()
	
end

function ENT:KeyValue( key, value )

	if key == "pickuptype" then
		self.PickupType = math.Clamp( tonumber( value ), 1, 6 )
	elseif key == "respawntime" then
		self.RespawnTime = math.Clamp( tonumber( value ), 1, 200 ) 
	end
	
end

function ENT:Touch( ent )

	if self.Entity:GetActiveTime() > CurTime() then return end
	
	if not ValidEntity( ent ) then return end
	
	if ent:IsPlayer() then
		self.Entity:DoPickup( ent )
	end
	
end

function ENT:EndTouch()

end

function ENT:StartTouch()

end

function ENT:Think()

	if self.PickupType then
		self.Entity:SetPickupType( self.PickupType )
	end
	
end

function ENT:DoPickup( ply )

	self.Entity:SetActiveTime( CurTime() + self.RespawnTime )
	
	ply:Give( PickupTypes[ self.Entity:GetPickupType() ].Name )
	ply:SelectWeapon( PickupTypes[ self.Entity:GetPickupType() ].Name )
	
	local name = PickupTypes[ self.Entity:GetPickupType() ].NiceName
	ply:Notice( "Picked up the "..name, 3, 100, 255, 100 )
	
	self.Entity:EmitSound( self.PickupSound, 100, 150 )
	
	local ed = EffectData()
	ed:SetOrigin(self.Center)
	util.Effect( "pickup_take", ed, true, true )
	
	local function effect( center )
	
		self.Entity:EmitSound( self.RespawnSound, 100, 150 ) 
		
		local ed = EffectData()
		ed:SetOrigin( center )
		util.Effect( "pickup_spawn", ed, true, true )
		
	end
	
	timer.Simple( self.RespawnTime, effect, self.Center )
	
end

function ENT:SetPickupType( num )

	self.Entity:SetNWInt( "PickupType", num )
	
end

function ENT:GetPickupType()

	return self.Entity:GetNWInt( "PickupType", 1 ) 
	
end
