
include("shared.lua")

function ENT:Initialize()
	
	local spindir = math.floor(math.Rand(-1,1))
	
	if spindir >= 0 then
		spindir = 1
	else
		spindir = -1
	end
	
	self.Ang = Angle(30, math.Rand(0,360), 0)
	self.SpinSpeed = math.Rand(20,40)*spindir
	
	self.VertDistance = math.Rand(1,3)
	self.JumpSpeed = math.Rand(1,3)
	self.TimeOffset = math.Rand(-2,2)
	
end

function ENT:Think()
	
	self.Ang.y = self.Ang.y + FrameTime()*self.SpinSpeed
	
	self:SetAngles(self.Ang)
	
end

function ENT:Draw()
	
	if self.dt.HScale == 3 then
		self:SetModelScale(Vector(2,2,2))
	end
	
	local pos,ang = EyePos(),EyeAngles()
	local bounce = math.sin((CurTime() + self.TimeOffset)*self.JumpSpeed)
	local offset = Vector(0,0,1)*bounce*self.VertDistance
	
	cam.Start3D(pos - Vector(0,0,self.VertDistance) + offset, ang)
		
		self:DrawModel()
		
	cam.End3D()
	
	local tang = self:GetAngles()
	tang:RotateAroundAxis(tang:Up(), 90)
	local toffset = 8
	local tshift = self:GetForward()*2
	
	if self.dt.HScale == 1 then
		tang:RotateAroundAxis(tang:Up(),180)
		tang:RotateAroundAxis(tang:Forward(),90)
	elseif self.dt.HScale == 2 then
		tshift = tshift*4
	else
		toffset = 14
		tshift = tshift*8
	end
	
	cam.Start3D2D(self:GetPos() + Vector(0,0,self.VertDistance+toffset) - offset + tshift, tang, 0.1*self.dt.HScale)
	
		local lcolor = render.GetLightColor( self:GetPos() ) * 2
		local col = Color(134,203,110,255)
		
		lcolor.x = col.r * mathx.Clamp( lcolor.x, 0, 1 )
		lcolor.y = col.g * mathx.Clamp( lcolor.y, 0, 1 )
		lcolor.z = col.b * mathx.Clamp( lcolor.z, 0, 1 )
		
		local col = Color(lcolor.x,lcolor.y,lcolor.z,255)
		
		draw.SimpleTextOutlined(self.dt.HScale.."C","FRETTA_LARGE",0,0,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
		draw.SimpleTextOutlined(21*self.dt.HScale.."HP","FRETTA_LARGE",0,-25,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
	
	cam.End3D2D()
	
end
