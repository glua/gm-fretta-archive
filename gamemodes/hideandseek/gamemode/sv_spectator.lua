
function GM:GetValidSpectatorModes( ply )

	// Note: Override this and return valid modes per player/team

	return GAMEMODE.ValidSpectatorModes
	// May force seekers to view in only third/first person

end

function GM:IsValidSpectatorTarget( pl, ent )

	if ( !IsValid( ent ) ) then return false end
	if ( ent == pl ) then return false end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorEntityNames( pl ), ent:GetClass() ) ) then return false end
	if ( ent:IsPlayer() && !ent:Alive() ) then return false end
	if ( ent:IsPlayer() && ent:IsObserver() ) then return false end
	if ( pl:Team() == TEAM_SEEKERS && ent:IsPlayer() && ent:Team() == TEAM_HIDERS ) then return false end
	
	return true

end

