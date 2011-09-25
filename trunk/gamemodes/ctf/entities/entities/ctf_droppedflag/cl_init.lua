include( "shared.lua" );

ENT.LastDLight = 0
function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()

	local teamNo = self:GetNetworkedInt( "team", 1 );
		
	if( teamNo > 0 and CurTime() > self.LastDLight + 0.09 ) then
			
		local dlight = DynamicLight( self:EntIndex() )

		if ( dlight ) then
			
			local teamColor = team.GetColor( teamNo );
				
			dlight.Pos = self:GetPos();
				
			dlight.r = teamColor.r;
			dlight.g = teamColor.g;
			dlight.b = teamColor.b;
				
			dlight.Brightness = 5;
			dlight.Size = 64;
			dlight.DieTime = CurTime() + 0.1
				
			self.LastDLight = CurTime();
			
		end 
	end
	
end
