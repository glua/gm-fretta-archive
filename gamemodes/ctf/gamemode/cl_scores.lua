function GM:AddScoreboardCaptures( ScoreBoard )

	local f = function( ply ) return ply:GetNetworkedInt( "Captures", 0 ) end
	ScoreBoard:AddColumn( "Captures", 50, f, 0.1, nil, 6, 6 )

end

function GM:PositionScoreboard( ScoreBoard )

	if ( GAMEMODE.TeamBased ) then
		ScoreBoard:SetSize( 800, ScrH() - 50 )
		ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) * 0.5,  25 )
	else
		ScoreBoard:SetSize( 400, ScrH() )
		ScoreBoard:SetPos( 100, 0 )
	end

end

function GM:CreateScoreboard( ScoreBoard )

	ScoreBoard:SetAsBullshitTeam( TEAM_SPECTATOR )
	ScoreBoard:SetAsBullshitTeam( TEAM_CONNECTING )
	
	if ( GAMEMODE.TeamBased ) then
		ScoreBoard:SetAsBullshitTeam( TEAM_UNASSIGNED )
		ScoreBoard:SetHorizontal( true )
	end

	ScoreBoard:SetSkin( "SimpleSkin" )

	self:AddScoreboardAvatar( ScoreBoard )		// 1
	self:AddScoreboardSpacer( ScoreBoard, 8 )	// 2
	self:AddScoreboardName( ScoreBoard )		// 3
	
	self:AddScoreboardKills( ScoreBoard )		// 4
	self:AddScoreboardCaptures( ScoreBoard )	// 5
	self:AddScoreboardDeaths( ScoreBoard )		// 6
	self:AddScoreboardPing( ScoreBoard )		// 7
	
		
	// Here we sort by these columns (and descending), in this order. You can define up to 4
	ScoreBoard:SetSortColumns( { 4, true, 5, true, 3, false } )

end
