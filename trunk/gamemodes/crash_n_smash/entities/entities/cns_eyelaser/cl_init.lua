
include( "shared.lua" )

ENT.Material = Material("cable/xbeam")
ENT.LightSprite = Material("sprites/light_glow02_add")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()

	self.Size = 0
	self.Entity:DrawShadow( false )

end

function ENT:Think()

	self.Entity:SetPos(self:GetOwner():GetPos())
	self.Entity:SetRenderBoundsWS( self:GetHitPos(), self.Entity:GetPos(), Vector()*8 )
	self.Size = math.Approach( self.Size, 1, 10*FrameTime() )
	
end

function ENT:Draw()

	local owner = self:GetOwner()
	local trace = owner:GetEyeTraceNoCursor( )

	self:SetHitPos( trace.HitPos )
	
	local struct = self:GetOwner():GetAttachment( self:GetOwner():LookupAttachment("eyes") )
	local StartPos = struct.Pos
	local EndPos = self:GetHitPos()
	
	local TexOffset = CurTime() * 10.0
	
	local ang = (EndPos - StartPos):Angle()
	local Normal = ang:Forward()
	local col = team.GetColor(self:GetOwner():Team())
	
	render.SetMaterial( self.LightSprite )
	render.DrawQuadEasy( EndPos + trace.HitNormal, trace.HitNormal, 64 * self.Size, 64 * self.Size, color_white )
	render.DrawQuadEasy( EndPos + trace.HitNormal, trace.HitNormal, math.Rand(32, 128) * self.Size, math.Rand(32, 128) * self.Size, col )
	render.DrawSprite( EndPos + trace.HitNormal, 64, 64, Color( col.r, col.g, col.b, self.Size * 255 ) )

	// Laser
	render.SetMaterial( self.Material )
	render.DrawBeam( StartPos, EndPos, 
					16, 
					TexOffset*-0.4, TexOffset*-0.4 + StartPos:Distance(EndPos) / 256, 
					col )
					
				
	render.SetMaterial( self.LightSprite )
	render.DrawSprite( StartPos, 128, 32, Color( col.r, col.g, col.b, 255 * self.Size ) )
	render.DrawSprite( StartPos + Normal * 8, 64, 16, Color( color_white.r, color_white.g, color_white.b, 255 * self.Size ) )
	render.DrawSprite( StartPos + Normal * 8, 64, 16, Color( col.r, col.g, col.b, 255 * self.Size ) )
	

end

