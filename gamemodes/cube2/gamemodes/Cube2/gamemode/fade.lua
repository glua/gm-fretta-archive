local meta = FindMetaTable( "Player" );

function meta:FadeIn( color, t )
	
	umsg.Start( "Fade", self );
		umsg.Vector( Vector( color.r, color.g, color.b ) );
		umsg.Short( t );
		umsg.Short( 1 );
	umsg.End();
	
end

function meta:FadeOut( color, t )
	
	umsg.Start( "Fade", self );
		umsg.Vector( Vector( color.r, color.g, color.b ) );
		umsg.Short( t );
		umsg.Short( -1 );
	umsg.End();
	
end
