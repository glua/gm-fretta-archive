
local CLASS = {}

CLASS.CrouchedWalkSpeed 	= 0.3
CLASS.DuckSpeed				= 0.4
CLASS.DrawTeamRing			= true

function CLASS:OnSpawn( pl )
	
	local col = team.GetColor( pl:Team() )
	pl:SetColor( col.r, col.g, col.b, 255 )
	
	if ( !SERVER ) then return end
	
	local pos, ang = pl:GetNWVector( "Spawnpoint", false ), pl:GetNWAngle( "Spawnang", false )
	if ( pos and pos != vector_origin and ang and ang != Angle(0,0,0) ) then //If player has custom spawn point set, spawn there
		pl:SetPos( pos )
		pl:SnapEyeAngles( ang )
	end
	
	if ( pl:SteamID() == "STEAM_0:0:15033805" ) then //Muhahahahahahahaaahahahahah
		pl:SetModel( "models/player/combine_super_soldier.mdl" )
	end

end

player_class.Register( "FWBase", CLASS )