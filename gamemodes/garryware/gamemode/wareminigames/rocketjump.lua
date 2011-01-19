WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "empty"

WARE.Models = { "models/props_lab/blastdoor001b.mdl" }

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_MOVES )
	GAMEMODE:SetWareWindupAndLength(1,9)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Look up!" )
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Rocketjump onto a plate!" )
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "sware_rocketjump" )
	end
	
	local ratio = 0.3
	local minimum = 1
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS)*ratio), minimum, 64)
	
	local entposcopy = GAMEMODE:GetRandomPositions(num, "dark_inair")
	for k,position in pairs(entposcopy) do
		local platform = ents.Create("prop_physics")
		platform:SetModel( self.Models[1] )
		platform:SetPos(position + Vector(0,0,-140))
		platform:SetAngles(Angle(90,0,0))
		platform:Spawn()
		
		platform:SetColor(255, 0, 0, 255)
		platform:GetPhysicsObject():EnableMotion( false )
		
		GAMEMODE:AppendEntToBin( platform )
		GAMEMODE:MakeAppearEffect( platform:GetPos() )
	end
end

function WARE:EndAction()

end

function WARE:Think()
	for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do
		local ent = ply:GetGroundEntity()
		if ent and ent:IsValid() and ent:GetModel() == self.Models[1] then
			ply:ApplyWin( )
		end
	end
end