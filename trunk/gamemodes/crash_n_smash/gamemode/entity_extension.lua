
local meta = FindMetaTable( "Entity" )
if (!meta) then return end 

// On what team's territory is this entity located?
function meta:TeamSide()

	if not ValidEntity(self) then return nil end
	return GAMEMODE:TeamSide(self:GetPos())

end

function meta:HitTeamBoundary()

end