
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Stick = Sound( "NPC_CombineCamera.Click" )
ENT.Alarm = Sound( "npc/attack_helicopter/aheli_damaged_alarm1.wav" )
ENT.Ignore = Sound( "npc/scanner/scanner_scan4.wav" )

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/items/grenadeammo.mdl" ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )
	
end

function ENT:StartTripmineMode( hitpos, forward )

	self.Entity:EmitSound( self.Stick )
	
	if hitpos then
	
		self.Entity:SetPos( hitpos ) 
	
	end
	
	self.Entity:SetAngles( forward:Angle() + Angle( 90, 0, 0 ) )

	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = self.Entity:GetPos() + forward * 5000
	trace.filter = self.Entity
	trace.mask = MASK_NPCWORLDSTATIC
	
	local tr = util.TraceLine( trace )

	local ent = ents.Create( "sent_tripmine_laser" )
	ent:SetPos( self.Entity:GetPos() + self.Entity:GetUp() * 3 )
	ent:Spawn()
	ent:Activate()
	ent:SetEndPos( tr.HitPos )
	ent:SetActiveTime( CurTime() + 3 )		
	ent:SetParent( self.Entity )
	
	local effectdata = EffectData()
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetNormal( forward )
		effectdata:SetMagnitude( 1 )
		effectdata:SetScale( 1 )
		effectdata:SetRadius( 1 )
	util.Effect( "Sparks", effectdata )

end

function ENT:DoAlarm( enemy )

	if self.AlarmTimer then return end
	
	self.AlarmTimer = CurTime() + 1.0
	
	if enemy then

		self.Entity:EmitSound( self.Alarm, 150, 150 )
		
	else
	
		self.Entity:EmitSound( self.Ignore )
	
	end

end

function ENT:Think()

	if self.AlarmTimer and self.AlarmTimer < CurTime() then
	
		self.AlarmTimer = nil
	
	end

end

function ENT:OnTakeDamage( dmginfo )
	
	self.Entity:DoAlarm()
	
end

function ENT:PhysicsCollide( data, phys )

	if not data.HitEntity:IsWorld() then return end
	
	phys:EnableMotion( false )
	phys:Sleep()
	
	self.Entity:StartTripmineMode( data.HitPos, data.HitNormal * -1 )
	
end


