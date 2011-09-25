
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
local Vehicle = NULL
local Cash = 0

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
	if ( Vehicle != LocalPlayer():GetNWEntity( "Car", nil ) ) then return true end
	
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
	Vehicle = LocalPlayer():GetNWEntity( "Car", nil )
	
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
	elseif ( IsObserver && LocalPlayer():Team() == TEAM_SPECTATOR ) then
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

function SetHUDNotice( msg )

	if GAMEMODE.Notice then return end

	GAMEMODE.Notice = {}
	
	GAMEMODE.Notice.Text = msg:ReadString()
	GAMEMODE.Notice.Duration = CurTime() + msg:ReadShort()
	GAMEMODE.Notice.Color = Color( msg:ReadShort(), msg:ReadShort(), msg:ReadShort(), 255 )
	GAMEMODE.Notice.Alpha = 255
	GAMEMODE.Notice.Pos = -25
	
end
usermessage.Hook( "Notice", SetHUDNotice )

function GM:OnHUDPaint()

	if GAMEMODE.Notice then
	
		draw.SimpleTextOutlined( GAMEMODE.Notice.Text, "GtaNotice", ScrW() * 0.50, GAMEMODE.Notice.Pos, 
			GAMEMODE.Notice.Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, Color( 10, 10, 10, GAMEMODE.Notice.Alpha ) ) 
	
		if GAMEMODE.Notice.Duration < CurTime() then
			
			if GAMEMODE.Notice.Alpha < 1 then
				
				if GAMEMODE.Notice.Color.a < 2 then
					GAMEMODE.Notice = nil
				else
					GAMEMODE.Notice.Color.a = GAMEMODE.Notice.Color.a - 2
				end
				
			else
				GAMEMODE.Notice.Alpha = GAMEMODE.Notice.Alpha - 1
			end
			
			return
			
		end
	
		if GAMEMODE.Notice.Pos < ScrH() * 0.15 then
			GAMEMODE.Notice.Pos = GAMEMODE.Notice.Pos + 2
		end
	
	end
	
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
	
	// Open splash screen results
	GAMEMODE:ShowEndGameStats( RoundResult )

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

	if ValidEntity( LocalPlayer():GetNWEntity( "Car", nil ) ) then
	
		GAMEMODE:PaintArmor()
	
	else
		
		GAMEMODE:PaintHealth()
		GAMEMODE:PaintAmmo()
		
	end	

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
				TeamIndicator:SetFont( "HudSelectionText" )
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

		end
		
	end

end

function GM:PaintArmor()
	
	local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 1 )
		
	local HealthIndicator = vgui.Create( "DHudUpdater" )
		HealthIndicator:SizeToContents()
		HealthIndicator:SetValueFunction( function() if ValidEntity( LocalPlayer():GetNWEntity( "Car", nil ) ) then 
												return LocalPlayer():GetNWEntity( "Car", nil ):GetNWInt( "Health", 1 ) 
												else Vehicle = 0 return 1
												end end  )
		HealthIndicator:SetLabel( "ARMOR" )
		HealthIndicator:SetFont( "FHUDElement" )
		
	Bar:AddItem( HealthIndicator )
	
	local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 3 )
	
	local CashIndicator = vgui.Create( "DHudUpdater" )
		CashIndicator:SizeToContents()
		CashIndicator:SetValueFunction( function()
											Cash = math.Approach( Cash, LocalPlayer():GetNWInt( "Cash", 0 ), 1 )
											return Cash 
										end )
		CashIndicator:SetLabel( "CASH" )
		CashIndicator:SetFont( "FHUDElement" )
	
	Bar:AddItem( CashIndicator )

end

function GM:PaintAmmo()

	local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 3 )

	local AmmoIndicator = vgui.Create( "DHudUpdater" )
		AmmoIndicator:SizeToContents()
		AmmoIndicator:SetValueFunction( function()
											if ValidEntity( LocalPlayer():GetActiveWeapon() ) then
												return LocalPlayer():GetActiveWeapon():Clip1()
											end
											return 0
										end )
		AmmoIndicator:SetLabel( "AMMO" )
		AmmoIndicator:SetFont( "FHUDElement" )
		
	Bar:AddItem( AmmoIndicator )
	
	if LocalPlayer():Team() != TEAM_GANG then return end
		
	local CashIndicator = vgui.Create( "DHudUpdater" )
		CashIndicator:SizeToContents()
		CashIndicator:SetValueFunction( function()
											Cash = math.Approach( Cash, LocalPlayer():GetNWInt( "Cash", 0 ), 1 )
											return Cash 
										end )
		CashIndicator:SetLabel( "CASH" )
		CashIndicator:SetFont( "FHUDElement" )
	
	Bar:AddItem( CashIndicator )

end

function GM:PaintHealth()
	
	local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 1 )
		
	local HealthIndicator = vgui.Create( "DHudUpdater" )
		HealthIndicator:SizeToContents()
		HealthIndicator:SetValueFunction( function() return LocalPlayer():Health() end )
		HealthIndicator:SetColorFunction( function() 
											if LocalPlayer():Health() <= 25 then
												return Color( 255, 100 + math.sin( RealTime() * 3 ) * 100, 100 + math.sin( RealTime() * 3 ) * 100, 255 )	
											end
											return Color( 255, 255, 255, 255 )
										end )
		HealthIndicator:SetLabel( "HEALTH" )
		HealthIndicator:SetFont( "FHUDElement" )
		
	Bar:AddItem( HealthIndicator )

end

function GM:UpdateHUD_AddedTime( iTimeAdded )
	// to do or to override, your choice
end
usermessage.Hook( "RoundAddedTime", function( um ) if( GAMEMODE && um ) then GAMEMODE:UpdateHUD_AddedTime( um:ReadFloat() ) end end )

function GM:AddScoreboardCash( ScoreBoard )

	local f = function( ply ) return ply:GetNWInt( "Cash", 0 ) end
	ScoreBoard:AddColumn( "Cash", 50, f, 0.1, nil, 6, 6 )

end

function GM:CreateScoreboard( ScoreBoard )

	ScoreBoard:SetAsBullshitTeam( TEAM_SPECTATOR )
	ScoreBoard:SetAsBullshitTeam( TEAM_CONNECTING )
	
	if ( GAMEMODE.TeamBased ) then
		ScoreBoard:SetAsBullshitTeam( TEAM_UNASSIGNED )
		ScoreBoard:SetHorizontal( true )
	end

	ScoreBoard:SetSkin( "SimpleSkin" )

	self:AddScoreboardAvatar( ScoreBoard )		
	self:AddScoreboardSpacer( ScoreBoard, 8 )	
	self:AddScoreboardName( ScoreBoard )		
	self:AddScoreboardCash( ScoreBoard )		
	self:AddScoreboardKills( ScoreBoard )		
	self:AddScoreboardDeaths( ScoreBoard )		
	self:AddScoreboardPing( ScoreBoard )		
		
	// Here we sort by these columns (and descending), in this order. You can define up to 4
	ScoreBoard:SetSortColumns( { 4, true, 5, false, 3, false } )

end
