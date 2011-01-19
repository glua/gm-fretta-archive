WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "hexaprism"

WARE.Models = {
"models/Roller.mdl"
}

WARE.ToGather = 0
WARE.Gathered = 0
WARE.ToSpawn = 0
WARE.ToSpawnToSend = 0

WARE.ZipEnt = nil
WARE.FacepunchEnt = nil
WARE.ZipBuilt = false

WARE.BVelocity = 128

function WARE:GetModelList()
	return self.Models
end


/*function WARE:IsPlayable()
	return false
end*/

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_FRENZY, AWARD_AIM )
	
	-- HAXX
	-- GravGunOnPickedUp hook is broken, so we'll use this tricky workaround
	local lua_run = ents.Create("lua_run")
	
	lua_run:SetKeyValue('Code','CALLER.Owner=ACTIVATOR')
	lua_run:SetKeyValue('targetname','luarun')
	lua_run:Spawn()


	self.Gathered = 0

	self.ZipEnt = nil
	self.FacepunchEnt = nil
	self.ZipBuilt = false

	GAMEMODE:RespawnAllPlayers( true, true )
	
	GAMEMODE:SetWareWindupAndLength(1, 12)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Be useful!" )
	
	local ratio = 0.6
	local minimum = 3
	self.ToGather =  math.Clamp(math.ceil( team.NumPlayers(TEAM_HUMANS) * ratio) , minimum, 64)
	self.ToSpawn = math.ceil( self.ToGather * 1.5 )
	
end

function WARE:StartAction()	

	GAMEMODE:DrawInstructions( "Gather up ".. self.ToGather .." files into the folder!" )

	local myChoice = {}
	
	local centerpos    = GAMEMODE:GetEnts("center")[1]:GetPos()
	local alandmeasure = math.floor((GAMEMODE:GetEnts("land_a")[1]:GetPos() - centerpos):Length() * 0.5)
	
	for i=1,self.ToSpawn do
		local newpos = Vector(0,0,128) + centerpos + Angle(0, math.random(0,360), 0):Forward() * math.random(alandmeasure * 0.5, alandmeasure)
		
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[1] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(newpos)
		prop:Spawn()
		
		prop:SetColor(255, 255, 255, 0)
		prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		prop.IsAFile = true
		
		prop:Fire("AddOutput", "OnPhysGunPickup luarun,RunCode")
	
		local physobj = prop:GetPhysicsObject()
		physobj:EnableMotion(true)
		physobj:ApplyForceCenter(VectorRand() * 256 * physobj:GetMass())

		local filelogo = ents.Create("ware_icon_file")
		filelogo:SetPos(newpos)
		filelogo:Spawn()
		filelogo:SetParent(prop)
		
		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:AppendEntToBin(filelogo)
		GAMEMODE:MakeAppearEffect(newpos)
	end
	
	local centerposupped = GAMEMODE:GetEnts("center")[1]:GetPos() + Vector(0,0,340)
	
	self.ZipEnt = ents.Create("prop_physics")
	self.ZipEnt:SetModel( self.Models[1] )
	self.ZipEnt:PhysicsInit(SOLID_VPHYSICS)
	self.ZipEnt:SetSolid(SOLID_VPHYSICS)
	self.ZipEnt:SetPos(centerposupped)
	self.ZipEnt:Spawn()
	
	self.ZipEnt:SetColor(255, 255, 255, 0)
	self.ZipEnt:GetPhysicsObject():EnableMotion(false)
	self.ZipEnt:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local zipicon = ents.Create("ware_icon_zip")
	zipicon:SetPos(centerposupped)
	zipicon:Spawn()
	zipicon:SetParent(self.ZipEnt)
	
	local textent = ents.Create("ware_text")
	textent:SetPos(centerposupped)
	textent:Spawn()
	textent:SetParent(self.ZipEnt)
	
	--local rp = RecipientFilter()
	--rp:AddAllPlayers()
	
	textent:SetEntityInteger( 0 )
	GAMEMODE:SendEntityTextColor( nil , textent, 255, 255, 0, 255 )
	
	self.ZipEnt.AssociatedText = textent
	
	GAMEMODE:AppendEntToBin(self.ZipEnt)
	GAMEMODE:AppendEntToBin(zipicon)
	GAMEMODE:AppendEntToBin(textent)
	GAMEMODE:MakeAppearEffect(centerposupped)
	
	
	
	
	local facepunchpos = centerposupped + Vector(0,0,64)
	self.FacepunchEnt = ents.Create("ware_bullseye")
	self.FacepunchEnt:SetPos(facepunchpos)
	self.FacepunchEnt:Spawn()
	
	self.FacepunchEnt:SetInternalVisibility( false )
	
	local phys = self.FacepunchEnt:GetPhysicsObject()
	phys:ApplyForceCenter(VectorRand() * 32)
	
	local facelogo = ents.Create("ware_icon_facepunch")
	facelogo:SetPos(facepunchpos)
	facelogo:Spawn()
	facelogo:SetParent(self.FacepunchEnt)
	
	GAMEMODE:AppendEntToBin(self.FacepunchEnt)
	GAMEMODE:AppendEntToBin(facelogo)
	GAMEMODE:MakeAppearEffect(self.FacepunchEnt:GetPos())
	
	
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
end

function WARE:MidActionTrigger()
	if self.ZipBuilt then return end
	self.ZipBuilt = true

	self.ToSpawnToSend = 0
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		if v:GetAchieved() == false then
			v:ApplyLose()
			v:StripWeapons()
		else
			v:SetAchievedNoLock( false )
			self.ToSpawnToSend = self.ToSpawnToSend + 1
		end
	end
	GAMEMODE:DrawInstructions( "Send every mail to Facepunch!" )
	
	local savedpos = self.ZipEnt:GetPos()
	self.ZipEnt:Remove()
	
	GAMEMODE:MakeAppearEffect( savedpos )
	
	for i=1,self.ToSpawnToSend do
		local newpos = savedpos
		
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[1] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(newpos)
		prop:Spawn()
		
		prop:SetColor(255, 255, 255, 0)
		prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		prop.IsAMail = true
		
		local physobj = prop:GetPhysicsObject()
		physobj:EnableMotion(true)
		physobj:ApplyForceCenter(VectorRand() * 256 * physobj:GetMass())
		
		prop:Fire("AddOutput", "OnPhysGunPickup luarun,RunCode")

		local filelogo = ents.Create("ware_icon_mail")
		filelogo:SetPos(newpos)
		filelogo:Spawn()
		filelogo:SetParent(prop)
		
		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:AppendEntToBin(filelogo)
		GAMEMODE:MakeAppearEffect(newpos)
	end
	
end

function WARE:EndAction()
	if not self.ZipBuilt then
		for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
			v:SetAchievedNoLock( false )
		end
	end

	for _,v in pairs(ents.FindByClass("lua_run")) do
		v:Remove()
	end
end

function WARE:Think()
	if self.FacepunchEnt then
		local physobj = self.FacepunchEnt:GetPhysicsObject()
		local vel = physobj:GetVelocity()
		local speed = vel:Length()
		if (speed > self.BVelocity) then
			vel = vel:Normalize() * ((speed - self.BVelocity) * 0.7 + self.BVelocity)
			physobj:SetVelocity(vel)
		end
	end

	if not self.ZipBuilt then
		if self.ZipEnt then
			local sphere = ents.FindInSphere(self.ZipEnt:GetPos() ,32)
			for _,target in pairs(sphere) do
				if target.IsAFile and target.Owner then
					GAMEMODE:MakeDisappearEffect( self.ZipEnt:GetPos() )
					
					if target.Owner then
						target.Owner:SetAchievedNoLock( true )
					end
					
					target:EmitSound("npc/roller/mine/combine_mine_deploy1.wav")
					target:Remove()
					
					self.Gathered = self.Gathered + 1
					
					if self.Gathered >= self.ToGather then
						self:MidActionTrigger()
					else
						self.ZipEnt.AssociatedText:SetEntityInteger( self.Gathered )
					end
				end
			end
		end
		
	else
		if self.FacepunchEnt then
			local sphere = ents.FindInSphere(self.FacepunchEnt:GetPos(), 64)
			for _,target in pairs(sphere) do
				if target.IsAMail and target.Owner then
					GAMEMODE:MakeDisappearEffect( self.FacepunchEnt:GetPos() )
					
					if target.Owner then
						target.Owner:ApplyWin( )
						target.Owner:StripWeapons()
					end
					
					target:EmitSound("npc/roller/mine/combine_mine_deploy1.wav")
					target:Remove()
				end
			end
		end
	end
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
