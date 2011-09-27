local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local star = surface.GetTextureID("gui/silkicons/star")

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	self:SetSize(16*8,32)
end

function PANEL:Paint()
	local y = (self:GetTall() - 16) / 2
	if ValidEntity(self.Player) and self.Player:IsPlayer() then
		surface.SetTexture(star)
		surface.SetDrawColor(255,255,255,255)
		
		if GAMEMODE.ScoreboardWinner==self.Player then
			for i=1,GAMEMODE.ScoreboardNewScore-1 do
				surface.DrawTexturedRect(16*(i-1), y, 16, 16)
			end
			
			if not self.Player.VictoryTargetX then
				self.Player.VictoryTargetX = 16 * (GAMEMODE.ScoreboardNewScore - 1)
			end
			
			if self.Player.VictoryCurrentX then
				self.Player.VictoryCurrentX = Lerp(0.1, self.Player.VictoryCurrentX, self.Player.VictoryTargetX)
			else
				self.Player.VictoryCurrentX = 16*8
			end
			surface.DrawTexturedRect(self.Player.VictoryCurrentX, y, 16, 16)
		else
			for i=1, self.Player:GetNWInt("Victories") do
				surface.DrawTexturedRect(16*(i-1), y, 16, 16)
			end
		end
	end
end

derma.DefineControl("VictoryCounter", "", PANEL, "Panel")