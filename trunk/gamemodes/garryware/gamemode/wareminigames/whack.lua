WARE.Author = "Hurricaaane (Ha3)"

function WARE:IsPlayable()
	if team.NumPlayers(TEAM_HUMANS) >= 5 then
		return true
	end
	
	return false
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:EnableFirstFailAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	GAMEMODE:SetFailAwards( AWARD_VICTIM )

	self.PlayersWhoDone = {}
	self.Balls = {}
	self.RoleColor = Color(114, 49, 130)

	GAMEMODE:SetWareWindupAndLength(0.8, 4)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Catch white!" )
	
	local ratio = 0.5
	local minimum = 1
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * ratio), minimum, 64)
	local entposcopy = GAMEMODE:GetRandomLocations(num, ENTS_ONCRATE)
	
	for k,v in pairs(entposcopy) do
		local ent = ents.Create ("ware_catchball")
		ent:SetPos(v:GetPos())
		ent:Spawn()
		
		table.insert(self.Balls, ent)
		
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter( VectorRand() * 256 )
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end

end

function WARE:StartAction()
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
	
end


function WARE:PreEndAction()
	if GAMEMODE:GetCurrentPhase() == 1
		and team.NumPlayers(TEAM_HUMANS) >= 2
		and team.NumPlayers(TEAM_HUMANS) > #self.PlayersWhoDone then
		
		local someoneAchieved = false
		local k = 1
		
		--We do that check in case every single player
		--that caught a ball got disconnected
		while ((k <= #self.PlayersWhoDone) and not someoneAchieved) do
			local ply = self.PlayersWhoDone[k]
			
			someoneAchieved = ply:IsWarePlayer() and ply:GetAchieved()
			
		end
		
		if someoneAchieved then
			GAMEMODE:SetNextPhaseLength( 6 )
			
		end
		--else the game ends and players 
		
	end
	
end

function WARE:PhaseSignal( iPhase )
	if iPhase == 2 then
		for k,v in pairs( self.Balls ) do
			if ValidEntity( v ) then
				GAMEMODE:MakeDisappearEffect( v:GetPos() )
				v:Remove()
			end
		end
	
		local rpFlee   = RecipientFilter()
		local rpAttack = RecipientFilter()
		
		for k,ply in pairs( team.GetPlayers(TEAM_HUMANS) ) do
			ply:StripWeapons()
			
			if ply:GetAchieved() then
				ply.WARE_IsAttacker = true
				
				rpAttack:AddPlayer( ply )
				ply:Give("weapon_crowbar")
				ply:SetAchievedNoLock( false )
				GAMEMODE:MakeLandmarkEffect( ply:GetPos() )
				
			elseif ply:IsWarePlayer() then
				ply.WARE_IsAttacker = false
				
				rpFlee:AddPlayer( ply )
				ply:Give("weapon_physcannon")
				ply:SetAchievedNoLock( true )
				
			end
			
		end
		
		GAMEMODE:DrawInstructions( "Whack players holding a Gravity Gun!" , self.RoleColor , nil , rpAttack )
		GAMEMODE:DrawInstructions( "Don't get hit!" , self.RoleColor , nil , rpFlee )
		
	end
	
end


function WARE:EndAction()
	
end

function WARE:EntityTakeDamage( ent, inflictor, attacker, amount )
	if GAMEMODE:GetCurrentPhase() == 2 then
		if not ValidEntity( ent ) or not ent:IsPlayer() or not ent:IsWarePlayer() or ent.WARE_IsAttacker or ent:GetLocked() then return end
		if not ValidEntity( attacker ) or not attacker:IsPlayer() or not attacker:IsWarePlayer() or not attacker.WARE_IsAttacker then return end
		
		attacker:ApplyWin( )
		attacker:SendHitConfirmation()
		ent:ApplyLose()
		
		ent:SimulateDeath()
		ent:StripWeapons()
		
	end
	
end

function WARE:GravGunOnPickedUp( pl, ent )
	if GAMEMODE:GetCurrentPhase() == 1 then
		if (ent:GetClass() == "ware_catchball") and ent:IsUsable() then
			pl:ApplyDone( )
			ent:SetUsability( false )
			
			table.insert(self.PlayersWhoDone, pl)
		end
	end
	
end
