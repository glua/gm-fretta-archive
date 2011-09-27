function CaptureZoneStatusUpdate (um)
	GAMEMODE.CaptureZoneTeam = um:ReadShort()
	GAMEMODE.CaptureZoneTime = um:ReadFloat()
	GAMEMODE.CaptureZoneStatus = um:ReadShort()
	--print ("Now!", GAMEMODE.CaptureZoneTeam, GAMEMODE.CaptureZoneTime)
end

usermessage.Hook ("lnl_cz", CaptureZoneStatusUpdate)

function CaptureZonePositionUpdate (um)
	GAMEMODE.CaptureZoneOBBMins = um:ReadVector()
	GAMEMODE.CaptureZoneOBBMaxs = um:ReadVector()
	GAMEMODE.CaptureZoneOBBMaxs.z = GAMEMODE.CaptureZoneOBBMins.z
	GAMEMODE.CaptureZoneOBBCenter = (GAMEMODE.CaptureZoneOBBMins + GAMEMODE.CaptureZoneOBBMaxs) * 0.5
	--GAMEMODE.CaptureZoneOBBMins2 = Vector (GAMEMODE.CaptureZoneOBBMins.x, GAMEMODE.CaptureZoneOBBMaxs.y, GAMEMODE.CaptureZoneOBBMins.z)
	--GAMEMODE.CaptureZoneOBBMaxs2 = Vector (GAMEMODE.CaptureZoneOBBMaxs.x, GAMEMODE.CaptureZoneOBBMins.y, GAMEMODE.CaptureZoneOBBMaxs.z)
	--print ("Now!", GAMEMODE.CaptureZoneOBBMins, GAMEMODE.CaptureZoneOBBMaxs)
end

usermessage.Hook ("lnl_cz_pos", CaptureZonePositionUpdate)

local Tex = surface.GetTextureID( "gui/gradient" )
local Mat = Material("lnl/white_notnoz")

function GM:CaptureZoneDraw ()
	if not self.CaptureZoneOBBMins then return end
	
	local col = Color (100,100,100,255)
	if self.CaptureZoneTeam != -1 then
		local tcol = team.GetColor(self.CaptureZoneTeam)
		local fract = self.CaptureZoneTime / self.CaptureZoneTimeRequired
		for k,v in pairs(col) do
			col[k] = col[k] * (1-fract) + tcol[k] * fract
		end
	end
	
	render.SetMaterial( Mat )
	render.DrawQuadEasy( self.CaptureZoneOBBCenter,    --position of the rect
		Vector(0,0,1),        --direction to face in
		self.CaptureZoneOBBMins.y - self.CaptureZoneOBBMaxs.y, self.CaptureZoneOBBMins.x - self.CaptureZoneOBBMaxs.x,              --size of the rect
		col  --color...
                 )
end

local w = ScreenScaleH(60)
local h = ScreenScaleH(14)

--local DownArrowTex = surface.GetTextureID( "lnl/downarrow" )

function GM:CaptureZoneIndicatorDraw ()
	if (not self.CaptureZoneOBBCenter) then return end
	local scrpos = (self.CaptureZoneOBBCenter + Vector (0,0,120)):ToScreen()
	if (scrpos.x < -w/2) or (scrpos.y < -h/2) or (scrpos.x > ScrW() + w/2) or (scrpos.y > ScrH() + h/2) then
		scrpos.x = ScrW() * 0.5
		scrpos.y = ScrH() * 0.08
	else
		if ((self.CaptureZoneStatus or -1) < 0) or (not ValidEntity(self.CaptureZoneDrawHandler)) then
			surface.SetDrawColor (255, 255, 255, 100)
		else
			local tcol = team.GetColor(self.CaptureZoneStatus)
			surface.SetDrawColor (tcol.r, tcol.g, tcol.b, tcol.a)
		end
		--surface.SetTexture (DownArrowTex)
		--surface.DrawTexturedRect (scrpos.x - ScreenScale(16), scrpos.y - ScreenScale(45), ScreenScale(32), ScreenScale(32))
		draw.NoTexture()
		local topleft = Vector (scrpos.x - ScreenScale(6), scrpos.y - ScreenScale(45))
		local LNLarrowVertices = {
			{
				x = topleft.x,
				y = topleft.y + ScreenScale(14)
			},
			{
				x = topleft.x,
				y = topleft.y
			},
			{
				x = topleft.x + ScreenScale(12),
				y = topleft.y
			},
			{
				x = topleft.x + ScreenScale(12),
				y = topleft.y + ScreenScale(14)
			},
			{
				x = topleft.x + ScreenScale(16),
				y = topleft.y + ScreenScale(14)
			},
			{
				x = topleft.x + ScreenScale(6),
				y = topleft.y + ScreenScale(32)
			},
			{
				x = topleft.x + ScreenScale(-4),
				y = topleft.y + ScreenScale(14)
			},
		}
		surface.DrawPoly (LNLarrowVertices)
	end
	if (not ValidEntity(self.CaptureZoneDrawHandler)) then
		local t = math.max (0, math.ceil(GetGlobalFloat ("RoundStartTime", 0) + self.CaptureZoneActivationDelay - CurTime()))
		surface.SetFont ("CV24Scaled")
		local w,h = surface.GetTextSize (t)
		surface.SetTextPos (scrpos.x - w/2, scrpos.y - h/2)
		surface.SetTextColor (255, 255, 255, 100)
		surface.DrawText (t)
	else
		surface.SetDrawColor (100, 100, 100, 100)
		surface.DrawRect (scrpos.x - w/2, scrpos.y - h/2, w, h)
		surface.SetDrawColor (255, 255, 255, 100)
		surface.DrawRect (scrpos.x - 2, scrpos.y - h/2, 4, h)
		if self.CaptureZoneTeam != -1 then
			local tcol = team.GetColor(self.CaptureZoneTeam)
			surface.SetDrawColor (tcol.r, tcol.g, tcol.b, tcol.a)
			if self.CaptureZoneTeam == 1 then
				surface.DrawRect (scrpos.x+2, scrpos.y - (h/2), ((w/2)-2) * self.CaptureZoneTime / self.CaptureZoneTimeRequired, h)
			else
				surface.DrawRect (scrpos.x-2 - ((w/2)-2) * self.CaptureZoneTime / self.CaptureZoneTimeRequired, scrpos.y - (h/2), ((w/2)-2) * self.CaptureZoneTime / self.CaptureZoneTimeRequired, h)
			end
		end
	end
end

GM:AddHook ("HUDPaint", "CaptureZoneIndicatorDraw")