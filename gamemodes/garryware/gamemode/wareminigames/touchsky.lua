WARE.Author = "Kelth"

function WARE:IsPlayable()
	if team.NumPlayers(TEAM_HUMANS) >= 2 then
		return true
	end
	return false
end

function WARE:Initialize()
	GAMEMODE:EnableFirstFailAward( )
	GAMEMODE:SetFailAwards( AWARD_VICTIM )
	GAMEMODE:SetWareWindupAndLength(2,6)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Stay on the ground!" )
	
	local entover = GAMEMODE:GetRandomLocations(1, ENTS_OVERCRATE)[1]:GetPos().z
	local entsky = GAMEMODE:GetRandomLocations(1, ENTS_INAIR)[1]:GetPos().z
	
	self.zsky = (entover + entsky)/2
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Don't reach the sky!" )
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "sware_velocitygun" )
	end
	for k,v in pairs(player.GetAll()) do 
		v:SetGravity(-0.1)
	end
end

function WARE:EndAction()
	for k,v in pairs(player.GetAll()) do 
		v:SetGravity(1)
	end
end

function WARE:Think( )
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		if v:GetPos().z > self.zsky then
			v:ApplyLose( )
		end
	end
end
