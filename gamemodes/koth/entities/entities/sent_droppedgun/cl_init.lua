include('shared.lua')

function ENT:Initialize()

end

function ENT:Think()
	
end

function ENT:Draw()

	self.Entity:SetMaterial( "" ) //draw normal model
	self.Entity:DrawModel()
	
	self.Entity:SetModelScale( Vector(1.2,1.2,1.2) ) //draw a glow over top
	self.Entity:SetMaterial( "models/props_combine/portalball001_sheet" )
	self.Entity:DrawModel()
	
end

