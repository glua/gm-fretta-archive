include('shared.lua')

function ENT:Initialize()
	
	hook.Add("HUDPaint",self:EntIndex().."HUD",function()
		local vehic = LocalPlayer():GetVehicle()
		if !LocalPlayer():Alive() || !ValidEntity(vehic) || vehic:GetClass() != "prop_vehicle_jeep" then return end
		
		local hp = self:GetNWInt("ta-health")
		local max = 1000
		local val = 255 * ( hp / max )
		local col = Color( 255 - val,val,0)
		draw.TexturedQuad({
			texture=surface.GetTextureID("ta/ta-jeep"),
			color=col,
			x= ScrW() - 350,
			y=ScrH() - 120,
			w = 100,
			h=100,
			})
		
	end)
	/*hook.Add("RenderScreenspaceEffects","JKLFJKDLS",function()
		debugoverlay.Cross(self:GetPos() + self:GetForward() * 15 + self:GetRight() * 29+ self:GetUp() *30,15,0.1,color_white,true)
	end)*/
end

function ENT:OnRemove()
	hook.Remove("HUDPaint",self:EntIndex().."HUD")
end

function ENT:Draw()
	self.Entity:DrawModel()
end

