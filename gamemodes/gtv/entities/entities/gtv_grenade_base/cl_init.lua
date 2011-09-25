ENT.Author = "Ghor"
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Created = 0
ENT.LifeTime = 3
ENT.Model = "models/Items/grenadeAmmo.mdl"

function ENT:Initialize()
	local ang = self:GetAngles()
	//self:SetAngles(Angle(0,0,0))
	self.Created = CurTime()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	//self:SetAngles(ang)
end

function ENT:Think()
end

local tracep = {}
tracep.mask = MASK_SOLID
local VecDown = Vector(0,0,-100)
local circlemat = Material("gtv/circle")
local colvec = Vector(1,1,1)

function ENT:DoDrawShadow()
	tracep.start = self:GetPos()
	tracep.endpos = self:GetPos()+VecDown
	tracep.filter = self
	local tr = util.TraceLine(tracep)
	if tr.Hit then
		//print("drawing shadow")
		local col = list.GetForEdit("PlayerColours")[self:GetOwner():GetNWString("pl_color")]||color_white
		colvec.r = col.r/255
		colvec.g = col.g/255
		colvec.b = col.b/255
		circlemat:SetMaterialVector("$color",colvec)
		render.SetMaterial(circlemat)
		
		//render.SetColorModulation(col.r/255,col.g/255,col.b/255)
		render.SetBlend(0.5)
		local frac = 1-tr.Fraction
		render.DrawQuadEasy(tr.HitPos,tr.HitNormal,32*frac,32*frac,color_white,0)
		//render.SetColorModulation(1,1,1)
		render.SetBlend(1)
	end
end

function ENT:Draw()
	self:DoDrawShadow()
	self:DrawModel()
end