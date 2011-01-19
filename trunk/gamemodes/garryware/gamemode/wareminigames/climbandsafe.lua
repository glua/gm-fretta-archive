WARE.Author = "Hurricaaane (Ha3)"

WARE.Models = {
	"models/props_junk/metalbucket01a.mdl",
	"models/props_junk/propanecanister001a.mdl",
	"models/props_c17/chair_office01a.mdl",
	"models/props_c17/chair_stool01a.mdl",
	"models/props_wasteland/controlroom_chair001a.mdl"
 }

local MDLLIST = WARE.Models

function WARE:GetModelList()
	return self.Models
end

function WARE:IsPlayable()
	if team.NumPlayers(TEAM_HUMANS) >= 3 then
		return true
	end
	
	return false
end

function WARE:Initialize()
	-- THIS HAS AWARDS IN OTHER PHASE.

	self.RoleColor = Color(114, 49, 130)
	GAMEMODE:SetWareWindupAndLength(0,4)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Get on a box!" )
	
end

function WARE:StartAction()
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "sware_crowbar" )
	end
	
end

function WARE:EndAction()

end

function WARE:PreEndAction()
	if GAMEMODE:GetCurrentPhase() < 2 then
		local someoneAchieved = false
		for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
			ply:StripWeapons()
			if ply:GetAchieved() then
				someoneAchieved = true
				ply:TellDone( )
				ply:SendHitConfirmation()
				
			else
				ply:ApplyLose()
				ply:SimulateDeath()
				
			end
			
		end
		
		if someoneAchieved then
			GAMEMODE:SetNextPhaseLength( 4 )
			
		end
		
	end
	
end

function WARE:PhaseSignal( iPhase )
	if iPhase == 2 then
		GAMEMODE:SetFailAwards( AWARD_VICTIM )
		
		for k,ply in pairs( team.GetPlayers(TEAM_HUMANS) ) do
			ply:SetAchievedNoLock( true )
			if not ply:GetLocked() then
				ply:Give("weapon_physcannon")
			end
		end
		
		local propRatio = 1.3
		local propMinimum = 1
		local propNum = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * propRatio), propMinimum, 64)
		for i,pos in ipairs(GAMEMODE:GetRandomPositions(propNum, ENTS_CROSS)) do	
			local model = MDLLIST[ math.random(1, #MDLLIST) ]
			
			local ent = ents.Create("prop_physics")
			ent:SetModel( model )
			ent:SetPos( pos + Vector(0,0,64) )
			ent:SetAngles( Angle(0, math.Rand(0,360), 0) )
			ent:Spawn()
			
			GAMEMODE:AppendEntToBin(ent)
			GAMEMODE:MakeAppearEffect(ent:GetPos())
		end

		GAMEMODE:DrawInstructions( "Stay on them!", self.RoleColor )
		
	end
	
end

function WARE:Think( )
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:SetAchievedNoLock(false)
	end
	local entposcopy = GAMEMODE:GetEnts(ENTS_ONCRATE)
	for _,block in pairs(entposcopy) do
		local box = ents.FindInBox(block:GetPos()+Vector(-30,-30,0),block:GetPos()+Vector(30,30,64))
		for _,target in pairs(box) do
			if target:IsPlayer() then
				target:SetAchievedNoLock(true)
			end
		end
	end
	
	if GAMEMODE:GetCurrentPhase() == 2 then
		for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
			if not v:GetLocked() and not v:GetAchieved() then
				v:ApplyLose()
				v:SimulateDeath()
				v:EjectWeapons( nil, 120 )
			end
		end
	end
end

