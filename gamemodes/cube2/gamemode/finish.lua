local meta = FindMetaTable( "Player" );

function meta:Win()
	
	local t = CurTime() - self.StartTime;
	
	if( self:GetNWInt( "BestTime" ) > t ) then
		
		self:SetNWInt( "BestTime", t );
		self:PrintMessage( 3, "New best time! " .. string.ToMinutesSecondsMilliseconds( t ) .. "!" );
		
	end
	
	--self:SetNWInt( "Finishes", self:GetNWInt( "Finishes" ) + 1 );
	
	umsg.Start( "PlayClSound", self );
		umsg.String( "physics/nearmiss/whoosh_huge2.wav" );
	umsg.End();
	
	self:FadeIn( Color( 255, 255, 255, 255 ), 1 );
	timer.Simple( 0.9, function()
		self:FadeOut( Color( 255, 255, 255, 255 ), 1 );
		self:Spawn();
	end );
	
end
