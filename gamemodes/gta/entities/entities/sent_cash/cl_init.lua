
include('shared.lua')

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

ENT.GlowMat = Material( "particle/fire" )

function ENT:Draw()

	if LocalPlayer():Team() == TEAM_POLICE then return end
	
	self.Entity:SetModelScale( Vector( 1.25, 1.25, 1.25 ) )
	self.Entity:DrawModel()
	
	local trace = {}
	trace.start = self.Entity:GetPos()
	trace.endpos = trace.start + Vector(0,0,-500)
	trace.filter = self.Entity
	local tr = util.TraceLine( trace )
	
	render.SetMaterial( self.GlowMat )
	render.DrawQuadEasy( tr.HitPos, tr.HitNormal, 25, 25, Color( 0, 255, 0, 200 ) )
	
end



