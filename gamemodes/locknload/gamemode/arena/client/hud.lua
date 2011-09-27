function LNLRoundStart ()
	GAMEMODE.RoundStartTime = CurTime()
end

usermessage.Hook ("lnl_roundstart", LNLRoundStart)

local enemy = {
	[TEAM_RED] = TEAM_BLUE,
	[TEAM_BLUE] = TEAM_RED
}

function GM:DrawRoundStartMessage ()
	if (self.RoundStartTime or -8) - CurTime() < -8 then return end
	if self.LoadoutMenu1 and self.LoadoutMenu1:IsVisible() then --keep it alive while they are still loading out
		self.RoundStartTime = CurTime()
		return
	end
	local alpha = 255 + math.min(0,(self.RoundStartTime + 6 - CurTime()) * 126.25)
	local pos = Vector (ScrW() * 0.5, ScrH() * 0.35)
	surface.SetFont ("CV24Scaled")
	local txt = "You are on "..team.GetName(LocalPlayer():Team())
	local w,h = surface.GetTextSize (txt)
	x = pos.x - w / 2
	y = pos.y - h / 2
	surface.SetTextPos (x, y)
	surface.SetTextColor (255,255,255,alpha)
	surface.DrawText ("You are on ")
	local col = team.GetColor(LocalPlayer():Team())
	surface.SetTextColor (col.r, col.g, col.b, alpha)
	surface.SetFont ("CV24ScaledNonAA")
	surface.DrawText (string.upper(team.GetName(LocalPlayer():Team())))
	txt = "Kill "..string.upper(team.GetName(enemy[LocalPlayer():Team()]))
	w = surface.GetTextSize (txt)
	x = pos.x - w / 2
	y = y + h
	surface.SetTextPos (x, y)
	surface.SetTextColor (255,255,255,alpha)
	surface.SetFont ("CV24Scaled")
	surface.DrawText ("Kill ")
	col = team.GetColor(enemy[LocalPlayer():Team()])
	surface.SetTextColor (col.r, col.g, col.b, alpha)
	surface.SetFont ("CV24ScaledNonAA")
	surface.DrawText (string.upper(team.GetName(enemy[LocalPlayer():Team()])))
	txt = "Or capture the middle zone"
	w = surface.GetTextSize (txt)
	x = pos.x - w / 2
	y = y + h
	surface.SetTextPos (x, y)
	surface.SetTextColor (255,255,255,alpha)
	surface.SetFont ("CV24Scaled")
	surface.DrawText (txt)
end

GM:AddHook ("HUDPaint", "DrawRoundStartMessage")