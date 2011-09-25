AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include('shared.lua')

function ENT:SpawnFunction( plr, tr )

	if not tr.Hit then return end
	
	local ent = ents.Create( self.Classname )
	ent:SetPos( tr.HitPos )
	ent:Spawn()
	ent:Activate()	
	
	return ent

end

function ENT:Initialize()	

	self:SetModel( "models/magnusson_teleporter.mdl" )
	self:SetSkin(0)
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)

	local phys = self:GetPhysicsObject()  	
	if phys:IsValid() then  		
		phys:Wake()  	
	end
	
	self:SetUseType(SIMPLE_USE)
	self.Item = nil
	self.SpawnerHealth = 200
	self.EngineFire = nil
	
end

function ENT:Think()  self:NextThink(CurTime());  return true;  end

function ENT:Use()
	
	if ValidEntity( self.Item ) || self.Charging then
		self:EmitSound( "items/suitchargeno1.wav" )
		return
	end
	
	local seq = self:LookupSequence("spinup")
	self:ResetSequence(seq)
	self.Charging = true
	timer.Simple(6.5,function()
		if !ValidEntity(self) then return end
		// SPAWN AMMO/HEALTHKIT
		local item = ents.Create("ent_ammopickup")
		item:SetPos( self:GetPos() + self:GetUp() * 52 )
		item:SetAngles( Angle( 70, 80, 10 ) )
		item:Spawn()
		item:Activate()
		item:SetMoveType(MOVETYPE_NONE)
		self.Item = item
		self.Charging = false
	end)
end

function ENT:OnTakeDamage( dmg )
	self.SpawnerHealth = self.SpawnerHealth - dmg:GetDamage()
	if self.SpawnerHealth < 0 then
		self:Remove()
	elseif self.SpawnerHealth < 150 and not ValidEntity(self.EngineFire) then
		local fire = ents.Create("env_fire_trail")
		fire:SetPos( self:GetPos() + Vector(0,0,75) )
		fire:Spawn()
		fire:SetParent( self )
		self.EngineFire = fire
	end
end

function ENT:OnRemove()

	local gibs = {
		"models/props_mining/elevator_winch_cog.mdl",
		"models/Combine_turrets/Floor_turret_gib1.mdl",
		"models/Combine_turrets/Floor_turret_gib2.mdl",
		"models/Combine_turrets/Floor_turret_gib3.mdl",
		"models/Combine_turrets/Floor_turret_gib4.mdl",
		"models/Combine_turrets/Floor_turret_gib5.mdl",
	}
	local props = {}
	
	for _,v in ipairs( gibs ) do
		local prop = ents.Create("prop_physics")
		prop:SetPos( self:GetPos() + Vector( math.random() * 20, math.random() * 20, math.random(1,2) * 50 ) )
		prop:SetAngles( Angle(math.random() * 360,math.random() * 360,math.random() * 360) )
		prop:SetModel(v)
		prop:Spawn()
		prop:Activate()
		local vec = VectorRand() * 750
		vec.z = math.Clamp(vec.z,0,1000)
		prop:GetPhysicsObject():SetVelocity( vec )
		table.insert(props,prop)
	end
	
	timer.Simple(10,function() for _,v in ipairs(props) do v:Remove() end end)
	
	//ParticleEffect( "building_explosion", self:GetPos(), Angle(0,0,0), nil )

	if ValidEntity( self.Item) then self.Item:Remove() end
	if ValidEntity( self.EngineFire) then self.EngineFire:Remove() end

end







