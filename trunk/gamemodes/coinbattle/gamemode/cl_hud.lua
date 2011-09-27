
include("vgui/vgui_ammo.lua")
include("vgui/vgui_health.lua")

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

local tex_health = surface.GetTextureID("coinbattle/HUD/health")
local tex_ammo = surface.GetTextureID("coinbattle/HUD/ammo")
local tex_cent = surface.GetTextureID("coinbattle/cent")
local tex_back_main = surface.GetTextureID("coinbattle/HUD/back_main")
local tex_back_s = surface.GetTextureID("coinbattle/HUD/back_s")

local healthPanel
local ammoPanel

function GM:CreateHUDPanels()
	
	healthPanel = vgui.Create("HealthDisplay")
	ammoPanel = vgui.Create("AmmoDisplay")
	
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

function GM:HUDPaint()
	
	GAMEMODE:HUDDrawTargetID()
	GAMEMODE:HUDDrawPickupHistory()
	GAMEMODE:DrawDeathNotice( 0.85, 0.04 )
	
	local ply = LocalPlayer()
	
	self:OnHUDUpdated()
	
	if ( InVote ) then return end
	
	if ( RoundResult != 0 ) then
		self:HUD_RoundResult(ply)
	elseif ( IsObserver ) then
		self:HUD_Observer(ply)
	elseif ( !Alive ) then
		self:HUD_Dead(ply)
	else
		self:HUD_Alive(ply)
	end
	
end

function GM:DrawDamageNumbers()
	
	for k,v in pairs(DamageNumberLabels) do
		if v.DieTime <= CurTime() then
			table.remove(DamageNumberLabels,k)
		end
		
		v.Pos.z = v.Pos.z + RealFrameTime()*20
		local spos = v.Pos:ToScreen()
		
		v.Col.a = math.Clamp(v.Col.a - RealFrameTime() * 150, 0 , 255)
		
		draw.ShadowText(v.Text, "FRETTA_MEDIUM", spos.x, spos.y, v.Col, TEXT_ALIGN_CENTER)
	end
	
end

local function GetTime()
	if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then
		return GetGlobalFloat( "RoundStartTime", 0 )
	end 
	return GetGlobalFloat( "RoundEndTime" )
end
function GM:DrawScores()
	
	if InRound then
		surface.SetTexture(tex_back_s)
		surface.SetDrawColor(team.GetColor(TEAM_CYAN))
		surface.DrawTexturedRect((ScrW()/2)-228,0,256,128)
		
		surface.SetDrawColor(team.GetColor(TEAM_ORANGE))
		surface.DrawTexturedRect((ScrW()/2)-28,0,256,128)
		
		surface.SetTexture(tex_back_main)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect((ScrW()/2)-128,0,256,128)
		
		local EndTime = GetTime()
		local Time = string.ToMinutesSeconds( EndTime - CurTime() )
		
		draw.DrawText(
			Time,
			"FRETTA_LARGE",
			ScrW()/2,
			28,
			Color(0,0,0),
			TEXT_ALIGN_CENTER
		)
		
		local text = "Round "..GetGlobalInt( "RoundNumber", 0 )
		draw.DrawText(
			text,
			"FRETTA_MEDIUM",
			ScrW()/2,
			12,
			Color(0,0,0),
			TEXT_ALIGN_CENTER
		)
		
		text = team.GetScore(TEAM_CYAN)
		draw.DrawText(
			text,
			"FRETTA_LARGE",
			ScrW()/2-150,
			12,
			Color(0,0,0),
			TEXT_ALIGN_CENTER
		)
		
		text = team.GetScore(TEAM_ORANGE)
		draw.DrawText(
			text,
			"FRETTA_LARGE",
			ScrW()/2+150,
			12,
			Color(0,0,0),
			TEXT_ALIGN_CENTER
		)
	
	end
	
end

function GM:HUD_Alive(ply)
	
	self:DrawScores()
	
	if GetGlobalBool("InPreRound",false) then
		
		local text = "Press F3 for buy menu."
		draw.ShadowText(
			text,
			"FRETTA_LARGE",
			ScrW()/2,
			100,
			GAMEMODE:GetTeamColor(ply),
			TEXT_ALIGN_CENTER
		)
		
	end
	
	if ValidEntity(ply) and ValidEntity(ply:GetActiveWeapon()) then
		
		surface.SetTexture(tex_health)
		surface.SetDrawColor(GAMEMODE:GetTeamColor(ply))
		surface.DrawTexturedRect(32,ScrH()-160,128,128)
		
		surface.SetTexture(tex_ammo)
		surface.DrawTexturedRect(ScrW()-160,ScrH()-160,128,128)
		
		local text = ply:GetCoins()
		draw.ShadowText(
			text,
			"FRETTA_LARGE",
			200,
			ScrH()-76,
			GAMEMODE:GetTeamColor(ply),
			TEXT_ALIGN_RIGHT
		)
		
		surface.SetTexture(tex_cent)
		
		surface.SetDrawColor(Color(0,0,0))
		surface.DrawTexturedRect(206,ScrH()-70,16,32)
		
		surface.SetDrawColor(GAMEMODE:GetTeamColor(ply))
		surface.DrawTexturedRect(206,ScrH()-71,16,32)
		
		local nades = ply.Grenades
		if nades and nades > 0 then

			local w,h = 32, 16

			local x,y = ScrW()-160-w, ScrH()-64

			for i=1, nades do

				draw.RoundedBox(4,x-1,y-1,w+2,h+2,Color(0,0,0))
				draw.RoundedBox(4,x,y,w,h,GAMEMODE:GetTeamColor(ply))
				y = y-h-4

			end

		end

		self:DrawDamageNumbers()
		
	end
	
	if healthPanel ~= nil then
		if ValidEntity(ply:GetActiveWeapon()) then
			healthPanel:SetVisible(true)
			healthPanel:InvalidateLayout(true)
		else
			healthPanel:SetVisible(false)
		end
	end
	
	if ammoPanel ~= nil then
		if ValidEntity(ply:GetActiveWeapon()) then
			ammoPanel:SetVisible(true)
			ammoPanel:InvalidateLayout(true)
		else
			ammoPanel:SetVisible(false)
		end
	end
	
end

function GM:HUD_Dead( ply )
	
	self:DrawScores()
	
	if ( !InRound && GAMEMODE.RoundBased ) then return end
	
	if ( WaitingToRespawn ) then
		
		local EndTime = ply:GetNWFloat( "RespawnTime", 0 )
		local Time = string.ToMinutesSeconds( EndTime - CurTime() )
		
		local text = "Spawn in "..Time
		draw.ShadowText(
			text,
			"FRETTA_MEDIUM",
			ScrW()/2,
			88,
			GAMEMODE:GetTeamColor(ply),
			TEXT_ALIGN_CENTER
		)
		
		return

	end
	
	if ( Team != TEAM_SPECTATOR && !Alive ) then
	
		local text = "Press fire to spawn"
		draw.ShadowText(
			text,
			"FRETTA_MEDIUM",
			ScrW()/2,
			88,
			GAMEMODE:GetTeamColor(ply),
			TEXT_ALIGN_CENTER
		)
		
	end

end

function GM:HUD_Observer(ply)
	
	healthPanel:SetVisible(false)
	ammoPanel:SetVisible(false)
	
	if IsValid( ObserveTarget ) && ObserveTarget:IsPlayer() && ObserveTarget != LocalPlayer() && ( ObserveMode == OBS_MODE_DEATHCAM || ObserveMode == OBS_MODE_FREEZECAM ) then
		
		local text = "You were killed by "..ObserveTarget:Nick()
		local font = "FRETTA_MEDIUM"
		
		surface.SetFont(font)
		local w,h = surface.GetTextSize(text)
		local x,y = w+64,h+64
		
		draw.RoundedBox(8,ScrW()-x-2,ScrH()-y-2,w+20,h+20,GAMEMODE:GetTeamColor(ObserveTarget))
		draw.RoundedBox(8,ScrW()-x,ScrH()-y,w+16,h+16,Color(0,0,0,200))
		draw.SimpleText(text,font,ScrW()-x+8,ScrH()-y+8,Color(255,255,255,255))
		
		return
		
	end
	
	if ( IsValid( ObserveTarget ) && ObserveTarget:IsPlayer() && ObserveTarget != LocalPlayer() && ObserveMode != OBS_MODE_ROAMING ) then
		
		surface.SetDrawColor(0,0,0,200)
		surface.DrawRect(0,0,ScrW(),112)
		surface.DrawRect(0,ScrH()-112,ScrW(),112)
		
		local text = "Spectating "..ObserveTarget:Nick()
		draw.ShadowText(
			text,
			"FRETTA_LARGE",
			ScrW()/2,
			ScrH()-78,
			Color(255,255,255),
			TEXT_ALIGN_CENTER
		)
		
	end
	
	self:HUD_Dead(ply)
	
end

function GM:HUD_RoundResult(ply)
	
	if ( IsObserver ) then
		self:HUD_Observer(ply)
	elseif ( !Alive ) then
		self:HUD_Dead(ply)
	else
		self:HUD_Alive(ply)
	end
	
	surface.SetTexture(tex_back_main)
	surface.SetDrawColor(RoundResult==-1 and Color(255,255,255) or team.GetColor(RoundResult))
	surface.DrawTexturedRect((ScrW()/2)-128,0,256,128)
	
	local text = GetGlobalString( "RRText" )
	if team.GetAllTeams()[ RoundResult ] && text == "" then
		
		local TeamName = team.GetName( RoundResult )
		if ( TeamName ) then text = TeamName .. " Wins!" end
		
	end
	draw.DrawText(
		text,
		"FRETTA_MEDIUM",
		ScrW()/2,
		28,
		Color(0,0,0),
		TEXT_ALIGN_CENTER
	)
	
end

function draw.ShadowText(text, font, x, y, col, align)
	
	draw.DrawText(
		text,
		font,
		x,
		y+1,
		Color(0,0,0,col.a),
		align
	)
	draw.DrawText(
		text,
		font,
		x,
		y,
		col,
		align
	)
	
end