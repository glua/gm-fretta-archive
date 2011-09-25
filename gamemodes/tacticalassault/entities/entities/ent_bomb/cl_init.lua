include('shared.lua')

function ENT:Initialize()
	
	hook.Add("HUDPaint",self.Entity:EntIndex(),function()
		if !self.Entity or !self.Entity:IsValid() then return end
		local d = self.Entity:GetNWInt("ta_defuse")
		if self.Entity:GetNWEntity("ta_defuser") == LocalPlayer() and d != 50 and LocalPlayer():KeyDown(IN_USE) then
			draw.RoundedBox(0,ScrW() / 2 - 100,300,200,30,color_black)
			draw.RoundedBox(0,ScrW() / 2 - 98,302,196 * d / 50,26,color_white)
		end
	end)
	
end


function ENT:Draw()

	self:DrawModel()
	
end
