WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "empty"

function WARE:Initialize()

	self.IsTrap = (math.random(0,10) <= 3)
	if not self.IsTrap then
		GAMEMODE:SetWareWindupAndLength(2, math.Rand(1.3, 5.0))
		GAMEMODE:SetWinAwards( AWARD_REFLEX )
		
	else
		GAMEMODE:SetWareWindupAndLength(2, math.Rand(1.3, 2.5))
		GAMEMODE:SetFailAwards( AWARD_VICTIM )
		
	end
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "When clock reaches zero..." )
	
	self.zcap = GAMEMODE:GetRandomLocations(1, "dark_ground")[1]:GetPos().z + 96

	return
end

function WARE:StartAction()
	if not self.IsTrap then
		GAMEMODE:DrawInstructions( "Be high in the air!" )
		
	else
		GAMEMODE:DrawInstructions( "Stay on the ground!" )
		
	end
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
		v:Give( "sware_rocketjump_limited" )
	end
	
	return
end

function WARE:EndAction()

end


function WARE:Think( )
	for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do
		if not self.IsTrap then
			ply:SetAchievedNoLock( ply:GetPos().z > self.zcap )
		
		else
			ply:SetAchievedNoLock( ply:GetPos().z < self.zcap )
			
		end
		
	end
end
