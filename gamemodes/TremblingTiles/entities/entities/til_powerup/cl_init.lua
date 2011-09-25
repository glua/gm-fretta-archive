include( "shared.lua" );

ENT.RotationTime = 1;

function ENT:Draw()
	
	local color = self:GetNWVector( "color" );
	local fadeStart = self:GetNWInt( "FadeStart", math.huge );
	local diff = CurTime() - fadeStart;
	local amul = 1;
	
	if( diff > 0 ) then
		
		amul = math.Clamp( 1 - diff, 0, 1 );
		
	end
	
	cam.Start3D2D( self:GetPos() + Vector( 0, 0, 64 ), Angle( 0, CurTime() * 360 / ( self.RotationTime * 2 ), 90 ), 0.1 );
		draw.DrawText( self:GetNWString( "text" ), "PowerupText", 0, 0, Color( 0, 0, 0, 255 * amul ), TEXT_ALIGN_CENTER );
		draw.DrawText( self:GetNWString( "text" ), "PowerupText", 1, 1, Color( color.x, color.y, color.z, 255 * amul ), TEXT_ALIGN_CENTER );
	cam.End3D2D();
	
	cam.Start3D2D( self:GetPos() + Vector( 0, 0, 64 ), Angle( 0, CurTime() * 360 / ( self.RotationTime * 2 ) + 180, 90 ), 0.1 );
		draw.DrawText( self:GetNWString( "text" ), "PowerupText", 0, 0, Color( 0, 0, 0, 255 * amul ), TEXT_ALIGN_CENTER );
		draw.DrawText( self:GetNWString( "text" ), "PowerupText", 1, 1, Color( color.x, color.y, color.z, 255 * amul ), TEXT_ALIGN_CENTER );
	cam.End3D2D();
	
end
