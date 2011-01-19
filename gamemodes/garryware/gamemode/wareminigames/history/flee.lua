--DISABLED.

WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "empty"

WARE.Models = {
"models/Roller.mdl",
"models/Roller_Spikes.mdl",
"models/manhack.mdl"
 }
 
WARE.Locations = {}

function WARE:GetModelList()
	return self.Models
end

local possiblenpcs = { "npc_manhack" , "npc_rollermine" }

function WARE:FlashSpawns( iteration, delay )
	for k,ent in pairs( self.Locations ) do
		GAMEMODE:MakeAppearEffect( ent:GetPos() )
	end
	if (iteration > 0) then
		timer.Simple( delay , self.FlashSpawns, self , iteration - 1, delay )
	end
	
end

function WARE:IsPlayable()
	return false
end

function WARE:Initialize()
	self.Choice = possiblenpcs[ math.random(1,2) ]
	
	GAMEMODE:SetWareWindupAndLength(2, 8)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Flee!" )
	
	local ratio = 0.7
	local minimum = 3
	local num = math.Clamp(math.ceil( team.NumPlayers(TEAM_HUMANS) * ratio) , minimum, 64)
	self.Locations = GAMEMODE:GetRandomLocations(num, {"dark_ground", "light_ground"} )
	
	self:FlashSpawns( 6 , 0.3 )
end

function WARE:StartAction()	
	for k,v in pairs(self.Locations) do
		local ent = ents.Create (self.Choice)
		ent:SetPos(v:GetPos() + Vector(0,0,256))
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter (VectorRand() * 16)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
end

function WARE:EndAction()

end

function WARE:EntityTakeDamage( ent, inflictor, attacker, amount)
	if ent:IsPlayer() and ent:IsWarePlayer() and attacker:IsNPC( ) then
		ent:ApplyLose()
	end
end
