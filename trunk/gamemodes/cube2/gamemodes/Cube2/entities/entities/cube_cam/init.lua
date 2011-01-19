--This ent is for cam locations so i can have more c2 maps

include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	self.Pos = self:GetPos();
	
end

function ENT:KeyValue( key, val )
	
	if( key == "camname" ) then
		
		timer.Simple( 0.5, function()
			
			CubeCams[val] = { Pos = self.Pos, Ang = self.Ang };
			
		end );
		
	end
	
	if( key == "angles" ) then
		
		local a = string.Explode( " ", val );
		self.Ang = Angle( a[1], a[2], a[3] );
		
	end
	
end
