
function EFFECT:Init( data )
	
	self.npc = data:GetEntity()
  self.Position=self.npc:GetPos()

self.Life=1

  self.size=30


	local Pos = self.Position
	local emitter = ParticleEmitter( Pos )
			
			local particle = emitter:Add( "pedobear/pedobear", Pos+Vector(0,0,self.size))

			particle:SetDieTime( self.Life )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )
      
			particle:SetStartSize(self.size)
			particle:SetEndSize(self.size)

      self.prt=particle
		
	emitter:Finish()
		
  	local darker=1
    local sunsize=30
    local sunX=Pos.x
    local sunY=Pos.y
    local mult=1
		DrawSunbeams( darker,
					mult,
					sunsize, 
					sunX, 
					sunY
					);
end

-- Returning false makes the entity die
function EFFECT:Think()
	local Pos = self.npc:GetPos()
	local emitter = ParticleEmitter( Pos )
			
			local particle = emitter:Add( "pedobear/pedobear", Pos+Vector(0,0,self.size))

			particle:SetDieTime( self.Life )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )
      
			particle:SetStartSize(self.size)
			particle:SetEndSize(self.size)
			
      self.prt=particle
		
	emitter:Finish()
  
  
end


-- Draw the effect
function EFFECT:Render()


	local Pos = self.npc:GetPos()
	local emitter = ParticleEmitter( Pos )
			
			local particle = emitter:Add( "pedobear/pedobear", Pos+Vector(0,0,self.size))


			particle:SetDieTime( self.Life )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )
      
			particle:SetStartSize(self.size)
			particle:SetEndSize(self.size)
			
      self.prt=particle
	  
	emitter:Finish()
end



