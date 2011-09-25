function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	self.Up = self.Angle:Up()
	
	local AddVel = self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter = ParticleEmitter(self.Position)
		
		local particle = emitter:Add( "sprites/heatwave", self.Position - self.Forward * 4 )

			particle:SetVelocity( 80 * self.Forward + 20 * VectorRand() + 1.05 * AddVel )
			particle:SetGravity( Vector( 0, 0, 100 ) )
			particle:SetAirResistance( 160 )

			particle:SetDieTime( math.Rand( 0.2, 0.25 ) )

			particle:SetStartSize( math.random( 15, 20 ) )
			particle:SetEndSize( 3 )

			particle:SetRoll( math.Rand( 180, 480 ) )
			particle:SetRollDelta( math.Rand( -1, 1 ) )

		for i = 1,4 do
			local particle = emitter:Add( "particle/particle_smokegrenade", self.Position )

				particle:SetVelocity( 50 * i * self.Forward + 8 * VectorRand() + AddVel )
				particle:SetAirResistance( 400 )
				particle:SetGravity( Vector(0, 0, math.Rand(50, 100) ) )

				particle:SetDieTime( math.Rand( 0.5, 1.0 ) )

				particle:SetStartAlpha( math.Rand( 25, 70 ) )
				particle:SetEndAlpha( 0 )

				particle:SetStartSize( math.Rand( 1, 4.5 ) )
				particle:SetEndSize( math.Rand( 6, 7.5 ) )

				particle:SetRoll( math.Rand( -25, 25 ) )
				particle:SetRollDelta( math.Rand( -0.05, 0.05 ) )

				particle:SetColor( 120, 120, 120 )
		end

	emitter:Finish()
end


function EFFECT:Think()

	return false
end


function EFFECT:Render()
end