AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Team = TEAM_RED
ENT.Target = nil
ENT.Speed = 1
ENT.SoundFile 	= "npc/scanner/combat_scan_loop1.wav"
ENT.Pitch		= 100
ENT.CanRespawn  = true
ENT.SnapNeck	= false

function ENT:SpawnFunction( ply, tr )
 
        if ( !tr.Hit ) then return end
       
        local SpawnPos = tr.HitPos + tr.HitNormal * 16
       
        local ent = ents.Create( "sent_rocketball" )
                ent:SetPos( SpawnPos )
        ent:Spawn()
        ent:Activate()
       
        return ent
       
end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	-- Use the helibomb model just for the shadow (because it's about the same size)
	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
	
	-- Don't use the model's physics - create a sphere instead
	self.Entity:PhysicsInitSphere( 16, "metal_bouncy" )
	
	-- Wake the physics object up. It's time to have fun!
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	-- Set collision bounds exactly
	self.Entity:SetCollisionBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
	
	self.Entity.Sound = CreateSound( self.Entity, self.SoundFile )
	self.Entity.Sound:PlayEx( 0.7, 100 )
	
	self.PhysObj = self.Entity:GetPhysicsObject()
	self.PhysObj:EnableGravity(false)
	self.CurrentAngle = self.Entity:GetAngles()
	self.Speed = 0
	self:SetRandomTarget( nil )
	
end

function ENT:SetRandomTarget( team )
	if team == nil then
		team = table.Random( {1, 2} )
	end
	
	self.Team = team
	
	if team == 1 then
		self.Entity:SetColor( 255, 0, 0, 255 )
		team = 2
	else
		self.Entity:SetColor( 0, 0, 255, 255 )
		team = 1
	end
	
	local teamTable = { }
	
	for k, pl in pairs( player.GetAll() ) do
		if pl:Team() == team and pl:Alive() then 
			table.insert( teamTable, pl ) 
		end
	end
	
	if #teamTable > 0 then
		local target = table.Random( teamTable )
		self.Target = target
		self.Speed = self.Speed + 1
		self.Entity:SetOwner( target )
		
		self.Pitch = math.min(self.Pitch + 1, 220)
		self.Entity.Sound:ChangePitch( self.Pitch )
		
		return target
	end
	
end

function ENT:OnPunt( pl )
	self:SetRandomTarget( pl:Team() )
	local puntVec = pl:GetAimVector() + Vector(0,0,1)
	self.CurrentAngle = puntVec:Angle()
end


/*---------------------------------------------------------
   Name: Physics
---------------------------------------------------------*/
function ENT:PhysicsUpdate()
	if self.Target and GAMEMODE:InRound() then
		self.PhysObj:EnableGravity(false)
		local VectorToTarget	= self.Target:EyePos() - self.Entity:GetPos()
		local AngleToTarget	= VectorToTarget:Angle()
		local DistanceToTarget = math.min(VectorToTarget:Length(), 5000)
		--local Mod = ( 5001 - DistanceToTarget ) / 50
		local Mod = (1700 / math.min(DistanceToTarget, 1700) ) * ( 1 + (self.Speed/20))
		local baseRate = 0.5
		self.CurrentAngle.p 	= math.ApproachAngle( self.CurrentAngle.p, AngleToTarget.p, baseRate * Mod   )
		self.CurrentAngle.r  	= math.ApproachAngle( self.CurrentAngle.r, AngleToTarget.r, baseRate * Mod  )
		self.CurrentAngle.y 	= math.ApproachAngle( self.CurrentAngle.y, AngleToTarget.y, baseRate * Mod )
		self.Entity:SetAngles( self.CurrentAngle )
		self.PhysObj:SetVelocity( self.Entity:GetForward() * (600 + (self.Speed*45) ) )
		
		if DistanceToTarget < 10 then
			if self.Target:IsBot() then
				self.SnapNeck = false
				SetGlobalString("CustomHudText", "")
				self:OnPunt( self.Target )
			else
				self:Explode()
			end
		end
	else
		self.PhysObj:EnableGravity(true)
	end
end

function ENT:PhysicsCollide( data, physobj )
	
	// Play sound on bounce
	if (data.Speed > 80 && data.DeltaTime > 0.2 ) then
		self.Entity:EmitSound( "Rubber.BulletImpact" )
	end
	
	if data.HitEntity:IsWorld() then
		for k,v in pairs( player.GetAll() ) do
			if self.Entity:GetPos():Distance( v:GetPos() ) < 250 then
				self:Explode()
				return
			end
		end
		
		self.CurrentAngle = (data.HitNormal*-1):Angle()
	else
		self:Explode()
	end
	
end

function ENT:Explode()
	if self.SnapNeck then
		self.Target:SetEyeAngles( self.Target:EyeAngles() + Angle(0,0,180) )
		self:OnPunt( self.Target )
		self.SnapNeck = false
	elseif not self.Exploded then
			local expl=ents.Create("env_explosion")
			expl:SetPos(self.Entity:GetPos())
			expl:SetName("Missile")
			expl:SetParent(self.Entity)
			expl:SetOwner(self.Entity:GetOwner())
			expl:SetKeyValue("iMagnitude","300");
			expl:SetKeyValue("iRadiusOverride", 250)
			expl:Spawn()
			expl:Activate()
			expl:Fire("explode", "", 0)
			expl:Fire("kill","",0)
			self.Exploded = true
			
			self.Entity.Sound:Stop()
			
			if self.CanRespawn then
				GAMEMODE:PreSpawnRocketball()
			end
			
			self.Entity:Remove()
		end
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )

	-- React physically when shot/getting blown
	-- self.Entity:TakePhysicsDamage( dmginfo )
	
end



