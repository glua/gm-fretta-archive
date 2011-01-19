WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "empty"

WARE.CircleRadius = 64

WARE.Circles      = {}
WARE.CirclesScore = {}

WARE.NumberOfCircles = 2

function WARE:IsPlayable()
	if team.NumPlayers(TEAM_HUMANS) >= 3 then
		return true
	end
	
	return false
end

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	self.NumberOfCircles = math.Clamp( 1 + math.ceil(team.NumPlayers(TEAM_HUMANS) / 7) , 2 , 3 )

	GAMEMODE:SetWareWindupAndLength(1, 6)

	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Get on the circle with fewest players!" )
	
	self.Circles = {}
	
	self.LastThinkDo = 0
	
	local entposcopy = GAMEMODE:GetRandomLocations(self.NumberOfCircles, "dark_ground" )
	
	for k,v in pairs(entposcopy) do
		local ent = ents.Create("ware_ringzone_preset")
		ent:SetPos(v:GetPos() + Vector(0,0,4) )
		ent:SetAngles(Angle(0,0,0))
		ent:Spawn()
		ent:Activate()
		
		GAMEMODE:AppendEntToBin(ent)
		
		table.insert( self.Circles , ent )
		self.CirclesScore[ k ] = 0

		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
	return
end

function WARE:StartAction()
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
		v:Give( "sware_rocketjump" )
	end
	
	return
end

function WARE:EndAction()

end


function WARE:Think( )
	if (CurTime() < (self.LastThinkDo + 0.1)) then return end
	self.LastThinkDo = CurTime()
	
	local playerList = team.GetPlayers(TEAM_HUMANS)
	local winnerNumber = #playerList 
	
	for k,ply in pairs(playerList) do
		ply.WAcircle = 0
	end
	
	for k,ring in pairs(self.Circles) do
		self.CirclesScore[k] = 0
		
		local sphere = ents.FindInSphere( ring:GetPos(), self.CircleRadius )
		for _,target in pairs(sphere) do
			if target:IsPlayer() and target:IsWarePlayer() and not(target:IsOnHold()) then
				self.CirclesScore[k] = self.CirclesScore[k] + 1
				target.WAcircle = k
			end
		end
		if self.CirclesScore[k] < winnerNumber then
			winnerNumber = self.CirclesScore[k]
		end
	end
	
	for k,ply in pairs(playerList) do
		if (ply.WAcircle > 0) and (self.CirclesScore[ ply.WAcircle ] == winnerNumber) then
			ply:SetAchievedNoLock( true )
		else
			ply:SetAchievedNoLock( false )
		end
	end
	
end
