// Stuff to send to our player
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "player_extensions.lua" );
AddCSLuaFile( "weapons.lua" );
AddCSLuaFile( "skin.lua" );
AddCSLuaFile( "player_animation.lua" );
AddCSLuaFile( "vgui/vgui_loadout.lua" );
AddCSLuaFile( "vgui/vgui_messagecenter.lua" );

// Includes
include( "shared.lua" );

// We can only start a round if we have someone who can be our Breen
function GM:CanStartRound( iNum )

	if( team.NumPlayers( TEAM_COMBINE ) >= 1 ) then // If there's one player then he'll have to defend himself :/
		return true
	end
	
	return false
	
end

// We need to select a Breen here.
function GM:OnPreRoundStart( num )

	GAMEMODE.RoundLength = as_roundlength:GetFloat() * 60;
	
	local combineTeam = team.GetPlayers( TEAM_COMBINE ); // get all the combine team
	local ourBreen = table.Random( combineTeam ); // get our dr. breen
		
	if( ValidEntity( ourBreen ) ) then
	
		if( ourBreen:GetPlayerClassName() != "As_DrBreen" ) then
			ourBreen.OldClass = ourBreen:GetPlayerClassName();
		end
		
		ourBreen:StripWeapons( );
		ourBreen:SetPlayerClass( "As_DrBreen" ); // make them breen
		
		SetGlobalEntity( "Breen", ourBreen );
		 
		local rp = RecipientFilter()
		rp:AddAllPlayers();
		
		umsg.Start( "OurBreen", rp );
		umsg.Entity( ourBreen );
		umsg.End()
		
	end
	
	self.BaseClass:OnPreRoundStart( num );

end

function GM:OnRoundStart( num )

	self.BaseClass:OnRoundStart( num );

end

function GM:RoundEnd()

	self.BaseClass:RoundEnd();
	
	local pl = GetGlobalEntity( "Breen" );

	for k, v in pairs( player.GetAll() ) do
		//v:Freeze( true );
		
		local weap = v:GetActiveWeapon()
		
		if( weap and weap.SetIronsights ) then
			weap:SetIronsights( false );
		end
	end
	
	if( ValidEntity( pl ) ) then
		if( pl.OldClass && pl.OldClass != "As_DrBreen" ) then
			pl:SetPlayerClass( pl.OldClass );
		else
			pl:SetRandomClass();
		end
	end
	
	SetGlobalEntity( "Breen", NULL );
	
end

//
// This is called when the round time ends.
//
function GM:RoundTimerEnd()

	if ( !GAMEMODE:InRound() ) then return end
	
	GAMEMODE:RoundEndWithResult( TEAM_REBELS, "Dr. Breen failed to escape. Rebels win." );

end

// Evacuated
function GM:Evacuated( )
	
	self:RoundEndWithResult( TEAM_COMBINE, "Dr. Breen was evacuated. Combine Soldiers win." );
	MsgN( "ESCAPED" );
end

// Can pickup weapon? Breen can't
function GM:PlayerCanPickupWeapon( ply, wep )

	if( !ValidEntity( wep ) ) then return false end
	
	if( ply:IsBreen() and wep:GetClass() != "weapon_as_revolver" ) then return false end
	if( ValidEntity( ply:GetWeapon( wep:GetClass() ) ) ) then return false end
	
	return true 
	
end

// Show gun menu
function GM:ShowSpare1( ply )
	ply:ConCommand( "open_loadout_menu" );
end
