// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Heads Up Display system.

local hud = {}

// Indicator
hud.IndicLeft			= surface.GetTextureID("LaserTag/HUD/hud_topindicator_left")
hud.IndicRight			= surface.GetTextureID("LaserTag/HUD/hud_topindicator_right")
hud.IndicCenter			= surface.GetTextureID("LaserTag/HUD/hud_topindicator_center")
hud.IndicPad			= surface.GetTextureID("LaserTag/HUD/hud_topindicator_pad")

// Team icons
hud.TeamIcon = {
	[TEAM_RED] = surface.GetTextureID("LaserTag/HUD/hud_rapture"),
	[TEAM_BLUE] = surface.GetTextureID("LaserTag/HUD/hud_siren"),
	[TEAM_GREEN] = surface.GetTextureID("LaserTag/HUD/hud_cobra"),
	[TEAM_YELLOW] = surface.GetTextureID("LaserTag/HUD/hud_fury")
}

// Other
hud.PwupBase			= surface.GetTextureID("LaserTag/HUD/powerup_base")
hud.BaseOpacity			= 150
hud.EdgeDistance		= 0.02
//local hudShieldFill			= surface.GetTextureID("LaserTag/HUD/hud_fillbar")

surface.CreateFont("Dodger", ScreenScale(3), 400, true, false, "DodgerSmall")
surface.CreateFont("Dodger", ScreenScale(8), 400, true, false, "DodgerMed")
surface.CreateFont("Dodger", ScreenScale(15), 400, true, false, "DodgerLarge")
surface.CreateFont("Trebuchet MS", ScreenScale(3), 800, true, false, "LaserTagSmall" )
surface.CreateFont("Trebuchet MS", ScreenScale(8), 800, true, false, "LaserTagMed" )
surface.CreateFont("Trebuchet MS", ScreenScale(15), 800, true, false, "LaserTagLarge" )

/*-------------------------------------------------------------------
	[ HUDShouldDraw ]
	Determine what HUD elements are permitted to draw.
-------------------------------------------------------------------*/
function GM:HUDShouldDraw(name)
	if name == "CHudHealth" or name == "CHudBattery" // We don't want the health or suit armor indicators. 
	or name == "CHudAmmo" or name == "CHudSecondaryAmmo" // We don't want ammo either.
	or name == "CHudWeaponSelection" then // Lastly, we don't want weapon selection since we only have one weapon.
		return false
	end
	
	return self.BaseClass:HUDShouldDraw(name)
end

// Local HUD vars
local hudScreen = nil
local Alive = false
local Class = nil
local Team = 0
local WaitingToRespawn = false
local InRound = false
local RoundResult = 0
local RoundWinner = nil
local IsObserver = false
local ObserveMode = 0
local ObserveTarget = NULL
local InVote = false

function GM:AddHUDItem( item, pos, parent )
	hudScreen:AddItem( item, parent, pos )
end

function GM:HUDNeedsUpdate()

	if ( !IsValid( LocalPlayer() ) ) then return false end

	if ( Class != LocalPlayer():GetNWString( "Class", "Default" ) ) then return true end
	if ( Alive != LocalPlayer():Alive() ) then return true end
	if ( Team != LocalPlayer():Team() ) then return true end
	if ( WaitingToRespawn != ( (LocalPlayer():GetNWFloat( "RespawnTime", 0 ) > CurTime()) && LocalPlayer():Team() != TEAM_SPECTATOR && !LocalPlayer():Alive()) ) then return true end
	if ( InRound != GetGlobalBool( "InRound", false ) ) then return true end
	if ( RoundResult != GetGlobalInt( "RoundResult", 0 ) ) then return true end
	if ( RoundWinner != GetGlobalEntity( "RoundWinner", nil ) ) then return true end
	if ( IsObserver != LocalPlayer():IsObserver() ) then return true end
	if ( ObserveMode != LocalPlayer():GetObserverMode() ) then return true end
	if ( ObserveTarget != LocalPlayer():GetObserverTarget() ) then return true end
	if ( InVote != GAMEMODE:InGamemodeVote() ) then return true end
	
	return false
end

function GM:OnHUDUpdated()
	Class = LocalPlayer():GetNWString( "Class", "Default" )
	Alive = LocalPlayer():Alive()
	Team = LocalPlayer():Team()
	WaitingToRespawn = (LocalPlayer():GetNWFloat( "RespawnTime", 0 ) > CurTime()) && LocalPlayer():Team() != TEAM_SPECTATOR && !Alive
	InRound = GetGlobalBool( "InRound", false )
	RoundResult = GetGlobalInt( "RoundResult", 0 )
	RoundWinner = GetGlobalEntity( "RoundWinner", nil )
	IsObserver = LocalPlayer():IsObserver()
	ObserveMode = LocalPlayer():GetObserverMode()
	ObserveTarget = LocalPlayer():GetObserverTarget()
	InVote = GAMEMODE:InGamemodeVote()
end

function GM:OnHUDPaint()

end

function GM:RefreshHUD()

	if ( !GAMEMODE:HUDNeedsUpdate() ) then return end
	GAMEMODE:OnHUDUpdated()
	
	if ( IsValid( hudScreen ) ) then hudScreen:Remove() end
	hudScreen = vgui.Create( "DHudLayout" )
	
	if not hudNotify or not IsValid(hudNotify) then
		hudNotify = vgui.Create("DTagNotify")
		hudNotify:SetWide(ScrW()*0.3)
		hudNotify:AlignRight(10)
	end
	
	if ( InVote ) then return end
	
	if ( RoundWinner and RoundWinner != NULL ) then
		GAMEMODE:UpdateHUD_RoundResult( RoundWinner, Alive )
	elseif ( RoundResult != 0 ) then
		GAMEMODE:UpdateHUD_RoundResult( RoundResult, Alive )
	elseif ( IsObserver ) then
		GAMEMODE:UpdateHUD_Observer( WaitingToRespawn, InRound, ObserveMode, ObserveTarget )
	elseif ( !Alive ) then
		GAMEMODE:UpdateHUD_Dead( WaitingToRespawn, InRound )
	else
		GAMEMODE:UpdateHUD_Alive( InRound )
	end
	
end

function GM:HUDPaint()

	self.BaseClass:HUDPaint()
	
	GAMEMODE:OnHUDPaint()
	GAMEMODE:RefreshHUD()
	
end


GM.pRoundFinish = false
function GM:UpdateHUD_RoundResult(RoundResult, Alive)
	if RoundResult < 1 or RoundResult > 1000 then return end
	
	local TeamName = team.GetName(RoundResult)
	
	// VGUI panel.
	self.pRoundFinish = vgui.Create("DRoundFinish")
	self.pRoundFinish:SetText(TeamName.." has won")
	
	
	self.pRoundFinish.Close.DoClick = function(self)
		self:GetParent():Remove()
		
		GAMEMODE.LastStatData = GAMEMODE.StatData
		GAMEMODE.StatData = {}
	end
	
	for id,v in pairs(self.StatData) do // Add stat data received already.
		self:UpdateHUD_RoundFinishStats(id,v)
	end
	
	// Positioning/layout.
	self.pRoundFinish:CenterHorizontal()
	self.pRoundFinish:AlignBottom(5)
	self.pRoundFinish:InvalidateLayout()
	self.pRoundFinish:MakePopup()
end

function GM:UpdateHUD_RoundFinishStats(id,v)
	if not self.pRoundFinish or not self.pRoundFinish:IsValid() then return end
	
	if v.Personal.Rank == 1 then
		self.pRoundFinish:WinStat(self.Stats[id].Name,self.Stats[id].Mat)
	end
	
	// Add the stat compare.
	local statcompare = vgui.Create("DRoundFinishStat")
	statcompare:SetWide(self.pRoundFinish.Canvas:GetWide()/2 - self.pRoundFinish.Canvas:GetSpacing()/2)
	statcompare:SetImage(self.Stats[id].Mat)
	statcompare:SetDesc(self.Stats[id].Desc)
	
	for k,data in ipairs(v.Info) do
		statcompare:AddRow(data.Rank.."/"..data.MaxRank,data.Ply,data.Score)
	end
	
	if v.LastRound then
		statcompare:AddCompare(v.LastRound.Rank.."/"..v.LastRound.MaxRank,v.LastRound.Ply,v.LastRound.Score)
	end
	
	statcompare:InvalidateLayout()
	self.pRoundFinish:AddItem(statcompare)
	self.pRoundFinish:InvalidateLayout()
end

function GM:UpdateHUD_Observer( bWaitingToSpawn, InRound, ObserveMode, ObserveTarget )

	local lbl = nil
	local txt = nil
	local col = Color( 255, 255, 255 );

	if ( IsValid( ObserveTarget ) && ObserveTarget:IsPlayer() && ObserveTarget != LocalPlayer() && ObserveMode != OBS_MODE_ROAMING ) then
		lbl = "SPECTATING"
		txt = ObserveTarget:Nick()
		col = team.GetColor( ObserveTarget:Team() );
	end
	
	if ( ObserveMode == OBS_MODE_DEATHCAM || ObserveMode == OBS_MODE_FREEZECAM ) then
		txt = "You Died!" // were killed by?
	end
	
	if ( txt ) then
		local txtLabel = vgui.Create( "DHudElement" );
		txtLabel:SetText( txt )
		if ( lbl ) then txtLabel:SetLabel( lbl ) end
		txtLabel:SetTextColor( col )
		
		GAMEMODE:AddHUDItem( txtLabel, 2 )		
	end

	
	GAMEMODE:UpdateHUD_Dead( bWaitingToSpawn, InRound )

end

function GM:UpdateHUD_Dead( bWaitingToSpawn, InRound )

	if ( !InRound && GAMEMODE.RoundBased ) then
	
		local RespawnText = vgui.Create( "DHudElement" );
			RespawnText:SizeToContents()
			RespawnText:SetText( "Waiting for round start" )
		GAMEMODE:AddHUDItem( RespawnText, 8 )
		return
		
	end

	if ( bWaitingToSpawn ) then

		local RespawnTimer = vgui.Create( "DHudCountdown" );
			RespawnTimer:SizeToContents()
			RespawnTimer:SetValueFunction( function() return LocalPlayer():GetNWFloat( "RespawnTime", 0 ) end )
			RespawnTimer:SetLabel( "SPAWN IN" )
		GAMEMODE:AddHUDItem( RespawnTimer, 8 )
		return

	end
	
	if ( InRound ) then
	
		local RoundTimer = vgui.Create( "DHudCountdown" );
			RoundTimer:SizeToContents()
			RoundTimer:SetValueFunction( function() 
											if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
											return GetGlobalFloat( "RoundEndTime" ) end )
			RoundTimer:SetLabel( "TIME" )
		GAMEMODE:AddHUDItem( RoundTimer, 8 )
		return
	
	end
	
	if ( Team != TEAM_SPECTATOR && !Alive ) then
	
		local RespawnText = vgui.Create( "DHudElement" );
			RespawnText:SizeToContents()
			RespawnText:SetText( "Press Fire to Spawn" )
		GAMEMODE:AddHUDItem( RespawnText, 8 )
		
	end

end

// ----------------------------------------------------------------------------------
//		This is the function that draws the primary interface elements.
function GM:UpdateHUD_Alive( InRound )

	if ( GAMEMODE.RoundBased || GAMEMODE.TeamBased ) then
	
		local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 8 )
		
		if hudNotify and IsValid(hudNotify) then hudNotify:MoveBelow(Bar,5) end

		local TagNumber = vgui.Create("DHudUpElement")
			TagNumber.GetContentTextFromFunction = function(self) return LocalPlayer():Frags() end
			TagNumber:SetText("Tags","0")
			TagNumber:SetFont("CenterPrintText","LaserTagLarge")
			TagNumber:SetHighlight(true)
			TagNumber:SizeToContents()
		Bar:AddItem(TagNumber,1)
		
		local SwapNumber = vgui.Create("DHudUpElement")
			SwapNumber.GetContentTextFromFunction = function(self) return LocalPlayer():Deaths() end
			SwapNumber:SetText("Swaps","0")
			SwapNumber:SetFont("CenterPrintText","LaserTagLarge")
			SwapNumber:SetHighlight(true)
			SwapNumber:SizeToContents()
		Bar:AddItem(SwapNumber,3)
		
		local RoundTimer = vgui.Create("DHudCountdown")
			RoundTimer:SetValueFunction(function() 
				if GetGlobalFloat("RoundStartTime", 0) > CurTime() then return GetGlobalFloat("RoundStartTime", 0)  end 
				return GetGlobalFloat("RoundEndTime")
			end)
			
			RoundTimer:SetLabel("")
			RoundTimer:SetFont("CenterPrintText")
			RoundTimer:SizeToContents()
		Bar:AddItem(RoundTimer,2)
		
		
		// Shield & Powerup indicator
		local ShieldIndicator = vgui.Create("DShieldIndicator")
		GAMEMODE:AddHUDItem(ShieldIndicator, 1)
		
		local PowIndicator = vgui.Create("DPowIndicator")
		GAMEMODE:AddHUDItem(PowIndicator, 3)
		
	end

end

local function ReceiveTagNotify(um)
	local attacker = um:ReadEntity()
	local attackteam = um:ReadShort()
	
	local victim = um:ReadEntity()
	local victeam = um:ReadShort()
	
	if hudNotify and IsValid(hudNotify) then
		local notify = vgui.Create("DTagNotifyTag")
		if attacker and attacker:IsValid() then notify:SetAttacker(attacker:Name(),team.GetColor(attackteam)) end
		
		if victim == LocalPlayer() then
			notify:SetVictim(team.GetName(attackteam).." team",team.GetColor(attackteam))
			notify:SetText("swapped you to")
		elseif victim and victim:IsValid() then notify:SetVictim(victim:Name(),team.GetColor(victeam)) end
		
		hudNotify:AddItem(notify)
	end
end
usermessage.Hook("LaserTag-Notify",ReceiveTagNotify)


