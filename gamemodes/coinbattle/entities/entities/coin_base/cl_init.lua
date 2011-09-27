
include("shared.lua")

function ENT:Initialize()
	
	local spindir = math.floor(math.Rand(-1,1))
	
	if spindir >= 0 then
		spindir = 1
	else
		spindir = -1
	end
	
	self.Ang = Angle(90, 0, math.Rand(0,360))
	self.SpinSpeed = math.Rand(50,100)*spindir
	
	self.VertDistance = math.Rand(2,4)
	self.JumpSpeed = math.Rand(2,4)
	self.TimeOffset = math.Rand(-2,2)
	
end

function ENT:Think()
	
	self.Ang.r = self.Ang.r + FrameTime()*self.SpinSpeed
	
	self:SetAngles(self.Ang)
	
end

local matGlow = Material("effects/blueflare1")
local matTrail = Material("particle/Particle_Glow_04")
function ENT:Draw()
	
	self:SetModelScale(Vector(4, 4, 0.5)*self.CoinScale)
	
	local pos,ang = EyePos(),EyeAngles()
	local vel = self:GetVelocity()
	local bounce = math.sin((CurTime() + self.TimeOffset)*self.JumpSpeed)
	local offset = Vector(0,0,1)*bounce*self.VertDistance
	
	cam.Start3D(pos - Vector(0,0,self.VertDistance) + offset, ang)
		
		local lcolor = render.GetLightColor( self:GetPos() ) * 2
		
		lcolor.x = self.Metal[1] * mathx.Clamp( lcolor.x, 0, 1 )
		lcolor.y = self.Metal[2] * mathx.Clamp( lcolor.y, 0, 1 )
		lcolor.z = self.Metal[3] * mathx.Clamp( lcolor.z, 0, 1 )
		
		local col
		local size
		
		if ( vel:Length() > 1 ) then
			render.SetMaterial(matTrail)
			for i = 1, 10 do
				
				col = Color( lcolor.x, lcolor.y, lcolor.z, 200 / i )
				size = 16*self.CoinScale
				render.DrawSprite( self:GetPos() + vel*(i*-0.01), size, size, col )
				
			end
		
		end
		
		render.SetMaterial(matGlow)
		col = Color( lcolor.x, lcolor.y, lcolor.z, 100+bounce*100 )
		size = bounce*6 + 32*self.CoinScale
		render.DrawSprite( self:GetPos(), size, size, col )
		
		self:DrawModel()
		
	cam.End3D()
	
end
