
function GM:AddScoreboardDelivers( ScoreBoard )

	local f = function( ply ) return ply:GetNWInt( "P_Delivery" ) end
	ScoreBoard:AddColumn( "Delivered", 50, f, 0.5, nil, 6, 6 )

end

function GM:AddScoreboardSteals( ScoreBoard )

	local f = function( ply ) return ply:GetNWInt( "P_Steals" ) end
	ScoreBoard:AddColumn( "Stolen", 50, f, 0.5, nil, 6, 6 )

end

function GM:AddScoreboardKills( ScoreBoard )

	local f = function( ply ) return ( ply:Frags() - ply:Deaths() ) end
	ScoreBoard:AddColumn( "Score", 50, f, 0.5, nil, 6, 6 )

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
	self:AddScoreboardDelivers( ScoreBoard )	// 4
	self:AddScoreboardSteals( ScoreBoard )		// 5
	self:AddScoreboardKills( ScoreBoard )		// 6
	self:AddScoreboardPing( ScoreBoard )		// 7
		
	// Here we sort by these columns (and descending), in this order. You can define up to 4
	ScoreBoard:SetSortColumns( { 4, true, 5, true, 6, true, 3, false } )

end
