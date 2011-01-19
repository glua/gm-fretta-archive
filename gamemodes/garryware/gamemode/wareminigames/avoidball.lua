WARE.Author = "Hurricaaane (Ha3)"

function WARE:Initialize()
	GAMEMODE:EnableFirstFailAward( )
	GAMEMODE:SetFailAwards( AWARD_VICTIM )
	
	GAMEMODE:SetWareWindupAndLength(1.5,8)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Dodge!" )
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
	
	return
end

function WARE:StartAction()
	local ratio = 1.1
	local minimum = 3
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS)*ratio), minimum, 64)
	local entposcopy = GAMEMODE:GetRandomLocations(num, ENTS_INAIR)
	
	for k,v in pairs(entposcopy) do
		local ent = ents.Create ("ware_avoidball")
		ent:SetPos(v:GetPos())
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter (VectorRand() * 512)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
end

function WARE:EndAction()

end
