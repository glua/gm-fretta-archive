include( "shared.lua" );
include( "fretta.lua" );
include( "meta.lua" );
include( "entity.lua" );
include( "powerup.lua" );

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "cl_umsg.lua" );

resource.AddFile( "maps/" .. game.GetMap() .. ".bsp" );
resource.AddFile( "materials/tt/blackpix.vtf" );

Deathcam = Vector( 0, 0, 0 );