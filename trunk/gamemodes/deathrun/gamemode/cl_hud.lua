function GM:UpdateHUD_Alive( InRound )
	self.BaseClass:UpdateHUD_Alive()
	GAMEMODE:PaintHealth()
	GAMEMODE:PaintAmmo()
end

function GM:PaintHealth()
	
	local Bar = vgui.Create( "DHudBar" )
		GAMEMODE:AddHUDItem( Bar, 1 )
		
	local HealthIndicator = vgui.Create( "DHudUpdater" )
		HealthIndicator:SizeToContents()
		HealthIndicator:SetValueFunction( function()
											return LocalPlayer():Health()
										end )
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
		AmmoIndicator:SetColorFunction( function() 
											if ValidEntity( LocalPlayer():GetActiveWeapon() ) then
												if LocalPlayer():GetActiveWeapon():Clip1() <= 1 then
													return Color( 255, 100 + math.sin( RealTime() * 3 ) * 100, 100 + math.sin( RealTime() * 3 ) * 100, 255 )	
												end
											end
											return Color( 255, 255, 255, 255 )
										end )
		AmmoIndicator:SetLabel( "AMMO" )
		AmmoIndicator:SetFont( "FHUDElement" )
		
	local AmountIndicator = vgui.Create( "DHudUpdater" )
		AmountIndicator:SizeToContents()
		AmountIndicator:SetValueFunction( function()
											if ValidEntity( LocalPlayer():GetActiveWeapon() ) then
												return LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
											end
											return 0
										end )
		AmountIndicator:SetLabel( "TOTAL" )
		AmountIndicator:SetFont( "FHUDElement" )
		
	Bar:AddItem( AmmoIndicator )
	Bar:AddItem( AmountIndicator )

end

function GM:AddScoreboardWins( ScoreBoard )

	local f = function( ply ) return tonumber(ply:GetNWInt("Drun_Wins",0)) end
	ScoreBoard:AddColumn( "Wins", 50, f, 1, nil, 6, 6 )

end

--[[function GM:AddScoreboardMoney( ScoreBoard )

	local f = function( ply ) return tonumber(ply:GetNWInt("Drun_Money",0)) end
	ScoreBoard:AddColumn( "Cash", 50, f, 1, nil, 6, 6 )

end]]

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
	self:AddScoreboardWins( ScoreBoard )
	-- self:AddScoreboardMoney( ScoreBoard )	
	self:AddScoreboardKills( ScoreBoard )		
	self:AddScoreboardDeaths( ScoreBoard )		
	self:AddScoreboardPing( ScoreBoard )		
		
	// Here we sort by these columns (and descending), in this order. You can define up to 4
	ScoreBoard:SetSortColumns( { 4, true, 5, false, 3, false } )

end

local function HideHUD(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudPoisonDamageIndicator", "CHudVoiceStatus", "CHudVoiceSelfStatus" } do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw","HideHUD",HideHUD)