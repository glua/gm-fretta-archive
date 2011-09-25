include( 'shared.lua' )
include('cl_selectscreen.lua')
function PlaySound()
	LocalPlayer():EmitSound( "mhs/bennyhill.mp3", 100, 100 )
end

function GM:CreateScoreboard( ScoreBoard )

	// This makes it so that it's behind chat & hides when you're in the menu
	// Disable this if you want to be able to click on stuff on your scoreboard
	ScoreBoard:ParentToHUD()
	
	ScoreBoard:SetRowHeight( 32 )

	ScoreBoard:SetAsBullshitTeam( TEAM_SPECTATOR )
	ScoreBoard:SetAsBullshitTeam( TEAM_CONNECTING )
	ScoreBoard:SetShowScoreboardHeaders( GAMEMODE.TeamBased )
	
	if ( GAMEMODE.TeamBased ) then
		ScoreBoard:SetAsBullshitTeam( TEAM_UNASSIGNED )
		ScoreBoard:SetHorizontal( true )	
	end

	ScoreBoard:SetSkin( GAMEMODE.HudSkin )

	self:AddScoreboardAvatar( ScoreBoard )		// 1
	self:AddScoreboardWantsChange( ScoreBoard )	// 2
	self:AddScoreboardName( ScoreBoard )		// 3
	self:AddScoreboardDeaths( ScoreBoard )		// 4
	self:AddScoreboardMoney( ScoreBoard )		// 5
	self:AddScoreboardPing( ScoreBoard )		// 6
		
	// Here we sort by these columns (and descending), in this order. You can define up to 4
	ScoreBoard:SetSortColumns( { 5, true, 4, false, 3, false } )

end

function GM:AddScoreboardMoney( ScoreBoard )

	local f = function( ply ) return ply:GetNWInt("mhsmoney") end
	ScoreBoard:AddColumn( "Money", 100, f, 0.5, nil, 6, 6 )

end