EFFECT.v_baseheight = Vector(0,0,36)

function EFFECT:Init(data)
	self.Created = CurTime()
	local pl = data:GetEntity()
	//self:SetPos(pl:GetPos()+self.v_baseheight)
	if pl:GetRagdollEntity() && pl:GetRagdollEntity():IsValid() then
		pl:GetRagdollEntity():Remove()
	end
	local vel = data:GetStart()

		local edata = EffectData()
		edata:SetScale(GIB_HEAD)
		edata:SetOrigin(self:GetPos()+VectorRand()*32)
		edata:SetStart(VectorRand()*500+vel)
		util.Effect("ef_giblet",edata)
		edata:SetScale(GIB_CHUNK)
		edata:SetOrigin(self:GetPos()+VectorRand()*32)
		edata:SetStart(VectorRand()*500+vel)
		util.Effect("ef_giblet",edata)
		edata:SetScale(GIB_LIMB)
		edata:SetOrigin(self:GetPos()+VectorRand()*32)
		edata:SetStart(VectorRand()*500+vel)
		util.Effect("ef_giblet",edata)
		edata:SetOrigin(self:GetPos()+VectorRand()*32)
		edata:SetStart(VectorRand()*500+vel)
		util.Effect("ef_giblet",edata)
		edata:SetOrigin(self:GetPos()+VectorRand()*32)
		edata:SetStart(VectorRand()*500+vel)
		util.Effect("ef_giblet",edata)
		edata:SetOrigin(self:GetPos()+VectorRand()*32)
		edata:SetStart(VectorRand()*500+vel)
		util.Effect("ef_giblet",edata)
		edata:SetScale(GIB_SQUISHY)
		edata:SetOrigin(self:GetPos()+VectorRand()*32)
		edata:SetStart(VectorRand()*500+vel)
		util.Effect("ef_giblet",edata)
		edata:SetOrigin(self:GetPos()+VectorRand()*32)
		edata:SetStart(VectorRand()*500+vel)
		util.Effect("ef_giblet",edata)
		edata:SetOrigin(self:GetPos()+VectorRand()*32)
		edata:SetStart(VectorRand()*500+vel)
		util.Effect("ef_giblet",edata)

end


function EFFECT:Think()
	if (CurTime()-self.Created) > 10 then
		return false
	else
		return true
	end
end

function EFFECT:Render()
return true
end