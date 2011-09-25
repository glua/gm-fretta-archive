AddCSLuaFile("init.lua")
EFFECT.sprites = {"effects/fire_embers1","effects/fire_embers2","effects/fire_embers3","effects/fire_cloud1","effects/fire_cloud2"}
EFFECT.Base = "ef_base_onoff"
EFFECT.RBmin = Vector(-16,-16,-16)
EFFECT.RBmax = Vector(16,16,16)
EFFECT.shoulddie = false

function EFFECT:Init(data)

	self.Created = CurTime()
	if effects_onoff[data:GetScale()] && effects_onoff[data:GetScale()]:IsValid() then
		effects_onoff[data:GetScale()].shoulddie = true
	end 
	effects_onoff[data:GetScale()] = self
	//self.em = ParticleEmitter(self:GetPos())
	self.Weapon = data:GetEntity()
	if self.Weapon:IsWeapon() then
		self.Owner = self.Weapon.Owner
	else
		self.Owner = self.Weapon
	end
	if !self.Weapon || !self.Weapon:IsValid() then
		self.shoulddie = true
		return false
	end
	self:SetPos(self.Owner:GetShootPos())
	self.Owner:EmitSound("ambient/fire/ignite.wav")
	self.sound = CreateSound(self.Owner,"ambient/fire/fire_med_loop1.wav")
	self.sound:Play()
	self.dlight = DynamicLight(0)
		self.dlight.Pos = self:GetPos()
		self.dlight.r = 255
		self.dlight.g = 200
		self.dlight.b = 150
		self.dlight.Brightness = 3
		self.dlight.Size = 500
		self.dlight.Decay = 500
		self.dlight.DieTime = CurTime() + 1
		self.shootpos = self:GetTracerShootPos(self.Owner:GetShootPos(),self.Weapon,1)	
	//ParticleEffectAttach("gtv_flamethrower",PATTACH_ABSORIGIN_FOLLOW,self,0) --I had a really nice particle effect for this but it didn't obey the angles for anyone but the local player
	self.em = ParticleEmitter(self:GetPos()) 
end

function EFFECT.partthink(part)
	local tr
		part.tracep.start = part.lastpos
		part.tracep.mask = MASK_SHOT
		part.tracep.endpos = part.lastpos+part:GetVelocity()*(CurTime()-part.lastmove)
		tr = util.TraceLine(part.tracep)	
	part.lastmove = CurTime()
	part.lastpos = part:GetPos()
	if tr.Hit && !part.nodecal then
		//util.Decal("scorch",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
		part:SetVelocity(vector_origin)
		part:SetEndSize(48)
		part:SetEndAlpha(0)
		part:SetPos(part:GetPos()+tr.HitNormal*12)
	end
	part:SetNextThink(CurTime()+0.1)
end

function EFFECT:Think()
	if self.dlight then
		self.dlight.Pos = self:GetPos()
		self.dlight.Brightness = 3
		self.dlight.Size = 500
		self.dlight.DieTime = CurTime() + 1
	end
	local pos = self.shootpos
	if self.shoulddie || !self.Weapon:IsValid() then
		self.sound:Stop()
		return false
	end
		for i=1,3 do
		local part
		if (self:WaterLevel() < 2) then
			part = self.em:Add(self.sprites[math.random(1,5)],self.Owner:GetShootPos())
			self.sound:Play()
		else
			part = self.em:Add("effects/bubble",pos)
			part.nodecal = true
			self.sound:Stop()
		end
		if part then
			local velscale = math.Rand(1,2*i)
			part:SetVelocity(self.Owner:GetAimVector()*200*velscale+self.Owner:GetVelocity())
			part:SetDieTime(1/velscale)
			part:SetStartSize(2)
			part:SetEndSize(8+math.random(0,16))
			part:SetStartAlpha(255)
			part:SetEndAlpha(20)
			part:SetGravity(Vector(0,0,math.random(0,96/((2*i)*velscale))))
			part:SetRoll(math.Rand(0,6.28))
			part:SetRollDelta(math.Rand(-6.28,6.28))
			part:SetThinkFunction(self.partthink)
			part.lastpos = part:GetPos()
			part.lastmove = CurTime()
			part.tracep = {}
			part.tracep.filter = self.Owner
			part:SetNextThink(CurTime()+0.1)
		end
	end
	//self:SetAngles(self.Owner:GetAngles()+angoffset)
	//self.shootpos = self.Owner:GetShootPos()
	//self:SetPos(self.shootpos)
	return true
end
angoffset=  Angle(0,0,0)
function EFFECT:Render()

end