WARE.Author = "Kelth"

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	GAMEMODE:SetWareWindupAndLength(0.8,6)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Catch white!" )
	
	local ratio = 0.5
	local minimum = 1
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS)*ratio), minimum, 64)
	local entposcopy = GAMEMODE:GetRandomLocations(num, ENTS_ONCRATE)
	
	for k,v in pairs(entposcopy) do
		local ent = ents.Create ("ware_catchball")
		ent:SetPos(v:GetPos())
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter (VectorRand() * 1024)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end

end

function WARE:StartAction()
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
	
end

function WARE:EndAction()

end

function WARE:GravGunOnPickedUp( pl, ent )
	if (ent:GetClass() == "ware_catchball") and ent:IsUsable() then
		pl:ApplyWin( )
		ent:SetUsability( false )
	end
end
