include( "shared.lua" )
include( "chat.lua" )
include( "endgame.lua" )
include( "fade.lua" )
include( "finish.lua" )
include( "gib.lua" )
include( "shift.lua" )
include( "view.lua" )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_gib.lua" )
AddCSLuaFile( "cl_miclimit.lua" )
AddCSLuaFile( "cl_effects.lua" )
AddCSLuaFile( "resources.lua" )

game.ConsoleCommand( "net_maxfilesize 64\n" );

resource.AddFile( "maps/" .. game.GetMap() .. ".bsp" );

resource.AddFile( "sound/cube/click.wav" );
resource.AddFile( "sound/cube/icecrack.wav" );
resource.AddFile( "models/weapons/v_Boot.mdl" );
resource.AddFile( "models/w_Boot.mdl" );
resource.AddFile( "materials/Shoe001a.vmt" );
resource.AddFile( "materials/v_boot_sheet.vmt" );
resource.AddFile( "models/cube/sonicdish.mdl" );
resource.AddFile( "materials/cube/ice_overlay.vmt" );

CU_Spawnpoints = { };