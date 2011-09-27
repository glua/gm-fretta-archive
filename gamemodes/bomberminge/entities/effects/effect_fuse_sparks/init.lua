
SPARK_SPREAD = 3
SPARK_GRAVITY = 800
SPARK_DAMPEN = 0.3

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local mag = data:GetMagnitude()
	local vecDir = data:GetNormal()
	
	local width = 5
	
	local pSparkEmitter = ParticleEmitter(pos)
	
	local dir = Vector()
	
	local numSparks = mag * mag * 2
	
	for i=1,numSparks do
		local particle = pSparkEmitter:Add("effects/yellowflare", pos)
		
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(0.5,1))
		
		local dir = Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)):Forward()
		
		particle:SetAirResistance(200)
		particle:SetVelocity(dir * math.Rand(50,100))
		particle:SetStartSize(width * math.Rand(0.8,1))
		particle:SetColor(math.Rand(180,255),math.Rand(180,255),math.Rand(0,100),255)
	end
	
	local numSparkles = mag * math.Rand(2,4)
	
	for i=1,numSparkles do
		local particle = pSparkEmitter:Add("particle/fire", pos)
		
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(0.5,1))
		
		local dir = Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)):Forward()
		
		particle:SetGravity(Vector(0,0,-700))
		particle:SetVelocity(dir * math.Rand(100,200))
		particle:SetStartSize(width * math.Rand(0.2,0.6))
		particle:SetColor(math.Rand(200,255),math.Rand(200,255),math.Rand(0,100),255)
	end
	
	local particle = pSparkEmitter:Add("effects/yellowflare", pos)
	particle:SetDieTime(math.Rand(0.3,0.6))
	particle:SetStartSize(math.Rand(8,16))
	particle:SetColor(math.Rand(200,255),math.Rand(200,255),math.Rand(0,100),255)
	
	pSparkEmitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end
