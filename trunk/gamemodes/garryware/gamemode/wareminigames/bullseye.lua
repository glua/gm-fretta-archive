WARE.Author = "Hurricaaane (Ha3)"

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_AIM, AWARD_REFLEX )
	
	GAMEMODE:SetWareWindupAndLength(1.5,8)
	
	self.TimesToHit = math.random(2,5)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Hit the bullseye exactly "..self.TimesToHit.." times!" )
	
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		ply:Give( "sware_pistol" )
		ply:GiveAmmo( 12, "Pistol", true )	
		ply.BULLSEYE_Hit = 0
	end
	
end

function WARE:StartAction()
	local ratio = 0.3
	local minimum = 1
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * ratio), minimum, 64)
	local entposcopy = GAMEMODE:GetRandomPositions(num, ENTS_INAIR)
	
	for k,pos in pairs(entposcopy) do
		local ent = ents.Create("ware_bullseye")
		ent:SetPos(pos)
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter(VectorRand() * 16)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
end

function WARE:EndAction()

end

function WARE:Think( )
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
	
		local timesHit = ply.BULLSEYE_Hit or 0
		
		if timesHit == self.TimesToHit then
			ply:SetAchievedNoLock( true )
			
		elseif timesHit > self.TimesToHit then
			ply:ApplyLose( )
			
		else
			ply:SetAchievedNoLock( false )
		end
		
	end
	
end
