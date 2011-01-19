
function GM:AddScoreboardPoints( ScoreBoard )
	
	local f = function( pl ) return pl:GetPoints() end
	//Reference: PANEL:AddColumn( Name, iFixedSize, fncValue, UpdateRate, TeamID, HeaderAlign, ValueAlign, Font )
	ScoreBoard:AddColumn( "Points", 70, f, 0.5, nil, 6, 6 )

end

function GM:AddScoreboardAssistPoints( ScoreBoard )

	local f = function( pl ) return pl:GetAssistPoints() end
	ScoreBoard:AddColumn( "Assist", 70, f, 0.5, nil, 6, 6 )

end

function GM:CreateScoreboard( ScoreBoard )

	// This makes it so that it's behind chat & hides when you're in the menu
	// Disable this if you want to be able to click on stuff on your scoreboard
	ScoreBoard:ParentToHUD()
	
	ScoreBoard:SetRowHeight( 32 )

	ScoreBoard:SetAsBullshitTeam( TEAM_SPECTATOR )
	ScoreBoard:SetAsBullshitTeam( TEAM_CONNECTING )
	ScoreBoard:SetShowScoreboardHeaders( GAMEMODE.TeamBased )
	

	ScoreBoard:SetAsBullshitTeam( TEAM_UNASSIGNED )
	ScoreBoard:SetHorizontal( true )	

	ScoreBoard:SetSkin( GAMEMODE.HudSkin )

	self:AddScoreboardAvatar( ScoreBoard )		// 1
	self:AddScoreboardWantsChange( ScoreBoard )	// 2
	self:AddScoreboardName( ScoreBoard )		// 3
	self:AddScoreboardPoints( ScoreBoard )		// 4
	self:AddScoreboardAssistPoints( ScoreBoard )// 5
	self:AddScoreboardPing( ScoreBoard )		// 6
		
	// Here we sort by these columns (and descending), in this order. You can define up to 4
	ScoreBoard:SetSortColumns( { 4, true, 5, true, 3, false } )

end
