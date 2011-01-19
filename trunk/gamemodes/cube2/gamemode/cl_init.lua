include( "shared.lua" );
include( "cl_hud.lua" );
include( "cl_gib.lua" );
include( "cl_miclimit.lua" );
include( "cl_effects.lua" );

language.Add( "trigger_cube_redshift", "Cube shift" );
language.Add( "trigger_cube_blueshift", "Cube shift" );
language.Add( "trigger_cube_cyanshift", "Cube shift" );
language.Add( "trigger_cube_greenshift", "Cube shift" );
language.Add( "trigger_cube_orangeshift", "Cube shift" );
language.Add( "trigger_cube_whiteshift", "Cube shift" );
language.Add( "trigger_cube_yellowshift", "Cube shift" );
language.Add( "func_door", "Hazard" );
language.Add( "func_tracktrain", "Moving cubes" );
language.Add( "cube_flashflame", "Microwave trap" );
language.Add( "cube_flashfreeze", "Freezer trap" );
language.Add( "trigger_cube_acid", "Acid trap" );
language.Add( "func_movelinear", "Hazard" );
language.Add( "weapon_suicidegun", "Suicide Gun" );
language.Add( "env_fire", "Fire" );

CamOverridePos = Vector( 0, 0, 0 );
CamOverrideAng = Angle( 0, 0, 0 );

function GM:AddScoreboardKills( ScoreBoard )
	
	local f = function( ply ) return string.ToMinutesSecondsMilliseconds( ply:GetNWInt( "BestTime" ) ) end
	ScoreBoard:AddColumn( "Best Time", 100, f, 3, nil, 6, 6 )
	
end
