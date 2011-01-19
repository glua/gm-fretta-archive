WARE.Author = "Kilburn"

local CrateColours = {
	{1,0,0},
	{0,1,0},
	{0,0,1},
	{1,1,0},
	{1,0,1},
	{0,1,1},
}

local CratePitches = {
	262,
	294,
	330,
	349,
	392,
	440,
}

WARE.Models = {
"models/props_junk/wood_crate001a.mdl"
 }

function WARE:GetModelList()
	return self.Models
end

function WARE:ResetCrate(i)
	if not self.Crates then return end
	
	local prop = self.Crates[i]
	if not(prop and prop:IsValid()) then return end
	
	local col = CrateColours[i]
	
	prop:SetColor(col[1]*100, col[2]*100, col[3]*100, 100)
end

function WARE:PlayCrate(i)
	if not self.Crates then return end
	
	local prop = self.Crates[i]
	if not(prop and prop:IsValid()) then return end
	
	local col = CrateColours[i]
	
	prop:SetColor(col[1]*255, col[2]*255, col[3]*255, 255)
	prop:SetHealth(100000)
	prop:EmitSound("buttons/button17.wav", 100, CratePitches[i]/3)
	
	GAMEMODE:MakeAppearEffect( prop:GetPos() )
	
	timer.Simple(0.5, self.ResetCrate, self, i)
end

-----------------------------------------------------------------------------------

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_IQ_WIN )
	GAMEMODE:SetFailAwards( AWARD_IQ_FAIL )
	GAMEMODE:OverrideAnnouncer( 2 )
	
	local numberSpawns = 5
	local delay = 4
	
	GAMEMODE:SetWareWindupAndLength(numberSpawns + delay, numberSpawns)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Watch carefully!" )
	
	self.Crates = {}
	
	for i,pos in ipairs(GAMEMODE:GetRandomPositions(numberSpawns, ENTS_ONCRATE)) do
		local col = CrateColours[i]
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[1] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(pos + Vector(0,0,64))
		prop:Spawn()
		
		prop:SetColor(col[1]*100, col[2]*100, col[3]*100, 100)
		prop:SetHealth(100000)
		prop:SetMoveType(MOVETYPE_NONE)
		prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		prop.CrateID = i
		
		self.Crates[i] = prop
		
		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:MakeAppearEffect(pos)
	end
	
	local sequence = {}
	for i=1,numberSpawns do sequence[i]=i end
	
	self.Sequence = {}
	for i=1,numberSpawns do
		self.Sequence[i] = table.remove(sequence, math.random(1,#sequence))
		timer.Simple(delay+i-1, self.PlayCrate, self, self.Sequence[i])
	end
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Repeat!" )
	
	self.PlayerCurrentCrate = {}
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give("sware_pistol")
		v:GiveAmmo(12, "Pistol", true)
		self.PlayerCurrentCrate[v] = 1
	end
end

function WARE:EndAction()
	
end

function WARE:EntityTakeDamage(ent,inf,att,amount,info)
	local pool = self
	
	if not att:IsPlayer() or not info:IsBulletDamage() then return end
	if not pool.PlayerCurrentCrate[att] then return end
	if not pool.Crates or not ent.CrateID then return end
	
	self:PlayCrate(ent.CrateID)
	
	if pool.Sequence[pool.PlayerCurrentCrate[att]] == ent.CrateID then
		pool.PlayerCurrentCrate[att] = pool.PlayerCurrentCrate[att] + 1
		att:SendHitConfirmation()
		if not pool.Sequence[pool.PlayerCurrentCrate[att]] then
			att:ApplyWin( )
			att:StripWeapons()
		end
	else
		att:ApplyLose( )
		att:StripWeapons()
	end
end
