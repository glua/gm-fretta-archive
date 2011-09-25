
function EFFECT:Init( data )

	self.LifeTime = CurTime() + 30
	self.Ent = data:GetEntity()
	
	if self.Ent:GetPos():Distance( LocalPlayer():GetPos() ) < 10 then
	
		ColorModify[ "$pp_colour_addg" ] = 0.3
	
	end
	
	self.Entity:SetParent( self.Ent )
	self.Emitter = ParticleEmitter( self.Ent:GetPos() )
	
end

function EFFECT:Think( )

	if not ValidEntity( self.Ent ) or not self.Ent:Alive() then 
	
		if self.Emitter then
			self.Emitter:Finish()
		end
		
		return false 
		
	end
	
	local particle = self.Emitter:Add( "sprites/light_glow02_add", self.Ent:GetPos() + Vector( math.Rand(-10,10), math.Rand(-10,10), math.Rand(0,50) ) )
	particle:SetVelocity( VectorRand() * 50 )
	particle:SetDieTime( math.Rand( 1.5, 2.0 ) )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.Rand( 2, 4 ) )
	particle:SetEndSize( 0 )
	particle:SetColor( 0, 255, 0 )

	particle:SetAirResistance( 50 )
	particle:SetGravity( Vector(0,0,300) )
	particle:SetCollide( true )
	particle:SetBounce( 1.0 )

	if self.LifeTime < CurTime() then
		
		if self.Emitter then
			self.Emitter:Finish()
		end
		
		return false
		
	end
	
	return true
	
end

function EFFECT:Render()

end
