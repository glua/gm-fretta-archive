
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Accel = 0.01
ENT.Turn = 0.01

function ENT:Initialize()

	self.Entity:SetModel( self.Model )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_PLAYER )
	
	self.Entity:StartMotionController( true ) 
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
		phys:Wake()
		phys:SetDamping( self.SpeedDamp, self.TurnDamp )
	end
	
	self.Entity:SetVehicleHealth( self.StartHealth )
	
end

function ENT:OnRemove()

	if self.Entity:GetVehicleHealth() < 10 then
		self.Entity:ExplodeEffects()
	end

end

function ENT:Explode( attacker )

	if not ValidEntity( self.Entity:GetOwner() ) then 
		
		self.Entity:Remove()
		return
		
	end
	
	self.Entity:GetOwner():UnSpectate()
	self.Entity:GetOwner():Spawn()
	self.Entity:GetOwner():SetPos( self.Entity:GetPos() )
	self.Entity:GetOwner():SetModel( table.Random( GAMEMODE.Corpses ) )
	self.Entity:GetOwner():TakeDamage( 100, attacker )
	self.Entity:Remove()

end

function ENT:ExplodeEffects()

	local center = self.Entity:LocalToWorld( self.Entity:OBBCenter() )
	local rad = self.Entity:BoundingRadius() 

	local trace = {}
	trace.start = center 
	trace.endpos = trace.start + Vector(0,0,-250)
	trace.filter = self.Entity
	local tr = util.TraceLine( trace )
	
	if tr.HitWorld then
		util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	end

	local ed = EffectData()
	ed:SetStart( tr.HitPos )
	ed:SetScale( rad )
	util.Effect( "scaled_explode", ed, true, true )
	
	local tbl = ents.FindByClass( "prop_physics" )
	tbl = table.Add( tbl, ents.FindByClass( "sent_debris" ) )
	tbl = table.Add( tbl, ents.FindByClass( "sent_fireball" ) )
	
	for k, v in pairs( tbl ) do
	
		local dist = v:GetPos():Distance( self.Entity:GetPos() )
		
		if dist < 500 then
		
			if ValidEntity( self.Entity:GetOwner() ) then
				v:SetPhysicsAttacker( self.Entity:GetOwner() )
			end
			
			local dir = ( v:GetPos() - self.Entity:GetPos() ):Normalize()
			local phys = v:GetPhysicsObject()
			if phys and phys:IsValid() then
				phys:ApplyForceCenter( phys:GetMass() * ( 10000 - dist * 20 ) * dir + Vector(0,0,5000) )
			end
			
		end
		
	end
	
	for i=1, math.random( 10, 15 ) do
	
		local pos = center + VectorRand() * ( rad / 2 )
		pos.z = center.z
	
		local name = "sent_debris"
		if math.random(1,5) == 1 then
			name = "sent_fireball"
		end
	
		local ball = ents.Create( name )
		ball:SetPos( pos )
		ball:SetOwner( self.Entity:GetOwner() )
		ball:Spawn()
		
		if ValidEntity( self.Entity:GetOwner() ) then
			ball:SetOwner( self.Entity:GetOwner() )
		end
	
	end
	
	self.Entity:EmitSound( table.Random( GAMEMODE.BombExplosion ), 100, math.random(90,110) )
	
	if not ValidEntity( self.Entity:GetOwner() ) then 
	
		util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), 600, 80 )
		return 
		
	end
	
	util.BlastDamage( self.Entity:GetOwner(), self.Entity:GetOwner(), self.Entity:GetPos(), 600, 80 )
	
end

function ENT:GetPlayerInput()

	if self.Entity:GetOwner():KeyDown( IN_FORWARD ) then
		self.Accel = math.Approach( self.Accel, 1, self.AccelDelta )
	elseif self.Entity:GetOwner():KeyDown( IN_BACK ) then
		self.Accel = math.Approach( self.Accel, -1, self.AccelDelta )
	else
		self.Accel = math.Approach( self.Accel, 0, self.AccelDelta * 1.5 )
	end
	
	if self.Entity:GetOwner():KeyDown( IN_MOVELEFT ) then
		self.Turn = math.Approach( self.Turn, 1, self.TurnDelta )
	elseif self.Entity:GetOwner():KeyDown( IN_MOVERIGHT ) then 
		self.Turn = math.Approach( self.Turn, -1, self.TurnDelta )
	else
		self.Turn = math.Approach( self.Turn, 0, self.TurnDelta * 1.5 )
	end

	return self.Accel, self.Turn
	
end

function ENT:PhysicsUpdate( phys, deltatime )

	if not ValidEntity( self.Entity:GetOwner() ) or self.ExplodeTime then return SIM_NOTHING end
	
	phys:Wake()
	
	local accel, turn = self.Entity:GetPlayerInput()
	local speed = accel * self.BaseSpeed
	local turnspeed = turn * self.TurnSpeed
	
	if speed != 0 then 
		phys:ApplyForceCenter( self.Entity:GetForward() * speed )
	end
	
	if turnspeed != 0 then
		phys:AddAngleVelocity( Angle( 0, 0, turnspeed ) )
	end
	
end

function ENT:Think()
	
	if self.ExplodeTime then
	    if self.ExplodeTime < CurTime() and self.Entity:GetVehicleHealth() > 5 then
			self.Entity:SetVehicleHealth( 1 )
			self.ExplodeTime = CurTime() + 2
		elseif self.ExplodeTime < CurTime() and self.Entity:GetVehicleHealth() <= 5 then
			self.Entity:Explode( self.Entity:GetOwner() )
		end
	end
	
	local flipped = self.Entity:IsFlipped()

	if flipped and not self.ExplodeTime then
		self.ExplodeTime = CurTime() + 5
		return
	elseif not flipped and self.ExplodeTime then
		self.ExplodeTime = nil
	end
	
	if not ValidEntity( self.Entity:GetOwner() ) then return end
	
	self.Entity:GetOwner():SetPos( self.Entity:GetPos() )
	
	if self.Entity:GetOwner():KeyDown( IN_ATTACK ) and ( self.Horn or 0 ) < CurTime() then
	
		self.Entity:EmitSound( self.HornSound )
		self.Horn = CurTime() + 5
	
	end

end 

function ENT:IsFlipped()

	local tr = {}
	tr.start = self.Entity:LocalToWorld( self.Entity:OBBCenter() )
	tr.endpos = tr.start + self.Entity:GetUp() * -100
	tr.filter = self.Entity
	local trace = util.TraceLine( tr )

	return !trace.Hit
	
end

function ENT:OnTakeDamage( dmginfo )
	
	if dmginfo:GetAttacker():IsPlayer() then
	
		if dmginfo:GetAttacker():Team() == TEAM_GANG and ValidEntity( self.Entity:GetOwner() ) then
			dmginfo:SetDamage( 0 )
		else
			dmginfo:ScaleDamage( self.DamageScale )
		end
	
	end
	
	self.Entity:TakeVehicleHealth( dmginfo:GetDamage() )
	
	if self.Entity:GetVehicleHealth() <= 1 then
		self.Entity:Explode( dmginfo:GetAttacker() )
	end
	
end 

function ENT:PhysicsCollide( data, phys )
	
	if data.Speed > 300 and ( data.DeltaTime > 0.05 or ( data.HitEntity:IsWorld() and data.DeltaTime > 0.01 ) ) then
	
		self.Entity:EmitSound( table.Random( GAMEMODE.CarSmash ), 100, math.random(90,110) )
		
		if not ValidEntity( self.Entity:GetOwner() ) then return end
		
		if data.HitEntity:IsPlayer() then
			
			data.HitEntity:EmitSound( table.Random( GAMEMODE.BodySmack ), 100, math.random(90,110) )
			
		else
			
			local class = data.HitEntity:GetClass()
			local dmg = math.Clamp( data.Speed / 50, 1, 100 )
			
			self.Entity:TakeVehicleHealth( dmg )
			
			if self.Entity:GetVehicleHealth() <= 1 then
				self.Entity:Explode( self.Entity:GetOwner() )
			end
			
			if class == "sent_debris" or string.find( class, "prop_phys" ) then
				data.HitEntity:SetPhysicsAttacker( self.Entity:GetOwner() )
			end
			
		end
	end
end

function ENT:Use( ply, caller )

	if ValidEntity( self.Entity:GetOwner() ) then return end
	if ply:Team() == TEAM_POLICE then return end
	
	ply:EnterCar( self.Entity )
	
end

function ENT:GetMake()
	return self.CarName
end

function ENT:GetPrice()
	return self.Price
end

function ENT:SetVehicleHealth( num )
	self.Entity:SetNWInt( "Health", num )
end

function ENT:GetVehicleHealth()
	return self.Entity:GetNWInt( "Health", 0 )
end

function ENT:TakeVehicleHealth( num )
	self.Entity:SetVehicleHealth( math.Round( self.Entity:GetVehicleHealth() - num ) )
end
