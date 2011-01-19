WARE.Author = ""

function WARE:IsPlayable()
	return false
end

function WARE:Initialize()
	self.RoleColor = Color(114, 49, 130)
	
	GAMEMODE:SetWareWindupAndLength(4, 5)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "A new GarryWare game starts!" )
	GAMEMODE:ForceNoAnnouncer( )
	
	self.Entground = GAMEMODE:GetEnts(ENTS_CROSS)
	umsg.Start("SpecialFlourish")
		umsg.Char( 1 )
	umsg.End()
	
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do
		ply:SetAchievedSpecialInteger( -1 )
		ply:SetLockedSpecialInteger( 1 )
	end
end

local function spawnModel( iModel , modelCount , delay )
	local pos = GAMEMODE:GetRandomPositions(1, ENTS_INAIR)[1]
	
	local ent = ents.Create ("prop_physics_override")
	ent:SetModel ( GAMEMODE.ModelPrecacheTable[iModel] )
	ent:SetPos( pos )
	ent:SetAngles( VectorRand():Angle() )
	ent:Spawn()
	ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	local physObj = ent:GetPhysicsObject()
	if physObj:IsValid() then
		physObj:ApplyForceCenter( VectorRand() * math.random( 256, 468 ) * physObj:GetMass() )
	end
	
	GAMEMODE:MakeAppearEffect( ent:GetPos() )
	GAMEMODE:AppendEntToBin( ent )
	
	if (iModel < modelCount) then
		timer.Simple( delay, spawnModel , iModel + 1 , modelCount , delay )
	end
end

function WARE:StartAction()
	GAMEMODE:DrawInstructions( "Rules are easy : Do what it tells you to do!" )
	
	-- This is completely stupid, but I can't get the util.Precache to work, so
	-- I manually do it in a weird and funny way by spawning every model used in game
	-- that the minigame files provided us, so that the intro seems less empty.
	-- But it will lag the players a bit : That's why prepaching is required :
	-- Players used to complain that their game was freezing right in the middle of a minigame.
	
	local modelCount = #GAMEMODE.ModelPrecacheTable
	
	if modelCount > 0 then
		local delay = 4.0 / modelCount
		spawnModel( 1 , modelCount, delay )
	end
	
	for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		v:Give( "weapon_physcannon" )
	end
end

function WARE:PreEndAction()
	if GAMEMODE:GetCurrentPhase() < 3 then
		GAMEMODE:SetNextPhaseLength( 3.5 )
		GAMEMODE:ForceNoAnnouncer( )
		
	end
end

function WARE:PhaseSignal( iPhase )
	if GAMEMODE:GetCurrentPhase() == 2 then
		GAMEMODE:DrawInstructions( "To get on a box, jump then press crouch while in the air!" , self.RoleColor )
		
	end
	
	if GAMEMODE:GetCurrentPhase() == 3 then
		GAMEMODE:DrawInstructions( "Try to get on a box!" , self.RoleColor )
		
	end

end

function WARE:EndAction()
	GAMEMODE:DrawInstructions( "Game begins now! Have fun!" )

end

function WARE:Think()	

end

function WARE:Think( )
	if GAMEMODE:GetCurrentPhase() < 3 then return end
	local entposcopy = GAMEMODE:GetEnts(ENTS_ONCRATE)
	for _,block in pairs(entposcopy) do
		local box = ents.FindInBox(block:GetPos()+Vector(-30,-30,0),block:GetPos()+Vector(30,30,64))
		for _,target in pairs(box) do
			if target:IsPlayer() and not target.__HasCompletedTraining then
				target.__HasCompletedTraining = true
				target:TellDone( )
			end
		end
	end
end

