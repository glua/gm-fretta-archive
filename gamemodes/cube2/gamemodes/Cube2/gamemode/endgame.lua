-- player:Deaths()
-- player:GetNWInt( "Finishes" )
-- player:GetNWInt( "BestTime" )

function GM:OnEndOfGame()
	
	for _, v in pairs( player.GetAll() ) do
		
		v:Freeze( true );
		v:FadeIn( Color( 255, 255, 255, 255 ), 1 );
		timer.Simple( 0.9, function()
			
			v:FadeOut( Color( 255, 255, 255, 255 ), 3 );
			
		end );
		timer.Simple( 1, function()
			
			v:SetCameraPos( CubeCams["intro"].Pos, CubeCams["intro"].Ang );
			
		end );
		
	end
	
	timer.Simple( 1, function()
		
		umsg.Start( "msgGameOver" );
		umsg.End();
		
	end );

end

function EndPVS( ply, view )
	
	AddOriginToPVS( CubeCams["intro"].Pos );
	
end
hook.Add( "SetupPlayerVisibility", "EndPVS", EndPVS );
