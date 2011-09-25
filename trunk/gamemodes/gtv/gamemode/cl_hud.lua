function GM:HUDAmmoPickedUp(ItemName,Amount)
	LocalPlayer():EmitSound("items/ammo_pickup.wav",100,90)
	return true
end

local wp = vgui.GetWorldPanel()
vgui.GetWorldPanel():SetCursor("crosshair")


local HUDNoShow = {
	["CHudSuitPower"] = true,
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudCrosshair"] = true,
	["CHudWeapon"] = true,
	["CHudDamageIndicator"] = true,
	}
	
function GM:HUDShouldDraw(elementname)
	if HUDNoShow[elementname] then
		return false
	end
	return true
end

--yes I need all of these buzz off
surface.CreateFont("coolvetica", 16, 400, true, false, "CV16")
surface.CreateFont("coolvetica", 20, 400, true, false, "CV20")
surface.CreateFont("coolvetica", 24, 400, true, false, "CV24")
surface.CreateFont("coolvetica", 32, 400, true, false, "CV32")
surface.CreateFont("coolvetica", 48, 400, true, false, "CV48")
local colgray = Color(100,100,100,200)
local gtvcol = Color(53,157,211,255)

//--------------------------------------------------//
// Health											//
//--------------------------------------------------//
local healthtex1 = surface.GetTextureID("gtv/tv1")


local HealthDisplay = vgui.Create("DPanel")
	HealthDisplay:SetSize(112,48)
	HealthDisplay.x = 32
	HealthDisplay.y = ScrH()
	HealthDisplay:SetPos(HealthDisplay.x,HealthDisplay.y)
	HealthDisplay:SetMouseInputEnabled(false)
	function HealthDisplay:Paint()
		if GetViewEntity():IsValid() then
			draw.RoundedBox(10,0,0,self:GetWide(),64,gtvcol)
			draw.RoundedBox(8,4,4,self:GetWide()-8,64,color_white)
			surface.SetTextColor(53,157,211,255)
			surface.SetTextPos(48,6)
			surface.SetFont("CV48")
			surface.DrawText(GetViewEntity():Health())
			surface.SetDrawColor(255,255,255,255)
			surface.SetTexture(healthtex1)
			surface.DrawTexturedRect(8,8,32,32)
			local healthlerp = GetViewEntity():Health()/100
			surface.SetTextColor(Lerp(healthlerp,117,54),Lerp(healthlerp,10,236),Lerp(healthlerp,33,58),255)
			surface.SetTextPos(16,3)
			surface.SetFont("CV48")
			surface.DrawText("+")
		end
	end
	function HealthDisplay:Think()
		if !LocalPlayer():IsValid() || !LocalPlayer():Alive() || LocalPlayer():IsObserver() then
			self.y = math.Approach(self.y,ScrH(),3)
		else
			self.y = math.Approach(self.y,ScrH()-48,2)
		end
		self:SetPos(self.x,self.y)
	end
	HealthDisplay:SetVisible(true)
	
//--------------------------------------------------//
// Score											//
//--------------------------------------------------//

local ScoreDisplay = vgui.Create("DPanel")
	ScoreDisplay:SetSize(180,48)
	ScoreDisplay.x = 32
	ScoreDisplay.y = ScrH()
	ScoreDisplay:SetPos(ScoreDisplay.x,ScoreDisplay.y)
	ScoreDisplay:SetMouseInputEnabled(false)
	function ScoreDisplay:Paint()
		if GetViewEntity():IsValid() then
			draw.RoundedBox(10,0,0,self:GetWide(),64,gtvcol)
			draw.RoundedBox(8,4,4,self:GetWide()-8,64,color_white)
			surface.SetTextColor(53,157,211,255)
			surface.SetTextPos(8,6)
			surface.SetFont("CV24")
			surface.DrawText("SCORE: "..LocalPlayer():Frags())
		end
	end
	function ScoreDisplay:Think()
		if !LocalPlayer():IsValid() || LocalPlayer():Alive() then
			self.y = math.Approach(self.y,ScrH(),3)
		else
			self.y = math.Approach(self.y,ScrH()-24,2)
		end
		self:SetPos(self.x,self.y)
	end
	ScoreDisplay:SetVisible(true)

//--------------------------------------------------//
// Ammo												//
//--------------------------------------------------//

offsetx = 0
offsety = 0
offsetx2 = 0

local AmmoDisplay = vgui.Create("DPanel")
	AmmoDisplay:SetSize(256,48)
	AmmoDisplay.x = ScrW()/2-AmmoDisplay:GetWide()/2
	AmmoDisplay.y = ScrH()
	AmmoDisplay:SetPos(AmmoDisplay.x,AmmoDisplay.y)
	AmmoDisplay:SetMouseInputEnabled(false)
	AmmoDisplay.LastSwitched = 0
	AmmoDisplay.ShouldShow = false
	AmmoDisplay.LastThink = 0
	function AmmoDisplay:Paint()
		draw.RoundedBox(10,0,0,self:GetWide(),64,gtvcol)
		draw.RoundedBox(8,4,4,self:GetWide()-8,64,color_white)
		surface.SetTextColor(53,157,211,255)
		surface.SetFont("CV48")
		-- -
		surface.SetTextPos(10,4)
		surface.DrawText("-")
		-- +
		surface.SetTextPos(234,4)
		surface.DrawText("+")
		-- ammo
		surface.SetFont("CV24")
		surface.SetTextPos(self:GetWide()/2-16,2)
		surface.DrawText("ammo")
		local ammo = 0
		local notenoughammo = false
		local wep = NULL
		if LocalPlayer():IsValid() && LocalPlayer():GetActiveWeapon():IsValid() then
			wep = LocalPlayer():GetActiveWeapon()
		end
		if wep:IsValid() && wep.Weapon && wep.AmmoCost then	
			ammo = math.ceil(wep.Weapon:Ammo1()/10)
			if wep.AmmoCost > wep.Weapon:Ammo1() then
				notenoughammo = true
			end
		end
		for i=1,20 do
			surface.SetTextPos(20+i*10,18)
			if (ammo < i) || notenoughammo then
				surface.DrawText("-")
			else
				surface.DrawText("|")
			end
		end
	end
	function AmmoDisplay:Think()
		local delt = CurTime()-self.LastThink
		if LocalPlayer():IsValid() && LocalPlayer():GetActiveWeapon():IsValid() then
			wep = LocalPlayer():GetActiveWeapon()
			if (wep.AmmoCost && wep.AmmoCost > 0) then
				self.y = math.Approach(self.y,ScrH()-48,64*delt)
			elseif (wep.AmmoCost || (wep.AmmoCost == 0)) then
				self.y = math.Approach(self.y,ScrH(),32*delt)
			end
		else
			self.y = math.Approach(self.y,ScrH(),32*delt)
		end
		self.LastThink = CurTime()
		self:SetPos(self.x,self.y)
	end
	AmmoDisplay:SetVisible(true)
	

//--------------------------------------------------//
// Notifications									//
//--------------------------------------------------//


local MsgDisplay = vgui.Create("DLabel")
	MsgDisplay:SetSize(256,48)
	MsgDisplay.x = ScrW()/2-MsgDisplay:GetWide()/2
	MsgDisplay.y = ScrH()-32
	MsgDisplay:SetPos(MsgDisplay.x,MsgDisplay.y)
	MsgDisplay:SetMouseInputEnabled(false)
	MsgDisplay.LastMsgTime = 0
	MsgDisplay:SetFont("CV24")
	local MsgDisplayColor = Color(200,200,200,200)
	function MsgDisplay:PerformLayout()
		self:SizeToContents()
		self.x = ScrW()/2-self:GetWide()/2
		self.y = ScrH()-48-self:GetTall()
		self:SetPos(self.x,self.y)
	end
	function MsgDisplay:Think()
		MsgDisplayColor.a = math.Clamp((1-(CurTime()-self.LastMsgTime)/3)*255,0,255)
		self:SetTextColor(MsgDisplayColor)
	end
	MsgDisplay:SetVisible(true)	
	GM.NotificationPanel = MsgDisplay
--[[
//--------------------------------------------------//
// Excitement										//
//--------------------------------------------------//	

local ExcitementDisplay = vgui.Create("DPanel")
	ExcitementDisplay:SetSize(104,48)
	ExcitementDisplay:SetPos(16,16)
	ExcitementDisplay:SetMouseInputEnabled(false)
	function ExcitementDisplay:Paint()
		draw.RoundedBox(16,0,0,104,48,colgray)
		if !LocalPlayer():IsValid() then
			return
		end
		surface.SetFont("CV48")
		surface.SetTextColor(255,255,255,255)
		surface.SetTextPos(16,0)
		surface.DrawText(LocalPlayer():GetNWFloat("Excitement"))
	end
	ExcitementDisplay:SetVisible(true)
	
	/*
		AmmoDisplay:SetSize(432,48)
	AmmoDisplay:SetPos(ScrW()-464,ScrH()-80)
	AmmoDisplay:SetMouseInputEnabled(false)
	function AmmoDisplay:Paint()
		draw.RoundedBox(16,0,0,self:GetWide(),self:GetTall(),colgray)
		if !LocalPlayer():IsValid() || !LocalPlayer():GetActiveWeapon():IsValid() || !LocalPlayer():GetActiveWeapon().AmmoCost then
			return
		end
		local wep = LocalPlayer():GetActiveWeapon()
		local x = self:GetWide()-16
		local y = self:GetTall()-24
		local w = 200*5
		local scale = 1
		surface.SetDrawColor(255,255,255,255)
		local cost = wep.AmmoCost
		if cost == 0 then
			cost = 1
			surface.SetDrawColor(150,150,150,255)
		end
		local unitw = cost*scale*2+(cost-1)*2
		for i=0,(wep.Weapon:Ammo1()/cost)-1 do
			if i*cost < 100 then
				surface.DrawRect(x-(i+1)*(unitw+2),y,unitw,16)
			else
				surface.DrawRect(x-(i+1)*(unitw+2)+400,y-18,unitw,16)
			end
		end
		*/
]]--
		
//--------------------------------------------------//
// Time 											//
//--------------------------------------------------//
		
local function GetPlayerPlace(pl)
	if !pl || !pl:IsValid() || !pl.ScoreboardPanel then
		return 0
	end
	return pl.ScoreboardPanel.rank
end

local TimeDisplay = vgui.Create("DPanel")
	TimeDisplay:SetSize(160,48)
	TimeDisplay.x = ScrW()-TimeDisplay:GetWide()-32
	TimeDisplay.y = ScrH()
	TimeDisplay:SetPos(TimeDisplay.x,TimeDisplay.y)
	TimeDisplay.Rank = 1
	function TimeDisplay:Paint()
		draw.RoundedBox(10,0,0,self:GetWide(),64,gtvcol)
		draw.RoundedBox(8,4,4,self:GetWide()-8,64,color_white)
		surface.SetTextColor(53,157,211,255)
		surface.SetTextPos(16,9)
		surface.SetFont("CV32")
		local timeleft
		if GetGlobalFloat("RoundStartTime", 0) > CurTime() then
			timeleft = GAMEMODE.RoundLength
		else
			timeleft = GetGlobalFloat("RoundEndTime")-CurTime()
		end
		if timeleft > 0 then
			surface.DrawText("TIME: "..string.ToMinutesSeconds(timeleft))
		elseif math.floor(CurTime()%2) == 0 then
			surface.DrawText("TIME: 00:00")
		else
			surface.DrawText("TIME:")
		end
		surface.SetFont("CV16")
		surface.SetTextPos(20,32)
		surface.DrawText("Round: "..GetGlobalFloat("RoundNumber"))
		//surface.SetTextPos(72,32)
		//surface.DrawText("Rank: "..self.Rank)
	end
	function TimeDisplay:Think()
		if GetGlobalFloat("RoundNumber") == 0 then
			self.y = math.Approach(self.y,ScrH(),3)
		else
			self.y = math.Approach(self.y,ScrH()-48,2)
		end
		self.rank = GetPlayerPlace(GetViewEntity())
		self:SetPos(self.x,self.y)
	end

function GM:UpdateHUD_Dead( bWaitingToSpawn, InRound )

	if ( !InRound && GAMEMODE.RoundBased ) then
	
		local RespawnText = vgui.Create( "DHudElement" )
			RespawnText:SizeToContents()
			RespawnText:SetText( "Waiting for round start" )
		GAMEMODE:AddHUDItem( RespawnText, 8 )
		return
		
	end

	if ( bWaitingToSpawn ) then

		local RespawnTimer = vgui.Create( "DHudCountdown" )
			RespawnTimer:SizeToContents()
			RespawnTimer:SetValueFunction( function() return LocalPlayer():GetNWFloat( "RespawnTime", 0 ) end )
			RespawnTimer:SetLabel( "SPAWN IN" )
		GAMEMODE:AddHUDItem( RespawnTimer, 8 )
		return

	end
	
	if ( Team != TEAM_SPECTATOR && !Alive ) then
	
		local RespawnText = vgui.Create( "DHudElement" )
			RespawnText:SizeToContents()
			RespawnText:SetText( "Press Fire to Spawn" )
		GAMEMODE:AddHUDItem( RespawnText, 8 )
		
	end

end

function GM:UpdateHUD_Alive( InRound )

	if ( GAMEMODE.RoundBased || GAMEMODE.TeamBased ) then
		local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 2 )
	end

end