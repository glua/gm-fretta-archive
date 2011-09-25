function CheckTeams() //Seeker selector, used on roundstart
//	if LastVictim == nil then
//		RandomizeVictim()
//	end
	if LastVictim == nil then return end //Ololol :)
	if #team.GetPlayers(TEAM_SEEKERS) <= 0 then
		if not LastVictim:IsValid() or LastVictim:Team() == TEAM_SPECTATOR or LastVictim:Team() == TEAM_UNASSIGNED then
			RandomizeVictim()
		end
			LastVictim:SetTeam(TEAM_SEEKERS)
			LastVictim:PrintMessage(HUD_PRINTTALK, "You are first seeker!")
			timer.Simple(0.5, function() LastVictim:Freeze(true) end)
			LastVictim:SetNetworkedBool("Blind", true)
			//LastVictim:Give("hns_crowbar")
	end
end

function RandomizeVictim()
	local plys1 = team.GetPlayers(TEAM_HIDERS)
	local plys2 = team.GetPlayers(TEAM_SEEKERS)
	table.Merge(plys1,plys2)
	LastVictim = table.Random(plys2)
	
end

function GM:OnPreRoundStart(num)
	game.CleanUpMap()
	CheckTeams()
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	BennyHill = false
	for k,v in pairs(player.GetAll()) do
		v:SetNWInt("InvisTime", 20)
		v:SetNWBool("Invis", false)
		timer.Destroy("InvisRestore"..v:EntIndex())
		v:SetColor(255,255,255,255)
		InvisActive[v] = false
	end
end

function GM:OnRoundStart( num )
	UTIL_UnFreezeAllPlayers()
	local plys = player.GetAll()
	local seekers = team.GetPlayers(TEAM_SEEKERS)
	for k,v in pairs(seekers) do
		v:SetNetworkedBool("Blind", false)
	end
end

function GM:OnRoundEnd( num )
	plys = player.GetAll()
	for k,v in pairs(plys) do
		if v:Team() == TEAM_SPECTATOR or v:Team() == TEAM_UNASSIGNED then
			//do nothing
		else
		v:SetTeam(TEAM_HIDERS)
		v:StripWeapons()
		v:SetNetworkedBool("Blind", false)
		v:SetColor(255,255,255,255)
		end
	end
	local rp = RecipientFilter()
	rp:AddAllPlayers()
	umsg.Start("BennyHill", rp)
	umsg.Bool(false)
	umsg.End()
end

function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	for k,v in pairs(team.GetPlayers(TEAM_HIDERS)) do
		v:AddFrags(#player.GetAll())
	end
	GAMEMODE:RoundEndWithResult(TEAM_HIDERS, "Hiders win!" )

end

function playerRespawn( ply )
if ply:Team() == 1001 or ply:Team() == TEAM_SPECTATOR then return end
	if LastVictim == nil then
		LastVictim = ply
	end
end
hook.Add( "PlayerSpawn", "hnsPlayerSpawn", playerRespawn )
