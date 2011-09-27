
include('shared.lua')

local bMat = Material( "cable/redlaser" )
local Red = Color( 255, 0, 0, 255 )

function ENT:OnRemove()
	
end 

local down = Vector(0,0,-1)

function ENT:Draw()
	self.Entity:DrawModel()
	if self:GetNWBool("Active") then
		render.SetMaterial(bMat)
		--local tr = util.QuickTrace(self:GetPos(),self:GetAngles():Up()*700,self,MASK_SOLID_BRUSHONLY)
		--self:SetRenderBoundsWS(self:GetPos(),tr.HitPos)
		--render.DrawBeam( self:GetPos(), tr.HitPos, 5, 0, 0, Red )
		--debugoverlay.Line( self:GetPos(), tr.HitPos)
		local tr = {}
		local numtra = 6
		local dist = self:BoundingRadius()*2
		local DistInc = dist/numtra
		local longest = 0
		for i=math.floor(numtra/-2)+2,math.floor(numtra/2)+2 do
			local start = self:GetPos()+(self:GetAngles():Up()*i*DistInc)
			tr[i] = util.QuickTraceHull(start,self:GetAngles():Right()*1500,self:OBBMins()/numtra,self:OBBMaxs()/numtra,{self},MASK_SOLID_BRUSHONLY) --convoluted shit here. All for the sake of resolution.
			render.DrawBeam( start, tr[i].HitPos, 5, 0, 0, Red )
			debugoverlay.Line( start, tr[i].HitPos)
			debugoverlay.Cross(start,20)
			if tr[i].HitPos:Distance(tr[i].StartPos) >= longest then
				longest = i
			end
		end
		self:SetRenderBoundsWS(self:GetPos(),tr[#tr].HitPos)
	end
end 

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	if LocalPlayer():GetNWBool("Curator") then
		RunConsoleCommand("CuratorUpdateEnt",self:EntIndex())
	end
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON) -- to replace ShouldCollide
end 