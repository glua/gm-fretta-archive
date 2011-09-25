//This is ripped from the fretta base, and modified to fit my needs.
//Basically, I use this file to get cactus players to chose a cactus to posess.

function GM:GetValidSpectatorModes( ply )

	// Note: Override this and return valid modes per player/team
	
	//Cactus may only use Chase mode
	if ply:IsCactus() then
		return { OBS_MODE_CHASE } --GAMEMODE.ValidSpectatorModes
	elseif ply:IsHuman() then
		return { OBS_MODE_CHASE } --
	end
	return GAMEMODE.ValidSpectatorModes
	
end

function GM:GetValidSpectatorEntityNames( ply )

	// Note: Override this and return valid entity names per player/team
	
	//Cactus may only spectate other cacti
	if ply:IsCactus() then
		return {"sent_cactus","info_cactus_spawn"}
	elseif ply:IsHuman() then
		return {"player", "sent_cactus"} --
	end
	return GAMEMODE.ValidSpectatorEntities
	
end

function GM:IsValidSpectator( ply )

	//Anyone who isn't a spectator
	if ( !IsValid( ply ) ) then return false end
	if ( ply:Team() != TEAM_SPECTATOR && !ply:IsObserver() && ply:Alive() ) then return false end --&& !ply:IsCactus() && !ply:IsHuman() 
	
	return true

end

function GM:IsValidSpectatorTarget( ply, ent )

	if ( !IsValid( ent ) ) then return false end
	if ( ent == ply ) then return false end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorEntityNames( ply ), ent:GetClass() ) ) then return false end
	if ( ent:IsPlayer() && !ent:Alive() ) then return false end
	if ( ent:IsPlayer() && ent:IsObserver() ) then return false end
	if ( !ent:IsPlayer() && ent:IsCactus() && !ent:GetCactusData().CanSelect ) then return false end
	if ( ply:IsCactus() && !ent:IsCactus() ) then return false end
	if ( ply:IsCactus() && !ent:IsPlayer() && ent:IsCactus() && IsValid(ent:GetPlayerObj()) ) then return false end
	if ( ply:Team() != TEAM_SPECTATOR && !ply:IsCactus() && ent:IsPlayer() && GAMEMODE.CanOnlySpectateOwnTeam && ply:Team() != ent:Team() ) then return false end
	
	return true

end

function GM:GetSpectatorTargets( ply )

	local t = {}
	for k, v in pairs( GAMEMODE:GetValidSpectatorEntityNames( ply ) ) do
		t = table.Merge( t, ents.FindByClass( v ) )
	end
	
	//Cacti can only spectate cactus SENT's that don't have player's assigned to them
	if ply:IsCactus() then
		return GAMEMODE:GetCactusEntities()
	end
	
	return t

end

function GM:FindRandomSpectatorTarget( ply )

	local Targets = GAMEMODE:GetSpectatorTargets( ply )
	if !Targets[1] then return NullEntity() end
	return table.Random( Targets )

end

function GM:FindNextSpectatorTarget( ply, ent )

	local Targets = GAMEMODE:GetSpectatorTargets( ply )
	return table.FindNext( Targets, ent )

end

function GM:FindPrevSpectatorTarget( ply, ent )

	local Targets = GAMEMODE:GetSpectatorTargets( ply )
	return table.FindPrev( Targets, ent )

end

function GM:StartEntitySpectate( ply )

	local CurrentSpectateEntity = ply:GetObserverTarget()
	
	for i=1, 32 do
	
		if ( GAMEMODE:IsValidSpectatorTarget( ply, CurrentSpectateEntity ) ) then
			ply:SpectateEntity( CurrentSpectateEntity )
			return
		end
	
		CurrentSpectateEntity = GAMEMODE:FindRandomSpectatorTarget( ply )
	
	end

end

function GM:NextEntitySpectate( ply )

	local Target = ply:GetObserverTarget()
	
	for i=1, 32 do
	
		Target = GAMEMODE:FindNextSpectatorTarget( ply, Target )	
		
		if ( GAMEMODE:IsValidSpectatorTarget( ply, Target ) ) then
			ply:SpectateEntity( Target )
			return
		end
	
	end

end

function GM:PrevEntitySpectate( ply )

	local Target = ply:GetObserverTarget()
	
	for i=1, 32 do
	
		Target = GAMEMODE:FindPrevSpectatorTarget( ply, Target )	
		
		if ( GAMEMODE:IsValidSpectatorTarget( ply, Target ) ) then
			ply:SpectateEntity( Target )
			return
		end
	
	end

end

function GM:ChangeObserverMode( ply, mode )

	if ( ply:GetInfoNum( "cl_spec_mode" ) != mode ) then
		ply:ConCommand( "cl_spec_mode "..mode )
	end
	
	if ( mode == OBS_MODE_IN_EYE || mode == OBS_MODE_CHASE ) then
		GAMEMODE:StartEntitySpectate( ply, mode )
	end
	
	ply:SpectateEntity( NULL )
	ply:Spectate( mode )

end

function GM:BecomeObserver( ply )

	local mode = ply:GetInfoNum( "cl_spec_mode", OBS_MODE_CHASE )
	
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( ply ), mode ) ) then 
		mode = table.FindNext( GAMEMODE:GetValidSpectatorModes( ply ), mode )
	end
	
	GAMEMODE:ChangeObserverMode( ply, mode )

end

local function spec_mode( ply, cmd, args )
	
	//We override this so cacti can select their cactus entity in spectator mode

	if ( !GAMEMODE:IsValidSpectator( ply ) ) then return end
	
	ply:SetCactus(NULL)
	
	if ply:IsCactus() then
		
		mode = OBS_MODE_CHASE
		
		if ValidEntity(ply:GetObserverTarget()) then
			
			local ent = ply:GetObserverTarget()
			MsgN("Spectating cactus entity "..tostring(ent))
			
			if !ent:IsPlayer() and !ValidEntity(ent:GetPlayerObj()) then
				ply:SetCactus(ent) --Assign player to entity
			end
			
			if ValidEntity(ply:GetCactus()) then
				print(ply:Nick().." has been assigned to cactus "..tostring(ply:GetCactus()))
				ply:SetPos(ply:GetCactus():GetPos())
				ply:Spawn()
				ent:SetOwner(ply)
			end
			
			return
			
		end
		
	end
	
	local mode = ply:GetObserverMode()
	local nextmode = table.FindNext( GAMEMODE:GetValidSpectatorModes( ply ), mode )
	
	GAMEMODE:ChangeObserverMode( ply, nextmode )

end

concommand.Add( "spec_mode",  spec_mode )

local function spec_next( ply, cmd, args )

	if ( !GAMEMODE:IsValidSpectator( ply ) ) then return end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( ply ), ply:GetObserverMode() ) ) then return end
	
	GAMEMODE:NextEntitySpectate( ply )

end

concommand.Add( "spec_next",  spec_next )

local function spec_prev( ply, cmd, args )

	if ( !GAMEMODE:IsValidSpectator( ply ) ) then return end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( ply ), ply:GetObserverMode() ) ) then return end
	
	GAMEMODE:PrevEntitySpectate( ply )

end

concommand.Add( "spec_prev",  spec_prev )