
_E.GIB_HEAD		= 0
_E.GIB_LIMB		= 1  
_E.GIB_CHUNK	= 2
_E.GIB_ORGAN	= 3 
_E.GIB_SQUISHY	= 4

gtv_gibs = {
	[GIB_HEAD]		= "models/Gibs/HGIBS.mdl",
	[GIB_LIMB]		= "models/Gibs/Antlion_gib_medium_2.mdl",
	[GIB_CHUNK]		= "models/Gibs/Antlion_gib_Large_1.mdl",
	[GIB_ORGAN]		= "models/Gibs/Antlion_gib_medium_1.mdl",
	[GIB_SQUISHY]	= "models/props_junk/watermelon01_chunk02a.mdl"
}

EFFECT.v_grav = Vector(0,0,-96)
function EFFECT:Init(data)
	self.em = ParticleEmitter(self:GetPos())
	self:SetModel(gtv_gibs[data:GetScale()])
	self.Created = CurTime()
	self:SetMaterial("models/flesh")
	--models/Zombie_Fast/fast_zombie_sheet
	//self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		self:GetPhysicsObject():SetVelocity(data:GetStart())
	end
	self.lastthink = CurTime()
end

function EFFECT:Think()
	if (CurTime()-self.Created) > 10 then
		return false
	else
		local phys = self.Entity:GetPhysicsObject()
		if (CurTime()-self.Created < 3) && phys:IsValid() then
			local vel =  phys:GetVelocity():Length()
			if vel > 50 then
				//local ef = EffectData()
				//ef:SetOrigin(self:GetPos())
				//util.Effect("BloodImpact",ef)
				local part = self.em:Add("effects/blood2",self:GetPos())
				local size = math.sqrt(vel/10)
				if part then
					part:SetColor(90,0,0)
					part:SetDieTime(size/10)
					part:SetStartSize(size)
					part:SetEndSize(2)
					part:SetStartAlpha(255)
					part:SetEndAlpha(0)
					part:SetGravity(self.v_grav)
				end
				self.em:Finish()
				local trace = {}
				trace.start = self:GetPos()
				trace.endpos = self:GetPos()+self:GetVelocity()*(CurTime()-self.lastthink)
				trace.filter = self
				local tr = util.TraceLine(trace)
				if tr.Hit then
					util.Decal("Blood",tr.HitPos+tr.HitNormal,tr.HitPos-tr.HitNormal)
				end
			end
		end
		self.lastthink = CurTime()
		return true
	end
end

function EFFECT:Render()
	self:DrawModel()
return true
end