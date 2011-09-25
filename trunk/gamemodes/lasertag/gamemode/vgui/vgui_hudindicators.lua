// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Derma defines for shield and powerup indicators.

local hud = {}
hud.ShieldIndicator		= surface.GetTextureID("LaserTag/HUD/hud_shieldindicator")
hud.UpgradeIndicator	= surface.GetTextureID("LaserTag/HUD/hud_upindicator")
hud.PowBase				= surface.GetTextureID("LaserTag/HUD/powerup_base")
hud.BaseOpacity			= 200

///////////////////////////////////////////////////////////
////Shield Indicator///////////////////////////////////////
local PANEL = {}

/*---------------------------------------------------------
  Init
---------------------------------------------------------*/
function PANEL:Init()
	local w = ScrW() * 0.14
	local h = w/4
	
	self:SetSize(w,h)
	self:SetPaintBackground(false)
end

/*---------------------------------------------------------
   Paint
---------------------------------------------------------*/
function PANEL:Paint()
	local col = team.GetColor(LocalPlayer():Team())
	local w,h = self:GetSize()
	
	// Scale the shield bar's fullness to a value dependant on how much shield we have left.
	local shield =  LocalPlayer():GetNetworkedInt("Shield")
	local fillval = math.floor((w/8*7) * shield/100)
	
	local baserate = 1 - shield/100
	local pulsedist = baserate*50
	local pulserate = baserate*15
	
	// This is the fill bar, we draw it underneath the shield overlay because it looks better that way.
	surface.SetDrawColor(col.r,col.g,col.b,100 + (pulsedist * math.sin(CurTime() * pulserate)))
	surface.DrawRect(w/16, h/4, fillval, h/2)
	
	// Setup indicator texture overlay.
	surface.SetTexture(hud.ShieldIndicator)
	surface.SetDrawColor(col.r,col.g,col.b,hud.BaseOpacity)
	surface.DrawTexturedRect(0, 0, w, h)
end
derma.DefineControl("DShieldIndicator", "LaserTag shield indicator.", PANEL, "DPanel")


///////////////////////////////////////////////////////////
////Upgrade Indicator//////////////////////////////////////
local PANEL = {}

/*---------------------------------------------------------
  Init
---------------------------------------------------------*/
function PANEL:Init()
	local w = ScrW() * 0.14
	local h = w/4
	
	self:SetSize(w,h)
	self:SetPaintBackground(false)
end

/*---------------------------------------------------------
   Paint
---------------------------------------------------------*/
function PANEL:Paint()
	local col 	= team.GetColor(LocalPlayer():Team())
	local w,h = self:GetSize()
	
	// Setup indicator texture overlay.
	surface.SetTexture(hud.UpgradeIndicator)
	surface.SetDrawColor(col.r,col.g,col.b,hud.BaseOpacity)
	surface.DrawTexturedRect(0, 0, w, h)
	
	if not GAMEMODE.Powerups then return end
	
	// Positioning code.
	local SlotY = h/4
	local Slot = {
		[POWERUP_PRIMARY]	= h/3,
		[POWERUP_SECONDARY] = w/2 - h/2,
		[POWERUP_PLAYER] 	= h*(2/3)
	}
	
	
	// Draw the powerups.
	self:DrawPowerupSlot(POWERUP_PRIMARY,	Slot[POWERUP_PRIMARY],	SlotY,h)
	self:DrawPowerupSlot(POWERUP_SECONDARY,	Slot[POWERUP_SECONDARY],SlotY,h)
	self:DrawPowerupSlot(POWERUP_PLAYER,	Slot[POWERUP_PLAYER],	SlotY,h)
end

function PANEL:DrawPowerupSlot(slot,x,y,w)
	local powerup = GAMEMODE:GetPowerupFromSlot(LocalPlayer(),slot)
	
	if powerup then
		surface.SetTexture(hud.PowBase)
		surface.SetDrawColor(powerup.Color.r,powerup.Color.g,powerup.Color.b,hud.BaseOpacity)
		surface.DrawTexturedRect(x,y,w,w/2)
		
		surface.SetTexture(powerup.Tex)
		surface.SetDrawColor(255,255,255,hud.BaseOpacity)
		surface.DrawTexturedRect(x,y,w,w/2)
	end
end

derma.DefineControl("DPowIndicator", "LaserTag powerup indicator.", PANEL, "DPanel")
