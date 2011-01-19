WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "hexaprism"
 
WARE.CircleRadius = 0

WARE.CenterEntity = nil

function WARE:IsPlayable()
	if team.NumPlayers(TEAM_HUMANS) >= 2 then
		return true
	end
	return false
end

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_MOVES )
	self.LastThinkDo = 0
	
	GAMEMODE:RespawnAllPlayers( true, true )
	
	GAMEMODE:SetWareWindupAndLength(1, 6)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "On the center!" )
	
	do
		local centerpos = GAMEMODE:GetEnts("center")[1]:GetPos()
		local apos      = GAMEMODE:GetEnts("land_a")[1]:GetPos()
		self.CircleRadius = ((centerpos - apos):Length() - 64) * 0.4
		
		local ent = ents.Create("ware_ringzone")
		ent:SetPos( centerpos + Vector(0,0,8) )
		ent:SetAngles( Angle(0,0,0) )
		ent:Spawn()
		ent:Activate()
		
		ent.LastActTime = 0
		
		ent:SetZSize(self.CircleRadius * 2.0)
		ent:SetZColor( Color(185,220,255) )
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
		
		self.CenterEntity = ent
	end
	
end

function WARE:StartAction()	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "sware_rocketjump" )
	end
	return
end

function WARE:EndAction()

end

function WARE:Think( )
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:SetAchievedNoLock( false )
	end
	
	local ring = self.CenterEntity
	local sphere = ents.FindInSphere(ring:GetPos(), self.CircleRadius)
	for _,target in pairs(sphere) do
		if target:IsPlayer() and target:IsWarePlayer() then
			target:SetAchievedNoLock( true )
		end
	end
end
