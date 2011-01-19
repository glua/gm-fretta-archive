function EFFECT:Init( ed )
	
	local mag = ed:GetMagnitude();
	
	timer.Simple( 0.05, function()
		
		self.Gib = ents.GetByIndex( mag );
		
	end );
	
	self.DieTime = CurTime() + 6;
	self.NextBlood = CurTime() + 0.1;
	
end

function EFFECT:Think()
	
	if( CurTime() > self.DieTime ) then return false end
	
	if( CurTime() > self.NextBlood and self.Gib and self.Gib:IsValid() ) then
		
		local ed = EffectData();
		ed:SetOrigin( self.Gib:GetPos() );
		util.Effect( "BloodImpact", ed );
		
		self.NextBlood = CurTime() + 0.1;
		
	end
	
	return true
	
end

function EFFECT:Render()
end
