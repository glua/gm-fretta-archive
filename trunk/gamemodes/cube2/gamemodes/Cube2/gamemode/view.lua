local meta = FindMetaTable( "Player" );

CubeCams = { };
CubeCams["intro"] = { Pos = Vector( 0, 0, 0 ), Ang = Angle( 0, 0, 0 ) };

function meta:SetCameraPos( pos, ang )
	
	self.InCam = true;
	
	umsg.Start( "SetViewLocation", self );
		umsg.Vector( pos );
		umsg.Angle( ang );
	umsg.End();
	
	self:GetViewModel():SetNoDraw( true );
	
end

function meta:ResetCameraPos()
	
	self.InCam = false;
	
	umsg.Start( "SetViewLocation", self );
		umsg.Vector( Vector( 0, 0, 0 ) );
		umsg.Angle( Angle( 0, 0, 0 ) );
	umsg.End();
	
	self:GetViewModel():SetNoDraw( false );
	
end
