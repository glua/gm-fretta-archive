

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.Ent = data:GetEntity()
	if not self.Ent or not self.Ent:IsValid() then self.Emitter = nil return end
	self.Emitter = ParticleEmitter(self.Ent:GetPos())
	
end


/*---------------------------------------------------------
   THINK
   Returning false makes the entity die
---------------------------------------------------------*/
function EFFECT:Think( )

	if not self.Ent:IsValid() or self.Ent == NULL or self.Ent == nil then
		self.Emitter:Finish()
		return false
	end
 	 
 	local pos = self.Ent:GetPos()
 		 
	for i=1, math.random(4,8) do
	
		local particle = self.Emitter:Add( "effects/blueflare1", pos ) 
 		 
 		particle:SetVelocity( VectorRand() * 20 + Vector(0,0,math.Rand(-50,-20)) ) 
 		particle:SetDieTime( math.Rand(0.5,1) ) 
 		particle:SetStartAlpha( math.Rand(150,250) ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random(3,6) ) 
 		particle:SetEndSize( 0 ) 
 		particle:SetColor( 255, math.Rand( 0, 50 ), 0 ) 
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, -500 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.7 )
 				 
 	end 
	return true
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()	
end



