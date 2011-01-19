	
ENT.Type 		= "brush"

AddCSLuaFile( "shared.lua" )


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

end

/*---------------------------------------------------------
   Name: StartTouch
---------------------------------------------------------*/
function ENT:StartTouch( entity )

	if ( self:PassesTriggerFilters( entity ) ) then
		hook.Call( "RedAddScore", GAMEMODE, entity )
	end

end

