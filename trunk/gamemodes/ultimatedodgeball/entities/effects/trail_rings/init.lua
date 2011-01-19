

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

	self.RingTimer = self.RingTimer or 0 
 	if ( self.RingTimer > CurTime() ) then return true end 
 	self.RingTimer = CurTime() + 0.01
 	 
 	local vOffset = self.Ent:LocalToWorld( self.Ent:OBBCenter() ) 
 	local vNormal = self.Ent:GetVelocity():GetNormalized() 
 	 
 	vOffset = vOffset + vNormal * -5
 		 
 	local particle = self.Emitter:Add( "effects/select_ring", vOffset ) 
 		 
 	particle:SetVelocity( vNormal * 300 ) 
 	particle:SetLifeTime( 0 ) 
 	particle:SetDieTime( 0.4 ) 
 	particle:SetStartAlpha( 255 ) 
 	particle:SetEndAlpha( 0 ) 
 	particle:SetStartSize( 7 ) 
 	particle:SetEndSize( 4 ) 
 	particle:SetAngles( vNormal:Angle() ) 
 	particle:SetColor( math.Rand( 10, 100 ), math.Rand( 100, 220 ), math.Rand( 240, 255 ) ) 
 						 
	return true
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()	
end



