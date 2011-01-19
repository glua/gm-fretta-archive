
include('shared.lua')

local matFlare = Material("effects/blueflare1")

/*---------------------------------------------------------
   Name: init
---------------------------------------------------------*/
function ENT:Initialize()
	
	self.PixVis = util.GetPixelVisibleHandle()
	
end

/*---------------------------------------------------------
   Name: draw
---------------------------------------------------------*/
function ENT:Draw()
	//self.Entity:DrawModel()
	render.SetMaterial( matFlare )
	local size = math.random(12,15)
	render.DrawSprite( self.Entity:GetPos(), size, size, Color(250, 230, 200, 250) ) 
end

