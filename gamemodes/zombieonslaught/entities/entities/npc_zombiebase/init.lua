AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.ClawHit = {"npc/zombie/claw_strike1.wav",
"npc/zombie/claw_strike2.wav",
"npc/zombie/claw_strike3.wav"}

ENT.ClawMiss = {"npc/zombie/claw_miss1.wav",
"npc/zombie/claw_miss2.wav"}

ENT.DoorHit = Sound("npc/zombie/zombie_hit.wav")

ENT.IdleTalk = 0
ENT.DoorTime = 0
ENT.VoiceTime = 0
ENT.RemoveTime = 0
ENT.RemovePos = Vector(0,0,0)

function ENT:Initialize()

	self.Entity:SetModel( "models/zombie/classic.mdl" )
	
	self.Entity:SetHullSizeNormal()
	self.Entity:SetHullType( HULL_HUMAN )
	
	self.Entity:SetSolid( SOLID_BBOX ) 
	self.Entity:SetMoveType( MOVETYPE_STEP )
	self.Entity:CapabilitiesAdd( CAP_MOVE_GROUND | CAP_INNATE_MELEE_ATTACK1 ) 
	
	self.Entity:SetMaxYawSpeed( 5000 )
	self.Entity:SetHealth( 100 )
	
	self.Entity:DropToFloor()
	
	self.Entity:UpdateEnemy( self.Entity:FindEnemy() )

end

function ENT:VoiceSound( tbl )

	if self.VoiceTime > CurTime() then return end

	self.VoiceTime = CurTime() + 1
	
	self.Entity:EmitSound( Sound( table.Random( tbl ) ), 100, math.random( 90, 100 ) )
	
end

function ENT:SpawnRagdoll( att )

	local ang = self.Entity:GetForward():Angle()

	local shooter = ents.Create("env_shooter")
	shooter:SetPos( self.Entity:GetPos() )
	shooter:SetKeyValue( "m_iGibs", "1" )
	shooter:SetKeyValue( "shootsounds", "3" )
	shooter:SetKeyValue( "gibangles", ang.p.." "..ang.y.." "..ang.r )
	shooter:SetKeyValue( "shootmodel", self.Entity:GetModel() ) 
	shooter:SetKeyValue( "simulation", "2" )
	shooter:SetKeyValue( "gibanglevelocity", math.random(-50,50).." "..math.random(-150,150).." "..math.random(-150,150) )
	
	if ValidEntity( att ) then
	
		local dir = ( att:GetPos() - self.Entity:GetPos() ):Normalize():Angle()
		dir.p = math.Clamp( dir.p, -10, 10 )
		
		shooter:SetKeyValue( "angles", dir.p.." "..dir.y.." "..dir.r )
		shooter:SetKeyValue( "m_flVelocity", tostring( math.Rand(0,40) ) )
		shooter:SetKeyValue( "m_flVariance", tostring( math.Rand(0,2) ) )
		
	end
	
	shooter:Spawn()
	
	shooter:Fire( "shoot", 0, 0 )
	shooter:Fire( "kill", 0.1, 0.1 )

end

function ENT:DropItem( attacker )

	if math.random(1,20) == 1 then
	
		local item = ents.Create( "sent_pickup" )
		item:SetPos( self.Entity:GetPos() + Vector(0,0,30) )
		item:SetType()
		item:Spawn()
		
		if not attacker.m_bItemNotice then
			attacker.m_bItemNotice = true
			attacker:Notice( "Some zombies will drop useful items", 5, 0, 100, 255 )
		end
		
	end
	
end

function ENT:DoDeath()

	if self.Dying then return end
	self.Dying = true

	local tbl = self.Entity:GetTopDamagers()
	
	for k,v in pairs( tbl ) do
		if ValidEntity( v ) then
			v:AddBones( 1 )
			if k == 1 then // the top damager
				self.Entity:DropItem( v )
				self.Entity:SpawnRagdoll( v )
			end
		end
	end
	
	self.Entity:VoiceSound( self.VoiceSounds.Death )
	
	self.Entity:SetSchedule( SCHED_FALL_TO_GROUND )
	self.Entity:Remove()
	//self.Entity:Fire( "kill", 0.01, 0.01 )
	
end

function ENT:AddDamageTaken( attacker, amt )

	for k,v in pairs( self.DamageTable ) do
		if v.Attacker == attacker then
			v.Damage = v.Damage + amt
			return
		end
	end

	table.insert( self.DamageTable, { Attacker = attacker, Damage = amt } )

end

function ENT:GetTopDamagers()

	table.SortByMember( self.DamageTable, "Damage" )
	
	//PrintTable( self.DamageTable )  
	
	local tbl = {}
	for k,v in pairs( self.DamageTable ) do
		if v.Damage > 50 or #tbl < 1 then
			table.insert( tbl, v.Attacker )
		end
	end

	return tbl
	
end

function ENT:OnTakeDamage( dmginfo )

	if dmginfo:GetAttacker():IsValid() and dmginfo:GetAttacker():IsPlayer() then
		if dmginfo:GetAttacker():Team() == TEAM_DEAD then 
			dmginfo:SetDamage( 0 )
		end
	end
	
	if not dmginfo:GetAttacker():IsPlayer() then return end
	
	self.Entity:AddDamageTaken( dmginfo:GetAttacker(), dmginfo:GetDamage() )
	self.Entity:SetHealth( math.Clamp( self.Entity:Health() - dmginfo:GetDamage(), 0, 100 ) )
	
	if self.Entity:Health() <= 0 then
		self.Entity:DoDeath()
	elseif math.random( 1, 3 ) == 1 then
		self.Entity:VoiceSound( self.VoiceSounds.Pain )
	end
	
end 

function ENT:FindEnemy()

	if team.NumPlayers( TEAM_ALIVE ) < 1 then
		
		return NULL
		
	else
	
		local enemy = table.Random( team.GetPlayers( TEAM_ALIVE ) )
		local dist = 99999
		
		for k,v in pairs( team.GetPlayers( TEAM_ALIVE ) ) do
			local compare = v:GetPos():Distance( self.Entity:GetPos() )
			if compare < dist and v:Alive() then
				enemy = v
				dist = compare
			end
		end
		
		return enemy
		
	end
	
end

function ENT:UpdateEnemy( enemy )

	if enemy and enemy:IsValid() and enemy:Alive() and enemy:Team() == TEAM_ALIVE then
		
		self:SetEnemy( enemy, true ) 
		self:UpdateEnemyMemory( enemy, enemy:GetPos() ) 
		
	else
		
		self:SetEnemy( NULL )
		
	end

end

function ENT:Think()

	if self.RemoveTime < CurTime() then
	
		if self.Entity:GetPos() == self.RemovePos then

			GAMEMODE:CreateZombie( self.Entity:GetClass() )
			self.Entity:Remove()
			
		end
		
		self.RemoveTime = CurTime() + 10
		self.RemovePos = self.Entity:GetPos()
	
	end

	if self.IdleTalk < CurTime() then
	
		self.Entity:VoiceSound( self.VoiceSounds.Taunt )
		self.IdleTalk = CurTime() + math.random(15,25)
		
	end

	if self.DoorTime < CurTime() then
	
		self.DoorTime = CurTime() + 5
		local door = self.Entity:NearDoor()
		
		if door and door:IsValid() then
		
			self.Entity:SetSchedule( SCHED_MELEE_ATTACK1 ) 
		
			door:TakeDamage( 100, self.Entity )
			
			if string.find( door:GetClass(), "door" ) then
				door:Fire( "kill", 0.01, 0.01 )
			end
			
			self.Entity:EmitSound( self.DoorHit, 100, math.random(90,110) )
			
		end
		
	end
	
	if self.AttackTime and self.AttackTime < CurTime() then
	
		self.AttackTime = nil
		local enemy = self.Entity:GetEnemy()
		
		if enemy and enemy:IsValid() and enemy:GetPos():Distance( self.Entity:GetPos() ) < 64 then
		
			local ed = EffectData()
			ed:SetEntity( enemy )
			ed:SetOrigin( enemy:GetPos() + Vector(0,0,40) )
			util.Effect( "playerhit", ed, true, true )
		
			enemy:TakeDamage( self.Damage, self.Entity )
			
			local sound = table.Random( self.ClawHit )
			self.Entity:EmitSound( Sound( sound ), 100, math.random(90,110) )

		else
		
			local sound = table.Random( self.ClawMiss )
			self.Entity:EmitSound( Sound( sound ), 100, math.random(90,110) )
		
		end
	
	end
	
end

function ENT:GetDoors()

	local tbl = ents.FindByClass( "prop_door_rotating" )
	tbl = table.Add( tbl, ents.FindByClass( "func_breakable" ) )
	tbl = table.Add( tbl, ents.FindByClass( "func_door" ) )
	tbl = table.Add( tbl, ents.FindByClass( "func_door_rotating" ) )
	tbl = table.Add( tbl, ents.FindByModel( "models/props_debris/wood_chunk03b.mdl" ) )
	
	return tbl

end

function ENT:NearDoor()

	local doors = self.Entity:GetDoors()
	local pos = self.Entity:GetPos()
	
	for k,v in pairs( doors ) do
		if v:GetPos():Distance( pos ) < 80 then
			return v
		end
	end
	
	return

end

function ENT:GetRelationship( entity )

	if entity:IsValid() and entity:IsPlayer() and entity:Team() == TEAM_ALIVE then return D_HT end
	
	return D_LI
	
end

function ENT:SelectSchedule()

	local enemy = self.Entity:GetEnemy()
	local sched = SCHED_IDLE_WANDER 
	
	if enemy and enemy:IsValid() then
	
		if self.Entity:HasCondition( 23 ) then //  COND_CAN_MELEE_ATTACK1 
			sched = SCHED_MELEE_ATTACK1
			self.AttackTime = CurTime() + 1
			self.Entity:VoiceSound( self.VoiceSounds.Attack )
		else
			sched = SCHED_CHASE_ENEMY
		end
		
	else
	
		self.Entity:UpdateEnemy( self.Entity:FindEnemy() )
		
	end

	self.Entity:SetSchedule( sched ) 

end
