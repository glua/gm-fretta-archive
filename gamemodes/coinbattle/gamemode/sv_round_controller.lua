function GM:SetInPreRound(bool) SetGlobalBool("InPreRound",bool) end
function GM:InPreRound() return GetGlobalBool("InPreRound",false) end

function GM:OnRoundResult(result, resulttext)
	
	for _,ply in pairs( player.GetAll() ) do 
	
		if ply:Team() == result then
			SendUserMessage("OnRoundResult",ply,true)
		else
			SendUserMessage("OnRoundResult",ply,false)
			ply:StripWeapons()
			ply:SetWalkSpeed(ply:GetPlayerClass().WalkSpeed/2)
			ply:SetRunSpeed(ply:GetPlayerClass().RunSpeed/2)
		end
		
	end

end

function GM:CanStartRound(iNum)
	
	if team.NumPlayers(TEAM_CYAN) >= 1 and team.NumPlayers(TEAM_ORANGE) >= 1 then
		return true
	end
	return false
	
end

function GM:OnPreRoundStart(num)
	
	for _,ent in pairs(ents.FindByClass("cb_medkit")) do
		
		ent:CompleteRemove()
		
	end
	game.CleanUpMap()
	
	for _,ply in pairs(player.GetAll()) do
		
		ply:AddBankCoins(ply:GetCoins())
		ply:SetCoins(0)
		
	end
	
	team.SetScore( TEAM_CYAN, 0 )
	team.SetScore( TEAM_ORANGE, 0 )
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
	GAMEMODE:SetInPreRound(true)
	
end

function GM:OnRoundStart(num)
	
	UTIL_UnFreezeAllPlayers()
	GAMEMODE:SetInPreRound(false)
	
end

function GM:RoundTimerEnd()

	if not GAMEMODE:InRound() then return end
	
	local CyanScore = team.GetScore(TEAM_CYAN)
	local OrangeScore = team.GetScore(TEAM_ORANGE)
	
	if CyanScore > OrangeScore then
		GAMEMODE:RoundEndWithResult(TEAM_CYAN)
	elseif CyanScore < OrangeScore then
		GAMEMODE:RoundEndWithResult(TEAM_ORANGE)
	else
		GAMEMODE:RoundEndWithResult(-1, "Everyone Loses!")
	end
	
	for _,ent in pairs(ents.GetAll()) do
		
		if string.find(ent:GetClass(),"coin_") then
			ent:Remove()
		end
		
		if string.find(ent:GetClass(),"cb_medkit") then
			ent:CompleteRemove()
		end
		
	end
	
end
