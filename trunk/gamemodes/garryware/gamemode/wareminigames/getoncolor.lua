WARE.Author = "Hurricaaane (Ha3)"

WARE.PossibleColors = {
{ "black" , Color(0,0,0,255) },
{ "grey" , Color(138,138,138,255), Color(255,255,255,255) },
{ "white" , Color(255,255,255,255), Color(0,0,0,255) },
{ "red" , Color(220,0,0,255) },
{ "green" , Color(0,220,0,255) },
{ "blue" , Color(64,64,255,255) },
{ "pink" , Color(255,0,255,255) }
}
 
WARE.Props = {}

WARE.TheProp = nil
WARE.CircleRadius = 64

function WARE:_DiceNoRepeat( myMax, lastUsed )
	local dice = math.random(1, myMax - 1)
	if (dice >= lastUsed) then
		dice = dice + 1
	end
	
	return dice
end

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_MOVES )
	GAMEMODE:SetWareWindupAndLength(0.7,5)
	
	self.Props = {}
	
	local spawnedcolors = {}
	local magicCopy = {}
	for k=1,#self.PossibleColors do
		magicCopy[k] = k
	end
	
	local ratio = 0.5
	local minimum = 3
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * ratio), minimum, #self.PossibleColors)
	local entposcopy = GAMEMODE:GetRandomLocations(num, ENTS_CROSS)
	
	for k,v in pairs(entposcopy) do
		local chosenColor = math.random(1, #magicCopy)
		local colorID = table.remove( magicCopy , chosenColor )
		table.insert(spawnedcolors, colorID)
		
		local ent = ents.Create("ware_ringzone")
		ent:SetPos(v:GetPos() + Vector(0,0,8) )
		ent:SetAngles( Angle(0,0,0) )
		ent:Spawn()
		ent:Activate()
		
		
		table.insert( self.Props , ent )
		
		ent.ColorID = colorID
		
		ent:SetZSize(self.CircleRadius * 2.0)
		ent:SetZColor(self.PossibleColors[colorID][2])

		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
	self.SelectedPropNum = math.random(1, #self.Props)
	self.TheProp = self.Props[ self.SelectedPropNum ]
	local selected = self.TheProp.ColorID
	self.SelectedColorID = selected
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Get on the ".. self.PossibleColors[selected][1] .." circle!" , self.PossibleColors[selected][2] or nil, self.PossibleColors[selected][3] or nil )
	
end

function WARE:StartAction()
	for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		ply:Give("sware_crowbar")
	end
	
end

function WARE:PreEndAction()
	if GAMEMODE:GetCurrentPhase() < 2 then
		local someoneAchieved = false
		for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
			ply:StripWeapons()
			if ply:GetAchieved() then
				someoneAchieved = true
				ply:Give( "weapon_physcannon" )
				ply:StripWeapons() -- To fix weaponmodel bu
				ply:Give( "sware_rocketjump" )
				ply:TellDone( )
				ply:SendHitConfirmation()
				
			else
				ply:ApplyLose()
				
			end
			
		end
		
		if someoneAchieved then
			GAMEMODE:SetNextPhaseLength( 6 )
			
		end
		
	end
	
end

function WARE:PhaseSignal( iPhase )
	if iPhase <= 3 then
		self.SelectedPropNum = self:_DiceNoRepeat( #self.Props, self.SelectedPropNum )
		self.TheProp = self.Props[ self.SelectedPropNum ]
		local selected = self.TheProp.ColorID
		self.SelectedColorID = selected
		
		GAMEMODE:DrawInstructions( "Now get on the ".. self.PossibleColors[selected][1] .." circle!" , self.PossibleColors[selected][2] or nil, self.PossibleColors[selected][3] or nil )
		
	end
	
end

function WARE:EndAction()
	if ValidEntity( self.TheProp ) then
		GAMEMODE:MakeLandmarkEffect( self.TheProp:GetPos() )
	end
end
		

function WARE:Think( )
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:SetAchievedNoLock( false )
	end
	
	for _,target in pairs( ents.FindInSphere(self.TheProp:GetPos() , self.CircleRadius) ) do
		if target:IsPlayer() and target:IsWarePlayer() then
			target:SetAchievedNoLock( true )
		end
	end
end
