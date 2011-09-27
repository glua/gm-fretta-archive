ENT.Type 			= "ai"
ENT.Base 			= "base_ai"
ENT.PrintName		= "Thief Shop"
ENT.Author			= "Levybreak"
ENT.Contact 		= "Facepunch"
ENT.Purpose			= ""
ENT.Instructions	= "Use it." 
ENT.AutomaticFrameAdvance = true 

function ENT:Think()
	self:NextThink(CurTime())
	return true
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
 
	self.AutomaticFrameAdvance = bUsingAnim
 
end