WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "empty"
WARE.MaxSpeed = 320

WARE.Models = {
"models/vehicles/prisoner_pod_inner.mdl",
"models/combine_helicopter/helicopter_bomb01.mdl"
}
 
function WARE:GetModelList()
	return self.Models
end

function WARE:IsPlayable()
	if team.NumPlayers(TEAM_HUMANS) >= 2 then
		return true
	end
	return false
end

function WARE:Initialize()
	GAMEMODE:EnableFirstWinAward( )
	GAMEMODE:SetWinAwards( AWARD_MOVES )
	
	self.RoleColor = Color(114, 49, 130)
	GAMEMODE:SetWareWindupAndLength(3, 3)
	
	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Don't stop sprinting!" )
	
	local ratio = 0.4
	local minimum = 1
	local num = math.Clamp(math.ceil( team.NumPlayers(TEAM_HUMANS) * ratio) , minimum, 64)
	local locations = GAMEMODE:GetRandomLocationsAvoidBox(num, {"dark_ground", "light_ground"},  function(v) return v:IsPlayer() end, Vector(-30,-30,0), Vector(30,30,128))
	
	self.Pods = {}
	
	for k,v in pairs(locations) do
		local pod = ents.Create ("prop_vehicle_prisoner_pod")
		pod:SetModel( self.Models[1] )
		pod:SetAngles( Angle(0,math.random(0,360),0) )
		pod:SetPos( v:GetPos() + Vector(0,0,32) )
		--pod:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		pod:Spawn()
		
		pod:Fire("Lock", "", 0)
		pod:Fire("Open", "", 5.7)
		
		local dynaba = ents.Create ("prop_dynamic_override")
		dynaba:SetModel( self.Models[2] )
		dynaba:SetPos( pod:GetPos() + pod:GetAngles():Up() * 86 + pod:GetAngles():Forward() * 9 )
		dynaba:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		dynaba:Spawn()
		dynaba:SetParent(pod)
		GAMEMODE:AppendEntToBin(dynaba)
		
		constraint.Ballsocket( pod, GetWorldEntity(), 0, 0, pod:GetPos() + pod:GetAngles():Up() * 86 + pod:GetAngles():Forward() * 9, 0, 0, 0 )

		local physObj = pod:GetPhysicsObject()
		if physObj:IsValid() then
			physObj:ApplyForceCenter(VectorRand() * physObj:GetMass() * 32)
		end
		
		GAMEMODE:AppendEntToBin(pod)
		GAMEMODE:MakeAppearEffect(pod:GetPos())
		
		table.insert(self.Pods, pod)
	end
end

function WARE:StartAction()
	
end
--[[
function WARE:PreEndAction()
	GAMEMODE:RespawnAllPlayers( true, true )
	
end
]]--
function WARE:PreEndAction()
	if GAMEMODE:GetCurrentPhase() == 1 then
		local someoneAchieved = false
		for _,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
			ply:StripWeapons()
			if ply:GetAchieved() then
				someoneAchieved = true
				ply:TellDone( )
				ply:SendHitConfirmation()
				ply:SetAchievedNoLock( false )
				
			else
				ply:ApplyLose()
				
			end
			
		end
		
		if someoneAchieved then
			GAMEMODE:SetNextPhaseLength( 6 )
			
		end
	else
		GAMEMODE:RespawnAllPlayers( true, true )
		
	end
	
end

function WARE:PhaseSignal( iPhase )
	if iPhase == 2 then
		GAMEMODE:DrawInstructions( "Now get in a pod!", self.RoleColor )
		for k,pod in pairs(self.Pods) do
			pod:Fire("Unlock", "", 0)
		end
		
	end
	
end

function WARE:Think( )
	if GAMEMODE:GetCurrentPhase() ~= 1 then return end
	
	for k,ply in pairs(team.GetPlayers(TEAM_HUMANS)) do 
		--Lower telerence
		if not ply:GetLocked() and ( ply:GetVelocity():Length() < (self.MaxSpeed * 0.7) ) then
			ply:ApplyLose( )
			ply:SimulateDeath()
			
		end
	end
end

function WARE:EndAction()
	timer.Simple(0, function()
		for k,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
			v:StripWeapons()
			v:RemoveAllAmmo( )
			v:Give("weapon_physcannon")
		end
	end)
	
end

function WARE:PlayerEnteredVehicle( ply, vehEnt, role )
	ply:ApplyWin()
	vehEnt:Fire("Close", "", 0)
	vehEnt:Fire("Lock", "", 0)
	
end

function WARE:CanPlayerEnterVehicle( ply, vehEnt, role )
	if GAMEMODE:GetCurrentPhase() ~= 2 then return false end
	if ply:GetLocked() then return false end
	if not ply:IsWarePlayer() then
		if not ply.__ISEXPLOITER then
			GAMEMODE:PrintInfoMessage( ply:Name(), " (SteamID : " .. ply:SteamID() .. " ) ", "is now registered as a bug exploiter." )
			ply.__ISEXPLOITER = true
		end
		
		return false
	end
	
	return true
end

function WARE:CanExitVehicle()

	return false
end

