PWR = {
	{
		Text = "Superjump",
		Color = Color( 255, 255, 0, 255 ),
		Time = 10,
		OnPickup = function( ply )
			ply:SetJumpPower( 500 );
		end,
		OnEndTime = function( ply )
			ply:SetJumpPower( 200 );
		end,
		RenderMat = 2
	},
	{
		Text = "Invisibility",
		Color = Color( 255, 255, 255, 255 ),
		Time = 10,
		OnPickup = function( ply )
			ply:SetNoDraw( true );
		end,
		OnEndTime = function( ply )
			ply:SetNoDraw( false );
		end,
		RenderMat = 1
	},
	{
		Text = "Shotgun",
		Color = Color( 255, 0, 0, 255 ),
		OnPickup = function( ply )
			ply:Give( "weapon_tt_shotty" );
		end,
		RenderMat = 1
	},
	{
		Text = "Swap",
		Color = Color( 0, 255, 255, 255 ),
		OnPickup = function( ply )
			
			local targ = table.Random( player.GetAll() );
			local pos = targ:GetPos();
			targ:SetPos( ply:GetPos() );
			ply:SetPos( pos );
			
		end,
		RenderMat = 1
	},
	{
		Text = "Low Gravity",
		Color = Color( 0, 255, 0, 255 ),
		Time = 10,
		OnPickup = function( ply )
			ply:SetGravity( 0.5 );
		end,
		OnEndTime = function( ply )
			ply:SetGravity( 1 );
		end,
		RenderMat = 3
	},
	{
		Text = "Second Chance",
		Color = Color( 255, 0, 255, 255 ),
		OnPickup = function( ply )
			ply.SecondChance = true;
		end,
		RenderMat = 1
	},
	{
		Text = "Invicibility",
		Color = Color( 0, 0, 255, 255 ),
		Time = 10,
		OnPickup = function( ply )
			ply.Invincible = true;
		end,
		OnEndTime = function( ply )
			ply.Invincible = false;
		end,
		RenderMat = 4
	},
	{
		Text = "Flight",
		Color = Color( 255, 128, 0, 255 ),
		Time = 2,
		OnPickup = function( ply )
			ply:SetMoveType( 4 );
			ply:SetPos( ply:GetPos() + Vector( 0, 0, 32 ) );
		end,
		OnEndTime = function( ply )
			ply:SetMoveType( 2 );
		end,
		RenderMat = 5
	},
	{
		Text = "Superspeed",
		Color = Color( 128, 0, 255, 255 ),
		Time = 5,
		OnPickup = function( ply )
			ply:SetRunSpeed( 1500 );
			ply:SetWalkSpeed( 750 );
			ply:SetCrouchedWalkSpeed( 3 );
		end,
		OnEndTime = function( ply )
			ply:SetRunSpeed( 500 );
			ply:SetWalkSpeed( 250 );
			ply:SetCrouchedWalkSpeed( 1 );
		end,
		RenderMat = 6
	},
	{
		Text = "Minorspeed",
		Color = Color( 128, 0, 255, 255 ),
		Time = 5,
		OnPickup = function( ply )
			ply:SetRunSpeed( 200 );
			ply:SetWalkSpeed( 100 );
			ply:SetCrouchedWalkSpeed( 0.3 );
		end,
		OnEndTime = function( ply )
			ply:SetRunSpeed( 500 );
			ply:SetWalkSpeed( 250 );
			ply:SetCrouchedWalkSpeed( 1 );
		end,
		RenderMat = 6
	},
	{
		Text = "No Jumping",
		Color = Color( 128, 64, 0, 255 ),
		Time = 3,
		OnPickup = function( ply )
			ply:SetJumpPower( 0 );
		end,
		OnEndTime = function( ply )
			ply:SetJumpPower( 200 );
		end,
		RenderMat = 7
	},
	{
		Text = "Flip",
		Color = Color( 0, 128, 0, 255 ),
		Time = 5,
		OnPickup = function( ply )
			for _, v in pairs( player.GetAll() ) do
				if( v != ply ) then
					umsg.Start( "FlipMeOver", v );
					umsg.End();
				end
			end
		end,
		OnEndTime = function( ply )
		end,
		RenderMat = 8
	}
}

function SpawnPowerup( id )
	
	local tiles = ents.GetAllAliveTiles();
	
	if( #tiles > 0 ) then
		
		local goodTab = { };
		
		for _, v in pairs( tiles ) do
			
			if( !v.Powerup ) then
				
				table.insert( goodTab, v );
				
			end
			
		end
		
		local tile = table.Random( goodTab );
		local pwr = table.Random( PWR );
		if( id ) then
			pwr = PWR[id];
		end
		
		if( tile ) then
			
			local function b() end
			
			local ent = ents.Create( "til_powerup" );
			ent:SetPos( tile.Pos );
			ent:SetTText( pwr.Text );
			ent:SetTColor( pwr.Color );
			ent:SetTime( pwr.Time or 2 );
			ent:SetOnGet( pwr.OnPickup );
			ent:SetOnEndTime( pwr.OnEndTime or b );
			ent:SetRenderMat( pwr.RenderMat or 1 );
			
			ent:Spawn();
			
			tile:SetPowerup( ent );
			
		end
		
	end
	
end

SHOTGUNMODE = false;

function shottytime()
	
	SHOTGUNMODE = !SHOTGUNMODE;
	for _, v in pairs( player.GetAll() ) do
		v:SendLua( [[chat.AddText( Color( 255, 0, 0, 255 ), "SHOTGUN TIME" )]] );
	end
	
end
concommand.Add( "shottytime", shottytime )
