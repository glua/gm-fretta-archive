AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

resource.AddFile("models/player/Group03m/Female_07.mdl")
resource.AddFile("models/player/Group03m/Female_07.phy")

resource.AddFile("models/player/Group03m/Male_04.mdl")
resource.AddFile("models/player/Group03m/Male_04.phy")

resource.AddFile("models/player/Group03m/male_06.mdl")
resource.AddFile("models/player/Group03m/male_06.phy")

resource.AddFile("models/player/Group03m/male_08.mdl")
resource.AddFile("models/player/Group03m/male_08.phy")

resource.AddFile("models/weapons/v_medkit.dx80.vtx")
resource.AddFile("models/weapons/v_medkit.dx90.vtx")
resource.AddFile("models/weapons/v_medkit.mdl")
resource.AddFile("models/weapons/v_medkit.sw.vtx")
resource.AddFile("models/weapons/v_medkit.vvd")
resource.AddFile("models/weapons/v_medkit.xbox.vtx")
resource.AddFile("models/items/w_medkit.dx80.vtx")
resource.AddFile("models/items/w_medkit.dx90.vtx")
resource.AddFile("models/items/w_medkit.mdl")
resource.AddFile("models/items/w_medkit.phy")
resource.AddFile("models/items/w_medkit.sw.vtx")
resource.AddFile("models/items/w_medkit.vvd")
resource.AddFile("models/items/w_medkit.xbox.vtx")

function GM:StartRoundBasedGame() 
	
	GAMEMODE:PreRoundStart( 1 )
	
	StripWorld()
	
end


function GM:OnRoundStart( num )
		
	for t=1,2 do
		for k,v in pairs( team.GetPlayers( t ) ) do
			v:SetFrags( 0 )
		end
	end
		
	UTIL_UnFreezeAllPlayers()

end

function GM:OnRoundResult( t )
	
	team.AddScore( t, 1 )
	
	if team.GetScore( t ) >= 3 then
		timer.Simple( 5, function() GAMEMODE:EndOfGame( true ) end )
	end
	
end

function GM:RoundTimerEnd()

	if team.TotalFrags( TEAM_REBEL ) < team.TotalFrags( TEAM_COMBINE ) then
		GAMEMODE:RoundEndWithResult( TEAM_COMBINE )
	elseif team.TotalFrags( TEAM_REBEL ) > team.TotalFrags( TEAM_COMBINE ) then
		GAMEMODE:RoundEndWithResult( TEAM_REBEL )
	else
		GAMEMODE:RoundEndWithResult( ROUND_RESULT_DRAW )
	end
	

end

function GM:CheckRoundEnd()

end

function GM:OnRoundWinner()

end

function StripWorld()
    // Remove all weapons from the world.
	for k,v in pairs(ents.FindByClass("weapon_*")) do
        v:Remove()
    end
	// Remove all items from the world.
	for k,v in pairs(ents.FindByClass("item_*")) do
        v:Remove()
    end
end
