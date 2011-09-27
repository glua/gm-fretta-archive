
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local col = data:GetAttachment()
	
	local pSparkEmitter = ParticleEmitter(pos)
	
	local particle = pSparkEmitter:Add("effects/yellowflare", pos)
	particle:SetDieTime(math.Rand(0.3,0.6))
	particle:SetStartSize(math.Rand(16,32))
	particle:SetRoll(math.Rand(150,180))
	particle:SetRollDelta(0.6*math.random(-1,1))
	particle:SetColor(math.Rand(180,255),math.Rand(100,150),math.Rand(0,80),255)
	
	pSparkEmitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end
