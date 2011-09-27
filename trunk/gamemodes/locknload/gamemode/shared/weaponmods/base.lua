WMOD.Name		= "UNNAMED" -- The name players see.
WMOD.Category	= 1 --Categories. 1: Fire type, 2: Load type, 3: Attachments

function WMOD:IsApplicable (classname)
	return true
end

function WMOD:Apply (wpn)
	local wpntbl = wpn:GetTable()
	if wpntbl.Modifications[self.Codename] then
		wpntbl.Modifications[self.Codename](wpntbl)
	end
end