
function GM:CorrectBeam(a, b)
	if(!IsValid(a) or !IsValid(b)) then
		return
	end
	
	local v1, v2 = a:GetPos(), b:GetPos()
	local trace = util.TraceLine({start=v1, endpos=v2})
	
	if trace.StartSolid then
		local npos = v1 + ((v2 - v1) * (trace.FractionLeftSolid + 0.005) )
		a:SetPos(npos)
	end
end

function GM:CorrectLasers()
	for k,v in ipairs(ents.FindByClass("env_laser")) do
		local e = v:GetKeyValues()
		
		local name = e["LaserTarget"]
		local endent = ents.FindByName(name)[1]
		
		self:CorrectBeam(v, endent)
	end
	
	for k,v in ipairs(ents.FindByClass("env_beam")) do
		local e = v:GetKeyValues()
		
		local sname = e["LightningStart"]
		local ename = e["LightningEnd"]
		
		local sent = ents.FindByName(sname)[1]
		local eent = ents.FindByName(ename)[1]
		
		self:CorrectBeam(sent, eent)
	end
end
