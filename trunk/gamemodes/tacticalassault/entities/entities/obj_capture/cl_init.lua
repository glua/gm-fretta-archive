include('shared.lua')

local curteam = 0

surface.CreateFont("Army",60,600,true,false,"TestFont2")
local ang = Angle(0,0,90)
function ENT:Draw()
	self.Entity:DrawModel()
	
	ang.yaw = ang.yaw + 1
	if ang.yaw > 360 then ang.yaw = 0 end
	
	local col,cap,str = color_white, self.Entity:GetNWInt("HasCapped"),"no team"
	//if cap == 1 then col = team.GetColor(1) elseif cap == 2 then col = team.GetColor(2) end
	if cap == 1 then col,str = Color(255,0,0),"Red" elseif cap == 2 then col,str = Color(0,0,255),"Blue" end
	
	cam.Start3D2D(self.Entity:GetPos() + Vector(-60,0,150),ang , 1)
		draw.SimpleTextOutlined(str, "TestFont2", 0, 0, col, 1, 1, 2, Color(0,0,0,255))
	cam.End3D2D()
	
	cam.Start3D2D(self.Entity:GetPos() + Vector(-60,0,150),Angle(0,180 + ang.yaw,90) , 1)
		draw.SimpleTextOutlined(str, "TestFont2", 0, 0, col, 1, 1, 2, Color(0,0,0,255))
	cam.End3D2D()
end


