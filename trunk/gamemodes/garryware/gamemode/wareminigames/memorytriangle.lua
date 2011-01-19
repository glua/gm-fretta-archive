WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "empty"

WARE.PossibleColours = {
	{"red"   , Color(255,92,92,255) },
	{"blue"  , Color(92,92,255,255) },
	{"green" , Color(0,192,0,255) }
}

WARE.Models = { "models/props_junk/wood_crate001a.mdl" }

function WARE:GetModelList()
	return self.Models
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_IQ_WIN )
	GAMEMODE:SetFailAwards( AWARD_IQ_FAIL )
	
	GAMEMODE:OverrideAnnouncer( 2 )
	
	local numberSpawns = #self.PossibleColours
	
	GAMEMODE:SetWareWindupAndLength(5,3.5)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions( "Memorize!" )
	
	self.Crates = {}
	
	for i,pos in ipairs(GAMEMODE:GetRandomPositions(numberSpawns, "dark_over")) do
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[1] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		
		local newpos = pos - Vector(0,0,32)
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
	
	local colors = {}
	for i=1,#self.PossibleColours do colors[i]=i end
	
	local previousnumber = 0
	self.RolledColor = {}
	self.RolledNumber = {}
	
	for i=1,numberSpawns do
		local chosencolor = table.remove(colors, math.random(1,#colors))
		self.RolledColor[i] = chosencolor
		
		previousnumber = previousnumber + math.random(1,35)
		self.RolledNumber[i] = previousnumber
		self.Crates[i].AssociatedText:SetEntityInteger(previousnumber)
	end
	
	timer.Simple(0.1, self.SendColors, self)
	timer.Simple(3.5, self.ReleaseAllCrates, self)
end

function WARE:SendColors()
	--local rp = RecipientFilter()
	--rp:AddAllPlayers()
	for i=1,#self.PossibleColours do
		GAMEMODE:SendEntityTextColor(
		nil
		, (self.Crates[i]).AssociatedText
		, self.PossibleColours[self.RolledColor[i]][2].r
		, self.PossibleColours[self.RolledColor[i]][2].g
		, self.PossibleColours[self.RolledColor[i]][2].b
		, 255
		)
	end
end

function WARE:ReleaseAllCrates()
	--local rp = RecipientFilter()
	--rp:AddAllPlayers()
	for i=1,#self.PossibleColours do
		local physobj = self.Crates[i]:GetPhysicsObject()
		
		physobj:EnableMotion(true)
		physobj:ApplyForceCenter(VectorRand() * 512 * physobj:GetMass())
		
		GAMEMODE:SendEntityTextColor( nil , (self.Crates[i]).AssociatedText, 0, 0, 0, 0 )
	end
end

function WARE:StartAction()
	local what_property_color = math.random(0,1)
	self.WinnerID = math.random(1,#self.PossibleColours)
	
	if (what_property_color == 1) then
		local text = self.PossibleColours[self.RolledColor[self.WinnerID]][1]

		GAMEMODE:DrawInstructions( "Shoot the ".. text .." one!" , self.PossibleColours[self.RolledColor[self.WinnerID]][2])
		
	else
		local text = self.RolledNumber[self.WinnerID]

		GAMEMODE:DrawInstructions( "Shoot the "..text.."!" )
	end
	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give("sware_pistol")
		v:GiveAmmo(12, "Pistol", true)
	end
end

function WARE:EndAction()

end

function WARE:EntityTakeDamage(ent,inf,att,amount,info)
	local pool = self
	
	if not att:IsPlayer() or not info:IsBulletDamage() then return end
	if not pool.Crates or not ent.CrateID then return end
	
	GAMEMODE:MakeAppearEffect(ent:GetPos())
	
	att:StripWeapons()
	
	local rp = att
	if self.WinnerID  == ent.CrateID then
		att:ApplyWin()
		
		for i=1,#self.PossibleColours do
			if (i == self.WinnerID) then
				GAMEMODE:SendEntityTextColor(
				rp
				, (pool.Crates[i]).AssociatedText
				, self.PossibleColours[self.RolledColor[i]][2].r
				, self.PossibleColours[self.RolledColor[i]][2].g
				, self.PossibleColours[self.RolledColor[i]][2].b
				, 255
				)
			else
				GAMEMODE:SendEntityTextColor(
				rp
				, (pool.Crates[i]).AssociatedText
				, self.PossibleColours[self.RolledColor[i]][2].r * 0.5
				, self.PossibleColours[self.RolledColor[i]][2].g * 0.5
				, self.PossibleColours[self.RolledColor[i]][2].b * 0.5
				, 255
				)
			end
		end
	else
		att:ApplyLose( )
		
		for i=1,#self.PossibleColours do
			if (i == self.WinnerID) then
				GAMEMODE:SendEntityTextColor(
				rp
				, (pool.Crates[i]).AssociatedText
				, self.PossibleColours[self.RolledColor[i]][2].r
				, self.PossibleColours[self.RolledColor[i]][2].g
				, self.PossibleColours[self.RolledColor[i]][2].b
				, 255
				)
			elseif (i == ent.CrateID) then
				GAMEMODE:SendEntityTextColor(
				rp
				, (pool.Crates[i]).AssociatedText
				, self.PossibleColours[self.RolledColor[i]][2].r * 0.5
				, self.PossibleColours[self.RolledColor[i]][2].g * 0.5
				, self.PossibleColours[self.RolledColor[i]][2].b * 0.5
				, 192
				)
			else
				GAMEMODE:SendEntityTextColor(
				rp
				, (pool.Crates[i]).AssociatedText
				, self.PossibleColours[self.RolledColor[i]][2].r * 0.5
				, self.PossibleColours[self.RolledColor[i]][2].g * 0.5
				, self.PossibleColours[self.RolledColor[i]][2].b * 0.5
				, 255
				)
			end
		end
	end
end
