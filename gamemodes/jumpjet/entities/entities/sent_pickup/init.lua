
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

ENT.PickupType = "normal"
ENT.RespawnTime = 30
ENT.PickupSound = Sound( "weapons/physcannon/physcannon_claws_close.wav" )
ENT.RespawnSound = Sound( "HL1/FVOX/fuzz.wav" )

function ENT:Initialize()

	self.Entity:SetModel( "models/props_junk/wood_crate001a.mdl" )

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
	trace.endpos = trace.start + Vector(0,0,-500)
	trace.filter = self.Entity
	local tr = util.TraceLine( trace )
	
	self.GroundPos = tr.HitPos
	self.Entity:SetPos( self.GroundPos + Vector(0,0,25) )
	
	self.Center = self.Entity:GetPos()
	
	local power = powerup.RandomPowerup()
	self.Entity:SetPower( power.ID, power.Color )
	
end

function ENT:KeyValue( key, value )
	
end

function ENT:Touch( ent )

	if self.Entity:GetActiveTime() > CurTime() then return end
	
	if not ValidEntity( ent ) then return end
	
	if ent:IsPlayer() and ent:GetPowerupName() == "null" then
	
		self.Entity:DoPickup( ent )
		
	end
	
end

function ENT:EndTouch()

end

function ENT:StartTouch()

end

function ENT:Think()
	
end

function ENT:DoPickup( ply )

	local oldpower = powerup.GetByID( self.Entity:GetPower() )
	local col = oldpower.Color

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	ed:SetStart( Vector( col.r, col.g, col.b ) )
	util.Effect( "crate_explode", ed, true, true )

	self.Entity:SetActiveTime( CurTime() + self.RespawnTime )

	ply:SetPowerup( self.Entity:GetPower() )
	
	local power = powerup.RandomPowerup()
	self.Entity:SetPower( power.ID )
	
	local function effect( ent, center, col )	
		
		if not ValidEntity( ent ) then return end
	
		ent:EmitSound( self.RespawnSound, 100, 150 ) 
		
		local ed = EffectData()
		ed:SetOrigin( self.Entity:GetPos() )
		ed:SetStart( Vector( col.r, col.g, col.b ) )
		util.Effect( "crate_spawn", ed, true, true )
		
	end
	
	timer.Simple( self.RespawnTime, effect, self.Entity, self.Center, power.Color )
	
end

function ENT:SetPower( num )

	self.Entity:SetNWInt( "PickupType", num )
	
end

function ENT:GetPower()

	return self.Entity:GetNWInt( "PickupType", 1 ) 
	
end
