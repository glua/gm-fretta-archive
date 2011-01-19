WARE.Author = "Hurricaaane (Ha3)"

WARE.Models = {
	"models/props_junk/plasticbucket001a.mdl",
	"models/props_junk/metalbucket01a.mdl",
	"models/props_junk/propanecanister001a.mdl",
	"models/props_combine/breenglobe.mdl",
	"models/props_c17/chair_office01a.mdl",
	"models/props_c17/chair_stool01a.mdl",
	"models/props_wasteland/controlroom_chair001a.mdl"
 }
 
WARE.Bullseyes = {}
WARE.BVelocity = 128
 
local MDLLIST = WARE.Models
 
function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_AIM )
	
	GAMEMODE:SetWareWindupAndLength(1.5,8)
	
	self.TimesToHit = 1
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Hit the bullseye!" )
	
	-- HAXX
	-- GravGunOnPickedUp hook is broken, so we'll use this tricky workaround
	local lua_run = ents.Create("lua_run")
	--lua_run:SetKeyValue('Code','CALLER:SetNWEntity("CanOwner",ACTIVATOR)')
	lua_run:SetKeyValue('Code','CALLER.LastPuntedBy=ACTIVATOR')
	lua_run:SetKeyValue('targetname','luarun')
	lua_run:Spawn()
	
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		ply:Give( "weapon_physcannon" )
		ply.BULLSEYE_Hit = 0
	end
	
	self.Bullseyes = {}
	
end

function WARE:StartAction()
	local ratio = 0.3
	local minimum = 1
	local num = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * ratio), minimum, 64)
	local entposcopy = GAMEMODE:GetRandomPositions(num, ENTS_OVERCRATE)
	
	for k,pos in pairs(entposcopy) do
		local ent = ents.Create("ware_bullseye")
		ent:SetPos(pos)
		ent:Spawn()
		
		self.Bullseyes[k] = ent
		
		local phys = ent:GetPhysicsObject()
		phys:ApplyForceCenter(VectorRand() * 16)
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
	local propRatio = 1.3
	local propMinimum = 1
	local propNum = math.Clamp(math.ceil(team.NumPlayers(TEAM_HUMANS) * propRatio), propMinimum, 64)
	for i,pos in ipairs(GAMEMODE:GetRandomPositions(propNum, ENTS_ONCRATE)) do	
		local model = MDLLIST[ math.random(1, #MDLLIST) ]
		
		local ent = ents.Create("prop_physics")
		ent:SetModel( model )
		ent:SetPos( pos + Vector(0,0,64) )
		ent:SetAngles( Angle(0, math.Rand(0,360), 0) )
		ent:Spawn()
		
		ent:Fire("AddOutput", "OnPhysGunPickup luarun,RunCode")
		
		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
end

function WARE:EndAction()
	for _,v in pairs(ents.FindByClass("lua_run")) do
		v:Remove()
	end

end

function WARE:Think()
	for k,ent in pairs(self.Bullseyes) do
		if ValidEntity(ent) and ent:GetPhysicsObject():IsValid() then
			local physobj = ent:GetPhysicsObject()
			local vel = physobj:GetVelocity()
			local speed = vel:Length()
			if (speed > self.BVelocity) then
				vel = vel:Normalize() * ((speed - self.BVelocity) * 0.7 + self.BVelocity)
				physobj:SetVelocity(vel)
			end
		end
	end
end

function WARE:WarePhysicsCollideStream( collide_ent, data, physobj )
	if (collide_ent:GetClass() == "ware_bullseye") and (data.HitEntity:GetClass() == "prop_physics") then
		if ValidEntity(data.HitEntity.LastPuntedBy) and data.HitEntity.LastPuntedBy:IsPlayer() then
			data.HitEntity.LastPuntedBy:ApplyWin( )
			data.HitEntity.LastPuntedBy:StripWeapons()
		end
	end
	
	return false
end

function WARE:GravGunPickupAllowed( ply, target )
	if ValidEntity(target) and target:GetClass() == "ware_bullseye" then
		return false
	else
		return true
	end
end

function WARE:GravGunPunt( ply, target )
	if ValidEntity(target) and target:GetClass() == "ware_bullseye" then
		return false
	else
		return true
	end
end