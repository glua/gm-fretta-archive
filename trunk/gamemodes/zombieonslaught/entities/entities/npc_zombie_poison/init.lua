AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')
	
ENT.Damage = 30

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = {"npc/zombie_poison/pz_die1.wav",
"npc/zombie_poison/pz_die2.wav",
"npc/zombie_poison/pz_idle2.wav",
"npc/zombie_poison/pz_warn2.wav"}

ENT.VoiceSounds.Pain = {"npc/zombie_poison/pz_idle3.wav",
"npc/zombie_poison/pz_idle4.wav",
"npc/zombie_poison/pz_pain1.wav",
"npc/zombie_poison/pz_pain2.wav",
"npc/zombie_poison/pz_pain3.wav",
"npc/zombie_poison/pz_warn1.wav"}

ENT.VoiceSounds.Taunt = {"npc/zombie_poison/pz_alert1.wav",
"npc/zombie_poison/pz_alert2.wav",
"npc/zombie_poison/pz_call1.wav",
"npc/zombie_poison/pz_throw2.wav",
"npc/zombie_poison/pz_throw3.wav"}

ENT.VoiceSounds.Attack = {"npc/zombie_poison/pz_throw2.wav",
"npc/zombie_poison/pz_throw3.wav",
"npc/zombie_poison/pz_alert2.wav"}

util.PrecacheModel( "models/zombie/poison.mdl" )
util.PrecacheModel( "models/Zombie/Classic_legs.mdl" )

function ENT:Initialize()

	self.Entity:SetModel( "models/zombie/poison.mdl" )
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	self.Entity:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_INNATE_MELEE_ATTACK1 ) 
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( 250 )
	
	self.Entity:ClearSchedule()
	self.Entity:DropToFloor()
	
	self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
	self.Entity:SetSchedule( SCHED_IDLE_WANDER ) 
	
	self.DamageTable = {}

end

function ENT:SpawnRagdoll( att )

	local ang = self.Entity:GetForward():Angle()

	local shooter = ents.Create("env_shooter")
	shooter:SetPos( self.Entity:GetPos() )
	shooter:SetKeyValue( "m_iGibs", "1" )
	shooter:SetKeyValue( "shootsounds", "3" )
	shooter:SetKeyValue( "gibangles", ang.p.." "..ang.y.." "..ang.r )
	shooter:SetKeyValue( "shootmodel", "models/Zombie/Classic_legs.mdl" ) 
	shooter:SetKeyValue( "simulation", "2" )
	shooter:SetKeyValue( "gibanglevelocity", math.random(-50,50).." "..math.random(-150,150).." "..math.random(-150,150) )
	
	if ValidEntity( att ) then
	
		local dir = ( att:GetPos() - self.Entity:GetPos() ):Normalize():Angle()
		shooter:SetKeyValue( "angles", dir.p.." "..dir.y.." "..dir.r )
		shooter:SetKeyValue( "m_flVelocity", tostring( math.Rand(0,40) ) )
		shooter:SetKeyValue( "m_flVariance", tostring( math.Rand(0,2) ) )
		
	end
	
	shooter:Spawn()
	
	shooter:Fire( "shoot", 0, 0 )
	shooter:Fire( "kill", 0.1, 0.1 )
	
	local cloud = ents.Create( "sent_poisoncloud" )
	cloud:SetPos( self:GetPos() )
	cloud:Spawn()

end

function ENT:Think()

	if self.IdleTalk < CurTime() then
	
		self.Entity:VoiceSound( self.VoiceSounds.Taunt )
		self.IdleTalk = CurTime() + math.random(15,25)
		
	end

	if self.DoorTime < CurTime() then
	
		self.DoorTime = CurTime() + 10
		local door = self.Entity:NearDoor()
		
		if door and door:IsValid() then
		
			self.Entity:SetSchedule( SCHED_MELEE_ATTACK1 ) 
		
			door:TakeDamage( 100, self.Entity )
			door:Fire( "kill", 0.01, 0.01 )
			self.Entity:EmitSound( self.DoorHit, 100, math.random(90,110) )
			
		end
		
	end
	
	if self.AttackTime and self.AttackTime < CurTime() then
	
		self.AttackTime = nil
		local enemy = self.Entity:GetEnemy()
		
		if enemy:GetPos():Distance( self.Entity:GetPos() ) < 50 then
		
			enemy:TakeDamage( self.Damage, self.Entity )
			enemy:DoPoison( self.Entity )
			
			local sound = table.Random( self.ClawHit )
			self.Entity:EmitSound( Sound( sound ), 100, math.random(90,110) )

		else
		
			local sound = table.Random( self.ClawMiss )
			self.Entity:EmitSound( Sound( sound ), 100, math.random(90,110) )
		
		end
	
	end
	
end
