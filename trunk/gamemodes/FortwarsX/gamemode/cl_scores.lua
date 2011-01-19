
//Fixed Kills and Deaths being too close to eachother

function GM:AddScoreboardKills( ScoreBoard )

	local f = function( ply ) return ply:Frags() end
	ScoreBoard:AddColumn( "Kills", /*50*/nil, f, 0.5, nil, 6, 6 ) 

end

function GM:AddScoreboardDeaths( ScoreBoard )

	local f = function( ply ) return ply:Deaths() end
	ScoreBoard:AddColumn( "Deaths", /*50*/nil, f, 0.5, nil, 6, 6 )

end

function GM:AddScoreboardPing( ScoreBoard )

	local f = function( ply ) return ply:Ping() end
	ScoreBoard:AddColumn( "Ping", /*50*/nil, f, 0.1, nil, 6, 6 )

end
