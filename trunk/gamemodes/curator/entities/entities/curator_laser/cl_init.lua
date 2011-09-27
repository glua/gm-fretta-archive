
include('shared.lua')

local bMat = Material( "cable/redlaser" )
local Red = Color( 255, 0, 0, 255 )

function ENT:OnRemove()
	
end 

function ENT:Draw()
	self.Entity:DrawModel()
	if self:GetNWBool("Active") then
		render.SetMaterial(bMat)
		local tr = util.QuickTrace(self:GetPos(),self:GetAngles():Up()*500,self,MASK_SOLID_BRUSHONLY)
		self:SetRenderBoundsWS(self:GetPos(),tr.HitPos)
		render.DrawBeam( self:GetPos(), tr.HitPos, 5, 0, 0, Red )
		debugoverlay.Line( self:GetPos(), tr.HitPos)
	end
end 

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	if LocalPlayer():GetNWBool("Curator") then
		RunConsoleCommand("CuratorUpdateEnt",self:EntIndex())
	end
	
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON) -- to replace ShouldCollide
end 