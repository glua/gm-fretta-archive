
include('shared.lua')

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

function ENT:Draw()
	
end

local function DrawBox(pos, mins, maxs, F, R, U)
	local bld = (pos + mins.x*F + mins.y*R + mins.z*U):ToScreen()
	local brd = (pos + mins.x*F + maxs.y*R + mins.z*U):ToScreen()
	local frd = (pos + maxs.x*F + maxs.y*R + mins.z*U):ToScreen()
	local fld = (pos + maxs.x*F + mins.y*R + mins.z*U):ToScreen()
	local blu = (pos + mins.x*F + mins.y*R + maxs.z*U):ToScreen()
	local bru = (pos + mins.x*F + maxs.y*R + maxs.z*U):ToScreen()
	local fru = (pos + maxs.x*F + maxs.y*R + maxs.z*U):ToScreen()
	local flu = (pos + maxs.x*F + mins.y*R + maxs.z*U):ToScreen()
	
	surface.DrawLine(bld.x, bld.y, brd.x, brd.y)
	surface.DrawLine(brd.x, brd.y, frd.x, frd.y)
	surface.DrawLine(frd.x, frd.y, fld.x, fld.y)
	surface.DrawLine(fld.x, fld.y, bld.x, bld.y)
	
	surface.DrawLine(blu.x, blu.y, bru.x, bru.y)
	surface.DrawLine(bru.x, bru.y, fru.x, fru.y)
	surface.DrawLine(fru.x, fru.y, flu.x, flu.y)
	surface.DrawLine(flu.x, flu.y, blu.x, blu.y)
	
	surface.DrawLine(blu.x, blu.y, bld.x, bld.y)
	surface.DrawLine(bru.x, bru.y, brd.x, brd.y)
	surface.DrawLine(flu.x, flu.y, fld.x, fld.y)
	surface.DrawLine(fru.x, fru.y, frd.x, frd.y)
end

hook.Add("HUDPaint", "WARE_TRIGGER_DEBUG", function()
	if not GetConVar("ware_debug") or GetConVar("ware_debug"):GetInt() ~= 1 then
		return
	end
	
	for _,v in pairs(ents.FindByClass("ware_trigger")) do
		local mins = v:GetNetworkedVector("mins")
		local maxs = v:GetNetworkedVector("maxs")
		local vmax = v:GetNetworkedVector("vmax")
		
		if mins and maxs then
			
			local pos = v:GetPos()
			
			local F = v:GetForward()
			local R = v:GetRight()
			local U = v:GetUp()
			
			surface.SetDrawColor(255, 255, 0, 255)
			DrawBox(pos, mins, maxs, F, R, U)
			
			if vmax then
				surface.SetDrawColor(255, 0, 0, 255)
				DrawBox(pos, (-1)*vmax, vmax, Vector(1,0,0), Vector(0,1,0), Vector(0,0,1))
			end
		end
	end
end)