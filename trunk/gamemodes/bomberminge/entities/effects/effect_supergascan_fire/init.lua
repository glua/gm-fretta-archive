
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	
	local width = 5
	
	local pSmokeEmitter = ParticleEmitter(pos)
	
	local dir = Vector()
	
	local numGlow = 2
	
	for i=1,numGlow do
		local particle = pSmokeEmitter:Add("effects/yellowflare", pos)
		
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(0.5,0.7))
		
		particle:SetStartSize(width * math.Rand(5,10))
		particle:SetEndSize(width * math.Rand(0.2,0.5))
		particle:SetRoll(math.Rand(150,180))
		particle:SetRollDelta(0.6*math.random(-1,1))
		particle:SetColor(math.Rand(180,255),math.Rand(180,255),math.Rand(0,100),255)
		particle:SetEndAlpha(0)
	end
	
	local numFlames = math.Rand(2,5)
	
	for i=1,numFlames do
		local particle = pSmokeEmitter:Add("effects/fire_cloud"..math.random(1,2), pos)
		
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(0.5,0.8))
		
		local dir = Angle(math.Rand(40,60),math.Rand(-180,180),0):Forward()
		
		particle:SetGravity(Vector(0,0,500))
		particle:SetAirResistance(200)
		particle:SetVelocity(dir * math.Rand(50,100))
		particle:SetStartSize(width * math.Rand(1,4))
		particle:SetEndSize(width * math.Rand(0.1,0.2))
		particle:SetRoll(math.Rand(150,180))
		particle:SetRollDelta(0.6*math.random(-1,1))
		particle:SetColor(math.Rand(180,255),math.Rand(180,255),math.Rand(0,100),255)
		particle:SetEndAlpha(0)
	end
	
	local numSmoke = math.Rand(3,6)
	
	for i=1,numSmoke do
		local particle = pSmokeEmitter:Add("particle/particle_smokegrenade", pos)
		
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(0.8,1.4))
		
		local dir = Angle(math.Rand(40,60),math.Rand(-180,180),0):Forward()
		
		particle:SetGravity(Vector(0,0,600))
		particle:SetAirResistance(100)
		particle:SetVelocity(dir * math.Rand(50,100))
		particle:SetStartSize(width * math.Rand(2,8))
		particle:SetEndSize(width * math.Rand(0.1,0.2))
		particle:SetRoll(math.Rand(150,180))
		particle:SetRollDelta(0.6*math.random(-1,1))
		particle:SetColor(255,255,255,100)
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
	end
	
	
	pSmokeEmitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end
