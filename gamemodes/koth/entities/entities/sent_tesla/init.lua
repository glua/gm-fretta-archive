AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

function ENT:Initialize()

	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )
	
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:EnableCollisions(false)
		phys:Wake()
	end
	
	self.ZapTime = CurTime() + 1
	
end

function ENT:SetScale( scale )

	self.Damage = 250 * scale // 250 being the maximum
	self.Radius = 2000 * scale
	self.Scale = scale
	
end

function ENT:SetTarget( ent )

	self.Target = ent
	self:SetNWEntity( "Target", ent )
	self:SetParent( ent )
	
	if not ent then return end
	
	self:SetPos( ent:GetPos() )

end

function ENT:DrawBeams( ent1, ent2 )

	ent2:EmitSound( table.Random( GAMEMODE.SmallZap ), 100, math.random(90,110) )
	
	local target = ents.Create( "info_target" )
	target:SetPos( ent1:LocalToWorld( ent1:OBBCenter() ) )
	target:SetParent( ent1 )
	target:SetName( tostring( ent1 )..math.random(1,900) )
	target:Spawn()
	target:Activate()
	
	local target2 = ents.Create( "info_target" )
	target2:SetPos( ent2:LocalToWorld( ent2:OBBCenter() ) )
	target2:SetParent( ent2 )
	target2:SetName( tostring( ent2 )..math.random(1,900) )
	target2:Spawn()
	target2:Activate()
	
	local laser = ents.Create( "env_beam" )
	laser:SetPos( ent1:GetPos() )
	laser:SetKeyValue( "spawnflags", "1" )
	laser:SetKeyValue( "rendercolor", "200 200 255" )
	laser:SetKeyValue( "texture", "sprites/laserbeam.spr" )
	laser:SetKeyValue( "TextureScroll", "1" )
	laser:SetKeyValue( "damage", "0" )
	laser:SetKeyValue( "renderfx", "6" )
	laser:SetKeyValue( "NoiseAmplitude", ""..math.random(5,20) )
	laser:SetKeyValue( "BoltWidth", "1" )
	laser:SetKeyValue( "TouchType", "0" )
	laser:SetKeyValue( "LightningStart", target:GetName())
	laser:SetKeyValue( "LightningEnd", target2:GetName())
	laser:SetOwner( self:GetOwner() )
	laser:Spawn()
	laser:Activate()
	
	laser:Fire("kill","",0.2)
	target:Fire("kill","",0.2)
	target2:Fire("kill","",0.2)

end 

function ENT:LocateNewTarget()

	local closest = nil
	local targs = {}
	
	local tbl = ents.FindByClass( "prop_phys*" )
	table.Add( tbl, ents.FindByClass( "sent_beacon" ) )
	table.Add( tbl, player.GetAll() )
	
	for k,v in pairs( tbl ) do
	
		local pd = v:GetPos():Distance( self.Entity:GetPos() )
		
		local tracedata = {}
		tracedata.start = self.Entity:GetPos()
		tracedata.endpos = v:GetPos() + Vector(0,0,10)
		tracedata.filter = { self.Entity, self.Target }
		local tr = util.TraceLine( tracedata )
		
		if pd < self.Radius and v != self.Target and not tr.HitWorld then
		
			table.insert(targs,v)
			closest = table.Random( targs )
		
		end
		
	end
	
	if closest == self.Entity:GetOwner() then
		closest = table.Random( targs )
	end
	
	if ValidEntity( closest ) then
	
		self.Entity:SetNWEntity( "ZapEntity", closest )
		closest:TakeDamage( self.Damage + ( closest:WaterLevel() * 25 ), self:GetOwner(), self.Entity )
		closest:EmitSound( table.Random( GAMEMODE.MediumZap ), 100, math.random(90,110) )
		
		self.Entity:DrawBeams( closest, self.Target )
		self.Entity:SetTarget( closest )
	
	else
	
		self.Entity:DoExplode()
	
	end

end

function ENT:Think()

	if self.Target and self.Target:IsValid() then
		if self.Target:IsPlayer() then
			if not self.Target:Alive() then
				self:SetTarget()
			end
		end
	else
		self:SetTarget()
	end
	
	if self.Damage < 15 then
		self.Entity:DoExplode()
	end
	
	if self.ZapTime < CurTime() and ValidEntity( self.Target ) then

		self.ZapTime = CurTime() + math.Rand( 0.2, 1.0 )

		if self.Target:GetClass() == "sent_beacon" then
			self.Entity:SetScale( self.Scale * 0.9 )
		else
			self.Entity:SetScale( self.Scale * 0.8 )
		end
		self.Entity:LocateNewTarget()		
		
	end
end

function ENT:DoExplode()

	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "electric_fade", ed )

	self.Entity:EmitSound( table.Random( GAMEMODE.ElectricDissipate ), 100, math.random(90,110) )
	self.Entity:Remove()

end

function ENT:PhysicsCollide( data, phys )
	
end