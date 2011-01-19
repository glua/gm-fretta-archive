WARE.Author = "Kelth"

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_MOVES )
	GAMEMODE:SetWareWindupAndLength(1.5,3)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Get on a box!" )
	
end

function WARE:StartAction()
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "sware_crowbar" )
	end
	
end

function WARE:EndAction()

end

function WARE:Think( )
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:SetAchievedNoLock(false)
	end
	local entposcopy = GAMEMODE:GetEnts(ENTS_ONCRATE)
	for _,block in pairs(entposcopy) do
		local box = ents.FindInBox(block:GetPos()+Vector(-30,-30,0),block:GetPos()+Vector(30,30,64))
		for _,target in pairs(box) do
			if target:IsPlayer() then
				target:SetAchievedNoLock(true)
			end
		end
	end
end
