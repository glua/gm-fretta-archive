ENT.Type 		= "anim"
ENT.PrintName	= "Land Mine"
ENT.Author		= "Worshipper"
ENT.Contact		= "Josephcadieux@hotmail.com"
ENT.Purpose		= ""
ENT.Instructions	= ""

/*---------------------------------------------------------
   Name: ENT:SetupDataTables()
   Desc: Setup the data tables.
---------------------------------------------------------*/
function ENT:SetupDataTables()  

	self:DTVar("Boal", 0, "Activated")
	self:DTVar("Entity", 0, "Owner")
end 