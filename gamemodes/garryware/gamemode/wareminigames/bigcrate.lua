WARE.Author = "Hurricaaane (Ha3)"

WARE.Models = { "models/props_junk/wood_crate001a.mdl", "models/props_junk/wood_crate002a.mdl" }

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	GAMEMODE:SetWareWindupAndLength(0.7,7.5)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Punt the biggest crate!" )
	
	return
end

function WARE:StartAction()
	local entsTable = GAMEMODE:GetEnts(ENTS_INAIR)
	
	local magicNumber = math.Clamp( math.ceil(#entsTable*0.07), 1, 3 )
	for k=1,magicNumber do
		local randNum    = math.random(1, #entsTable)
		local entOnCrate = table.remove(entsTable, randNum)
	
		local ent = ents.Create("prop_physics")
		ent:SetModel( self.Models[2] )
		ent:SetPos( entOnCrate:GetPos() + Vector(0,0,64) )
		ent:SetAngles( Angle(0, math.Rand(0,360), 0) )
		ent:Spawn()
		ent:SetHealth(100000)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
		
		
		local land = ents.Create("gmod_landmarkonremove")
		land:SetPos(ent:GetPos())
		land:SetParent(ent)
		land:Spawn()
		
		GAMEMODE:AppendEntToBin(land)
	end
	
	for k,v in pairs(entsTable) do
		local ent = ents.Create("prop_physics")
		ent:SetModel( self.Models[1] )
		ent:SetPos( v:GetPos() + Vector(0,0,64) )
		ent:SetAngles( Angle(0, math.Rand(0,360), 0) )
		ent:Spawn()
		ent:SetHealth(1)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
	return
end

function WARE:EndAction()

end

function WARE:GravGunPunt( ply, target )
	if target:GetModel() == self.Models[2] then
		ply:ApplyWin()
	else
		ply:ApplyLose()
	end
end

function WARE:GravGunPickupAllowed( ply, target )
	if ValidEntity(target) and target:GetModel() == self.Models[2] then
		return false
	else
		return true
	end
end
