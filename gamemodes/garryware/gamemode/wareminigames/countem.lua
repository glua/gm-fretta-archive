WARE.Author = "Hurricaaane (Ha3)"

WARE.Models = { "models/props_c17/FurnitureWashingmachine001a.mdl", "models/props_junk/wood_crate001a.mdl" }
WARE.MyProps = nil

WARE.CorrectColor = Color(0,0,0,255)

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:OverrideAnnouncer( 2 )
	GAMEMODE:SetWareWindupAndLength(5, 6)
	GAMEMODE:SetPlayersInitialStatus( nil )
	GAMEMODE:DrawInstructions( "Watch the props..." )
	
	self.Grid = entity_map.Create()
	for k,v in pairs( GAMEMODE:GetEnts( ENTS_ONCRATE ) ) do	
		v.W_CRATE = nil
		self.Grid:Insert( v )
		
	end
	
	
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
		v.W_CRATE = ent
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
		
		self.MyProps[k] = ent
	end
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "How many props were in this row?" )
	
	local useX = (math.random(0,1) == 1) and true or false
	local whichAttic = math.random(1, useX and self.Grid:Width() or self.Grid:Height())
	
	self.myCoponents = {}
	-- We reversed because we want every orthogon to this row/column which is determined by whichAttic
	
	local howManyPossible = (not useX and self.Grid:Width() or self.Grid:Height())
	for i=1,howManyPossible do
		local myCopo = self.Grid:Get( (useX and whichAttic or i), (not useX and whichAttic or i) )
		if myCopo.W_CRATE then
			table.insert( self.myCoponents, myCopo )
			myCopo.W_CRATE:Remove()
			
		end
		
	end
	
	self.Answer = #self.myCoponents
	
	local extremaA = self.Grid:Get( (useX and whichAttic or 1), (not useX and whichAttic or 1) ):GetPos()
	local extremaB = self.Grid:Get( (useX and whichAttic or howManyPossible), (not useX and whichAttic or howManyPossible) ):GetPos()
	
	for r=0,howManyPossible do
		local relative = r / howManyPossible
		local newpos = extremaB * relative + extremaA * (1 - relative) + Vector(0, 0, 128)
		
		
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[2] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(newpos)
		prop:Spawn()
		
		prop:SetColor(255, 255, 255, 192)
		prop:SetHealth(100000)
		prop:GetPhysicsObject():EnableMotion( false )
		prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		prop.CrateID = r
		
		local textent = ents.Create("ware_text")
		textent:SetPos( newpos )
		textent:Spawn( )
		textent:SetParent( prop )
		
		prop.AssociatedText = textent
		
		textent:SetEntityInteger( r )
		
		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:AppendEntToBin(textent)
		GAMEMODE:MakeAppearEffect(newpos)
		
	end
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v.W_MYCHOICE = -1
	
		v:Give("sware_pistol")
		v:GiveAmmo(12, "Pistol", true)
	end
end

function WARE:EndAction()
	for k,ply in pairs( team.GetPlayers( TEAM_HUMANS ) ) do
		if (ply.W_MYCHOICE or -1) == self.Answer then
			ply:SetAchievedNoLock( true )
		else
			ply:SetAchievedNoLock( false )
			
		end
		
	end
	
	for k,v in pairs( self.myCoponents ) do
		GAMEMODE:MakeLandmarkEffect( v:GetPos() )
	end
	
	GAMEMODE:DrawInstructions( "Answer was ".. self.Answer .."!" , self.CorrectColor)
	
end

function WARE:EntityTakeDamage(ent,inf,att,amount,info)
	local pool = self
	
	if not att:IsPlayer() or not info:IsBulletDamage() then return end
	if not ent.CrateID then return end
	
	GAMEMODE:MakeAppearEffect(ent:GetPos())
	
	att:StripWeapons()
	GAMEMODE:SendEntityTextColor( att , ent.AssociatedText , 255, 255, 64, 255 )
	
	att.W_MYCHOICE = ent.CrateID
	
end
