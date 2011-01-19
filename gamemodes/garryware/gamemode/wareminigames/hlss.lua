WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "none"

--WARE.OccurencesPerCycle = 1

function WARE:IsPlayable()
	return false
	--if team.NumPlayers(TEAM_HUMANS) >= 4 then
	--	return true
	--end
	--return false
end

function WARE:Initialize()
	GAMEMODE:SetWareWindupAndLength(1.5,2)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Don't use HLSS!" )
	
	return
end

function WARE:StartAction()
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "sware_hlss" )
	end
end

function WARE:EndAction()

end

local function WareHLSS(player, commandName, args)
	if (GAMEMODE:GetCurrentMinigameName() == "hlss") then
		player:ApplyLose( )
	end
end
concommand.Add("cware_hlss",WareHLSS)
