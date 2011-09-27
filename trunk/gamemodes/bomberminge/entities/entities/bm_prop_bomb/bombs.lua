BOMBS = {}

function RegisterBomb(path)
	local ENT = {}
	include("bombs/"..path..".lua")
	BOMBS[ENT.ID] = ENT
end

function ENT:InitBomb(id)
	
end