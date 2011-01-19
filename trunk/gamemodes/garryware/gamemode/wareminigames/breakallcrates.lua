WARE.Author = "Hurricaaane (Ha3)"

WARE.Models = { "models/props_junk/wood_crate001a.mdl" }

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	GAMEMODE:SetWareWindupAndLength(0.7,6)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Be useful!" )
	
	local ratio = 0.7
	local minimum = 2
	self.Num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * ratio), minimum, 64)
	self.Broke = 0
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Break all crates!" )

	local entposcopy = GAMEMODE:GetRandomLocationsAvoidBox(self.Num, ENTS_ONCRATE, function(v) return v:IsPlayer() end, Vector(-30,-30,0), Vector(30,30,64))
	
	for k,v in pairs(entposcopy) do
		local ent = ents.Create ("prop_physics")
		ent:SetModel ( self.Models[1] )
		ent:SetPos(v:GetPos() + Vector(0,0,32))
		ent:SetAngles(Angle(0,math.Rand(0,360),0) )
		ent:Spawn()
		ent:SetHealth(15)
		ent.ValidDetProp = true
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_crowbar" )
	end
	
end

function WARE:EndAction()
	if (self.Broke < self.Num) then
		for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
			v:SetAchievedNoLock( false )
		end
	end
end

function WARE:PropBreak(killer, prop)
	if not (prop.ValidDetProp) then return end

	if killer:IsPlayer() then
		killer:SetAchievedNoLock( true )
	end
	self.Broke = self.Broke + 1
	
	if (self.Broke == self.Num) then
		for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
			v:ApplyLock()
		end
	end
end

