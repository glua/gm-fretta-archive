include( "shared.lua" );

Deathcam = Vector( 0, 0, 0 );
StartFlip = -10;

function SyncDeathcam( um )
	
	local pos = um:ReadVector();
	Deathcam = pos;
	
end
usermessage.Hook( "SyncDeathcam", SyncDeathcam );

function FlipMeOver()
	
	StartFlip = CurTime();
	
end
usermessage.Hook( "FlipMeOver", FlipMeOver );