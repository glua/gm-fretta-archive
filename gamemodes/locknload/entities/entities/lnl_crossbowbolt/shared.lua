ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

function ENT:UpdateColor ()
	self.Color = Color (255, 255, 255, 255)
	local ltr = self.Entity:GetNWString ("fm")
	if ltr == "e" then
		self.Color = Color (255,100,100,255)
	elseif ltr == "r" then
		self.Color = Color (255,255,100,255)
	elseif ltr == "a" then
		self.Color = Color (100,100,255,255)
	end
end