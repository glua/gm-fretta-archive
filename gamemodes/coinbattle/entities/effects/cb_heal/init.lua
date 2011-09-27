
/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	// Keep the start and end pos - we're going to interpolate between them
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()

end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	self:Render()

	return false

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )
	
	local emitter = ParticleEmitter( self.Position )
	
	local part_gun = emitter:Add( "sprites/light_glow02_add", self.StartPos + VectorRand()*4 )
	if (part_gun) then
		
		part_gun:SetVelocity( ((self.EndPos+VectorRand()*16)-self.StartPos) )
		
		part_gun:SetLifeTime( 0 )
		part_gun:SetDieTime( math.Rand(0.2,0.8) )
		
		part_gun:SetStartAlpha( 255 )
		part_gun:SetEndAlpha( 0 )
		
		part_gun:SetStartSize( math.Rand(8,10) )
		part_gun:SetEndSize( 0 )
		
		part_gun:SetRoll( math.Rand(0, 360) )
		part_gun:SetRollDelta( math.Rand(-200, 200) )
		
		part_gun:SetAirResistance( math.Rand(80,100) )
		
		part_gun:SetGravity( Vector( 0, 0, 0 ) )
		
		part_gun:SetColor(0,255,0)
	
	end

	local part_gun = emitter:Add( "sprites/light_glow02_add", self.EndPos + VectorRand()*16 )
	if (part_gun) then
		
		part_gun:SetVelocity( VectorRand()*6 )
		
		part_gun:SetLifeTime( 0 )
		part_gun:SetDieTime( math.Rand(0.4,1) )
		
		part_gun:SetStartAlpha( 255 )
		part_gun:SetEndAlpha( 0 )
		
		part_gun:SetStartSize( math.Rand(8,10) )
		part_gun:SetEndSize( 0 )
		
		part_gun:SetRoll( math.Rand(0, 360) )
		part_gun:SetRollDelta( math.Rand(-200, 200) )
		
		part_gun:SetAirResistance( math.Rand(80,100) )
		
		part_gun:SetGravity( Vector( 0, 0, 6 ) )
		
		part_gun:SetColor(0,255,0)
	
	end
		
	emitter:Finish()
	
end