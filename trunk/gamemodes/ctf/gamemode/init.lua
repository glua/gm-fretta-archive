
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "player_extensions_sh.lua" );
AddCSLuaFile( "cl_deathnotice.lua" );
AddCSLuaFile( "cl_postprocess.lua" );
AddCSLuaFile( "cl_scores.lua" );
AddCSLuaFile( "skin.lua" );

include( "shared.lua" )
include( "utility.lua" )

-- content to download from server
resource.AddFile( GM.Folder .. "/content/materials/weapons/scopes/scope2.vtf" );
resource.AddFile( GM.Folder .. "/content/materials/weapons/scopes/scope2.vmt" );


function GM:SetTeamFlag( team, flag )

	if( flag and flag:IsValid() ) then
		SetGlobalEntity( "flag_" .. tostring( team ), flag );
	end
	
end

function GM:PlayerSpawn( pl ) 
	
	self.BaseClass:PlayerSpawn( pl )	
	
	if( pl:Team() != TEAM_SPECTATOR and pl:Team() != TEAM_UNASSIGNED ) then
		pl.Protected = true;
		pl:SetNetworkedBool( "protected", true )
		
		local color = team.GetColor( pl:Team() );
		pl:SetColor( color.r, color.g, color.b, 180 );
		
		timer.Simple( GAMEMODE.SpawnProtection, function( ply ) if( !ValidEntity( ply ) ) then return end ply.Protected = false; ply:SetNetworkedBool( "protected", false ); ply:SetColor(255,255,255,255) end, pl )
	end
	
end

function GM:PlayerShouldTakeDamage( victim, attacker )
	
	if( victim.Protected ) then
		return false
	end
	
	return self.BaseClass:PlayerShouldTakeDamage( victim, attacker );
	
end

function GM:PlayerDisconnected( pl )

	local enemy = TEAM_RED;
	
	if( pl:Team() == TEAM_RED ) then
		enemy = TEAM_BLUE
	end
	
	local flag = GetGlobalEntity( "flag_" .. tostring( enemy ) );
	
	if( flag and flag:IsValid() ) then
		local carrier = flag:GetNetworkedEntity( "carrier" );
		
		if( carrier and carrier:IsValid() and carrier == pl ) then
			flag:FlagDropped( carrier );
		end
	end
	
	self.BaseClass:PlayerDisconnected( pl );
end

function GM:DoPlayerDeath( pl, attacker, dmginfo ) 

	local team = pl:Team();
	local enemy_flag = nil;
	local enemy_team = TEAM_RED;
	
	if( team == TEAM_RED ) then
		enemy_flag = GetGlobalEntity( "flag_1" );
		enemy_team = TEAM_BLUE
	else
		enemy_flag = GetGlobalEntity( "flag_2" );
	end
	
	if( enemy_flag and enemy_flag:IsValid() and enemy_flag:GetNetworkedBool( "stolen" ) ) then
		local carrier = enemy_flag:GetNetworkedEntity( "carrier" );
		
		if( carrier and carrier:IsValid() and carrier == pl ) then
			enemy_flag:FlagDropped( pl );
		end
	end
	
	pl:SetNetworkedFloat( "respawnTime", CurTime() + GAMEMODE.MinimumDeathLength );
	
	if( pl:Team() != TEAM_UNASSIGNED and pl:Team() != TEAM_SPECTATOR ) then
		timer.Simple( 2, GAMEMODE.SpectateFlag, GAMEMODE, pl );
	end
	
	self.BaseClass:DoPlayerDeath( pl, attacker, dmginfo );
end

function GM:SpectateFlag( pl )
	pl:Spectate( OBS_MODE_CHASE );
	pl:SpectateEntity( GetGlobalEntity( "flag_" .. tostring( pl:Team() ) ) );
end

function GM:HandleWin( red, blue )

	local winningTeam = TEAM_RED;
	
	if( blue > red ) then
		winningTeam = TEAM_BLUE
	end
	
	for k, v in pairs( player.GetAll() ) do
		if( v:Team() == winningTeam ) then
			v:SendLua( "LocalPlayer():EmitSound( \"Game.YourTeamWon\" )");
		else
			v:SendLua( "LocalPlayer():EmitSound( \"Game.YourTeamLost\" )");
		end
	end
	
	PrintMessage( HUD_PRINTCENTER, team.GetName( winningTeam ) .. " win" );
end

function GM:EndOfGame( bGamemodeVote )

	SetGlobalBool( "interval", true );
	
	local red_score = team.GetScore( TEAM_RED );
	local blue_score = team.GetScore( TEAM_BLUE );
	
	if( red_score == blue_score ) then
		BroadcastLua( "LocalPlayer():EmitSound( \"Game.Stalemate\" )");
		PrintMessage( HUD_PRINTCENTER, "Game draw!" );
	else
		GAMEMODE:HandleWin( red_score, blue_score );
	end

	self.BaseClass:EndOfGame( bGamemodeVote );

end

function GM:AddFlagMessage( player, team, vteam, action )

	local rp = RecipientFilter();
	rp:AddAllPlayers();

	umsg.Start( "PlayerFlagAction", rp );
		umsg.Entity( player );
		umsg.Short( team );
		umsg.Short( vteam );
		umsg.String( action );
	umsg.End();
	
end

OldPrintMessage = PrintMessage
function PrintMessage( t, m )

	if( t == HUD_PRINTCENTER ) then
		-- add our player
		local rp = RecipientFilter();
		rp:AddAllPlayers();
			
		-- send our user message
		umsg.Start( "gmdm_printcenter", rp );
		umsg.String( m );
		umsg.End();

	else
		OldPrintMessage( t, m );
	end
end
