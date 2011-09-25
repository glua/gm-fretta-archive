AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

// MAKE HUD FOR JEEP HEALTH

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos + tr.HitNormal * 15 )
	ent:Spawn()
	ent:Activate()
	ent:SetAngles(plr:GetAngles())
	
	return ent

end

function ENT:Initialize()

	self.MaxHealth = 1000
	self:SetNWInt("ta-health",self.MaxHealth)
	self.Damage = 0
	self.OnFire = false
	self.LastUse = CurTime()
	self.LastGetIn = CurTime()
	
	self:SetUseType(SIMPLE_USE)

	local ent = ents.Create("prop_vehicle_jeep_old")  
	ent:SetPos( self:GetPos() )
	ent:SetModel("models/buggy.mdl")  
	ent:SetKeyValue("vehiclescript","scripts/vehicles/jeep_test.txt")  
	ent:Spawn()
	ent:Activate()
	
	local seat = ents.Create( "prop_vehicle_prisoner_pod" )
	seat:SetPos( self:GetPos() + Vector(18,-37,19) )
	seat:SetModel( "models/nova/jeep_seat.mdl") 
	seat:Spawn()
	seat:Activate()
	seat:SetParent(ent)
	
	local seat2 = ents.Create( "prop_vehicle_prisoner_pod" )
	seat2:SetPos( self:GetPos() + Vector(0,-105,56) )
	seat2:SetModel( "models/Nova/airboat_seat.mdl") 
	seat2:SetAngles( Angle(0,180,0) )
	seat2:Spawn()
	seat2:Activate()
	seat2:SetParent(ent)
	
	self.Jeep = ent
	self.Seat = seat
	self.Seat2 = seat2
	
	self:SetPos( self:GetPos() + Vector(-2,0,5) )
	self:SetModel("models/jeeparmor.mdl")
	//self:SetNoDraw(true)
	self:SetAngles( Angle(0,270,0) )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	//self:SetParent( ent )
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then
		phys:Wake() 
		phys:SetMass( 100 )
	else ErrorNoHalt("Jeep armor has no physics!") end
	constraint.Weld(self,ent,0,0,false)
	constraint.NoCollide(ent,self,0,0)
	constraint.NoCollide(seat,self,0,0)
	constraint.NoCollide(seat2,self,0,0)
	
end

function ENT:OnTakeDamage( dmg )
	self.LastAttacker = dmg:GetAttacker()
	self.Damage = self.Damage + dmg:GetDamage()
	self:SetNWInt("ta-health",self.MaxHealth - self.Damage)
	
	if self.Damage >= self.MaxHealth then
		self:Remove()
		if ValidEntity(self.Jeep:GetDriver()) then self.Jeep:GetDriver():Kill() end
		if ValidEntity(self.Seat:GetDriver()) then self.Seat:GetDriver():Kill() end
		if ValidEntity(self.Seat2:GetDriver()) then self.Seat2:GetDriver():Kill() end
	elseif self.Damage >= self.MaxHealth * 3/4 and not self.OnFire then
		self.OnFire = true
		
		local fire = ents.Create("env_fire_trail")
		fire:SetPos( self:GetPos() + self:GetForward() * 90 + self:GetUp() * 60 )
		fire:Spawn()
		fire:SetParent( self.Jeep )
		self.EngineFire = fire
	end
end

function ENT:Use( activator, caller )
	
	if CurTime() - self.LastUse < 0 then return end
	self.LastUse = CurTime() + 0.4
	
	local pos = activator:GetShootPos()
	local d_pass, d_drive = pos:Distance(self.Seat:GetPos()),pos:Distance( self:GetPos() + self:GetForward() * 15 + self:GetRight() * 29+ self:GetUp() *30) 
	if d_pass < 100 and d_pass < d_drive and not ValidEntity( self.Seat:GetDriver() ) then
		activator:EnterVehicle( self.Seat )
	elseif d_drive < 100 and d_drive < d_pass and not ValidEntity( self.Jeep:GetDriver() ) then
		activator:EnterVehicle( self.Jeep )
		self.LastGetIn = CurTime()
	end
end

function ENT:Think()
	local driver = self.Jeep:GetDriver()
	if ValidEntity(driver) then
		if driver:KeyDownLast(IN_USE) and CurTime() - self.LastGetIn > 0.4 then
			driver:ExitVehicle()
		end
	end
end

function ENT:OnRemove()

	local gibs = {
		"models/props_vehicles/carparts_wheel01a.mdl",
		"models/props_vehicles/carparts_wheel01a.mdl",
		"models/props_vehicles/carparts_wheel01a.mdl",
		"models/props_vehicles/carparts_wheel01a.mdl",
		"models/combine_apc_destroyed_gib02.mdl",
		"models/combine_apc_destroyed_gib03.mdl",
		"models/combine_apc_destroyed_gib04.mdl",
		"models/combine_apc_destroyed_gib05.mdl",	
		"models/combine_apc_destroyed_gib06.mdl",	
		"models/Nova/airboat_seat.mdl",		
		 "models/nova/jeep_seat.mdl",
		  "models/nova/jeep_seat.mdl",
		//  "models/buggy.mdl",
	}
	local props = {}

	
	// EXPLOSION HERE
	ta.Explosion( self, self:GetPos(),100)
	ParticleEffect( "building_explosion", self:GetPos(), Angle(0,0,0), nil )
	
	for _,v in ipairs( gibs ) do
		local prop = ents.Create("prop_physics")
		prop:SetPos( self:GetPos() + Vector( math.random() * 20, math.random() * 20, math.random(1,2) * 30 ) )
		prop:SetAngles( Angle(math.random() * 360,math.random() * 360,math.random() * 360) )
		prop:SetModel(v)
		prop:Spawn()
		prop:Activate()
		local vec = VectorRand() * 100
		vec.z = math.Clamp(vec.z,-5,1000)
		prop:GetPhysicsObject():SetVelocity( VectorRand() * 100 )
		table.insert(props,prop)
	end
	
	timer.Simple(10,function() for _,v in ipairs(props) do v:Remove() end end)
	
	if ValidEntity( self.Seat ) then self.Seat:Remove() end
	if ValidEntity( self.Seat2) then self.Seat2:Remove() end
	if ValidEntity( self.Jeep) then self.Jeep:Remove() end
	if ValidEntity( self.EngineFire) then self.EngineFire:Remove() end

end
