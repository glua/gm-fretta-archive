WARE.Author = "Kilburn"

local function ResetFlashCrate(prop)
	if not(prop and prop:IsValid()) then return end
	
	prop:SetColor(255,255,255,255)
end

local function FlashCrate(prop)
	if not(prop and prop:IsValid()) then return end
	
	prop:SetColor(255,255,255,50)
	timer.Simple(0.45, ResetFlashCrate, prop)
end


WARE.Models = {
	"models/props_junk/wood_crate001a.mdl",
	"models/props_junk/watermelon01.mdl",
	"models/props_junk/plasticbucket001a.mdl",
	"models/props_junk/metalbucket01a.mdl",
	"models/props_junk/propanecanister001a.mdl",
	"models/props_combine/breenglobe.mdl",
	false
 }

local MDL_CRATE = 1
local MDL_MELON = 2
local MDL_OTHER = 3

local MDLLIST = WARE.Models
 
function WARE:GetModelList()
	return self.Models
end


function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY )
	local maxcount = table.Count(GAMEMODE:GetEnts(ENTS_ONCRATE))
	
	local numberMelonSpawns = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * 0.5), 1, maxcount)
	local numberFakeSpawns = math.Clamp(team.NumPlayers(TEAM_HUMANS) + 1, 4, maxcount - numberMelonSpawns)
	
	local delay = 2
	
	GAMEMODE:SetWareWindupAndLength(delay + 1,6)

	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Watch the crates..." )
	
	for i,pos in ipairs(GAMEMODE:GetRandomPositions(numberMelonSpawns+numberFakeSpawns, ENTS_ONCRATE)) do
		pos = pos + Vector(0,0,100)
		
		local prop = ents.Create("prop_physics")
		prop:SetModel( MDLLIST[MDL_CRATE] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(pos)
		prop:Spawn()
		
		prop:SetMoveType(MOVETYPE_NONE)
		
		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:MakeAppearEffect(pos)
		
		local model
		
		if i <= numberMelonSpawns then
			model = MDLLIST[MDL_MELON]
		else
			model = MDLLIST[ math.random(MDL_OTHER, #MDLLIST) ]
		end
		
		-- If it's a "false" then it's an empty crate.
		if model then
			local prop2 = ents.Create("prop_physics")
			prop2:SetModel( model )
			prop2:PhysicsInit(SOLID_VPHYSICS)
			prop2:SetSolid(SOLID_VPHYSICS)
			prop2:SetPos(pos)
			prop2:SetAngles( Angle(math.random(-180,180),math.random(-180,180),math.random(-180,180)) )
			prop2:Spawn()
			
			prop2:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			prop2:SetMoveType(MOVETYPE_VPHYSICS)
			prop2:GetPhysicsObject():EnableMotion(false)
			
			GAMEMODE:AppendEntToBin(prop2)
			
			prop.Contents = prop2
		end
		
		timer.Simple(delay, FlashCrate, prop)
	end
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Break a melon!" )
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give("weapon_crowbar")
	end
end

function WARE:EndAction()
	for _,prop in pairs(ents.FindByModel( MDLLIST[MDL_MELON] )) do
		GAMEMODE:MakeLandmarkEffect(prop:GetPos())
	end
end

function WARE:PropBreak(pl, prop)
	if not pl:IsPlayer() then return end
	
	if prop:GetModel() == MDLLIST[MDL_MELON] then
		pl:ApplyWin( )
		pl:StripWeapons()
		
	elseif prop.Contents then
		prop.Contents:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
		prop.Contents:GetPhysicsObject():EnableMotion(true)
		prop.Contents:GetPhysicsObject():Wake()
	end
	
end
