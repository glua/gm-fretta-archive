local Mat = Material("effects/emp_ring")

local AVec = Vector(99999, 99999, 99999)

function EFFECT:Init(efdata)
	self.Length = efdata:GetMagnitude()
	self.End = CurTime()+self.Length
	self.Start = CurTime()
	self.Size = efdata:GetScale()
	self.Pos = efdata:GetOrigin()
	self.Entity:SetPos(self.Pos)
	self.Elapsed = 0
	
	self.RandVecs = {}
	for i=1,7 do
		self.RandVecs[i] = VectorRand()
	end
	
	self.Entity:SetRenderBounds(AVec*-1,AVec)
end 

function EFFECT:Think()
	return (CurTime() < self.End)
end 

--[[
 ---Blue Uns---

sprites/strider_blackball
sprites/bluelight
sprites/physring1
sprites/physcannon_bluecore1b
sprites/physcannon_bluecore2b

---Other Uns---

sprites/flare1
sprites/glow01
sprites/orangecore1
sprites/glow
sprites/halo
]]
local TehCol = Color(255,255,255,255)
function EFFECT:Render()
	self.Elapsed = CurTime()-self.Start
	render.SetMaterial(Mat)
	local frac = self.Elapsed/self.Length
	TehCol.a=255*(1-(frac))
	local size = self.Size*(frac)
	for i=1,7 do
		local vec = self.RandVecs[i]
		render.DrawQuadEasy( self.Pos,
		vec,
		size, size,
		TehCol
		)
		
		render.DrawQuadEasy( self.Pos,
		vec*-1,
		size, size,
		TehCol
		)
	end
end 