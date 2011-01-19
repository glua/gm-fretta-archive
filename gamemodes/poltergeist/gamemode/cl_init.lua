include( 'shared.lua' )
include( 'cl_hud.lua' )

function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

function GM:HUDShouldDraw( name )

	if GAMEMODE.ScoreboardVisible then return false end
	
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end 
  	end 
	
	if name == "CHudDamageIndicator" and not LocalPlayer():Alive() then
		return false
	end
	
	return true
	
end

function GM:PlayerBindPress( pl, bind, down )

	// Redirect binds to the spectate system
	if ( pl:Team() == TEAM_SPECTATOR && pl:IsObserver() && down ) then
	
		if ( bind == "+jump" ) then 	RunConsoleCommand( "spec_mode" )	end
		if ( bind == "+attack" ) then	RunConsoleCommand( "spec_next" )	end
		if ( bind == "+attack2" ) then	RunConsoleCommand( "spec_prev" )	end
		
	end
	
	return false	
	
end

function GM:HUDDrawTargetID()
	return false
end
