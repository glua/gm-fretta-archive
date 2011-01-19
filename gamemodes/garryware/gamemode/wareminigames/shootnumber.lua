WARE.Author = "Hurricaaane (Ha3)"

WARE.Models = {
"models/props_wasteland/laundry_basket001.mdl"
 }
 
WARE.CorrectColor = Color(0,0,0,255)

function WARE:GetModelList()
	return self.Models
end

WARE.Numbers = {}
WARE.NumberSpawns = 0

WARE.NumPhases = 5

function WARE:_DiceNoRepeat( myMax, lastUsed )
	local dice = math.random(1, myMax - 1)
	if (dice >= lastUsed) then
		dice = dice + 1
	end
	
	return dice
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_REFLEX, AWARD_FRENZY, AWARD_AIM )
	self.RoleColor = Color(114, 49, 130)
	
	self.NumberSpawns = math.random( 7, 20 )
	
	self.Crates = {}
	self.Numbers = {}
	self.Sequence = {}
	
	local previousnumber = 0
	for i,pos in ipairs(GAMEMODE:GetRandomPositions(self.NumberSpawns, ENTS_ONCRATE)) do
		local prop = ents.Create("prop_physics")
		prop:SetModel( self.Models[1] )
		prop:PhysicsInit(SOLID_VPHYSICS)
		prop:SetSolid(SOLID_VPHYSICS)
		prop:SetPos(pos+Vector(0,0,92))
		prop:Spawn()
		
		prop:SetColor(255, 255, 255, 100)
		prop:SetHealth(100000)
		prop:SetMoveType(MOVETYPE_NONE)
		prop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		prop.CrateID = i
		
		self.Crates[i] = prop
		
		local textent = ents.Create("ware_text")
		previousnumber = previousnumber + math.random(1,35)
		textent:SetPos(pos + Vector(0,0,92))
		textent:Spawn()
		textent:SetEntityInteger( previousnumber )
		
		table.insert( self.Numbers , previousnumber )
		
		prop.AssociatedText = textent
		
		GAMEMODE:AppendEntToBin(prop)
		GAMEMODE:AppendEntToBin(textent)
		GAMEMODE:MakeAppearEffect(pos)
	end
	
	self.TimeToGuess = 2.1 + (#self.Numbers / 7) * 0.2
	

	GAMEMODE:SetWareWindupAndLength(#self.Numbers * 0.2, self.TimeToGuess )
	
	self.Dice = math.random(1, #self.Numbers)
	
	GAMEMODE:SetPlayersInitialStatus( false )
	GAMEMODE:DrawInstructions("Shoot the " .. self.Numbers[self.Dice] .. "!")
	GAMEMODE:OverrideAnnouncer( 3 )
	
end

function WARE:StartAction()	
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give("sware_pistol")
		v:GiveAmmo(12, "Pistol", true)
		
	end
	
end

function WARE:EndAction()
	
end


function WARE:PreEndAction()
	if GAMEMODE:GetCurrentPhase() < self.NumPhases then
		local someoneAchieved = false
		local recipient = RecipientFilter()
		for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
			if ply:GetAchieved() then
				ply:SetAchievedNoLock( false )
				someoneAchieved = true
				recipient:AddPlayer( ply )
				
			else
				ply:ApplyLose()
				
			end
			
		end
		
		if someoneAchieved then
			local goodent = self.Crates[self.Dice]
			GAMEMODE:SendEntityTextColor( recipient , goodent.AssociatedText , 255, 255, 255, 255 )
			
			GAMEMODE:SetNextPhaseLength( self.TimeToGuess )
			
		end
		
	end
	
end

function WARE:PhaseSignal( iPhase )
	self.Dice = self:_DiceNoRepeat( #self.Numbers, self.Dice )
	
	GAMEMODE:DrawInstructions( "Now shoot the ".. self.Numbers[self.Dice] .. "!" , self.RoleColor )
	GAMEMODE:OverrideAnnouncer( 3 )

end



function WARE:EntityTakeDamage(ent,inf,att,amount,info)
	local pool = self
	
	if not att:IsPlayer() or not info:IsBulletDamage() then return end
	if not pool.Crates or not ent.CrateID then return end
	
	GAMEMODE:MakeAppearEffect( ent:GetPos() )
	
	if not att:GetAchieved() then
		if (ent.CrateID == self.Dice) then
			if GAMEMODE:GetCurrentPhase() == self.NumPhases then
				att:ApplyWin()
				att:StripWeapons()
			
			else
				att:TellDone( )
				att:SendHitConfirmation( )
				att:SetAchievedNoLock( true )
				
			end
			
			GAMEMODE:SendEntityTextColor( att, ent.AssociatedText , 0, 192, 0, 255 )
		
		else
			local goodent = pool.Crates[self.Dice]
			GAMEMODE:SendEntityTextColor( att , goodent.AssociatedText , 255, 0, 0, 255 )
			GAMEMODE:SendEntityTextColor( att , ent.AssociatedText     , 96, 96, 96, 255 )
		
			att:ApplyLose( )
			att:StripWeapons()
			
		end
		
	end
end
