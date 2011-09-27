
ViewFOV = 110
ViewDistance = 400
local bm_viewangles = CreateClientConVar("bm_viewangles", 60)

-- All of this is easily hackable on a non script enforced server, but who cares... it's not game breaking at all
function GM:PlayerBindPress(pl, bind, down)
	if self.BaseClass:PlayerBindPress(pl, bind, down) then return true end
	
	if bind=="invprev" then
		ViewFOV = math.Clamp(ViewFOV - 5, 40,130)
		return true
	elseif bind=="invnext" then
		ViewFOV = math.Clamp(ViewFOV + 5, 40,130)
		return true
	elseif bind=="+jump" then -- anyway, you can't jump, the Move hook prevents you from doing it
		return true
	end
end

function GM:CalcView(pl, pos, ang, fov)
	if pl:GetNWBool("FPSMode") then
		return self.BaseClass:CalcView(pl, pos, ang, fov)
	end
	
	local target = pl
	if pl:GetObserverMode()==OBS_MODE_CHASE then
		local p = pl:GetObserverTarget()
		if ValidEntity(p) then
			target = p
		end
	end
	
	local ang = Angle(RotateCameraPitch or bm_viewangles:GetFloat(),0,0)
	local dir = ang:Forward()
	local startpos = target:GetPos()
	local endpos = startpos - dir * ViewDistance
	startpos.z = endpos.z
	
	local tr = util.TraceLine{
		start = startpos,
		endpos = endpos,
		mask = MASK_SOLID_BRUSHONLY
	}
	
	local hitpos = tr.HitPos
	hitpos.x = hitpos.x + 8
	
	pl.TargetView = {
		angles = (target:GetPos() - hitpos):Angle(),
		origin = hitpos,
		fov = ViewFOV
	}
	
	if pl.CurrentView then
		-- Perform a smooth transition if the view settings change too quickly
		pl.CurrentView.angles = LerpAngle(0.2, pl.CurrentView.angles, pl.TargetView.angles)
		pl.CurrentView.origin = LerpVector(0.2, pl.CurrentView.origin, pl.TargetView.origin)
		pl.CurrentView.fov = Lerp(0.2, pl.CurrentView.fov, pl.TargetView.fov)
	else
		pl.CurrentView = {
			angles = pl.TargetView.angles,
			origin = pl.TargetView.origin,
			fov = pl.TargetView.fov
		}
	end
	
	return pl.CurrentView
end

function GM:CreateMove(ucmd)
	if LocalPlayer():GetNWBool("FPSMode") then return end
	
	if LocalPlayer().ViewAngles then
		ucmd:SetViewAngles(LocalPlayer().ViewAngles)
	end
end
