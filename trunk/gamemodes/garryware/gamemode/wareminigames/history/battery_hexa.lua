WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "hexaprism"

WARE.Models = {
"models/items/item_item_crate.mdl",
"models/props_lab/tpplugholder_single.mdl",
"models/items/car_battery01.mdl",
"models/props_lab/tpplug.mdl",
"models/combine_camera/combine_camera.mdl"
 }

local MDL_CRATE = 1
local MDL_PLUGHOLDER = 2
local MDL_BATTERY = 3
local MDL_BATTERYDONGLE = 4

local MDLLIST = WARE.Models

local hexaprism_oppositions = {
"land_a",
"land_b",
"land_c",
"land_d",
"land_e",
"land_f"
}

//TBD DEBUG
function WARE:IsPlayable()
	return false
end

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:RespawnAllPlayers( true, true )

	self.Sockets = {}
	GAMEMODE:SetWareWindupAndLength(1,12)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Find a battery and plug it!" )
	
	-- HAXX
	-- GravGunOnPickedUp hook is broken, so we'll use this tricky workaround
	local lua_run = ents.Create("lua_run")
	--lua_run:SetKeyValue('Code','CALLER:SetNWEntity("CanOwner",ACTIVATOR)')
	lua_run:SetKeyValue('Code','CALLER.BatteryOwner=ACTIVATOR')
	lua_run:SetKeyValue('targetname','luarun')
	lua_run:Spawn()
	
	local ratio = 1
	local minimum = 1
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * ratio),minimum,64)
	local centerpos    = GAMEMODE:GetEnts("center")[1]:GetPos()
	local alandmeasure = math.floor((GAMEMODE:GetEnts("land_a")[1]:GetPos() - centerpos):Length() * 0.5)
	
	local cratelist = {}
	for i=1,num do
		local ent = ents.Create ("prop_physics")
		ent:SetModel( self.Models[MDL_CRATE] )
		ent:SetPos(Vector(0,0,256) + centerpos + Angle(0, math.random(0,360), 0):Forward() * math.random(alandmeasure * 0.5, alandmeasure) )
		ent:Spawn()
		
		table.insert(cratelist, ent)
		
		local phys = ent:GetPhysicsObject()
		phys:Wake()
		phys:ApplyForceCenter(VectorRand() * 256)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
		
		ent.contains = true
	end
	
	local measure = (GAMEMODE:GetEnts( "land_a" )[1]:GetPos() - GAMEMODE:GetEnts( "land_measure" )[1]:GetPos()):Length()
	
	local ratio3 = 0.5
	local minimum3 = 1
	local num3 = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS)*ratio3),minimum3,64)
	local entposcopy3 = {}
	
	local paternation = 0
	
	for i=1,num3 do
		if #entposcopy3 == 0 then
			entposcopy3 = { 1, 2, 3, 4, 5, 6 }
			paternation = paternation + 1
		end
		local idam = table.remove(entposcopy3, math.random(1, #entposcopy3) )
		local land_side  = GAMEMODE:GetEnts( hexaprism_oppositions[idam] )[1]:GetPos() 
		local land_oppos = GAMEMODE:GetEnts( hexaprism_oppositions[(idam - 1 + 3) % 6 + 1] )[1]:GetPos() 
		
		local myAngle    = (land_oppos - land_side):Angle()
		local myPosition = land_side + (land_side - land_oppos):Normalize() * measure + Vector(0,0,64) * paternation
		
		local ent = ents.Create ("prop_physics")
		ent:SetModel( self.Models[MDL_PLUGHOLDER] )
		ent:PhysicsInit(SOLID_VPHYSICS)
		ent:SetSolid(SOLID_VPHYSICS)
		
		ent:SetPos( myPosition )
		ent:SetAngles( myAngle )
		//ent:SetPos( ent:GetPos() + ent:GetRight()*13 + Vector(0,0,-5) )
		
		ent:SetMoveType(MOVETYPE_NONE)
		ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		ent:Spawn()
		ent:GetPhysicsObject():EnableMotion(false)
		
		ent.IsOccupied = false
		table.insert(self.Sockets, ent)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
		
		
		local camera = ents.Create ("npc_combine_camera")
		camera:SetAngles( Angle( myAngle.y, math.random(0,360), myAngle.r ) )
		camera:SetPos( myPosition + Vector(0,0,32) )
		camera:SetKeyValue("spawnflags",208)
		camera:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		camera:Spawn()
		
		ent.LinkedCamera = camera
		
		GAMEMODE:AppendEntToBin(camera)
		GAMEMODE:MakeAppearEffect(camera:GetPos())
	end
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
	return
end

function WARE:StartAction()
	return
end

function WARE:EndAction()
	for _,v in pairs(ents.FindByClass("lua_run")) do
		v:Remove()
	end
	for _,v in pairs(ents.FindByClass("prop_physics")) do
		if v:GetModel() == self.Models[MDL_PLUGHOLDER] and not v.IsOccupied then
			GAMEMODE:MakeLandmarkEffect( v:GetPos() )
		end
	end
end

function WARE:PropBreak(pl,prop)	
	if prop.contains == true then
		local ent = ents.Create ("prop_physics")
		ent:SetModel( self.Models[MDL_BATTERY] )
		ent:SetPos(prop:GetPos())
		ent:Spawn()
		
		ent:Fire("AddOutput", "OnPhysGunPickup luarun,RunCode")
		
		local ent2 = ents.Create ("prop_physics")
		ent2:SetModel( MDLLIST[MDL_BATTERYDONGLE] )
		ent2:SetPos(ent:GetPos() + ent:GetForward()*-8)
		ent2:Spawn()
		ent2:SetParent(ent)

		local phys = ent:GetPhysicsObject()
		phys:Wake()
		phys:AddAngleVelocity(Angle(math.random(200,300),math.random(200,300),math.random(200,300)))
		phys:ApplyForceCenter(VectorRand() * 64)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
		
		local trail_entity = util.SpriteTrail( ent,  //Entity
												0,  //iAttachmentID
												Color( 255, 255, 255, 92 ),  //Color
												false, // bAdditive
												0.9, //fStartWidth
												1.5, //fEndWidth
												1.2, //fLifetime
												1 / ((0.7+1.2) * 0.5), //fTextureRes
												"trails/physbeam.vmt" ) //strTexture
	end
end

local function PlugBatteryIn(batteryremove, socket)
	if ( not ValidEntity(batteryremove) or not ValidEntity(socket) ) then return end
	
	batteryremove:Remove()
	
	
	local battery = ents.Create ("prop_dynamic_override")
	battery:SetModel( MDLLIST[MDL_BATTERY] )
	battery:SetPos(socket:GetPos() + socket:GetForward()*13 + socket:GetRight()*-13 + Vector(0,0,10))
	battery:SetAngles(socket:GetAngles())
	battery:Spawn()
	GAMEMODE:AppendEntToBin(battery)
	
	//battery:GetPhysicsObject():EnableMotion(false)
	//DropEntityIfHeld(battery)
	//battery:GetPhysicsObject():ApplyForceCenter( Vector( 0, 0, 128 ) )

	socket:EmitSound("npc/roller/mine/combine_mine_deploy1.wav")

	local spark = ents.Create("env_spark")
	spark:SetPos(battery:GetPos())
	spark:SetKeyValue("MaxDelay",2)
	spark:SetKeyValue("Magnitude",4)
	spark:SetKeyValue("TrailLength",2)
	spark:Spawn()
	spark:SetParent(battery)
	spark:Fire("SparkOnce")
	
	local camera = socket.LinkedCamera
	camera:Fire("Enable")
end

function WARE:Think()
	if self.Sockets then
		if not self.NextPlugThink or CurTime() > self.NextPlugThink then
		
			for l,w in pairs(self.Sockets) do
			
				for _,v in pairs(ents.FindInSphere(w:GetPos(),24)) do
					if not w.IsOccupied and v:GetModel() == MDLLIST[MDL_BATTERY] then
						local Owner = v.BatteryOwner
						if Owner and Owner:IsPlayer() then
							Owner:StripWeapons()
							Owner:ApplyWin( )
							w.IsOccupied = true
							
							GAMEMODE:MakeAppearEffect(v:GetPos())
							
							timer.Simple(0.05, PlugBatteryIn, v, w)
						end
					end
				end
				
			end
			
			self.NextPlugThink = CurTime() + 0.05
		end
	end
	
	for k,camera in pairs(ents.FindByClass("npc_combine_camera")) do
		local sphere = ents.FindInSphere(camera:GetPos(),24)
		for _,target in pairs(sphere) do
			if target:GetClass() == "prop_physics" then
				target:GetPhysicsObject():ApplyForceCenter((target:GetPos() - camera:GetPos()):Normalize() * 500)
			end
		end
	end
end
