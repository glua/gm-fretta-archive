local pmeta = FindMetaTable( "Player" );
local emeta = FindMetaTable( "Entity" );

function pmeta:OnDeath()
	
	if( GAMEMODE:InRound() ) then
		
		self:DisableRespawn();
		
		local pl = player.GetAlive();
		
		if( #pl == 1 ) then
			
			for _, v in pairs( player.GetAll() ) do
				
				v:EnableRespawn();
				
			end
			
			local effectdata = EffectData();
				effectdata:SetOrigin( pl[1]:GetPos() );
			util.Effect( "balloon_pop", effectdata );
			
			GAMEMODE:RoundEndWithResult( pl[1] );
			
		elseif( #pl < 1 ) then
			
			for _, v in pairs( player.GetAll() ) do
				
				v:EnableRespawn();
				
			end
			
			GAMEMODE:RoundEndWithResult( -1 );
			
		end
		
	else
		
		for _, v in pairs( player.GetAll() ) do
			
			v:EnableRespawn();
			
		end
		
	end
	
end

function GM:ProcessResultText( result )
	
	if( result == -1 ) then
		
		return "Draw";
		
	else
		
		return result:Nick() .. " won!";
		
	end

end

function GM:SelectCurrentlyWinningPlayer()
	
	local plys = player.GetAlive();
	
	if( #plys > 0 ) then
		
		return table.Random( plys );
		
	end
	
	return nil;

end

TILESACTIVE = false;

function emeta:CanActivateTile( tile )
	
	if( self:IsPlayer() and self:Alive() ) then
		if( TILESACTIVE ) then
			if( self:GetPos().z >= tile.Pos.z ) then
				
				return true;
				
			end
		end
	end
	
	return false;
	
end

function GM:OnRoundStart( num )
	
	UTIL_UnFreezeAllPlayers();
	
	local n = #ents.GetAllAliveTiles();
	if( !DEBUG ) then
		timer.Create( "DoRandomTileFall", GAMEMODE.RoundLength / n, n, DoRandomTileFall );
	end
	timer.Create( "DoPowerup", GAMEMODE.RoundLength / 12, 11, SpawnPowerup );
	
	TILESACTIVE = true;
	
end

function GM:OnRoundEnd( num )
	
	TILESACTIVE = false;
	timer.Destroy( "DoRandomTileFall" );
	timer.Destroy( "DoPowerup" );
	umsg.Start( "msgResetRenderPowerup" );
	umsg.End();
	
end
