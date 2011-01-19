
include('shared.lua')

local matLight 		= Material( "sprites/light_ignorez" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	
	self.Color = Color( 255, 255, 255, 255 )
	
	if ( !self.Emitter ) then
		self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	end
	self.PixVis = util.GetPixelVisibleHandle()
	
end

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:OnRemove()
	
	if ( self.Emitter ) then	
		self.Emitter = nil
	end
	
end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function ENT:Think()
	
	
	local Gravity = Vector( 0, 0, -40 )
	
	if ( self.Emitter ) then
	
		if ( !self.LastParticle || self.LastParticle < CurTime() ) then
		
			self.LastParticle = CurTime() + 0.008
			self.ParticlesSpawned = self.ParticlesSpawned or 1
			self.ParticlesSpawned = self.ParticlesSpawned + 1
		
			local particle = self.Emitter:Add( "particles/smokey", self.Entity:GetPos() )
				particle:SetVelocity( VectorRand() * math.Rand( 1, 64 ) )
				particle:SetDieTime( math.Rand( 1, 2 ) )
				particle:SetStartAlpha( 255 )
				particle:SetStartSize( math.Rand( 5, 10 ) )
				particle:SetEndSize( 32 )
				particle:SetRoll( math.Rand( -0.3, 0.3 ) )
				particle:SetAirResistance( 100 )
				particle:SetLighting( true )
			
			// This is to fix z order problems with different particles
			// Make a new emitter every x particles
			if ( self.ParticlesSpawned > 16 ) then
			
				self.Emitter:Finish()
				self.Emitter = ParticleEmitter( self.Entity:GetPos() )
				self.ParticlesSpawned = 0
				
			end
			
		end
	
	end
	
	
	
	self.TimeTillDie = (self.Entity:GetNetworkedFloat( "ExplodeTime", CurTime() + self.FuseLength ) - CurTime()) / self.FuseLength
	self.TimeTillDie = math.Clamp( self.TimeTillDie, 0, 1 )
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 30
		dlight.g = 30
		dlight.b = 100
		dlight.Brightness = 1 * math.Rand( .5, .7 )
		dlight.Decay = 128
		dlight.size = 256 * math.Rand( 0.2, .7 )
		dlight.DieTime = CurTime( ) + 0.2
	end

end

g_SMGGlares = {}

/*---------------------------------------------------------
   Name: 
---------------------------------------------------------*/
function ENT:Draw()

end



/*---------------------------------------------------------
   Name: DrawTranslucent
---------------------------------------------------------*/
function ENT:DrawTranslucent()
	
	local Pos = self.Entity:GetPos()
	
	local Visibile	= util.PixelVisible( Pos, 8, self.PixVis )
	if ( !Visibile ) then return end
	if ( Visibile == 0 ) then return end
	
	local Visibile = 1
	
	self.Visibility = Visibile
	table.insert( g_SMGGlares, self )

end


/*---------------------------------------------------------
   Name: DrawTranslucent
---------------------------------------------------------*/
function ENT:RenderGlare()
	
	local Pos = self.Entity:GetPos()
	local Dist = math.Clamp( Pos:Distance( EyePos() ) / 2048, 0, 1 )
	local Visibile	= self.Visibility
	
	local Col = Color( 255, 0, 0, Visibile * 255 )
	
	if ( self.TimeTillDie < 0.3 ) then
		Col.r = 255
		Col.g = 0
		Col.b = 0
	end
	
	local Size = 512 * Dist
	
		Col.b = 1 * math.Rand( 0.6, 1 ) 
		Col.g = 1 * math.Rand( 0.6, 1 )
		Col.r = 255
	
	render.SetMaterial( matLight )
	
	render.DrawSprite( Pos, Size, Size, Col, Dist * 360 )
	render.DrawSprite( Pos, 16, 16, Color(255, 255, 255, Visibile*255), Dist * 360 )
	render.DrawSprite( Pos, 64, 64, Color(255, 255, 255, Visibile*255), -Dist * 360)


end

local function RenderGrenadeGlares()

	for k, v in ipairs( g_SMGGlares ) do
		v:RenderGlare()
	end

	g_SMGGlares = {}

end

hook.Add( "PostDrawTranslucent", "RenderSMGGlares", RenderGrenadeGlares )
