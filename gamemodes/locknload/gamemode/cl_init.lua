-- For easy fonts!
local created = {}
function Font(base, size, weight, antialiasing, italic)
	weight = weight or 400
	if antialiasing == nil then antialiasing = true end
	if italic == nil then italic = false end
	
	local aa = {[true] = "AA", [false] = ""}
	local it = {[true] = "I", [false] = ""}
	
	local name = base .. "." .. size .. "." .. weight .. aa[antialiasing] .. it[italic]
	if !created[name] then
		surface.CreateFont(base, size, weight, antialiasing, italic, name)
		created[name] = true
	end
	
	return name
end

include("shared.lua")