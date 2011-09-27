
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local vecDir = data:GetNormal()
	local col = data:GetAttachment()
	
	local width = 5
	
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(vecDir * 2)
		effectdata:SetMagnitude(5)
		effectdata:SetScale(1)
		effectdata:SetRadius(6)
	util.Effect("Sparks", effectdata)
	
	local pSparkEmitter = ParticleEmitter(pos)
	
	local dir
	
	local numSparks = math.Rand(30,60)
	
	for i=1,numSparks do
		local particle = pSparkEmitter:Add("effects/yellowflare", pos)
		
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(1,2))
		
		local dir = vecDir:Angle()
		dir:RotateAroundAxis(vecDir, math.Rand(-180,180))
		dir = dir:Right()+dir:Forward()*math.Rand(-0.1,0.1)
		
		particle:SetAirResistance(100)
		particle:SetVelocity(dir * math.Rand(80,100))
		particle:SetStartSize(width * math.Rand(0.8,1))
		if col==2 then
			particle:SetColor(math.Rand(0,80),math.Rand(100,150),math.Rand(180,255),255)
		else
			particle:SetColor(math.Rand(180,255),math.Rand(100,150),math.Rand(0,80),255)
		end
	end
	
	local numSparkles = math.Rand(10,15)
	
	for i=1,numSparkles do
		local particle = pSparkEmitter:Add("particle/fire", pos)
		
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(1,2))
		
		local dir = Angle(math.Rand(-180,180),math.Rand(-180,180),math.Rand(-180,180)):Forward()
		
		particle:SetGravity(Vector(0,0,-700))
		particle:SetVelocity(dir * math.Rand(100,200))
		particle:SetStartSize(width * math.Rand(0.2,0.6))
		if col==2 then
			particle:SetColor(math.Rand(0,80),math.Rand(100,150),math.Rand(180,255),255)
		else
			particle:SetColor(math.Rand(180,255),math.Rand(100,150),math.Rand(0,80),255)
		end
	end
	
	local particle = pSparkEmitter:Add("effects/yellowflare", pos)
	particle:SetDieTime(math.Rand(0.5,1))
	particle:SetStartSize(math.Rand(32,64))
	if col==2 then
		particle:SetColor(math.Rand(0,80),math.Rand(100,150),math.Rand(180,255),255)
	else
		particle:SetColor(math.Rand(180,255),math.Rand(100,150),math.Rand(0,80),255)
	end
	
	pSparkEmitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end
