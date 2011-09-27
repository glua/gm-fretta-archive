
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local mag = data:GetAttachment()
	
	local emitter = ParticleEmitter(pos)
	
	local col
	if mag==3 then
		col = Color(255,50,20,255)
	elseif mag==2 then
		col = Color(20,100,255,255)
	else
		col = Color(255,255,255,255)
	end
	
	local num = 20
	
	for i=1,num do
		local particle = emitter:Add("effects/fire_cloud"..math.random(1,2), pos)
		particle:SetGravity(Vector(0,0,600))
		particle:SetVelocity(Angle(math.Rand(0,90), math.Rand(-180,180), 0):Forward() * math.Rand(10,200))
		particle:SetAirResistance(300)
		particle:SetDieTime(math.Rand(0.4,1))
		particle:SetStartSize(math.Rand(15,30))
		particle:SetEndSize(math.Rand(25,50))
		particle:SetRoll(math.Rand(150,180))
		particle:SetRollDelta(0.6*math.random(-1,1))
		particle:SetColor(col.r,col.g,col.b,col.a)
		particle:SetEndAlpha(0)
	end
	
	local particle = emitter:Add("effects/yellowflare", pos)
	particle:SetDieTime(math.Rand(0.3,0.6))
	particle:SetStartSize(math.Rand(150,300))
	particle:SetColor(col.r,col.g,col.b,col.a)
	
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end
