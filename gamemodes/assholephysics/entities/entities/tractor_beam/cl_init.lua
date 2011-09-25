
include('shared.lua')

local matBeam		 		= Material( "effects/tool_tracer" )
local matLight 				= Material( "particle/fire" )
local matFlare              = Material( "effects/blueflare1" )
local matRefraction			= Material( "egon_ringbeam" )
local matRefractRing		= Material( "refract_ring" )

function ENT:Initialize()		

	self.Size = 0
	self.Emitter = ParticleEmitter( self.Entity:GetPos() )

end

function ENT:OnRemove()

	if self.Emitter then
		self.Emitter:Finish()
	end

end

function ENT:Think()

	self.Entity:SetRenderBoundsWS( self:GetEndPos(), self.Entity:GetPos(), Vector() * 8 )
	
	self.Size = math.Approach( self.Size, 1, FrameTime() * 10 )
	
	local dist = self.Entity:GetEndPos():Distance( self.Entity:GetPos() )
	local dir = ( self.Entity:GetEndPos() - self.Entity:GetPos() ):Normalize()
	
	for i=1, 3 do
	
		local particle = self.Emitter:Add( "effects/yellowflare", self.Entity:GetEndPos() + VectorRand() * 5 )
		particle:SetVelocity( dir * -200 + VectorRand() * 100 )
		particle:SetColor( 100, 100, 255 )
		particle:SetDieTime( 1.5 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand(1,3) )
		particle:SetEndSize( 0 )
		
		particle:SetGravity( Vector( 0, 0, -300 ) )
		particle:SetBounce( 0.5 )
	
	end
	
end

function ENT:DrawMainBeam( StartPos, EndPos )

	local TexOffset = CurTime() * -2.0
	
	// Cool Beam
	render.SetMaterial( matBeam )
	render.DrawBeam( StartPos, EndPos, 
					7, 
					TexOffset * -0.5, TexOffset * -0.5 + StartPos:Distance( EndPos ) / 256, 
					col_white )

	matLight:SetMaterialInt( "$ignorez", 1 )
	
	render.SetMaterial( matLight )
	render.DrawSprite( StartPos, 18, 18, Color( 200, 200, 255, 255 ) )

end

function ENT:Draw()

	local Owner = self.Entity:GetOwner()
	
	if not ValidEntity( Owner ) then return end

	local StartPos 		= self.Entity:GetPos()
	local EndPos 		= self:GetEndPos()
	local ViewModel 	= Owner == LocalPlayer()
	
	local trace = {}
	
	local Angle = Owner:EyeAngles()
	
	// If it's the local player we start at the viewmodel
	if ( ViewModel ) then
	
		local vm = Owner:GetViewModel()
		
		if not ValidEntity( vm ) then return end
		
		local attachment = vm:GetAttachment( 1 )
		StartPos = attachment.Pos
		
		trace.start = Owner:EyePos()
	
	else
	// If we're viewing another player we start at their weapon
	
		local vm = Owner:GetActiveWeapon()
		
		if not ValidEntity( vm ) then return end
		
		local attachment = vm:GetAttachment( 1 )
		StartPos = attachment.Pos
		
		trace.start = StartPos
	
	end
	
	// Predict the endpoint, smoother, faster, harder, stronger
	
	trace.endpos = trace.start + ( Owner:EyeAngles():Forward() * 5000 )
	trace.filter = { Owner, Owner:GetActiveWeapon() }
	
	local tr = util.TraceLine( trace )
	
	EndPos = tr.HitPos
	
	
	// offset the texture coords so it looks like it's scrolling
	local TexOffset = CurTime() * -2
	
	// Make the texture coords relative to distance so they're always a nice size
	local Distance = EndPos:Distance( StartPos ) * self.Size
	
	Angle = ( EndPos - StartPos ):Angle()
	local Normal = Angle:Forward()
	
	local size = math.random( 32, 64 )
	local size2 = math.random( 16, 32 )
	
	render.SetMaterial( matLight )
	render.DrawQuadEasy( EndPos + tr.HitNormal, tr.HitNormal, size * self.Size, size * self.Size, Color( 200, 200, 255, 255 ) )
	
	render.SetMaterial( matFlare )
	render.DrawQuadEasy( EndPos + tr.HitNormal, tr.HitNormal, size2 * self.Size, size2 * self.Size, Color( 200, 200, 255, 255 ) )

	// Draw the beam
	self:DrawMainBeam( StartPos, StartPos + Normal * Distance )
	
	// Light glow coming from gun to hide ugly edges 
	if not ViewModel  then 
	
		render.SetMaterial( matFlare )
		render.DrawSprite( StartPos, 32, 32, Color( 200, 200, 255, 255 ) )
		
	end
	
end

