WARE.Author = "Hurricaaane (Ha3)"

function WARE:Initialize()
	GAMEMODE:SetFailAwards( AWARD_VICTIM )
	GAMEMODE:SetWareWindupAndLength(3.5,2)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Don't move!" )
	return
end

function WARE:StartAction()
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "sware_crowbar" )
	end
	return
end

function WARE:EndAction()

end

function WARE:Think( )
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		if (v:GetVelocity():Length() > 16) then
			v:ApplyLose( )
			v:SimulateDeath( v:GetVelocity() * 10^3 )
			v:EjectWeapons(nil, 120)
		end
	end
end
