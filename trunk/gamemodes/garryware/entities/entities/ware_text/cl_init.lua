
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	self.TextColor = Color( 255, 255, 255, 255 )
	if (CLIENT) then
		self.Entity:SetRenderBoundsWS(self.Entity:GetPos()+Vector(-128,-128,-128), self.Entity:GetPos()+Vector(128,128,128))
	end
end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
end


function ENT:SetEntityColor(r,g,b,a)
	self.TextColor = Color(r,g,b,a)
end
