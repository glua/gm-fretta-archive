DeriveGamemode( "fretta" );

AddCSLuaFile( "sh_class.lua" );
include( "sh_class.lua" );

DEBUG = false

GM.Name		= "Trembling Tiles"
GM.Author	= "Disseminate"
GM.Email	= ""
GM.Website	= ""
GM.Help     = [[If you touch a regular tile, it will turn red. 1 second later, it will fall. If you fall, you die and lose the round.

If you see floating text above a tile, it is a powerup. Different powerups do different things. Touch the tile to get the powerup.]]

-- Project begin: November 20, 2009 (as Bunny Hop)
-- Project resurrection: May 04, 2010

GM.TeamBased 					= false;
GM.AllowAutoTeam 				= true;
GM.AllowSpectating 				= true;  
GM.SelectClass 					= true;
GM.SecondsBetweenTeamSwitches 	= 0;
GM.GameLength 					= 10;
GM.NoPlayerDamage 				= false;
GM.NoPlayerSelfDamage 			= true;
GM.NoPlayerTeamDamage 			= true;
GM.NoPlayerPlayerDamage 		= true;
GM.NoNonPlayerPlayerDamage 		= false;

GM.RoundLimit = -1;
GM.RoundBased = true;
GM.RoundLength = 60;
GM.RoundPreStartTime = 2;
GM.RoundPostLength = 2;
GM.RoundEndsWhenOneTeamAlive = false;

function GM:ShouldCollide( ent1, ent2 )
	
	if( ent1:IsPlayer() and ent2:IsPlayer() ) then return false; end
	return true;
	
end

function player.GetAlive()
	
	local LivePlayers = { };
	
	for _, v in pairs( player.GetAll() ) do
		
		if( v:Alive() and v:Team() != TEAM_SPECTATOR ) then
			
			table.insert( LivePlayers, v );
			
		end
		
	end
	
	return LivePlayers;
	
end

FemalePlayermodels = {
	"models/player/alyx.mdl",
	"models/player/mossman.mdl",
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_06.mdl",
	"models/player/group01/female_07.mdl",
	"models/player/group03/female_01.mdl",
	"models/player/group03/female_02.mdl",
	"models/player/group03/female_03.mdl",
	"models/player/group03/female_04.mdl",
	"models/player/group03/female_06.mdl",
	"models/player/group03/female_07.mdl"
};

matBlack = CreateMaterial( "TremblingTilesNone", "UnlitGeneric", { [ "$basetexture" ] = "tt/blackpix", [ "$translucent" ] = "1" } );
matYellow = CreateMaterial( "TremblingTilesYellow", "UnlitGeneric", { [ "$basetexture" ] = "models/debug/debugwhite", [ "$color2" ] = "[ 1 1 0 ]" } );
matGreen = CreateMaterial( "TremblingTilesGreen", "UnlitGeneric", { [ "$basetexture" ] = "models/debug/debugwhite", [ "$color2" ] = "[ 0 1 0 ]" } );
matBlue = CreateMaterial( "TremblingTilesBlue", "UnlitGeneric", { [ "$basetexture" ] = "models/debug/debugwhite", [ "$color2" ] = "[ 0 0 1 ]" } );
matOrange = CreateMaterial( "TremblingTilesOrange", "UnlitGeneric", { [ "$basetexture" ] = "models/debug/debugwhite", [ "$color2" ] = "[ 1 0.5 0 ]" } );
matPurple = CreateMaterial( "TremblingTilesPurple", "UnlitGeneric", { [ "$basetexture" ] = "models/debug/debugwhite", [ "$color2" ] = "[ 0.5 0 1 ]" } );
matBrown = CreateMaterial( "TremblingTilesBrown", "UnlitGeneric", { [ "$basetexture" ] = "models/debug/debugwhite", [ "$color2" ] = "[ 0.5 0.25 0 ]" } );
matDarkGreen = CreateMaterial( "TremblingTilesDarkGreen", "UnlitGeneric", { [ "$basetexture" ] = "models/debug/debugwhite", [ "$color2" ] = "[ 0 0.5 0 ]" } );
matDarkGreen = CreateMaterial( "TremblingTilesDarkGreen", "UnlitGeneric", { [ "$basetexture" ] = "models/debug/debugwhite", [ "$color2" ] = "[ 0 0.5 0 ]" } );

matRenderTranslateTab = { };
matRenderTranslateTab[1] = matBlack;
matRenderTranslateTab[2] = matYellow;
matRenderTranslateTab[3] = matGreen;
matRenderTranslateTab[4] = matBlue;
matRenderTranslateTab[5] = matOrange;
matRenderTranslateTab[6] = matPurple;
matRenderTranslateTab[7] = matBrown;
matRenderTranslateTab[8] = matDarkGreen;