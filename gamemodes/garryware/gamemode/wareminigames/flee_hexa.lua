WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "hexaprism"

WARE.Models = {
"models/Roller.mdl",
"models/Roller_Spikes.mdl",
"models/manhack.mdl"
 }
 
WARE.Positions = {}



function WARE:GetModelList()
	return self.Models
end

local possiblenpcs = { "npc_manhack" , "npc_rollermine" }

function WARE:FlashSpawns( iteration, delay )
	for k,pos in pairs( self.Positions ) do
		GAMEMODE:MakeAppearEffect( pos )
	end
	if (iteration > 0) then
		timer.Simple( delay , self.FlashSpawns, self , iteration - 1, delay )
	end
	
end

--TBD DEBUG
---function WARE:IsPlayable()
---	return true
---end

function WARE:Initialize()
	GAMEMODE:EnableFirstFailAward( )
	GAMEMODE:SetFailAwards( AWARD_VICTIM )
	self.SpawnedNPCs = {}

	GAMEMODE:RespawnAllPlayers( true, true )
	
	--self.ChoiceNum = math.random(#possiblenpcs + 1, #possiblenpcs + 5)
	
	GAMEMODE:SetWareWindupAndLength(2, 8)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Flee! Don't fall!" )
	
	local pitposz = GAMEMODE:GetEnts("pit_measure")[1]:GetPos().z
	local aposz   = GAMEMODE:GetEnts("land_measure")[1]:GetPos().z
	self.zlimit = pitposz + (aposz - pitposz) * 0.8
	
	local ratio = 0.7
	local minimum = 3
	local num = math.Clamp(math.ceil( team.NumPlayers(TEAM_HUMANS) * ratio) , minimum, 64)
	
	self.Positions = {}
	local centerpos    = GAMEMODE:GetEnts("center")[1]:GetPos()
	local alandmeasure = math.floor((GAMEMODE:GetEnts("land_a")[1]:GetPos() - centerpos):Length() * 0.5)
	for i=1,num do
		table.insert( self.Positions, Vector(0,0,92) + centerpos + Angle(0, math.random(0,360), 0):Forward() * math.random(alandmeasure * 0.5, alandmeasure) )
	end
	
	self:FlashSpawns( 6 , 0.3 )
end

function WARE:StartAction()	
	local myChoice = {}
	--if self.ChoiceNum > #possiblenpcs then
		myChoice = possiblenpcs
	--else
	--	myChoice = { possiblenpcs[self.ChoiceNum] }
	--end
	local spectators = team.GetPlayers(TEAM_SPECTATOR)
	
	for k,pos in pairs(self.Positions) do
		local ent = ents.Create( myChoice[ math.random(1, #myChoice) ] )
		ent:SetPos( Vector(0,0,164) + pos )
		ent:Spawn()
		
		table.insert( self.SpawnedNPCs, ent )
		
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter (VectorRand() * 16)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
		
		for k,spec in pairs( spectators ) do
			ent:AddEntityRelationship( spec, 4, 10 )
			
		end
	end
end

function WARE:EndAction()

end

function WARE:EntityTakeDamage( ent, inflictor, attacker, amount)
	if ent:IsPlayer() and ent:IsWarePlayer() and not ent:GetLocked() and attacker:IsNPC( ) then
		ent:ApplyLose( )
		ent:SimulateDeath()
		
		for k,npc in pairs( self.SpawnedNPCs ) do
			npc:AddEntityRelationship( ent, 4, 10 )
		end
		
	end
	
end

function WARE:Think( )
	for k,ent in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		if ent:IsPlayer() and ent:IsWarePlayer() and not ent:GetLocked() and ent:GetPos().z < self.zlimit then
			ent:ApplyLose( )
			ent:SimulateDeath()
			
			for k,npc in pairs( self.SpawnedNPCs ) do
				npc:AddEntityRelationship( ent, 4, 10 )
			end
		
		end
	end
end
