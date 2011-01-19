
function EFFECT:Init(data)
	
	self.Normal = data:GetNormal()
	self.StartPos = data:GetOrigin()
	self.Right = self.Normal:Angle():Right()
	self.Up = self.Normal:Angle():Up()
	
	self.Rendered = false
end


function EFFECT:Think()

	return !self.Rendered
	
end


function EFFECT:Render()

	local emitter = ParticleEmitter( self.StartPos )
	if emitter then
		for i = 1, 25 do
			local vec = (self.Up * math.Rand(-1,1) + self.Right * math.Rand(-1,1)):GetNormal() * math.Rand( 100, 150 )
			local col = Color(255,255,255)
			local particle = emitter:Add( "sprites/light_glow02_add", self.StartPos )
			particle:SetVelocity( vec )
			particle:SetDieTime( 1+math.Rand(0,0.5) )
			particle:SetAirResistance( math.Rand(200,300) )
			particle:SetStartSize( math.Rand( 1, 5 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -0.2, 0.2 ) )
			particle:SetColor( col.r, col.g, col.b )
		end
		emitter:Finish()
	end

	self.Rendered = true
end


