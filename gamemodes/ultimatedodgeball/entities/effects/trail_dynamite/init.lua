

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
 	 
 	local pos = self.Ent:GetPos() + self.Ent:GetUp() * -4
	local ang = self.Ent:GetUp()
 		 
	for i=1, math.random(3,6) do
	
		local particle = self.Emitter:Add( "effects/yellowflare", pos ) 
 		 
 		particle:SetVelocity( ang * math.Rand(-150,-100) + (VectorRand() * math.Rand(10,90)) ) 
 		particle:SetDieTime( math.Rand(0.5,1) ) 
 		particle:SetStartAlpha( math.Rand(150,250) ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random(2,4) ) 
 		particle:SetEndSize( 0 ) 
 		particle:SetColor( 255, math.Rand( 150, 220 ), 0 ) 
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, -500 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.8 )
 				 
 	end 
	return true
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()	
end



