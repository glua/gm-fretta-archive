AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "Clavus"
ENT.Purpose			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

util.PrecacheModel("models/props_junk/watermelon01.mdl")
util.PrecacheSound("items/battery_pickup.wav")

function ENT:SetParticleColor( col )
	
	self:SetNWVector("particlecol", Vector(col.r,col.g,col.b))

end

function ENT:GetParticleColor()

	local vec = self:GetNWVector("particlecol",Vector(255,255,255))
	return Color(vec.x, vec.y, vec.z)

end

function ENT:SetPowerupType( type )

	self:SetNWString("powerup", type)

end

function ENT:GetPowerupType()

	return self:GetNWString("powerup", "none")

end

if SERVER then
	function ENT:Initialize()

		self.Entity:DrawShadow( false )
		self.Entity:SetModel("models/props_junk/watermelon01.mdl")
		
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		
		self.phys = self.Entity:GetPhysicsObject()
		if ValidEntity(self.phys) then

			self.phys:EnableGravity( false )
			self.phys:EnableDrag( false ) 
			self.phys:SetMass(1)

			local randvec = Vector(math.Rand(-1,1),math.Rand(-1,1),math.Rand(-1,1))
			randvec = randvec:GetNormal() * 200
			self.phys:SetVelocity(randvec)
			self.phys:Wake()
		end

	end

	function ENT:Think()

		// Make sure the powerup stays on the center plane
		local vec1 = self.phys:GetVelocity()
		local vec2 = GAMEMODE.TeamDivider:GetAngles():Up()
		local vec3 = GAMEMODE.TeamDivider:GetAngles():Right()

		local vecn = vec2:Cross(vec3)
		vecn:Normalize()
		
		self.phys:SetVelocity(vec1 - vec1:Dot(vecn) * vecn)

		// Make sure it stays up to speed
		if self.phys:GetVelocity():Length() < 200 then
			self.phys:SetVelocity(self.phys:GetVelocity():GetNormal()*200)
		end

	end
	
	function ENT:StartTouch( ent )

		if ValidEntity(ent) and ent:IsPlayer() then
			GAMEMODE:ActivatePowerup( self:GetPowerupType(), ent:Team() )
			ent:EmitSound("items/battery_pickup.wav")
			self:Remove()
		end
		
	end

end

if CLIENT then
	function ENT:Think()
	
		local spawnPos = self.Entity:GetPos()+self.Entity:GetVelocity():GetNormal()*10

		-- Particle timer
		self.ParticleTimer = self.ParticleTimer or (CurTime()+0.01)
		if ( self.ParticleTimer <= CurTime() ) then 
			self.ParticleTimer = CurTime() + 0.01
			
			local col = self:GetParticleColor()
			local emitter = ParticleEmitter( spawnPos )
			if emitter then
				local particle = emitter:Add( "sprites/light_glow02_add", spawnPos )
				particle:SetVelocity( self.Entity:GetAngles():Right()*math.Rand( -120, 120 ) + 
					self.Entity:GetAngles():Up()*math.Rand( -120, 120 ) + 
					self.Entity:GetAngles():Forward()*math.Rand( 0, 100 ) )
				particle:SetDieTime( 3+math.Rand(0,0.5) )
				particle:SetAirResistance( 300 )
				particle:SetStartSize( math.Rand( 5, 10 ) )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand( -0.2, 0.2 ) )
				particle:SetColor( col.r, col.g, col.b )
						
				emitter:Finish()
			end
		end
	end
	
	ENT.LightSprite = Material("sprites/light_glow02_add")

	function ENT:Draw()
	
		self.Entity:DrawModel()
		
		local distance = self.Entity:GetPos():Distance(LocalPlayer():EyePos())
		
		if distance < 1200 then
			local TargetPos = self.Entity:GetPos() + Vector(0,0,30)
			local TargetAngles = (LocalPlayer():EyePos()-TargetPos):Angle()
			TargetAngles:RotateAroundAxis(TargetAngles:Right(), 	-90)
			TargetAngles:RotateAroundAxis(TargetAngles:Up(), 		90)
			TargetAngles:RotateAroundAxis(TargetAngles:Forward(), 0)
			
			local color = Color(255,255,255,math.min(255, math.max(0, 2055-(distance * 2))))
			local color2 = Color(0,0,0,color.a)

			cam.Start3D2D(TargetPos, TargetAngles, 0.6)
				draw.SimpleTextOutlined("Powerup!", "ScoreMedium", 0, 0, color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,color2)
			cam.End3D2D() 	
		end
		
		local col = self:GetParticleColor()
		render.SetMaterial( self.LightSprite )
		render.DrawSprite( self.Entity:GetPos(), 128, 128, Color( col.r, col.g, col.b, 100 ) )
		render.DrawSprite( self.Entity:GetPos(), 64, 64, Color( color_white.r, color_white.g, color_white.b, 255 ) )
		render.DrawSprite( self.Entity:GetPos(), 64, 64, Color( col.r, col.g, col.b, 200 ) )
		
	end
	
	function ENT:OnRemove()
	
		for i = 1, 50 do
		
			local spawnPos = self.Entity:GetPos()
			local col = self:GetParticleColor()
			local emitter = ParticleEmitter( spawnPos )
			local particle = emitter:Add( "sprites/light_glow02_add", spawnPos )
			particle:SetVelocity( Angle(math.random(0,360),math.random(0,360),math.random(0,360)):Forward()*math.random(300,400 ) )
			particle:SetDieTime( 3+math.Rand(0,0.5) )
			particle:SetAirResistance( 200 )
			particle:SetStartSize( math.Rand( 5, 10 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -0.2, 0.2 ) )
			particle:SetColor( col.r, col.g, col.b )
					
			emitter:Finish()

		end
	end

end

