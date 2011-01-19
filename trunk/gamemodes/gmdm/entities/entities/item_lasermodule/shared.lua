ENT.Type = "anim"

function ENT:GetEndPos( )

	// Is the laser touching?
	local trace = {}
	trace.start = self:GetPos()
	trace.endpos = self:GetPos()+(self:GetAngles()*1024)
	trace.filter = { self, self:GetOwner(), self:GetOwner():GetActiveWeapon(), self:GetOwner():GetViewModel() }
	
	local tr = util.TraceLine( trace )
	
	if( tr and tr.HitPos ) then
		return tr.HitPos;
	end
	
	return self:GetPos();
	
end