function ScreenScaleH( size )
	return size * ( ScrH() / 400.0 )	
end

local dontdraw = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true
}

function GM:HUDShouldDraw (name)
	return not dontdraw[name]
end

function GM:HUDPaint ()
	self:OnHUDPaint()
	self:RefreshHUD()
	
	local tmcolr = team.GetColor (LocalPlayer():Team())
	
	self:DrawAmmo()
	self:DrawHealth()
	self:DrawTargetID()
end

function GM:DrawAmmo ()
	--why did I do this all without VGUI? I DON'T KNOW. But it's awesome.
	if not self.TwitchAimConvar then
		self.TwitchAimConvar = GetConVar ("lnl_zoom_twitchaiming")
	end
	local wpnent = LocalPlayer():GetActiveWeapon()
	if type(wpnent) != "number" and ValidEntity (wpnent) and wpnent:GetTable().AmmoDrawValues then
		wpn = wpnent:GetTable()
		local Values = wpn.AmmoDrawValues
		if not Values.Scaled then
			for k,v in pairs (Values) do
				if k != "UnitsPerRow" then
					Values[k] = math.Round (ScreenScaleH (v/2))
				end
			end
			Values.Scaled = true
		end
		local PixelWidth = Values.UnitWidth * Values.UnitsPerRow + Values.UnitWidthGap * (Values.UnitsPerRow-1)
		local ClipSize = wpn.Primary.ClipSize
		local LoadedUnits = wpn.Weapon:Clip1()
		local Rows = math.ceil(ClipSize / Values.UnitsPerRow)
		
		local centrePt = Vector (ScrW() * 0.5, ScrH() * 0.5)
		if self.TwitchAimConvar:GetBool() then
			local hitpos = util.TraceLine ({
				start = LocalPlayer():GetShootPos(),
				endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 4096,
				filter = LocalPlayer(),
				mask = MASK_SHOT
			}).HitPos
			local scrpos = hitpos:ToScreen()
			centrePt = Vector (scrpos.x, scrpos.y)
		end
		
		local dist = ScrH() * 0.2
		
		local zoom_deg = wpn.DegreeOfZoom
		
		--[[if not LocalPlayer():Alive() then
			if LocalPlayer():GetObserverTarget():KeyDown (IN_ATTACK2) then --could network this?
				zoom_deg = 1
			end
		end]]
		
		local deg_rot = (zoom_deg or 0) * 45
		
		local pos = centrePt + Vector (-(dist * math.sin (math.rad (deg_rot))), dist * math.cos (math.rad (deg_rot))) - Vector (PixelWidth / (2 - (wpn.DegreeOfZoom or 0)), (Rows * Values.UnitHeight + Rows * Values.RowHeightGap) / 2)
		pos.x = math.Round (pos.x)
		pos.y = math.Round (pos.y)
		surface.SetDrawColor (255,255,255,125)
		
		if LocalPlayer():Alive() then
			local Unit = 0
			for Row=1, Rows do
				for UnitInRow=0, Values.UnitsPerRow-1 do
					Unit = Unit + 1
					UnitInRow = UnitInRow + 1
					if Unit > ClipSize then
						break
					elseif Unit > LoadedUnits then
						surface.SetDrawColor (100,100,100,100)
					end
					surface.DrawRect (pos.x + (UnitInRow-1) * (Values.UnitWidth + Values.UnitWidthGap), pos.y + ((Row-1) * (Values.UnitHeight + Values.RowHeightGap)), Values.UnitWidth, Values.UnitHeight)
				end
			end
			
			pos.y = pos.y + (Rows * Values.UnitHeight + Rows * Values.RowHeightGap)
		end
		
		if wpn.WeaponIconDrawValues then
			local x,y = 0,0
			for k,v in pairs (wpn.WeaponIconDrawValues) do
				surface.SetTextColor (255,255,255,125)
				surface.SetFont (v.font.."Scaled" or "ChatText")
				local w = surface.GetTextSize (v.text)
				x = pos.x - w / 2 + PixelWidth / 2
				y = (v.y or 0) + pos.y
				surface.SetTextPos (x, y)
				surface.DrawText (v.text)
			end
			if wpn.WeaponModNames then
				y = y + ScreenScaleH (17.5)
				if wpn.WeaponModNames[3] then --attachment always first here
					v = wpn.WeaponModNames[3]
					surface.SetFont ("CV12Scaled")
					local w = surface.GetTextSize (v)
					x = pos.x - w / 2 + PixelWidth / 2
					x = math.floor (x)
					if LocalPlayer():Alive() then
						--check for something to recharge
						if wpn.Tertiary.GetFractionReady then
							local fraction = wpn.Tertiary.GetFractionReady(wpn)
							local h = ScreenScaleH (7)+2
							--local w = ScreenScaleH (50)
							surface.SetDrawColor (100,100,100,100)
							surface.DrawRect (x-2, y+h-1, w+2, h)
							surface.SetDrawColor (255,255,255,125)
							surface.DrawRect (x-1, y+h, w * fraction, h-2)
							if fraction == 1 then
								surface.SetFont ("CV12ScaledNonAA")
								local w = surface.GetTextSize ("Press USE")
								x2 = pos.x - w / 2 + PixelWidth / 2
								x2 = math.floor (x2)
								surface.SetTextPos (x2, y+h-1)
								surface.SetTextColor (0,0,0,200)
								surface.DrawText ("Press USE")
								surface.SetFont ("CV12Scaled")
								surface.SetTextColor (255,255,255,125)
							end
						end
						y = y + ScreenScaleH(13)+2
					else
						y = y + ScreenScaleH(4)
					end
					surface.SetTextPos (x, y)
					surface.DrawText (v)
					y = y + ScreenScaleH(7)
				end
				for k,v in pairs (wpn.WeaponModNames) do
					if k == 3 then break end
					y = y + ScreenScaleH(7)
					surface.SetFont ("CV12Scaled")
					local w = surface.GetTextSize (v)
					x = pos.x - w / 2 + PixelWidth / 2
					surface.SetTextPos (x, y)
					surface.DrawText (v)
				end
			end
		end
	end
end

local SquareNumber = 3
local SquareValue = 40
local SquarePixelSize = math.Round(ScreenScaleH(15))
local SquarePixelSize2 = math.Round(ScreenScaleH(7.5))
local SquarePixelGap = math.Round(ScreenScaleH(3))

SquareNumberStatus = {}
for i=1, SquareNumber do
	SquareNumberStatus[i] = {
		redFlashTime = -1,
		greyedOut = false
	}
end

local regenerating = true

function GM:DrawHealth ()
	local PlayerHealth = LocalPlayer():Health()
	if PlayerHealth > (OldPlayerHealth or 0) then
		regenerating = true
		for k,v in pairs (SquareNumberStatus) do
			v.greyedOut = (PlayerHealth <= ((k-1) * SquareValue))
			--print (k, v.greyedOut)
		end
	elseif PlayerHealth < (OldPlayerHealth or 0) then
		regenerating = false
		for k,v in pairs (SquareNumberStatus) do
			v.redFlashTime = CurTime()
		end
	end
	OldPlayerHealth = PlayerHealth
	
	if not LocalPlayer():Alive() then
		local wpnent = LocalPlayer():GetActiveWeapon()
		if ValidEntity (wpnent) then
			PlayerHealth = LocalPlayer():GetObserverTarget():Health()
		else
			return
		end
	end
	if self.LoadoutMenu1 and self.LoadoutMenu1:IsVisible() then return end
	local centrePt = Vector (ScrW() * 0.5, ScrH() * 0.5)
	if self.TwitchAimConvar:GetBool() then
		local hitpos = util.TraceLine ({
			start = LocalPlayer():GetShootPos(),
			endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 4096,
			filter = LocalPlayer(),
			mask = MASK_SHOT
		}).HitPos
		local scrpos = hitpos:ToScreen()
		centrePt = Vector (scrpos.x, scrpos.y)
	end
	
	local dist = ScrH() * -0.3
	local deg_rot = (LNL_DegreeOfZoom or 0) * 45
	
	local pos = centrePt + Vector (-(dist * math.sin (math.rad (deg_rot))), dist * math.cos (math.rad (deg_rot))) - Vector ((SquareNumber * SquarePixelSize + (SquareNumber-1) * SquarePixelGap) / 2, 0)
	
	surface.SetFont ("CV12Scaled")
	local w = surface.GetTextSize ("Health")
	surface.SetTextPos (pos.x - w / 2 + (SquareNumber * SquarePixelSize + (SquareNumber-1) * SquarePixelGap) / 2, pos.y-ScreenScaleH(8.5))
	surface.DrawText ("Health")
	
	self:DrawHealthBoxes (pos.x, pos.y, PlayerHealth, SquarePixelSize)
end

function GM:DrawHealthBoxes (x,y,health,size,alpha,other)
	alpha = alpha or 150
	for i=1, SquareNumber do
		local fraction = 1 - math.max (0, (math.min (1, (i*SquareValue - health) / SquareValue)))
		surface.SetDrawColor (255,255,255,alpha)
		surface.DrawRect (x + (i-1)*(size + SquarePixelGap), y, size * fraction, size)
		if fraction < 1 then
			if not other then
				sqAlpha = math.max(0,alpha-25)
				if (not regenerating) and (not SquareNumberStatus[i].greyedOut) then
					--surface.SetDrawColor (255,0,0,sqAlpha)
					SquareNumberStatus[i].redFlashTime = CurTime()
				else
					--surface.SetDrawColor (100,100,100,sqAlpha)
				end
				local col = Color (100,100,100,sqAlpha)
				local col2 = Color (255,0,0,sqAlpha)
				local redAmt = math.max (0, SquareNumberStatus[i].redFlashTime + 1 - CurTime())
				col.r = col.r * (1-redAmt) + col2.r * redAmt
				col.g = col.g * (1-redAmt) + col2.g * redAmt
				col.b = col.b * (1-redAmt) + col2.b * redAmt
				surface.SetDrawColor (col.r, col.g, col.b, col.a)
			else
				surface.SetDrawColor (100,100,100,alpha)
			end
			
			surface.DrawRect (x + (i-1)*(size + SquarePixelGap) + size * fraction, y, size * (1-fraction), size)
		end
	end
end

local spottedPlayers = {}

function GM:DrawTargetID ()
	if not LocalPlayer():Alive() then return end
	
	local ent = util.TraceLine ({
		start = LocalPlayer():GetShootPos(),
		endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 4096,
		filter = LocalPlayer(),
		mask = MASK_SHOT
	}).Entity
	if ValidEntity(ent) and ent:IsPlayer() then
		spottedPlayers[ent:EntIndex()] = {ent, CurTime() + 2}
	end
	
	for k,v in pairs (spottedPlayers) do
		if v[2] < CurTime() then
			spottedPlayers[k] = nil
		else
			ply = v[1]
			local pos
			if ply:Alive() and ply:Health() > 0 then
				pos = ply:GetShootPos() + Vector (0,0,8)
				v[3] = pos
			else
				pos = v[3] or (ply:GetShootPos() + Vector (0,0,8))
			end
			local scrpos = pos:ToScreen()
			local health = ply:Health()
			if not ply:Alive() then
				health = 0
			end
			self:DrawHealthBoxes (scrpos.x, scrpos.y - 20, ply:Health(), SquarePixelSize2, 150 * math.min(1,v[2] - CurTime()), true)
		end
	end
end
