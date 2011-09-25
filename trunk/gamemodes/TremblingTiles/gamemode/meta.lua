local pmeta = FindMetaTable( "Player" );

function pmeta:SyncDeathcam()
	
	umsg.Start( "SyncDeathcam", self );
		umsg.Vector( Deathcam );
	umsg.End();
	
end

hook.Add( "PlayerInitialSpawn", "SyncDeathcam", function( ply ) ply:SyncDeathcam() end );