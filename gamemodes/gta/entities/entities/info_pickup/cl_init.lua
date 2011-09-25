
include('shared.lua')

ENT.ShineMat = "models/props_combine/portalball001_sheet"
ENT.GlowMat = Material( "particle/fire" )

function ENT:Initialize()
	
	self.Ang = Angle( 0, math.random( 0, 360 ), 0 )
	
end

function ENT:Think()

	self.Ang.y = self.Ang.y + FrameTime() * 50
	
	if self.Ang.y >= 360 then
		self.Ang.y = 0
	end
	
	self.Entity:SetAngles( self.Ang )

end

function ENT:Draw()

	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,-500)
	trace.filter = self.Entity
	local tr = util.TraceLine( trace )
	
	render.SetMaterial( self.GlowMat )
	render.DrawQuadEasy( tr.HitPos, tr.HitNormal, 35, 35, Color( 0, 100, 255, 200 ) )
	
	if self:GetActiveTime() > CurTime() then 
	
		local alpha = 255 * ( 1 - ( self:GetActiveTime() - CurTime() ) / 30 )
		alpha = math.Clamp( alpha, 1, 150 )
		
		self.Entity:SetColor( 255, 255, 255, alpha )
		self.Entity:DrawModel()
	
	else
	
		self.Entity:SetColor( 255, 255, 255, 255 )
		self.Entity:DrawModel()
	
	end
	
end



