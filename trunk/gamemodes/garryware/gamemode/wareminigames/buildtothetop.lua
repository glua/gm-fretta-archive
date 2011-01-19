WARE.Author = "Kilburn"

WARE.PreinstructionColor = Color(0,0,0,255)

WARE.Models = {
"models/props_junk/sawblade001a.mdl",
"models/props_lab/blastdoor001b.mdl"
 }
 
local sawbladeModel = WARE.Models[1]

function WARE:GetModelList()
	return self.Models
end

local function RespawnSawblade(ent)
	if not ent or not ent:IsValid() or not ent.OriginalPos then return end
	
	local saw = ents.Create ("prop_physics")
	saw:SetModel( sawbladeModel )
	saw:SetPos(ent.OriginalPos)
	saw:SetAngles( Angle(0,0,0) )
	saw:Spawn()
	
	GAMEMODE:AppendEntToBin(saw)
	GAMEMODE:MakeAppearEffect( saw:GetPos() )
end

-----------------------------------------------------------------------------------

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY, AWARD_MOVES )
	GAMEMODE:SetWareWindupAndLength(2,14)

	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Punt a sawblade to freeze it..." , self.PreinstructionColor )
	
	for k,v in pairs( GAMEMODE:GetEnts(ENTS_ONCRATE) ) do
		local saw = ents.Create ("prop_physics")
		saw:SetModel( self.Models[1] )
		saw:SetPos(v:GetPos() + Vector(0,0,100))
		saw:SetAngles(Angle(0,0,0))
		saw:Spawn()
		
		saw.OriginalPos = v:GetPos() + Vector(0,0,100)
		
		GAMEMODE:AppendEntToBin(saw)
		GAMEMODE:MakeAppearEffect(saw:GetPos())
	end
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give("weapon_physcannon")
	end
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Get up there!" )
	
	local numberSpawns = math.ceil(team.NumPlayers(TEAM_HUMANS) * 0.75)
	
	for i,pos in ipairs(GAMEMODE:GetRandomPositions(numberSpawns, ENTS_INAIR)) do
		local platform = ents.Create("prop_physics")
		platform:SetModel(self.Models[2])
		platform:SetPos(pos + Vector(0,0,-140))
		platform:SetAngles(Angle(90,0,0))
		platform:Spawn()
		platform:SetColor(255,0,0,255)
		platform:GetPhysicsObject():EnableMotion(false)
		
		GAMEMODE:AppendEntToBin(platform)
		GAMEMODE:MakeAppearEffect(platform:GetPos())
	end
end

function WARE:EndAction()
	
end

function WARE:Think()
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
		local ent = v:GetGroundEntity()
		
		if ent and ent:IsValid() and ent:GetModel() == self.Models[2] then
			v:ApplyWin( )
		end
	end
end

function WARE:GravGunPunt(pl,ent)
	if not pl:IsPlayer() then return end
	
	if ent:GetPhysicsObject() and ent:GetPhysicsObject():IsValid() and not ent.Stuck then
		ent:GetPhysicsObject():EnableMotion(false)
		ent.Stuck = true
		
		ent:EmitSound("doors/vent_open3.wav")
		GAMEMODE:MakeDisappearEffect( ent:GetPos() )
		
		timer.Simple(1.7, RespawnSawblade, ent)
	end
end
