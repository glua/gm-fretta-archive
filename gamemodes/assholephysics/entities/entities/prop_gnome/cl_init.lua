
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

language.Add( "prop_gnome", "Gnome" )

function ENT:Initialize()

end

function ENT:Draw()

	self.Entity:DrawModel()

end
	