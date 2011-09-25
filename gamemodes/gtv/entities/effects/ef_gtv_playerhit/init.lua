local refang = Angle(0,0,0)

function EFFECT:Init(data)
	self.Created = CurTime()
	self.Owner = data:GetEntity()
	self:EmitSound("ambient/machines/steam_release_1.wav",40,255)
	//ParticleEffect("gtv_smokeburst",self:GetPos(),refang,self.Owner)
end

function EFFECT:Think()
	if self.Created+0.04 < CurTime() then
		return false
	end
	return true
end

local dmgmat = Material("models/shiny")

function EFFECT:Render()
	if !self.Owner:IsValid() then
		return false
	end
	SetMaterialOverride(dmgmat)
	render.SetColorModulation(1000,1000,1000)
	render.SuppressEngineLighting(true)
		self.Owner:DrawModel()
	render.SuppressEngineLighting(false)
	render.SetColorModulation(1,1,1)
	SetMaterialOverride()
	return true
end