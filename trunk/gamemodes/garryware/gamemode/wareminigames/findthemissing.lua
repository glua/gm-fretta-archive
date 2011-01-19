WARE.Author = "Hurricaaane (Ha3)"

WARE.Models = { "models/props_c17/FurnitureWashingmachine001a.mdl" }
WARE.MyProps = nil

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:SetWareWindupAndLength(5, 6)
	GAMEMODE:SetPlayersInitialStatus( nil )
	GAMEMODE:DrawInstructions( "Watch the props..." )
	
	local ratio = 0.8
	local minimum = 4
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS)*ratio), minimum, 64)
	self.MyProps = GAMEMODE:GetRandomLocationsAvoidBox(num, ENTS_ONCRATE, function(v) return v:IsPlayer() end, Vector(-30,-30,0), Vector(30,30,64))
	for k,v in pairs(self.MyProps) do
		local ent = ents.Create ("prop_physics")
		ent:SetModel( self.Models[1] )
		ent:SetPos(v:GetPos() + Vector(0,0,22))
		ent:SetAngles(Angle(0,math.Rand(0,360),0) )
		ent:Spawn()
		
		ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
		ent:GetPhysicsObject():EnableMotion( false )
		
		ent.LocationOrigin = v
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
		
		self.MyProps[k] = ent
	end
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Stand on a missing prop!" )
	
	self.MissingEnts = {}
	local ratio = 0.25
	local minimum = 1
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS)*ratio),minimum,64)
	
	for i=1,num do
		local randNum = math.random(1, #self.MyProps)
		local ent     = table.remove(self.MyProps, randNum)
	
		table.insert( self.MissingEnts, ent.LocationOrigin )
		ent:Remove()
		
		local land = ents.Create ("gmod_landmarkonremove")
		land:SetPos( ent.LocationOrigin:GetPos() )
		land:Spawn()
		GAMEMODE:AppendEntToBin( land )
	end
end

function WARE:EndAction()
	for k,v in pairs(self.MissingEnts) do
		local missentpos = v:GetPos()
		local box = ents.FindInBox(missentpos + Vector(-30,-30,0), missentpos + Vector(30,30,64))
		for _, target in pairs(box) do
			if target:IsPlayer() then
				target:ApplyWin( )
			end
		end
	end
end
