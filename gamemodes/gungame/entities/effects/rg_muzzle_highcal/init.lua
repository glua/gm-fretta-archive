function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.Position = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)
	self.Forward = data:GetNormal()
	self.Angle = self.Forward:Angle()
	self.Right = self.Angle:Right()
	
	local AddVel = self.WeaponEnt:GetOwner():GetVelocity()
	
	local emitter = ParticleEmitter(self.Position)
		
		local particle = emitter:Add( "sprites/heatwave", self.Position - self.Forward * 4 )

		particle:SetVelocity( 80 * self.Forward + 20 * VectorRand() + 1.05 * AddVel )
		particle:SetGravity( Vector( 0, 0, 100 ) )
		particle:SetAirResistance( 160 )

		particle:SetDieTime( math.Rand( 0.2, 0.25 ) )

		particle:SetStartSize( math.random( 35, 70 ) )
		particle:SetEndSize( 15 )

		particle:SetRoll( math.Rand( 180, 480 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		
		for i = 1,4 do

			local particle = emitter:Add( "particle/particle_smokegrenade", self.Position )

				particle:SetVelocity( 175 * i * self.Forward + 8 * VectorRand() + AddVel )
				particle:SetAirResistance( 400 )
				particle:SetGravity( Vector(0, 0, math.Rand(100, 200) ) )

				particle:SetDieTime( math.Rand( 1.0, 1.5 ) )

				particle:SetStartAlpha( math.Rand( 25, 70 ) )
				particle:SetEndAlpha( 0 )

				particle:SetStartSize( math.Rand( 2, 5 ) )
				particle:SetEndSize( math.Rand( 35, 50 ) )

				particle:SetRoll( math.Rand( -25, 25 ) )
				particle:SetRollDelta( math.Rand( -0.05, 0.05 ) )

				particle:SetColor( 120, 120, 120 )
		end
		
		for i = 1,2 do 

			local particle = emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), self.Position + 8 * self.Forward )

				particle:SetVelocity( 350 * self.Forward + 1.1 * AddVel )
				particle:SetAirResistance( 160 )

				particle:SetDieTime( 0.1 )

				particle:SetStartAlpha( 160 )
				particle:SetEndAlpha( 0 )

				particle:SetStartSize( 10 * i )
				particle:SetEndSize( 8 * i )

				particle:SetRoll( math.Rand( 180, 480 ) )
				particle:SetRollDelta( math.Rand( -1, 1) )

				particle:SetColor( 255, 255, 255 )	
		end
	
	emitter:Finish()
end


function EFFECT:Think()

	return false
end


function EFFECT:Render()
end