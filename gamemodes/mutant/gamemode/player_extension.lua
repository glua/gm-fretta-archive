local meta = FindMetaTable( "Player" )
if (!meta) then return end

function meta:IsMutant()
	return (self:GetPlayerClassName() == "Mutant")
end

function meta:IsBottomFeeder()
	local lowest = true
	for _, pl in pairs(player.GetAll()) do
		if pl ~= self and pl:Frags() <= self:Frags() then lowest = false end
	end
	return lowest
end
