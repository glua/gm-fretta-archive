
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
local CanStartYet = true

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
	
	//if ( LocalPlayer().ChainUpdated ) then return true end
	if ( CanStartYet != GetGlobalBool( "CanStartYet", true ) ) then return true end
	
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
	
	//LocalPlayer().ChainUpdated = false
	CanStartYet = GetGlobalBool( "CanStartYet", true )
end

function GM:OnHUDPaint()
	
end

function GM:RefreshHUD()

	if ( !GAMEMODE:HUDNeedsUpdate() ) then return end
	GAMEMODE:OnHUDUpdated()
	
	if ( IsValid( hudScreen ) ) then hudScreen:Remove() end
	hudScreen = vgui.Create( "DHudLayout" )
	
	if ( InVote ) then return end
	
	if ( RoundWinner and RoundWinner != NULL ) then
		GAMEMODE:UpdateHUD_RoundResult( RoundWinner, Alive )
	elseif ( RoundResult != 0 ) then
		GAMEMODE:UpdateHUD_RoundResult( RoundResult, Alive )
	elseif ( IsObserver ) then
		GAMEMODE:UpdateHUD_Observer( WaitingToRespawn, InRound, ObserveMode, ObserveTarget )
		GAMEMODE:UpdateHUD_TeamData()
	elseif ( !Alive ) then
		GAMEMODE:UpdateHUD_Dead( WaitingToRespawn, InRound )
		GAMEMODE:UpdateHUD_TeamData()
	else
		GAMEMODE:UpdateHUD_Alive( InRound )
		GAMEMODE:UpdateHUD_TeamData()
		//GAMEMODE:UpdateHUD_Chains()
	end
	
end

function GM:HUDPaint()

	self.BaseClass:HUDPaint()
	
	GAMEMODE:OnHUDPaint()
	GAMEMODE:RefreshHUD()
	
	if ( RoundResult != 0 ) then
		GAMEMODE:DrawScoreResults()
	else
		GAMEMODE:DrawScoreNotifications()
		GAMEMODE:PaintTips() // from cl_tips.lua
	end
	
	GAMEMODE:DrawPropsBrokenChain()
	
end

function GM:UpdateHUD_RoundResult( RoundResult, Alive )

	local txt = GetGlobalString( "RRText" )
	
	if ( type( RoundResult ) == "number" ) && ( team.GetAllTeams()[ RoundResult ] && txt == "" ) then
		local TeamName = team.GetName( RoundResult )
		if ( TeamName ) then txt = TeamName .. " Wins!" end
	elseif ( type( RoundResult ) == "Player" && ValidEntity( RoundResult ) && txt == "" ) then
		txt = RoundResult:Name() .. " Wins!"
	end

	local RespawnText = vgui.Create( "DHudElement" );
		RespawnText:SizeToContents()
		RespawnText:SetText( txt )
	GAMEMODE:AddHUDItem( RespawnText, 8 )

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

function GM:UpdateHUD_Alive( InRound )

	if ( GAMEMODE.RoundBased || GAMEMODE.TeamBased ) then
	
		local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 2 )

		if ( GAMEMODE.TeamBased ) then
		
			local TeamIndicator = vgui.Create( "DHudUpdater" );
				TeamIndicator:SizeToContents()
				TeamIndicator:SetValueFunction( function() 
													return team.GetName( LocalPlayer():Team() )
												end )
				TeamIndicator:SetColorFunction( function() 
													return team.GetColor( LocalPlayer():Team() )
												end )
				TeamIndicator:SetFont( "ScoreBig" )
			Bar:AddItem( TeamIndicator )
			
		end
		
		if ( GAMEMODE.RoundBased ) then 
		
			local RoundNumber = vgui.Create( "DHudUpdater" );
				RoundNumber:SizeToContents()
				RoundNumber:SetValueFunction( function() return GetGlobalInt( "RoundNumber", 0 ) end )
				RoundNumber:SetLabel( "ROUND" )
			Bar:AddItem( RoundNumber )
			
			local RoundTimer = vgui.Create( "DHudCountdown" );
				RoundTimer:SizeToContents()
				RoundTimer:SetValueFunction( function() 
												if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
												return GetGlobalFloat( "RoundEndTime" ) end )
				RoundTimer:SetLabel( "TIME" )
			Bar:AddItem( RoundTimer )

			if (!CanStartYet) then
				local BarPreRound = vgui.Create( "DHudBar" )
				GAMEMODE:AddHUDItem( BarPreRound, 8, Bar )
				
				local required = self.PlayersPerTeamRequiredBeforeRoundCanStart
				
				local StartReason = vgui.Create( "DHudElement" );
					StartReason:SizeToContents()
					StartReason:SetText( "At least "..required.." players per team needed!" )
				BarPreRound:AddItem( StartReason )
			end
		end
		
	end

end

/*
Let's write out the Fretta HUD aligning code:
parent: HUD element to set relative to (can be nil)
pos: (format: <option with no relative> / <option with relative>), ...)
	1 bottom / move below, left / same x as relative
	2 bottom / move below, center horizontal / x align center with relative center
	3 bottom / move below, right / x align right of relative
	4 center vertical / same y as relative, left / same x as relative, place left of relative (if not nil)
	5 center vertical / same y as relative, center horizontal / x align center with relative center
	6 center vertical / same y as relative, right / x align right of relative, place left of relative (if not nil)
	7 top / move above, left / same x as relative
	8 top / move above, center horizontal / x align center with relative center
	9 top / move above, right / x align right of relative
*/

function GM:UpdateHUD_TeamData()

	// Red team score
	local BarRed = vgui.Create( "DHudBar" )
	GAMEMODE:AddHUDItem( BarRed, 7 )

	local TeamRedScore = vgui.Create( "DHudUpdater" )
		TeamRedScore:SizeToContents()
		TeamRedScore:SetValueFunction( function() return "Total score: "..teaminfo[TEAM_RED].TotalPropValue end )
		TeamRedScore:SetColorFunction( function() return team.GetColor( TEAM_RED ) end )
		TeamRedScore:SetFont( "ScoreBig" )
	BarRed:AddItem( TeamRedScore )
	
	local TeamRedProps = vgui.Create( "DHudUpdater" )
		TeamRedProps:SizeToContents()
		TeamRedProps:SetValueFunction( function() return "Props: "..teaminfo[TEAM_RED].PropCount end )
		TeamRedProps:SetColorFunction( function() return team.GetColor( TEAM_RED ) end )
		TeamRedProps:SetFont( "HudSelectionText" )
	BarRed:AddItem( TeamRedProps, TeamRedScore, 1 )

	
	// Blue team score
	local BarBlue = vgui.Create( "DHudBar" )
	GAMEMODE:AddHUDItem( BarBlue, 1, BarRed )

	local TeamBlueScore = vgui.Create( "DHudUpdater" )
		TeamBlueScore:SizeToContents()
		TeamBlueScore:SetValueFunction( function() return "Total score: "..teaminfo[TEAM_BLUE].TotalPropValue end )
		TeamBlueScore:SetColorFunction( function() return team.GetColor( TEAM_BLUE ) end )
		TeamBlueScore:SetFont( "ScoreBig" )
	BarBlue:AddItem( TeamBlueScore )
	
	local TeamBlueProps = vgui.Create( "DHudUpdater" )
		TeamBlueProps:SizeToContents()
		TeamBlueProps:SetValueFunction( function() return "Props: "..teaminfo[TEAM_BLUE].PropCount end )
		TeamBlueProps:SetColorFunction( function() return team.GetColor( TEAM_BLUE ) end )
		TeamBlueProps:SetFont( "HudSelectionText" )
	BarBlue:AddItem( TeamBlueProps, TeamBlueScore, 1 )
	
	
	// Personal score
	local BarScore = vgui.Create( "DHudBar" )
	GAMEMODE:AddHUDItem( BarScore, 1, BarBlue )

	local PointsScore = vgui.Create( "DHudUpdater" )
		PointsScore:SizeToContents()
		PointsScore:SetValueFunction( function() return "Your points: "..LocalPlayer():GetPoints() end )
		PointsScore:SetColorFunction( function() return team.GetColor( LocalPlayer():Team() ) end )
		PointsScore:SetFont( "ScoreMedium" )
	BarScore:AddItem( PointsScore )
	
	local AssistScore = vgui.Create( "DHudUpdater" )
		AssistScore:SizeToContents()
		AssistScore:SetValueFunction( function() return "Assists: "..LocalPlayer():GetAssistPoints() end )
		AssistScore:SetColorFunction( function() return team.GetColor( LocalPlayer():Team() ) end )
		AssistScore:SetFont( "HudSelectionText" )
	BarScore:AddItem( AssistScore, PointsScore, 1 )
	
end

// Part of the old chain system. It just didn't work out so well. It's still functional in the background, but no longer displayed
/*function GM:UpdateHUD_Chains()
	
	local prevbar
	
	for k, chain in pairs(GetScoreChains()) do
		
		local Bar = vgui.Create( "DHudBar" )
		
		if k == LocalPlayer() then // If you're the chain lead
			GAMEMODE:AddHUDItem( Bar, 8, prevbar )
			
			local chaintext = vgui.Create( "DHudElement" );
				chaintext:SizeToContents()
				chaintext:SetText( "CHAIN ("..chain.size..")" )
				chaintext:SetFont( "ScoreBig" )
				chaintext:SetColor( Color(255, 50, 50, 255) )
			Bar:AddItem( chaintext )
			
			local chaintimer = vgui.Create( "DHudUpdater" )
				chaintimer:SizeToContents()
				chaintimer:SetValueFunction( function() return math.ceil(math.max(0,chain.endtime-CurTime())) end )
				chaintimer:SetColorFunction( function() return Color(255,255,255,255) end )
			Bar:AddItem( chaintimer )
		else // If you're part of someone elses chain
			if ValidEntity(prevbar) then
				GAMEMODE:AddHUDItem( Bar, 2, prevbar )
			else
				GAMEMODE:AddHUDItem( Bar, 8 )
			end		
			
			local chaintext = vgui.Create( "DHudElement" );
				chaintext:SizeToContents()
				chaintext:SetText( "CHAIN ("..chain.size..")" )
				chaintext:SetFont( "ScoreMedium" )
				chaintext:SetColor( Color(255, 255, 255, 255) )
			Bar:AddItem( chaintext )	

			local chaintimer = vgui.Create( "DHudUpdater" )
				chaintimer:SizeToContents()
				chaintimer:SetValueFunction( function() return math.ceil(math.max(0,chain.endtime-CurTime())) end )
				chaintimer:SetColorFunction( function() return Color(255,255,255,255) end )
			Bar:AddItem( chaintimer )
		end
		
		prevbar = Bar
	
	end

end*/

function GM:PostDrawOpaqueRenderables()

	self:DrawPropTargetValue()
	self:DrawPlayerHints()
	
end

GM.LastTracedEntity = nil
function GM:DrawPropTargetValue()

	// Draw prop value
	local tr = utilx.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetCursorAimVector() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then 
		if ValidEntity(self.LastTracedEntity) then
			self.LastTracedEntity:RemoveEffects(EF_ITEM_BLINK)
			self.LastTracedEntity = nil
		end
		return 
	end

	if ValidEntity(self.LastTracedEntity) and self.LastTracedEntity != trace.Entity then
		self.LastTracedEntity:RemoveEffects(EF_ITEM_BLINK)
	end
	
	if (table.HasValue(propClasses,trace.Entity:GetClass())) then
		local prop = trace.Entity
		if self.LastTracedEntity != trace.Entity then
			self.LastTracedEntity = trace.Entity
			prop:AddEffects(EF_ITEM_BLINK)
		end
		
		local value = trace.Entity.Value or GetPropValue(trace.Entity)
		
		local TargetPos = prop:GetPos() + Vector(0,0,40)
		
		local TargetAngles = (LocalPlayer():EyePos()-TargetPos):Angle()
		TargetAngles:RotateAroundAxis(TargetAngles:Right(), 	-90)
		TargetAngles:RotateAroundAxis(TargetAngles:Up(), 		90)
		TargetAngles:RotateAroundAxis(TargetAngles:Forward(), 0)
		
		local color = team.GetColor(prop:TeamSide())

		cam.Start3D2D(TargetPos, TargetAngles, 0.5)
			draw.SimpleTextOutlined("Value: "..value, "ScoreBig", 0, 0, color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,COLOR_BLACK)
			if (prop:TeamSide() == LocalPlayer():Team()) then
				draw.SimpleTextOutlined("Defend!", "ScoreMedium", 0, 20, color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,COLOR_BLACK)
			else
				draw.SimpleTextOutlined("Break!", "ScoreMedium", 0, 20, color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,COLOR_BLACK)
			end
		cam.End3D2D() 
	end
	
end

GM.PlayerHints = {
	friend_assist = { "Assist!", "Friendly!", "Support!" },
	friend_shoot = { "Launch him!", "Send him flying!" }, 
	
	enemy_kill = { "Kick his ass!", "Whack him good!", "Kill him!" }
}
function GM:DrawPlayerHints()

	local players = {}
	local plmidpos = LocalPlayer():GetPos()+Vector(0,0,30)
	
	for k, v in pairs(ents.FindInSphere( plmidpos, 500 )) do
		// entity is player, and within view range of player
		local dis = v:GetPos()-plmidpos
		if v:IsPlayer() and v:Alive() and not v:IsAbsorbed() and dis:Dot(LocalPlayer():GetAimVector()) > 0.2 then
			tab = { pl = v, dist = dis:Length() }
			table.insert(players, tab)
		end
	end
	
	table.sort(players, function(a, b) return a.dist > b.dist end)
	
	for k, v in pairs(players) do

		local pl = v.pl
		local distance = v.dist
		local text = ""
		local index = 0
		
		if pl:HasAbsorbedPlayer() then
		
			local other_pl = pl:GetAbsorbedPlayer()
			text = "Absorbed player\n"..other_pl:Name()
		
		elseif pl:Team() != LocalPlayer():Team() then
			// Select a text based on their UserID
			index = pl:UserID() % table.Count(self.PlayerHints.enemy_kill) + 1
			text = self.PlayerHints.enemy_kill[index]
		else
			if pl:TeamSide() == pl:Team() then
				index = pl:UserID() % table.Count(self.PlayerHints.friend_shoot) + 1
				text = self.PlayerHints.friend_shoot[index]
			else
				index = pl:UserID() % table.Count(self.PlayerHints.friend_assist) + 1
				text = self.PlayerHints.friend_assist[index]
			end		
		end
		
		// Details, but I'm a perfectionist.
		if (pl:GetNWString("gender") == "female") then
			text = string.Replace( text, "his", "her" )
			text = string.Replace( text, "him", "her" )
		end
		
		if text != "" then
			local TargetPos = pl:GetPos() + Vector(0,0,75)
			
			local TargetAngles = (LocalPlayer():EyePos()-TargetPos):Angle()
			TargetAngles:RotateAroundAxis(TargetAngles:Right(), 	-90)
			TargetAngles:RotateAroundAxis(TargetAngles:Up(), 		90)
			TargetAngles:RotateAroundAxis(TargetAngles:Forward(), 0)
			
			local color = team.GetColor(pl:Team())
			color.a = math.min(255, math.max(0, 855-(distance * 2)))
			local color2 = Color(0,0,0,color.a)

			cam.Start3D2D(TargetPos, TargetAngles, 0.3)
				for k, v in pairs(string.Explode("\n",text)) do
					draw.SimpleTextOutlined(v, "ScoreMedium", 0, (k-1)*18, color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,color2)
				end
			cam.End3D2D() 	
		end
	end


end


GM.ScoreNotes = {}
// The lil' '+1' messages that pop up after someon breaks a prop
function GM:DrawScoreNotifications()

	local toremove = nil
	for k, note in pairs(self.ScoreNotes) do

		local subtract = math.min((CurTime()-note.time) * 20, 30)
		local color = team.GetColor(note.forteam)

		if note.forteam == TEAM_RED then
			draw.SimpleText("+"..note.val, "ScoreBig", 220, 40-subtract, color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
		end
		
		if note.forteam == TEAM_BLUE then 
			draw.SimpleText("+"..note.val, "ScoreBig", 220, 90-subtract, color,TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP)
		end
	
		if note.time + 3 < CurTime() then
			toremove = k
		end
		
	end
	
	if toremove != nil then
		table.remove(self.ScoreNotes, toremove)
	end
	
end

local PropsDrawing = {}
function GM:DrawPropsBrokenChain() 

	if not GAMEMODE.YourPropsBrokenChain then return end
	
	local num_drawing = table.Count(PropsDrawing)
	local num_chain = table.Count(GAMEMODE.YourPropsBrokenChain)
	
	if num_chain == 0 and num_drawing > 0 then
		for k, v in pairs(PropsDrawing) do
			v:Remove()
		end
		PropsDrawing = {}
	end
	
	local visible = (RoundResult == 0 and LocalPlayer():Alive())
	for k, v in pairs(PropsDrawing) do
		v:SetVisible(visible)
	end

	if num_drawing > 0 then
		draw.SimpleText( "Props broken:", "ScoreSmall", 32, 174, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	end
	
	if num_drawing < num_chain then
		local propmodel = vgui.Create("DModelPanel")
		propmodel:SetPos( 32 + (num_drawing % 8) * 54, 190 + math.floor(num_drawing/8) * 54 ) 
		propmodel:SetSize( 50, 50 )
		propmodel:SetCamPos( Vector( 40, 40, 40 ) )
		propmodel:SetLookAt( Vector( 0, 0, 0 ) )
		propmodel:SetAnimSpeed( 0 )
		propmodel:SetModel( GAMEMODE.YourPropsBrokenChain[num_chain] )
		table.insert(PropsDrawing, propmodel)
	end
	
end


function GM:DrawScoreResults()

	local timerec = self.ScoresReceived

	if timerec < CurTime() - 30 then // Must mean it's still old data
		return
	end
	
	local sw = ScrW()
	local sh = ScrH()
	local w = sw/1.4
	local h = 32
	
	local scores = {}
	if (timerec < CurTime() - 2) then table.insert(scores, { "Most points scored by: ", scoreinfo.MostPoints } ) end
	if (timerec < CurTime() - 2.5) then table.insert(scores, { "Most assists points by: ", scoreinfo.MostAssistPoints } ) end
	if (timerec < CurTime() - 3) then table.insert(scores, { "Most props broken by: ", scoreinfo.MostPropsBroken } ) end
	if (timerec < CurTime() - 3.5) then table.insert(scores, { "Most players launched by: ", scoreinfo.MostPlayersLaunched } ) end
	if (timerec < CurTime() - 4) then table.insert(scores, { "Most players killed by: ", scoreinfo.MostKills } ) end
	if (timerec < CurTime() - 4.5) then table.insert(scores, { "Most fall damage taken by: ", scoreinfo.MostFallDamage } ) end
	if (timerec < CurTime() - 5) then table.insert(scores, { "Most props broken in a life: ", scoreinfo.PropsBrokenChainRecord } ) end
	//if (timerec < CurTime() - 4.5) then table.insert(scores, { "Longest score chain by: ", scoreinfo.LongestChain, "chain" } ) end
	
	for k, v in ipairs(scores) do
		draw.RoundedBox( 6, sw/2-w/2, sh/2-40*3.5+40*k, w, h, Color(0,0,0,180) )
		draw.SimpleText( v[1], "ScoreBig", sw/2-300, sh/2-40*3.5+40*k+h/2, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		if v[2] then
			if v[3] and v[3] == "chain" then
				// Code for displaying score chains, not used right now
				local chainstr = "n/a"
				for i, j in pairs(v[2].players) do
					local str = ", "
					if i == 1 then 
						chainstr = "" 
						str = ""
					end
					chainstr = chainstr..str..j
				end
				draw.SimpleText( chainstr, "ScoreBig", sw/2+30, sh/2-40*3.5+40*k+h/2, team.GetColor(v[2].team), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			else
				draw.SimpleText( tostring(v[2].player).." ("..tostring(v[2].score)..")", "ScoreBig", sw/2+30, sh/2-40*3.5+40*k+h/2, team.GetColor(v[2].team), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		end
	end	
	
end