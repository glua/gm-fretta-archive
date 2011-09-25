
ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
end
 
function ENT:KeyValue( key, value )
end

function ENT:Think()
	self:CheckWinners()
end

function ENT:StartTouch( ent )
	
	if ( !ent:IsPlayer() or ent:Team() != TEAM_RUNNER or !ent:Alive() or ent:GetNWBool( "Finished", true ) ) then return end
	
	ent:SetNWBool( "Finished", true )
	
	umsg.Start( "Finish" )
		umsg.Entity( ent )
	umsg.End()
	
	self:CheckWinners()
	
end

function ENT:CheckWinners()

	local runners = {}
	
	for _, v in pairs( team.GetPlayers( TEAM_RUNNER ) ) do
		if ( v:Alive() ) then table.insert( runners, v ) end //All alive runners added to the runners table
	end
	
	local finishedrunners = {}
	
	for _, v in pairs( runners ) do
		if ( v:GetNWBool( "Finished", false ) ) then table.insert( finishedrunners, v ) end //All finished alive runners added to the finishedrunners table
	end
	
	local failed = false
	
	for _, v in pairs( runners ) do
		if ( !table.HasValue( finishedrunners, v ) ) then failed = true break end //If the finishedplayers table doesn't have an entry the runners table DOES have: FAIL!
	end
	
	local empty = ( #runners == 0 and #finishedrunners == 0 ) //Don't finish when there's no runners!
	
	if ( !failed and GAMEMODE:InRound() and !empty ) then GAMEMODE:RoundEndWithResult( TEAM_RUNNER, "finish" ) end
	
end