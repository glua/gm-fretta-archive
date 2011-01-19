WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "hexaprism"

WARE.Models = {
"models/Combine_turrets/Ceiling_turret.mdl",
"models/props_c17/gravestone003a.mdl",
"models/props_junk/TrashBin01a.mdl",
"models/props_c17/FurnitureFridge001a.mdl",
"models/props_c17/oildrum001.mdl",
"models/props_debris/metal_panel02a.mdl",
"models/props_interiors/Radiator01a.mdl",
"models/props_interiors/refrigeratorDoor01a.mdl",
"models/props_junk/wood_crate001a.mdl"
 }
 
WARE.StringPos = {
"land_a",
"land_b",
"land_c",
"land_d",
"land_e",
"land_f"
}

WARE.Positions = {}

function WARE:IsPlayable()
	return false
end

function WARE:GetModelList()
	return self.Models
end

function WARE:FlashSpawns( iteration, delay )
	for k,pos in pairs( self.Positions ) do
		GAMEMODE:MakeAppearEffect( pos )
	end
	if (iteration > 0) then
		timer.Simple( delay , self.FlashSpawns, self , iteration - 1, delay )
	end
	
end


function WARE:Initialize()
	self.Positions = {}

	GAMEMODE:RespawnAllPlayers( true, true )
	
	GAMEMODE:SetWareWindupAndLength(2, 8)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Shield! Don't fall!" )
	
	local pitposz = GAMEMODE:GetEnts("pit_measure")[1]:GetPos().z
	local aposz   = GAMEMODE:GetEnts("land_measure")[1]:GetPos().z
	self.zlimit = pitposz + (aposz - pitposz) * 0.8
	
	self.SPosCopy = table.Copy(self.StringPos)
	
	local centerpos    = GAMEMODE:GetEnts("center")[1]:GetPos()
	local alandmeasure = math.floor((GAMEMODE:GetEnts("land_a")[1]:GetPos() - centerpos):Length() * 0.5)
	for i=1,2 do
		local myLandmarkName = table.remove( self.SPosCopy, math.random(1,#self.SPosCopy) )
		table.insert( self.Positions, GAMEMODE:GetEnts(myLandmarkName)[1]:GetPos() )
	end
	
	self:FlashSpawns( 6 , 0.3 )
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
	
	
	local ratio = 1.1
	local minimum = 3
	local num = math.Clamp(math.ceil( team.NumPlayers(TEAM_HUMANS) * ratio) , minimum, 64)
	
	for i=1,num do
		local newpos = Vector(0,0,256) + centerpos + Angle(0, math.random(0,360), 0):Forward() * math.random(alandmeasure * 0.5, alandmeasure)
		
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[ math.random(2, #self.Models) ] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(newpos)
		prop:Spawn()
		
		prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	
		local physobj = prop:GetPhysicsObject()
		physobj:EnableMotion(true)
		physobj:ApplyForceCenter(VectorRand() * 256 * physobj:GetMass())

		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:MakeAppearEffect(newpos)
	end
	
	
end

function WARE:StartAction()	
	local centerpos    = GAMEMODE:GetEnts("center")[1]:GetPos()
	
	for k,pos in pairs(self.Positions) do
		local anglePart = (pos - centerpos):Angle()
		anglePart.p = -35
		anglePart.r = -180
		anglePart.y = anglePart.y + 180
	
		local ent = ents.Create( "npc_turret_ceiling" )
		ent:SetKeyValue("spawnflags", 32)
		ent:SetPos( pos + (pos - centerpos) * 0.05 )
		ent:SetAngles( anglePart )
		ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		ent:Spawn()
		
		--ent:Fire("Enable")
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
end

function WARE:EndAction()

end

function WARE:EntityTakeDamage( ent, inflictor, attacker, amount)
	if ent:IsPlayer() and ent:IsWarePlayer() and attacker:IsNPC( ) then
		ent:ApplyLose( )
	end
end

function WARE:Think( )
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		if v:GetPos().z < self.zlimit then
			v:ApplyLose( )
		end
	end
end
