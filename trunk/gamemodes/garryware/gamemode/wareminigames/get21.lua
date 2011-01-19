WARE.Author = "Hurricaaane (Ha3)"

local List3cards = {
{ 6 , 7 , 8 } , { 5 , 7 , 9 } , { 5 , 6 , 10 } , { 4 , 8 , 9 } , { 4 , 7 , 10 } , { 4 , 6 , 11 } , { 3 , 8 , 10 } , { 3 , 7 , 11 } , { 2 , 9 , 10 } , { 2 , 8 , 11 } , { 1 , 9 , 11 }
}
local List4cards = {
{ 3 , 5 , 6 , 7 } , { 3 , 4 , 6 , 8 } , { 3 , 4 , 5 , 9 } , { 2 , 5 , 6 , 8 } , { 2 , 4 , 7 , 8 } , { 2 , 4 , 6 , 9 } , { 2 , 4 , 5 , 10 } , { 2 , 3 , 7 , 9 } , { 2 , 3 , 6 , 10 } , { 2 , 3 , 5 , 11 } , { 1 , 5 , 7 , 8 } , { 1 , 5 , 6 , 9 } , { 1 , 4 , 7 , 9 } , { 1 , 4 , 6 , 10 } , { 1 , 4 , 5 , 11 } , { 1 , 3 , 8 , 9 } , { 1 , 3 , 7 , 10 } , { 1 , 3 , 6 , 11 } , { 1 , 2 , 8 , 10 } , { 1 , 2 , 7 , 11 }
}
local List5cards = {
{ 2 , 3 , 4 , 5 , 7 } , { 1 , 3 , 4 , 6 , 7 } , { 1 , 3 , 4 , 5 , 8 } , { 1 , 2 , 5 , 6 , 7 } , { 1 , 2 , 4 , 6 , 8 } , { 1 , 2 , 4 , 5 , 9 } , { 1 , 2 , 3 , 7 , 8 } , { 1 , 2 , 3 , 6 , 9 } , { 1 , 2 , 3 , 5 , 10 } , { 1 , 2 , 3 , 4 , 11 }
}
local PossibleCards = { List3cards , List4cards , List5cards }

WARE.Models = {
"models/props_junk/wood_crate001a.mdl"
 }
 
WARE.CorrectColor = Color(0,0,0,255)

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_IQ_WIN )
	GAMEMODE:SetFailAwards( AWARD_IQ_FAIL )
	GAMEMODE:OverrideAnnouncer( 2 )
	
	local numberSpawns = 5
	
	GAMEMODE:SetWareWindupAndLength(1,9)
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Get 21!" )
	
	self.Crates = {}
	
	for i,pos in ipairs(GAMEMODE:GetRandomPositions(numberSpawns, ENTS_OVERCRATE)) do
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[1] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		local newpos = pos - Vector(0,0,0)
		prop:SetPos(newpos)
		prop:Spawn()
		
		prop:SetColor(255, 255, 255, 192)
		prop:SetHealth(100000)
		prop:GetPhysicsObject():EnableMotion(false)
		prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		prop.CrateID = i
		
		self.Crates[i] = prop
		
		local textent = ents.Create("ware_text")
		textent:SetPos(newpos)
		textent:Spawn()
		textent:SetParent(prop)
		
		prop.AssociatedText = textent
		
		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:AppendEntToBin(textent)
		GAMEMODE:MakeAppearEffect(newpos)
	end
	
	local LootEasiest = math.random(1,8)
	local LootAdd = 0
	if (LootEasiest == 8) then
		LootAdd = 1
	end
	local NbCardsToChoose = math.random(3,4+LootAdd)
	self.NbCardsToChoose = NbCardsToChoose
	local ChosenCards = PossibleCards[NbCardsToChoose-2][math.random(1,#PossibleCards[NbCardsToChoose-2])]
	
	for i=1,NbCardsToChoose do
		self.Crates[i].Number = ChosenCards[i]
		self.Crates[i].AssociatedText:SetEntityInteger(ChosenCards[i])
	end
	
	local ListOfCards = {}
	local j = 1
	local n = 1
	while (n <= 11) do
		if (table.HasValue(ChosenCards,n) == false) then
			ListOfCards[j] = n
			j = j + 1
		end
		n = n + 1
	end
	if (NbCardsToChoose < 4) then
		local FakeNumber = table.remove(ListOfCards, math.random(1, #ListOfCards )  )
		self.Crates[4].Number = FakeNumber
		self.Crates[4].AssociatedText:SetEntityInteger(FakeNumber)
	end
	if (NbCardsToChoose < 5) then
		local FakeNumber = table.remove(ListOfCards, math.random(1, #ListOfCards )  )
		self.Crates[5].Number = FakeNumber
		self.Crates[5].AssociatedText:SetEntityInteger(FakeNumber)
	end
end

function WARE:StartAction()
	self.PlayerAddition = {}
	self.PlayerAlreadyHitCrate = {}
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
		self.PlayerAddition[v] = 0
		self.PlayerAlreadyHitCrate[v] = {}
		for i=1,5 do
			self.PlayerAlreadyHitCrate[v][i] = false
		end
		v:Give("sware_pistol")
		v:GiveAmmo(12, "Pistol", true)
	end
end

function WARE:EndAction()
	local message = ""
	
	for iNum=1,self.NbCardsToChoose do
		message = message .. self.Crates[ iNum ].Number
		if iNum < self.NbCardsToChoose then
			message = message .. " + "
		end
	end

	GAMEMODE:PrintInfoMessage( "Possible combination", " was ", message .."!" )
	GAMEMODE:DrawInstructions( "Possible combination was ".. message .."!" , self.CorrectColor)
end

function WARE:EntityTakeDamage(ent,inf,att,amount,info)
	local pool = self
	
	if not att:IsPlayer() or not info:IsBulletDamage() then return end
	if not pool.Crates or not ent.CrateID then return end
	
	GAMEMODE:MakeAppearEffect(ent:GetPos())
	
	if (self.PlayerAlreadyHitCrate[att][ent.CrateID] == true) then return end
	
	self.PlayerAlreadyHitCrate[att][ent.CrateID] = true
	self.PlayerAddition[att] = self.PlayerAddition[att] + ent.Number
	
	if (self.PlayerAddition[att] == 21) then
		att:ApplyWin( )
		att:StripWeapons()
		
		for crateID,uBool in pairs(self.PlayerAlreadyHitCrate[att]) do
			if uBool then
				local correctPlyCrate = self.Crates[ crateID ]
				GAMEMODE:SendEntityTextColor( att , correctPlyCrate.AssociatedText , 0, 192, 0, 255 )
			end
		end
		
	elseif (self.PlayerAddition[att] > 21) then
		att:ApplyLose( )
		att:StripWeapons()
		
		for i=1,self.NbCardsToChoose do
			GAMEMODE:SendEntityTextColor( att , (pool.Crates[i]).AssociatedText , 255, 0, 0, 255 )
		end
		
		if (self.NbCardsToChoose < 4) then
			GAMEMODE:SendEntityTextColor( att , (pool.Crates[4]).AssociatedText , 64, 64, 64, 255 )
		end
		if (self.NbCardsToChoose < 5) then
			GAMEMODE:SendEntityTextColor( att , (pool.Crates[5]).AssociatedText , 64, 64, 64, 255 )
		end
	else
		
		GAMEMODE:SendEntityTextColor( att , ent.AssociatedText , 255, 255, 64, 255 )
		
	end
end
