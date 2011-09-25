include("shared.lua")

language.Add("ent_mad_mine", "Mine")

/*---------------------------------------------------------
   Name: ENT:Initialize()
---------------------------------------------------------*/
function ENT:Initialize()
 
	self.Owner = self.Entity:GetDTEntity(0)
	self.Alpha = 255
end

/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()

	if self.Entity:GetDTBool(0) then
		if (LocalPlayer() == self.Owner) then // or (LocalPlayer():Team() == self.Owner:Team()) then
			self.Alpha = math.Approach(self.Alpha, 100, 5)
		else
			self.Alpha = math.Approach(self.Alpha, 1, 5)
		end
	else
		self.Alpha = math.Approach(self.Alpha, 255, 5)
	end

	self.Entity:SetColor(255, 255, 255, self.Alpha)
	self.Entity:DrawModel()
end