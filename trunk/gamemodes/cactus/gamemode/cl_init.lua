
include( 'shared.lua' )
include( 'admin.lua' )

function GM:AddScoreboardKills( ScoreBoard )

	local f = function( ply ) return ply:Frags() end
	ScoreBoard:AddColumn( "Points", 60, f, 0.5, nil, 6, 6 )
	
	local g = function( ply ) return ply:GetNWInt("normalcacticaught") end
	ScoreBoard:AddColumn( "", 16 ) // Gap
	ScoreBoard:AddColumn( "Normal Cacti", 70, g, 0.5, nil, 6, 6 )
	
	local h = function( ply ) return ply:GetNWInt("slowcacticaught") end
	ScoreBoard:AddColumn( "", 16 ) // Gap
	ScoreBoard:AddColumn( "Slow Cacti", 60, h, 0.5, nil, 6, 6 )
	
	local i = function( ply ) return ply:GetNWInt("fastcacticaught") end
	ScoreBoard:AddColumn( "", 16 ) // Gap
	ScoreBoard:AddColumn( "Fast Cacti", 60, i, 0.5, nil, 6, 6 )
	
	local j = function( ply ) return ply:GetNWInt("powerupcacticaught") end
	ScoreBoard:AddColumn( "", 16 ) // Gap
	ScoreBoard:AddColumn( "Powerup Cacti", 60, j, 0.5, nil, 6, 6 )
	
	local k = function( ply ) return ply:GetNWInt("goldencacticaught") end
	ScoreBoard:AddColumn( "", 16 ) // Gap
	ScoreBoard:AddColumn( "Golden Cacti", 60, k, 0.5, nil, 6, 6 )
	
	local l = function( ply ) return ply:GetNWInt("totalcacticaught") end
	ScoreBoard:AddColumn( "", 16 ) // Gap
	ScoreBoard:AddColumn( "Total Cacti", 60, l, 0.5, nil, 6, 6 )

end
function GM:AddScoreboardDeaths( ScoreBoard )
	return false
end

/*function GM:ShowSplash()
	self.BaseClass:ShowSplash()
end*/
