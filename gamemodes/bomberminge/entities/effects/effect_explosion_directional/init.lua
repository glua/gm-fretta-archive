
EXPLO_DAMPING = 880
EXPLO_VELOCITY_MULTIPLIER = 22
EXPLO_NUM_FULLSPEED_PARTICLES = 1

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local mag = data:GetAttachment()
	local dir = data:GetStart()
	
	local emitter = ParticleEmitter(pos)
	
	local dist = dir:Length()
	local num = math.ceil(dist / 5)
	local num2 = num - EXPLO_NUM_FULLSPEED_PARTICLES
	local col
	if mag==3 then
		col = Color(255,50,20,255)
	elseif mag==2 then
		col = Color(20,100,255,255)
	else
		col = Color(255,255,255,255)
	end
	
	for i=1,num do
		local vel
		if i<=num2 then
			local min, max = (i-1) * EXPLO_VELOCITY_MULTIPLIER/num2, i * EXPLO_VELOCITY_MULTIPLIER/num2
			vel = math.Rand(min, max)
		else
			-- there should be at least one particle released at full speed, so players can see the actual range of the explosion
			vel = EXPLO_VELOCITY_MULTIPLIER
		end
		
		local particle = emitter:Add("effects/fire_cloud"..math.random(1,2), pos + Angle(math.Rand(-90,90),math.Rand(-180,180),0):Forward() * math.Rand(5,10))
		particle:SetGravity(Vector(0,0,600))
		particle:SetVelocity(dir * vel)
		particle:SetAirResistance(EXPLO_DAMPING)
		particle:SetDieTime(math.Rand(0.4,1))
		particle:SetStartSize(math.Rand(10,20))
		particle:SetEndSize(math.Rand(20,40))
		particle:SetRoll(math.Rand(150,180))
		particle:SetRollDelta(0.6*math.random(-1,1))
		particle:SetColor(col.r,col.g,col.b,col.a)
		particle:SetEndAlpha(0)
	end
	
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end
