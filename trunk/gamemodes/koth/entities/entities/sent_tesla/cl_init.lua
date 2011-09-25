include('shared.lua')

function ENT:Initialize()

	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 200
		dlight.g = 200
		dlight.b = 255
		dlight.Brightness = 4
		dlight.Decay = 1024
		dlight.size = 512
		dlight.DieTime = CurTime() + 1
	end

end

function ENT:Think()

	if ValidEntity( self.Entity:GetNWEntity( "ZapEntity", nil ) ) then
	
		local dlight = DynamicLight( self.Entity:EntIndex() )
	
		if dlight then
			dlight.Pos = self.Entity:GetNWEntity( "ZapEntity", nil ):GetPos()
			dlight.r = 200
			dlight.g = 200
			dlight.b = 255
			dlight.Brightness = 3
			dlight.Decay = 1024
			dlight.size = 512
			dlight.DieTime = CurTime() + 1
		end
		
		local ed = EffectData()
		ed:SetOrigin( self.Entity:GetNWEntity( "ZapEntity", nil ):GetPos() )
		util.Effect( "electric_fade", ed )
	
		local dist = LocalPlayer():GetPos():Distance(self:GetPos())
		
		if dist < 100 then
		
			local scale = 1 - ( dist / 100 )
		
			Sharpen = scale * 6.5
			
			if LocalPlayer() == self.Entity:GetNWEntity( "ZapEntity", nil ) then
			
				ViewWobble = scale * 0.5
				MotionBlur = scale * 0.9
				ColorModify[ "$pp_colour_brightness" ] = scale * 0.6
			
			end
		
		end
		
		self.Entity:SetNWEntity( "ZapEntity", nil )
	
	end
	
end

function ENT:Draw()
	
end

