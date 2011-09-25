
function UTIL_GetTotalCacti()
	return table.Count(ents.FindByClass("cactus")) - UTIL_GetTotalType("golden")
end

function UTIL_GetTotalType(strType)
	local cacti = ents.FindByClass("cactus")
	local numCacti = table.Count(cacti)
	local numCactiType = 0
	for k,v in pairs(cacti) do
		if v:GetCactusType() == strType then
			numCactiType = numCactiType+1
		end
	end
	return numCactiType
end

function UTIL_GetValidCactus()
	
	if UTIL_GetTotalCacti() >= GetGlobalInt("maxcacti") then return end
	
	local curType = table.Random(types)
	local ctypes = {}
	for k,v in pairs(types) do
		if UTIL_GetTotalType(v)<GetGlobalInt("max"..v) then
			table.insert(ctypes,v)
		end
	end
	return table.Random(ctypes)
	
end
