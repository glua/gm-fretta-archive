
function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.Normal = data:GetNormal()
	
	self.StartPos = self:GetTracerShootPos(data:GetOrigin(), self.WeaponEnt, self.Attachment)

	self.Rendered = false
end


function EFFECT:Think()

	return !self.Rendered
	
end


function EFFECT:Render()

	function RemovePart( part, hitpos )
		part:SetDieTime( 0 )
	end

	local emitter = ParticleEmitter( self.StartPos )
	if emitter then
		for i = 1, 20 do
			local vecrand = Angle(math.Rand(0,360), math.Rand(0,360), 0):Forward()
			local col = Color(255,255,255,math.random(100,200))
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPos )
			particle:SetVelocity( self.Normal + vecrand )
			particle:SetDieTime( math.Rand(0.2,0.4) )
			particle:SetAirResistance( math.Rand(0.1,0.2) )
			particle:SetStartSize( math.Rand( 20, 30 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -0.2, 0.2 ) )
			particle:SetColor( col.r, col.g, col.b )
		end
		
		for i = 1, 25 do
			local col = Color(255,255,255,math.random(100,200))
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPos )
			particle:SetVelocity( self.Normal * math.Rand(200,5000) )
			particle:SetDieTime( 1+math.Rand(0,0.5) )
			particle:SetAirResistance( math.Rand(200,250) )
			particle:SetStartSize( math.Rand( 1, 5 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -0.2, 0.2 ) )
			particle:SetColor( col.r, col.g, col.b )
			particle:SetCollide( true )
			particle:SetCollideCallback( RemovePart )
		end
		emitter:Finish()
	end

	self.Rendered = true
end


