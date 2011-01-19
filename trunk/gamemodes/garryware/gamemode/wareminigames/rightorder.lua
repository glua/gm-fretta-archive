WARE.Author = "Hurricaaane (Ha3)"

WARE.Models = {
"models/props_junk/wood_crate001a.mdl"
 }
 
WARE.CorrectColor = Color(0,0,0,255)

function WARE:GetModelList()
	return self.Models
end

WARE.Numbers = {}
WARE.NumberSpawns = 7

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_IQ_WIN )
	GAMEMODE:SetFailAwards( AWARD_IQ_FAIL )
	
	local doTrap = (math.random(0,4) == 4)
	GAMEMODE:OverrideAnnouncer( 2 )
	
	self.NumberSpawns = math.random( 4, 7 )

	GAMEMODE:SetWareWindupAndLength(self.NumberSpawns * 0.4, self.NumberSpawns * 1.7 * (doTrap and 1.3 or 1))
	
	GAMEMODE:SetPlayersInitialStatus( false )
	--GAMEMODE:DrawInstructions("Shoot all " .. self.NumberSpawns .." crates in the right order!" )
	GAMEMODE:DrawInstructions("Shoot in the right order!" )
	
	self.Crates = {}
	self.Numbers = {}
	self.Sequence = {}
	
	local previousnumber = doTrap and (-math.random(50,120)) or 0
	for i,pos in ipairs(GAMEMODE:GetRandomPositions(self.NumberSpawns, ENTS_ONCRATE)) do
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[1] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(pos+Vector(0,0,64))
		prop:Spawn()
		
		prop:SetColor(255, 255, 255, 100)
		prop:SetHealth(100000)
		prop:SetMoveType(MOVETYPE_NONE)
		prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		prop.CrateID = i
		
		self.Crates[i] = prop
		
		local textent = ents.Create("ware_text")
		previousnumber = previousnumber + math.random(1,35)
		textent:SetPos(pos + Vector(0,0,64))
		textent:Spawn()
		textent:SetEntityInteger( previousnumber )
		
		table.insert( self.Numbers , previousnumber )
		
		prop.AssociatedText = textent
		
		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:AppendEntToBin(textent)
		GAMEMODE:MakeAppearEffect(pos)
	end
	
end

function WARE:StartAction()
	
	local croissant = math.random(0,1)
	if (croissant == 1) then
		for k=1,self.NumberSpawns do
			table.insert( self.Sequence , k )
		end
		GAMEMODE:DrawInstructions( "In the ascending order! (1 , 2 , 3...)" )
		GAMEMODE:PrintInfoMessage( "Sequence order", " is ", "ascending (1 , 2 , 3...)!" )
	else
		for k=self.NumberSpawns,1,-1 do
			table.insert( self.Sequence , k )
		end
		GAMEMODE:DrawInstructions( "In the descending order! (3 , 2 , 1...)" )
		GAMEMODE:PrintInfoMessage( "Sequence order", " is ", "descending (3 , 2 , 1...)!" )
	end
	
	self.PlayerCurrentCrate = {}
	self.PlayerAlreadyHitCrate = {}
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		self.PlayerAlreadyHitCrate[v] = {}
		v:Give("sware_pistol")
		v:GiveAmmo(12, "Pistol", true)
		self.PlayerCurrentCrate[v] = 1
	end
end

function WARE:EndAction()
	local message = ""
	
	for k,seqK in pairs( self.Sequence ) do
		message = message .. self.Numbers[ seqK ]
		if k < #self.Sequence then
			message = message .. " , "
		end
	end
	
	GAMEMODE:PrintInfoMessage( "Sequence", " was ", message .."!" )
	GAMEMODE:DrawInstructions( "Sequence was ".. message .."!" , self.CorrectColor)
end

function WARE:EntityTakeDamage(ent,inf,att,amount,info)
	local pool = self
	
	if not att:IsPlayer() or not info:IsBulletDamage() then return end
	if not pool.PlayerCurrentCrate[att] then return end
	if not pool.Crates or not ent.CrateID then return end
	
	if (self.PlayerAlreadyHitCrate[att][ent.CrateID] == true) then return end
	self.PlayerAlreadyHitCrate[att][ent.CrateID] = true
	
	GAMEMODE:MakeAppearEffect( ent:GetPos() )
	
	if pool.Sequence[pool.PlayerCurrentCrate[att]] == ent.CrateID then
		pool.PlayerCurrentCrate[att] = pool.PlayerCurrentCrate[att] + 1
		
		att:SendHitConfirmation( )
		GAMEMODE:SendEntityTextColor( att , ent.AssociatedText , 0, 192, 0, 255 )
		
		if not pool.Sequence[pool.PlayerCurrentCrate[att]] then
			att:ApplyWin( )
			att:StripWeapons()
		end
		
	else
		local goodent = pool.Crates[pool.Sequence[pool.PlayerCurrentCrate[att]]]
		GAMEMODE:SendEntityTextColor( att , goodent.AssociatedText , 255, 0, 0, 255 )
		GAMEMODE:SendEntityTextColor( att , ent.AssociatedText     , 96, 96, 96, 255 )
	
		att:ApplyLose( )
		att:StripWeapons()
		
	end
end
