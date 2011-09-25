AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.RemoveTime = 0
ENT.RemovePos = Vector(0,0,0)
ENT.StartHealth = 100
ENT.Models = { "models/Humans/Group01/Female_01.mdl" }

function ENT:Initialize()

	local model = table.Random( self.Models )
	
	if not model or type( model ) != "string" then
		model = "models/Humans/Group01/Female_01.mdl"
	end
	
	util.PrecacheModel( model )
	
	self.Entity:SetModel( model )
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	self.Entity:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_TURN_HEAD ) 
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( self.StartHealth )
	
	self.Entity:DropToFloor()
	
	self.PosTime = CurTime() + 3

end

function ENT:SpawnRagdoll( att, model )

	local ang = self.Entity:GetForward():Angle()

	local shooter = ents.Create( "env_shooter" )
	shooter:SetPos( self.Entity:GetPos() )
	shooter:SetKeyValue( "m_iGibs", "1" )
	shooter:SetKeyValue( "shootsounds", "3" )
	shooter:SetKeyValue( "gibangles", ang.p.." "..ang.y.." "..ang.r )
	shooter:SetKeyValue( "shootmodel", ( model or self.Entity:GetModel() ) ) 
	shooter:SetKeyValue( "simulation", "2" )
	shooter:SetKeyValue( "gibanglevelocity", math.random(-50,50).." "..math.random(-250,250).." "..math.random(-250,250) )
	
	if ValidEntity( att ) then
	
		local dir = ( self.Entity:GetPos() - att:GetPos() ):Normalize():Angle()
		dir.p = math.Clamp( dir.p, -10, 10 )
		
		shooter:SetKeyValue( "angles", dir.p.." "..dir.y.." "..dir.r )
		shooter:SetKeyValue( "m_flVariance", tostring( math.Rand(0,2) ) )
		
		if string.find( att:GetClass(), "vehicle" ) then
		
			shooter:SetKeyValue( "m_flVelocity", tostring( math.Rand(50,100) ) )
			
			if ValidEntity( att:GetOwner() ) then
				att:GetOwner():Roadkill()
			end		
			
		else
			
			shooter:SetKeyValue( "m_flVelocity", tostring( math.Rand(0,50) ) )
			
		end
		
	end
	
	shooter:Spawn()
	
	shooter:Fire( "shoot", 0, 0 )
	shooter:Fire( "kill", 0.1, 0.1 )

end

function ENT:SpawnCash()

	if math.random( 1, 5 ) == 1 then return end

	for i=1, math.random( 1, 5 ) do
	
		local cash = ents.Create( "sent_cash" )
		cash:SetPos( self.Entity:GetPos() + Vector( 0, 0, 30 ) )
		cash:Spawn()
	
	end

end

function ENT:DoDeath( dmginfo )

	if self.Dying then return end
	self.Dying = true
	
	if dmginfo:GetAttacker():IsPlayer() then
		dmginfo:GetAttacker():AddFrags( 1 )
	elseif string.find( dmginfo:GetAttacker():GetClass(), "vehicle" ) then
		if ValidEntity( dmginfo:GetAttacker():GetOwner() ) then
			dmginfo:GetAttacker():GetOwner():AddFrags( 1 )
		end
	end
	
	if self.Entity:CanSpeak() then
		self.Entity:Speak( self.Death )
	end
	
	self.Entity:SpawnCash()
	self.Entity:PanicCheck( 2000 )

	if not dmginfo:IsExplosionDamage() then
		self.Entity:SpawnRagdoll( dmginfo:GetAttacker() )
	else
		self.Entity:SpawnRagdoll( dmginfo:GetAttacker(), table.Random( GAMEMODE.Corpses ) )
	end
	
	self.Entity:SetSchedule( SCHED_FALL_TO_GROUND )
	self.Entity:Remove()
	
end

function ENT:OnTakeDamage( dmginfo )

	if ValidEntity( dmginfo:GetAttacker() ) and dmginfo:GetAttacker():IsPlayer() then
		if dmginfo:GetAttacker():Team() == TEAM_POLICE then 
			dmginfo:SetDamage( 0 )
		end
	end
	
	self.Entity:Panic()
	self.Entity:SetHealth( math.Clamp( self.Entity:Health() - dmginfo:GetDamage(), 0, 900 ) )
	
	if self.Entity:Health() < 1 then
		self.Entity:DoDeath( dmginfo )
	end
	
	if self.Entity:CanSpeak() then
		self.Entity:Speak( self.Pain )
	end
	
end 

function ENT:OnRemove()

	if ValidEntity( self.Marker ) then
		self.Marker:Remove()
	end

end

function ENT:Think()
	
	if ( self.PosTime or 0 ) < CurTime() then
	
		self.PosTime = CurTime() + 10
		local canuse = true
	
		for k,v in pairs( GAMEMODE:GetSpawnPositions() ) do
			if v:Distance( self.Entity:GetPos() ) < 500 then
				canuse = false
			end
		end
	
		if canuse then
			GAMEMODE:AddSpawnPosition( self.Entity:GetPos() )
		end
		
	end
	
	if self.PanicTime then
	
		if self.PanicTime > CurTime() then return end
		
		self.PanicTime = nil
	
		if self.Entity:CanSpeak() then
			self.Entity:Speak( self.Scream )
		end
	
	end
	
	if not ValidEntity( self.Marker ) then
	
		self.Marker = ents.Create( "info_npcmarker" )
		self.Marker:SetPos( self.Entity:GetPos() )
		self.Marker:Spawn()
		self.Marker:SetParent( self.Entity )
	
	end
	
end

function ENT:GetRelationship( entity )

	return D_HT
	
end

function ENT:SelectSchedule()

	local sched = table.Random{ SCHED_IDLE_WANDER, SCHED_IDLE_WALK, SCHED_COMBAT_PATROL }
	
	if self.Entity:IsFleeing() then
		sched = self.Entity:IsFleeing()
	end

	self.Entity:SetSchedule( sched ) 

end

function ENT:PanicCheck( dist )

	for k,v in pairs( ents.FindByClass( "npc_*" ) ) do
		if v!= self.Entity and v:GetPos():Distance( self.Entity:GetPos() ) < dist then
			v:Panic()
		end
	end

end

function ENT:Panic()

	self.Flee = table.Random{ SCHED_RUN_FROM_ENEMY, SCHED_RUN_RANDOM }
	self.PanicTime = CurTime() + math.Rand( 0.5, 2.5 )
	
end

function ENT:IsFleeing()

	return self.Flee
	
end

function ENT:CanSpeak()

	return ( self.VoiceTime or 0 ) < CurTime()
	
end

function ENT:Speak( sounds )

	local sound = table.Random( sounds )
	
	if type( sound ) == "table" then return end 
	
	self.Entity:EmitSound( sound )
	self.VoiceTime = CurTime() + 3

end
