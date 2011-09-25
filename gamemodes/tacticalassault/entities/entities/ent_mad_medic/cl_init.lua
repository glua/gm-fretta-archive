include("shared.lua")

language.Add("ent_mad_medic", "Medic Kit")

/*---------------------------------------------------------
   Name: ENT:Draw()
---------------------------------------------------------*/
function ENT:Draw()

	self.Entity:DrawModel() 
end