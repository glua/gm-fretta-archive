
include('shared.lua')

local matBeam		 		= Material( "egon_middlebeam" )
local matLight 				= Material( "sprites/gmdm_pickups/light" )
local matRefraction			= Material( "egon_ringbeam" )
local matRefractRing		= Material( "refract_ring" )

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()		

	self.Size = 0

end

function ENT:Think()

	self.Entity:SetRenderBoundsWS( self:GetEndPos(), self.Entity:GetPos(), Vector()*8 )
	
	self.Size = math.Approach( self.Size, 1, 10*FrameTime() )
	
end


function ENT:DrawMainBeam( StartPos, EndPos )

	local TexOffset = CurTime() * -2.0
	
	// Cool Beam
	render.SetMaterial( matBeam )
	render.DrawBeam( StartPos, EndPos, 
					32, 
					TexOffset*-0.4, TexOffset*-0.4 + StartPos:Distance(EndPos) / 256, 
					col_white )
					
	// Refraction Beam
	render.SetMaterial( matRefraction )
	render.UpdateRefractTexture()
	render.DrawBeam( StartPos, EndPos, 
					32, 
					TexOffset*0.5, TexOffset*0.5 + StartPos:Distance(EndPos) / 1024, 
					col_white )	


end

function ENT:DrawCurlyBeam( StartPos, EndPos, Angle )

	local TexOffset = CurTime() * 0.5

	local Forward	= Angle:Forward()
	local Right 	= Angle:Right()
	local Up 		= Angle:Up()
	
	local LastPos
	local Distance = StartPos:Distance( EndPos )
	local StepSize = 16
	local RingTightness = 0.05
		
	render.SetMaterial( matBeam )
	
	for i=0, Distance, StepSize do
	
		//local SizeMul = math.Clamp( (Distance-i) / Distance, 0.2, 1 )
	
		local sin = math.sin( CurTime() * -30 + i * RingTightness )
		local cos = math.cos( CurTime() * -30 + i * RingTightness )
		
		local Pos = StartPos + (Forward * i) + (Up * sin * 16) + (Right * cos * 16)
	
		if (LastPos) then
		
			render.DrawBeam( LastPos, Pos, 
							 (math.sin( i*0.02 )+1) * 4, 
							 TexOffset + i, 
							 TexOffset+Distance/128 + i, 
							 col_white )	 
		end
						 
		LastPos = Pos
	
	end

end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()

	local Owner = self.Entity:GetOwner()
	if (!Owner || Owner == NULL) then return end

	local StartPos 		= self.Entity:GetPos()
	local EndPos 		= self:GetEndPos()
	local ViewModel 	= Owner == LocalPlayer()
	
	local trace = {}
	
	local Angle = Owner:EyeAngles()
	
	// If it's the local player we start at the viewmodel
	if ( ViewModel ) then
	
		local vm = Owner:GetViewModel()
		if (!vm || vm == NULL) then return end
		local attachment = vm:GetAttachment( 1 )
		StartPos = attachment.Pos
		
		trace.start = Owner:EyePos()
	
	else
	// If we're viewing another player we start at their weapon
	
		local vm = Owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		local attachment = vm:GetAttachment( 1 )
		StartPos = attachment.Pos
		
		trace.start = StartPos
	
	end
	
	// Predict the endpoint, smoother, faster, harder, stronger
	
		trace.endpos = trace.start + (Owner:EyeAngles():Forward() * 4096)
		trace.filter = { Owner, Owner:GetActiveWeapon() }
			
		local tr = util.TraceLine( trace )
		
		EndPos = tr.HitPos
		
	
	// offset the texture coords so it looks like it's scrolling
	local TexOffset = CurTime() * -2
	
	// Make the texture coords relative to distance so they're always a nice size
	local Distance = EndPos:Distance( StartPos ) * self.Size
	
	
	
	Angle = (EndPos - StartPos):Angle()
	local Normal 	= Angle:Forward()
	
	render.SetMaterial( matLight )
	render.DrawQuadEasy( EndPos + tr.HitNormal, tr.HitNormal, 64 * self.Size, 64 * self.Size, color_white )
	render.DrawQuadEasy( EndPos + tr.HitNormal, tr.HitNormal, math.Rand(32, 128) * self.Size, math.Rand(32, 128) * self.Size, color_white )
	render.DrawSprite( EndPos + tr.HitNormal, 64, 64, Color( 255, 255, 255, self.Size * 255 ) )
	
	if (ViewModel) then
		--render.IgnoreZ( true )
		matLight:SetMaterialInt( "$ignorez", 1 );
	end

	// Draw the beam
	self:DrawMainBeam( StartPos, StartPos + Normal * Distance )
	
	// Draw curly Beam
	self:DrawCurlyBeam( StartPos, StartPos + Normal * Distance, Angle )
	
	// Light glow coming from gun to hide ugly edges :x
	if( !ViewModel ) then 
	render.SetMaterial( matLight )
	render.DrawSprite( StartPos, 128, 128, Color( 255, 255, 255, 255 * self.Size ) )
	render.DrawSprite( StartPos + Normal * 32, 64, 64, Color( 255, 255, 255, 255 * self.Size ) )
	end
	
	if ( !self.LastDecal || self.LastDecal < CurTime() ) then
		util.Decal( "EgonBurn", StartPos, StartPos + Normal * Distance * 1.1 )
		self.LastDecal = CurTime() + 0.01
	end
	 
end

