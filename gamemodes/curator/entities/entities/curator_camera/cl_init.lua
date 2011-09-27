
include('shared.lua')

function ENT:OnRemove()
	
end 

function ENT:Draw()
	self.Entity:DrawModel()
end 

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	if LocalPlayer():GetNWBool("Curator") then
		RunConsoleCommand("CuratorUpdateEnt",self:EntIndex())
	end
end 