
surface.CreateFont( "Tahoma", 18, 600, true, false, "ModeFont" )
surface.CreateFont( "Tahoma", 14, 600, true, false, "ScoreFont" )

local hudScreen = nil
local Alive = false
local Team = 0
local WaitingToRespawn = false
local InRound = false
local RoundResult = 0
local IsObserver = false
local ObserveMode = 0
local ObserveTarget = NULL
local InVote = false

function GM:AddHUDItem( item, pos, parent )
	hudScreen:AddItem( item, parent, pos )
end

function GM:HUDNeedsUpdate()

	if ( !IsValid( LocalPlayer() ) ) then return false end

	if ( Alive != LocalPlayer():Alive() ) then return true end
	if ( Team != LocalPlayer():Team() ) then return true end
	if ( WaitingToRespawn != ( (LocalPlayer():GetNWFloat( "RespawnTime", 0 ) > CurTime()) && LocalPlayer():Team() != TEAM_SPECTATOR && !LocalPlayer():Alive()) ) then return true end
	if ( InRound != GetGlobalBool( "InRound", false ) ) then return true end
	if ( RoundResult != GetGlobalInt( "RoundResult", 0 ) ) then return true end
	if ( IsObserver != LocalPlayer():IsObserver() ) then return true end
	if ( ObserveMode != LocalPlayer():GetObserverMode() ) then return true end
	if ( ObserveTarget != LocalPlayer():GetObserverTarget() ) then return true end
	if ( InVote != GAMEMODE:InGamemodeVote() ) then return true end
	
	return false
end

function GM:OnHUDUpdated()
	Alive = LocalPlayer():Alive()
	Team = LocalPlayer():Team()
	WaitingToRespawn = (LocalPlayer():GetNWFloat( "RespawnTime", 0 ) > CurTime()) && LocalPlayer():Team() != TEAM_SPECTATOR && !Alive
	InRound = GetGlobalBool( "InRound", false )
	RoundResult = GetGlobalInt( "RoundResult", 0 )
	IsObserver = LocalPlayer():IsObserver()
	ObserveMode = LocalPlayer():GetObserverMode()
	ObserveTarget = LocalPlayer():GetObserverTarget()
	InVote = GAMEMODE:InGamemodeVote()
end

function GM:RefreshHUD()

	if ( !GAMEMODE:HUDNeedsUpdate() ) then return end
	GAMEMODE:OnHUDUpdated()
	
	if ( IsValid( hudScreen ) ) then hudScreen:Remove() end
	hudScreen = vgui.Create( "DHudLayout" )
	
	if ( InVote ) then return end
	
	if ( RoundResult != 0 ) then
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

function GM:UpdateHUD_RoundResult( RoundResult, Alive )

	local txt = "Round Over"
	if ( RoundResult == ROUND_RESULT_DRAW ) then txt = "Draw! Everyone Loses!" end
	if ( RoundResult == ROUND_RESULT_OUT_OF_TIME ) then txt = "Out of Time!" end
	
	if ( team.GetAllTeams()[ RoundResult ] ) then
		local TeamName = team.GetName( RoundResult )
		if ( TeamName ) then txt = TeamName .. " Wins!" end
	end

	local RespawnText = vgui.Create( "DHudElement" );
		RespawnText:SizeToContents()
		RespawnText:SetText( txt )
	GAMEMODE:AddHUDItem( RespawnText, 8 )

end

function GM:UpdateHUD_Observer( bWaitingToSpawn, InRound, ObserveMode, ObserveTarget )

	local lbl = nil
	local txt = nil

	if ( IsValid( ObserveTarget ) && ObserveTarget:IsPlayer() && ObserveTarget != LocalPlayer() && ObserveMode != OBS_MODE_ROAMING ) then
		lbl = "SPECTATING"
		txt = ObserveTarget:Nick()
	end
	
	if ( ObserveMode == OBS_MODE_DEATHCAM || ObserveMode == OBS_MODE_FREEZECAM ) then
		txt = "You Died!" // were killed by?
	end
	
	if ( txt ) then
		local txtLabel = vgui.Create( "DHudElement" );
		txtLabel:SetText( txt )
		if ( lbl ) then txtLabel:SetLabel( lbl ) end
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

function TimeFormat( time )

    local seconds = math.floor( time % 60 )
	local minutes = math.floor( time / 60 ) % 60
	local formatted = "00:00"
	
	if minutes < 10 then
		formatted = "0"..minutes..":"
	else
		formatted = minutes..":"
	end
	
	if seconds < 10 then
		formatted = formatted.."0"..seconds
	else
		formatted = formatted..seconds
	end
   
    return formatted
	
end

function GM:UpdateHUD_Alive( InRound )

	GAMEMODE:PaintAmmo()
	GAMEMODE:PaintHealth()
	
	local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 8 )
		
	local RedScore = vgui.Create( "DHudUpdater" )
		RedScore:SizeToContents()
		RedScore:SetValueFunction( function() 
										return TimeFormat( GetGlobalInt( "TeamScore"..TEAM_RED ) )
									end )
		RedScore:SetColorFunction( function() 
										return team.GetColor( TEAM_RED )
									end )
		RedScore:SetFont( "ScoreFont" )
		
	local BlueScore = vgui.Create( "DHudUpdater" )
		BlueScore:SizeToContents()
		BlueScore:SetValueFunction( function() 
										return TimeFormat( GetGlobalInt( "TeamScore"..TEAM_BLUE ) )
									end )
		BlueScore:SetColorFunction( function() 
										return team.GetColor( TEAM_BLUE )
									end )
		BlueScore:SetFont( "ScoreFont" )
		
	Bar:AddItem( RedScore )
	Bar:AddItem( BlueScore )

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

function GM:PaintAmmo()

	local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 3 )

	local AmmoIndicator = vgui.Create( "DHudUpdater" )
		AmmoIndicator:SizeToContents()
		AmmoIndicator:SetValueFunction( function()
											if ValidEntity( LocalPlayer():GetActiveWeapon() ) then
												return LocalPlayer():GetActiveWeapon():Clip1() or 0
											end
											return 0
										end )
		AmmoIndicator:SetLabel( "AMMO" )
		AmmoIndicator:SetFont( "FHUDElement" )
		
	Bar:AddItem( AmmoIndicator )
		
	local ModeIndicator = vgui.Create( "DHudUpdater" )
		ModeIndicator:SizeToContents()
		ModeIndicator:SetValueFunction( function()
											if ValidEntity( LocalPlayer():GetActiveWeapon() ) then
												if LocalPlayer():GetActiveWeapon().Firemodes then
													return LocalPlayer():GetActiveWeapon().Firemodes[ LocalPlayer():GetActiveWeapon():GetNWInt("Firemode",1) ]
												end
											end
											return "Primary Fire"
										end )
		ModeIndicator:SetFont( "ModeFont" )
		
	Bar:AddItem( ModeIndicator )

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


function GM:AddScoreboardTime( ScoreBoard )

	local f = function( ply ) return ply:GetNWInt("Time",0) end
	ScoreBoard:AddColumn( "Time", 50, f, 0.1, nil, 6, 6 )

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
	self:AddScoreboardTime( ScoreBoard )		
	self:AddScoreboardKills( ScoreBoard )		
	self:AddScoreboardDeaths( ScoreBoard )		
	self:AddScoreboardPing( ScoreBoard )		
		
	// Here we sort by these columns (and descending), in this order. You can define up to 4
	ScoreBoard:SetSortColumns( { 4, true, 5, false, 3, false } )

end