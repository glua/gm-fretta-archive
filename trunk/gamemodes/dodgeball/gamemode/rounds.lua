function GM:OnPreRoundStart( num )
	
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
	for k, v in pairs( ents.FindByClass( "gmod_dodgeball" ) ) do
		v:Remove()
	end
	
	for k, v in pairs( ents.FindByClass( "logic_dodgeball" ) ) do
		v:SendStartWarmup()
	end
end

function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()
	
	for k,v in pairs( ents.FindByClass( "logic_dodgeball" ) ) do
		v:SendStartRound()
	end
	
	local dispencers = ents.FindByClass( "gmod_dodgeballdispencer" )
	
	local balls = math.floor( ( #player.GetAll( ) / 2 ) ) //floor means 2.7 becomes 2
	local balls = math.max( balls, 2 ) //Atleast two balls
	local balls = math.min( balls, #dispencers ) //Don't let it go over the amount of dispencers we have
	
	for a=1, balls do
		local dbent = ents.Create("gmod_dodgeball")
		dbent:SetPos( dispencers[a]:GetPos() )
		dbent:Spawn()
	end
	
end
function GM:OnRoundEnd( num )
	
	local Teams = GAMEMODE:GetTeamAliveCounts() --Grab alive teams in table
	if ( table.Count( Teams ) == 1 ) then --If we have only one key
		local TeamID = table.GetFirstKey( Teams ) --Since there is only one key
		for k, v in pairs( ents.FindByClass( "logic_dodgeball" ) ) do --Grab our logic entity
			if TeamID == 1 then
				v:SendRedWins() --Check logic
			else
				v:SendBlueWins() --Under entities
			end
		end
	end
	
	for k, v in pairs( ents.FindByClass( "logic_dodgeball" ) ) do
		v:SendEndRound()
	end
	
end

function GM:GetTeamAliveCounts()

	local TeamCounter = {}

	for k,v in pairs( player.GetAll() ) do
		if ( !v:IsJailed() && v:Team() > 0 && v:Team() < 1000 ) then
			TeamCounter[ v:Team() ] = TeamCounter[ v:Team() ] or 0
			TeamCounter[ v:Team() ] = TeamCounter[ v:Team() ] + 1
		end
	end

	return TeamCounter

end

//util

function UTIL_SpawnAllPlayers() //Fix the spec bug
	GAMEMODE:UnjailAll( )
end

function GM:UnjailAll( )
	for k, v in pairs(player.GetAll( )) do
		if v:Team() > 0 && v:Team() < 1000 then //Not a spec or unassigned
			v:PutInPlayer( false )
		end
	end
end

function GM:JailBreak( dteam )
	for k, v in pairs(team.GetPlayers( dteam )) do
		if v:IsJailed() then
			v:PutInPlayer( false )
		end
	end
end
