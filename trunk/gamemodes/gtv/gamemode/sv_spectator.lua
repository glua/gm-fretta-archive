GM.ValidSpectatorModes = {OBS_MODE_ROAMING,OBS_MODE_CHASE}

local PLAYER = FindMetaTable("Player")
local oldspec = PLAYER.SpectateEntity
//PLAYER.LastSpecTarget = NULL

function PLAYER:SpectateEntity( Target )
	if self:GetObserverMode() == OBS_MODE_ROAMING then
		self:SetViewEntity(self)
		return
	end
	
	if Target:IsValid() then
		self.LastSpecTarget = Target
		//if Target:IsPlayer() then
			self:SetViewEntity(Target)
		//end
	end
	oldspec(self,Target)
end

local oldunspec = PLAYER.UnSpectate
function PLAYER:UnSpectate()
	self:SetViewEntity(self)
	oldunspec(self)
end

/*---------------------------------------------------------
   Name: gamemode:ChangeObserverMode( Player pl, Number mode )
   Desc: Change the observer mode of a player.
---------------------------------------------------------*/
function GM:ChangeObserverMode( pl, mode )

	if ( pl:GetInfoNum( "cl_spec_mode" ) != mode ) then
		pl:ConCommand( "cl_spec_mode "..mode )
	end
	
	if mode == OBS_MODE_IN_EYE then
		return
	end
	if ( mode == OBS_MODE_CHASE ) then
		GAMEMODE:StartEntitySpectate( pl, mode )
		pl:SpectateEntity(pl.LastSpecTarget||self.FindRandomSpectatorTarget(pl))
	else
		pl:SpectateEntity( NULL )
	end
	pl:Spectate( mode )

end

/*---------------------------------------------------------
   Name: gamemode:BecomeObserver( Player pl )
   Desc: Called when we first become a spectator.
---------------------------------------------------------*/
function GM:BecomeObserver( pl )

	local mode = pl:GetInfoNum( "cl_spec_mode", OBS_MODE_CHASE )
	pl:SpectateEntity(pl.LastSpecTarget||self.FindRandomSpectatorTarget(pl))
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( pl ), mode ) ) then 
		mode = table.FindNext( GAMEMODE:GetValidSpectatorModes( pl ), mode )
	end
	
	GAMEMODE:ChangeObserverMode( pl, mode )

end

function GM:EndSpectating( ply )

	if ( !GAMEMODE:PlayerCanJoinTeam( ply ) ) then return end

	GAMEMODE:PlayerJoinTeam( ply, TEAM_UNASSIGNED )
	ply:Spectate(OBS_MODE_FIXED)
	ply:KillSilent()
end