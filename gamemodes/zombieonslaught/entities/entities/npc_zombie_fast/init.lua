AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Damage = 15

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = {"npc/fast_zombie/fz_alert_close1.wav",
"npc/fast_zombie/fz_alert_far1.wav"}

ENT.VoiceSounds.Pain = {"npc/fast_zombie/idle1.wav",
"npc/fast_zombie/idle2.wav",
"npc/fast_zombie/idle3.wav",
"npc/headcrab_poison/ph_hiss1.wav",
"npc/headcrab_poison/ph_idle1.wav"}

ENT.VoiceSounds.Taunt = {"npc/fast_zombie/fz_frenzy1.wav",
"npc/fast_zombie/fz_scream1.wav",
"npc/barnacle/barnacle_pull1.wav",
"npc/barnacle/barnacle_pull2.wav",
"npc/barnacle/barnacle_pull3.wav",
"npc/barnacle/barnacle_pull4.wav"}

ENT.VoiceSounds.Attack = {"npc/fast_zombie/wake1.wav",
"npc/fast_zombie/leap1.wav"}

util.PrecacheModel( "models/zombie/fast.mdl" )

function ENT:Initialize()

	self.Entity:SetModel( "models/zombie/fast.mdl" )
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	self.Entity:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_INNATE_MELEE_ATTACK1 | CAP_MOVE_JUMP | CAP_MOVE_CLIMB )
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( 50 )
	
	self.Entity:ClearSchedule()
	self.Entity:DropToFloor()
	
	self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
	
	self.DamageTable = {}

end

function ENT:SelectSchedule()

	local enemy = self.Entity:GetEnemy()
	local sched = SCHED_IDLE_WANDER 
	
	if enemy and enemy:IsValid() then
	
		if self.Entity:HasCondition( 23 ) then //  COND_CAN_MELEE_ATTACK1 
			sched = SCHED_MELEE_ATTACK1
			self.AttackTime = CurTime() + 0.5
			self.Entity:VoiceSound( self.VoiceSounds.Attack )
		else
			sched = SCHED_CHASE_ENEMY
		end
		
	else
	
		self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
		
	end

	self.Entity:SetSchedule( sched ) 

end
