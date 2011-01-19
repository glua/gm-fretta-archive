

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
 	 
 	local vOffset = self.Ent:LocalToWorld( self.Ent:OBBCenter() ) 
 		 
	for i=1, math.random(4,8) do
	
		local particle = self.Emitter:Add( "particles/smokey", vOffset ) 
 		 
 		particle:SetVelocity( VectorRand() * 40 ) 
 		particle:SetLifeTime( 0 ) 
 		particle:SetDieTime( math.Rand(0.5,1) ) 
 		particle:SetStartAlpha( math.Rand(150,200) ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random(5,10) ) 
 		particle:SetEndSize( math.random(20,40) ) 
		local dark = math.Rand(50,100)
 		particle:SetColor( dark, dark, dark ) 
		
		particle:SetAirResistance( 50 )
		particle:SetGravity( Vector( 0, 0, 100 ) )
		particle:SetCollide( true )
		particle:SetBounce( 0.2 )
 				 
 	end 
	
	for i=1, math.random(2,4) do
	
		local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), vOffset )
 		 
 		particle:SetVelocity( VectorRand() * 30 + Vector(0,0,20) ) 
 		particle:SetLifeTime( 0 ) 
 		particle:SetDieTime( math.Rand(0.4,0.8) ) 
 		particle:SetStartAlpha( 255 ) 
 		particle:SetEndAlpha( 0 ) 
 		particle:SetStartSize( math.random(10,40) ) 
 		particle:SetEndSize( 1 ) 
 		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
		
		particle:SetAirResistance( 50 )
 				 
 	end 
	return true
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()	
end



