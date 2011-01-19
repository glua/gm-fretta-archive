AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.ActivateTime 	= 0;
ENT.IsSticky		= false;

local function removeself(self)
	local rmvsnd = Sound("npc/roller/mine/rmine_shockvehicle1.wav")
	self:EmitSound( rmvsnd, math.random(50,75), 150 )
	loopsound:Stop()
	self:EmitSound( rmvsnd, 125, 150 )
	self:Remove()
end


//Initialize
function ENT:Initialize()
	
	util.PrecacheSound("weapons/grenade/tick1.wav")
	self.Entity:SetModel("models/weapons/w_grenade.mdl")
	self.Entity:EmitSound( "weapons/grenade/tick1.wav", 62, 100 )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local electric_loop = Sound("npc/roller/mine/rmine_shockvehicle2.wav")
	loopsound = CreateSound( self, electric_loop )
	loopsound:SetSoundLevel( SNDLVL_70dB )
	loopsound:PlayEx(math.random(50,80),math.random(55,65))
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		
		timer.Simple(5.5,removeself,self)

	end
	
	self.ActivateTime = CurTime() + 1.0
	
end

//Not used
function ENT:SpawnFunction()
end

function ENT:Think()

	if( CurTime() < self.ActivateTime ) then return end
	
	local randomsnd = Sound("npc/roller/mine/rmine_shockvehicle2.wav")
	
	for k,v in pairs(ents.FindInSphere( self:GetPos(), 160 )) do
		if( !( v:IsPlayer() and !v:Alive() ) ) then
		
			local dmgAmount = 0;
			
			if( self.IsSticky == true ) then
				dmgAmount = math.random(20,30)
			else
				dmgAmount = math.random(40,50)
			end
			
			v:TakeDamage( dmgAmount, self:GetOwner(), self )
			util.ScreenShake( self:GetPos(), 32, 210, 1, 128 )

		end
	end
	
	self:EmitSound( randomsnd, math.random(50,75), 150 )
		
end

ENT.StickyEnts = { "prop_physics", "prop_physics_respawnable", "prop_physics_multiplayer", "grenade_electricity", "door_rotating", "func_physbox", "func_breakable_surf", "func_clip_vphysics" }

//Play physics sound on impact
function ENT:PhysicsCollide( data, physobj )

	local ent = data.HitEntity
	local entclass = ent:GetClass()
	
	if( self.IsSticky == true ) then
		if ( ent:IsPlayer() or ent == GetWorldEntity() or table.HasValue( self.StickyEnts, entclass ) ) then
				constraint.Weld(self, data.HitEntity, 0, 0, 9000000, true )
				self:EmitSound( Sound( "physics/metal/sawblade_stick3.wav" ), 40, 100 )
		end	
	end
	
	if (data.Speed > 132 && data.DeltaTime > 0.21 ) then
		self.Entity:EmitSound("physics/metal/weapon_impact_soft" .. (math.random(1,2)) .. ".wav", 52, 100)
	end

end 

function ENT:PhysicsUpdate()

end 

function ENT:KeyValue( key, value)
	if( key == "IsSticky" ) then
		self.IsSticky = util.tobool( value )
	end
end

function ENT:UpdateTransmitState()

end 