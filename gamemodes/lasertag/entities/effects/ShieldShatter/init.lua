// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Shield shattering effect, used when shields are depleted to 0.

EFFECT.GlowMat = Material("effects/yellowflare")
//EFFECT.GlowMat = Material("sprites/animglow01")


/*---------------------------------------------------------
	Init
---------------------------------------------------------*/
function EFFECT:Init(data)
	
	self.Ply = data:GetEntity()
	if not self.Ply or not self.Ply:IsValid() then return end
	
	self.Alpha = 255
	self.Size = 40
	self.Mat = {
		"effects/fleck_glass1",
		"effects/fleck_glass2",
		"effects/fleck_glass3"
	}
	
	col = team.GetColor(math.Round(data:GetMagnitude()))
	self.Color = col
	
	local vOffset = self.Ply:GetPos()+Vector(0,0,36)
	local low,high = self.Ply:WorldSpaceAABB()
	local NumParticles = math.random(128,256)
	
	self.Pos = vOffset
	self.Low,self.High = low,high
	self.Entity:SetRenderBoundsWS(low,high)
	
	
	local emitter = ParticleEmitter(vOffset)
		for i=0, NumParticles do
			local vPos = Vector(math.Rand(low.x,high.x),math.Rand(low.y,high.y),math.Rand(low.z,high.z))
			local particle = emitter:Add(self.Mat[math.random(1,#self.Mat)],vPos)
			
			if particle then
				particle:SetColor(col.r,col.g,col.b)
				particle:SetLifeTime(0)
				particle:SetDieTime(math.Rand(2.0,5.0))
				particle:SetVelocity((vPos - vOffset)*10)
				particle:SetStartAlpha(225)
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(1,3))
				particle:SetEndSize(0)
				particle:SetRoll(math.random(0,360))
				particle:SetRollDelta(0)
				
				particle:SetAirResistance(50)
				//particle:SetGravity(Vector(math.random(-100,100),math.random(-100,100),math.random(-10,10)))
				particle:SetGravity(Vector(0,0,-200))
				particle:SetCollide(true)
				particle:SetBounce(0.3)
			end
		end
	emitter:Finish()
end


/*---------------------------------------------------------
	Think
---------------------------------------------------------*/
function EFFECT:Think()
	self.Alpha = self.Alpha - FrameTime() * 100
	self.Size = self.Size + FrameTime() * 100
	self.Pos = self.Ply:GetPos()+Vector(0,0,36)
	
	local low,high = self.Ply:WorldSpaceAABB()
	self.Entity:SetRenderBoundsWS(low,high)

	if self.Alpha < 0 then return false end
	return true
end

/*---------------------------------------------------------
	Render
---------------------------------------------------------*/
function EFFECT:Render()
	if self.Alpha < 1 then return end
	//local texcoord = CurTime() * -0.2
	local col = Color(self.Color.r, self.Color.g, self.Color.b, self.Alpha)
	
	render.SetMaterial(self.GlowMat)
	render.DrawSprite(self.Pos,self.Size,self.Size,col)
end
