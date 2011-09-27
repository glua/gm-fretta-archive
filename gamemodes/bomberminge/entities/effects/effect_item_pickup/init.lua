
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local mag = data:GetAttachment()
	local vecDir = data:GetNormal()
	
	local width = 5
	
	local emitter = ParticleEmitter(pos)
	
	local dir = Vector()
	
	local mat, col
	if mag==2 then
		mat, col = "effects/yellowflare", Color(255,80,80,255)
	else
		mat, col = "effects/blueflare1", Color(255,255,255,255)
	end
	
	local num = 20
	local radius = 30
	for i=1,num do
		local ppos = pos + Angle(0,math.Rand(-180,180),0):Forward() * math.Rand(0,radius)
		local particle = emitter:Add(mat, ppos)
		
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(0.8,1.2))
		particle:SetGravity(Vector(0,0,80))
		particle:SetStartSize(width * math.Rand(2,4))
		particle:SetColor(col.r, col.g, col.b, col.a)
	end
	
	for i=1,num do
		local particle = emitter:Add(mat, pos)
		
		local dir = Angle(0,math.Rand(-180,180),0):Forward()
		particle:SetVelocity(dir * math.Rand(180,200))
		particle:SetAirResistance(100)
		particle:SetLifeTime(0)
		particle:SetDieTime(math.Rand(0.6,1))
		particle:SetStartSize(width * math.Rand(2,4))
		particle:SetColor(col.r, col.g, col.b, col.a)
	end
	
	local particle = emitter:Add(mat, pos)
	particle:SetDieTime(math.Rand(0.3,0.6))
	particle:SetStartSize(math.Rand(30,60))
	particle:SetColor(col.r, col.g, col.b, col.a)
	
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end
