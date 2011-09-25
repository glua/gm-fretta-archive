
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function GM:OnRoundStart()
	contracts = {}
	crossref = {}
	contract_count = team.NumPlayers( TEAM_PLAYERS )
	for k,v in pairs( team.GetPlayers(TEAM_PLAYERS) ) do 
	if v:Alive() then
		slot = math.random(contract_count)
		while contracts[slot] ~= nil do
			slot = math.random(contract_count)
		end
		contracts[slot] = v
		crossref[v] = slot
	end
	end
	UTIL_UnFreezeAllPlayers()
	
	end

function UpdateContractList()

new_list = {}
	for k,v in pairs( team.GetPlayers(TEAM_PLAYERS) ) do 
		if v:Alive() then
			new_list[crossref[v]] = v
		end
	end
	contracts = new_list
	
	for k,v in pairs( team.GetPlayers(TEAM_PLAYERS) ) do 
	if v:Alive() then
		target = crossref[v]+1
		if target > contract_count  then target = 1 end
		while contracts[target] == nil do
			if target == contract_count + 1 then
				target = 1
			else
				target = target + 1
			end
		
		end
		
		umsg.Start("new_contract", v)
		umsg.Entity(contracts[target])
		umsg.End()
	end
	end
end
StartCountdown = 20

previous_alive_count = 0
function GM:CanStartRound(inum)
	
	local readycount = 0
	local total = table.Count(player.GetAll())
	
	for k,v in pairs( team.GetPlayers(TEAM_PLAYERS) ) do
		if v:IsBot() or v.ReadyToGo then
			readycount = readycount + 1
		end
		SendUserMessage("reset_contract", v, "Please Wait")
	end
	
	StartCountdown = StartCountdown - 1

	
	if readycount > 2 and StartCountdown <= 0 then
		previous_alive_count = 0
		return true
	else
		return false
	end
end

function playershouldtakedamage(victim, attacker)

	if attacker:IsWorld() then return true end
	local victim_number = crossref[victim]
	local search = victim_number - 1
	while contracts[search] == nil do
		if search == 0 then
			search = contract_count
		else
			search = search - 1
		end
		
	end
	if contracts[search] == attacker then
		return true
	end
	
	search = victim_number + 1
	while contracts[search] == nil do
		if search == contract_count + 1 then
			search = 1
		else
			search = search + 1
		end
		
	end
	if contracts[search] == attacker then
		return true
	end
	if attacker:Health() > 20 then
	attacker:SetHealth( attacker:Health() - 20 )
	else
	attacker:SetHealth( 1)
	end
	return false
end
 
hook.Add( "PlayerShouldTakeDamage", "playershouldtakedamage", playershouldtakedamage)


function GM:CheckRoundEnd()
	alive_count = 0
	
	if ( !GAMEMODE:InRound() ) then return end 
 
	for k,v in pairs( team.GetPlayers(TEAM_PLAYERS) ) do
 		if v:Alive() then
			alive_count = alive_count + 1
			last_player = v
		end
	end
	
	if alive_count ~= previous_alive_count and alive_count > 1 then
		UpdateContractList()
	end
	previous_alive_count = alive_count
	if alive_count == 1 then
		SendUserMessage("reset_contract", last_player, "Please Wait")
		GAMEMODE:RoundEndWithResult( last_player )
	elseif alive_count == 0 then
		GAMEMODE:RoundEndWithResult(-1)
	end
        
 
end

function GM:PlayerJoinTeam( ply, teamid )
	
	local iOldTeam = ply:Team()
	
	if ( ply:Alive() ) then
		if ( iOldTeam == TEAM_SPECTATOR || (iOldTeam == TEAM_UNASSIGNED && GAMEMODE.TeamBased) ) then
			ply:KillSilent()
		else
			ply:Kill()
		end
	end
	
	ply:SetTeam( teamid )
	ply.LastTeamSwitch = RealTime()
	
	local Classes = team.GetClass( teamid )
	
	
	// Needs to choose class
	if ( Classes && #Classes > 1 ) then
	
		if ( ply:IsBot() || !GAMEMODE.SelectClass ) then
	
			GAMEMODE:PlayerRequestClass( ply, math.random( 1, #Classes ) )
	
		else

			ply.m_fnCallAfterClassChoose = function() 
												ply.DeathTime = CurTime()
												GAMEMODE:OnPlayerChangedTeam( ply, iOldTeam, teamid ) 
												ply:EnableRespawn() 
												ply.ReadyToGo = true
											end

			ply:SendLua( "GAMEMODE:ShowClassChooser( ".. teamid .." )" )
			ply:DisableRespawn()
			ply:SetRandomClass() // put the player in a VALID class in case they don't choose and get spawned
			return
					
		end
		
	end
	
	// No class, use default
	if ( !Classes || #Classes == 0 ) then
		ply:SetPlayerClass( "Default" )
	end
	
	// Only one class, use that
	if ( Classes && #Classes == 1 ) then
		GAMEMODE:PlayerRequestClass( ply, 1 )
	end
	
	GAMEMODE:OnPlayerChangedTeam( ply, iOldTeam, teamid )
	
end


