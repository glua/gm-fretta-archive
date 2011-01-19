include('shared.lua')

function ENT:Initialize()

	self.Emitter = ParticleEmitter( self.Entity:GetPos() ) 
	self.Smoke = 0
	
end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
		
	end

end

function ENT:Think()

	if self.Entity:GetNWFloat( "BurnDelay", 9000 ) > CurTime() then return end
	
	if self.Smoke < CurTime() then
	
		self.Smoke = CurTime() + 0.2
	
		local particle = self.Emitter:Add( "particles/smokey", self.Entity:GetPos() + self.Entity:GetUp() * 3 )
		particle:SetVelocity( VectorRand() * 5 + WindVector )
		particle:SetDieTime( math.Rand( 2.0, 3.0 ) )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.random( 2, 4 ) )
		particle:SetEndSize( math.random( 15, 30 ) )
		particle:SetGravity( Vector( 0, 0, 10 ) )
			
		local col = math.random( 100, 150 )
		particle:SetColor( col + 20, col, col + 50 )
		
	end
	
	local dlight = DynamicLight( self.Entity:EntIndex() )
	
	if dlight then
	
		dlight.Pos = self.Entity:GetPos()
		dlight.r = 100
		dlight.g = 50
		dlight.b = 255
		dlight.Brightness = math.Rand( 2, 3 )
		dlight.Decay = 512
		dlight.size = 512 * math.Rand( 1.0, 1.1 )
		dlight.DieTime = CurTime() + 1
		
	end
	
	if not LocalPlayer():Alive() or LocalPlayer():Team() == TEAM_SPECTATOR then return end
	
	local dist = LocalPlayer():GetPos():Distance( self.Entity:GetPos() )
		
	if dist < 200 then
		
		local scale = math.Clamp( 1 - ( math.Clamp( dist, 1, 200 ) / 200 ), 0, 1 )
			
		Sharpen = scale * 5
		MotionBlur = scale * 0.25
		
		if LocalPlayer():Team() == TEAM_STALKER then
		
			ColorModify[ "$pp_colour_contrast" ] = 1 + ( scale * 0.75 )
		
		else
		
			ColorModify[ "$pp_colour_contrast" ] = 1 + ( scale * 0.5 )
		
		end
		
	end
	
end

local matFlare = Material( "effects/blueflare1" )

function ENT:Draw()

	self.Entity:DrawModel()

	if self.Entity:GetNWFloat( "BurnDelay", 9000 ) > CurTime() then return end
	
	local size = math.Rand( 5, 10 )
	
	render.SetMaterial( matFlare )
	render.DrawSprite( self.Entity:GetPos() + self.Entity:GetUp() * 3, size, size, Color( 100, 50, 255, 255 ) ) 
	
end

