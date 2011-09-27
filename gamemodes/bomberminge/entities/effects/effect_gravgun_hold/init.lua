
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local col = data:GetAttachment()
	
	local pSparkEmitter = ParticleEmitter(pos)
	
	local dir
	
	local numSparks = math.Rand(2,4)
	
	for i=1,numSparks do
		local dir = Angle(math.Rand(-90,90), math.Rand(-180,180), 0):Forward()
		local pos2 = pos + dir*12
		local particle = pSparkEmitter:Add("effects/yellowflare", pos2)
		
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(1,2))
		
		particle:SetGravity(Vector(0,0,200))
		particle:SetAirResistance(500)
		particle:SetVelocity(dir * math.Rand(60,80))
		particle:SetStartSize(10 * math.Rand(0.8,1))
		if col==2 then
			particle:SetColor(math.Rand(0,80),math.Rand(100,150),math.Rand(180,255),255)
		else
			particle:SetColor(math.Rand(180,255),math.Rand(100,150),math.Rand(0,80),255)
		end
		particle:SetEndAlpha(0)
	end
	
	pSparkEmitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end
