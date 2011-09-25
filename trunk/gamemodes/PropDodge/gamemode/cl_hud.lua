--optomizing from PAC
local Start3D2D = cam.Start3D2D
local End3D2D = cam.End3D2D
local SimpleTextOutlined = draw.SimpleTextOutlined
local sin = math.sin
local GetColor = team.GetColor

function DrawNames()
	for k,v in pairs(player.GetAll()) do
		if v:Alive() and v != LocalPlayer() and v:Team() != TEAM_SPECTATOR then
			Start3D2D( v:GetPos()+Vector(0,0,80)+Vector(0,0,2)*sin(CurTime()), Angle(0,LocalPlayer():EyeAngles().y-90,90), 0.4 )
				SimpleTextOutlined(v:Nick(), "TargetID", 0,0, GetColor(v:Team()), 1, 0, 1, Color(0,0,0,255))
				SimpleTextOutlined(v:Health(), "TargetID", 0,13, GetColor(v:Team()), 1, 0, 1, Color(0,0,0,255))
			End3D2D()
		end
	end
end
hook.Add("PostPlayerDraw", "DrawNames", DrawNames)

function GM:HUDPaint()
	--DrawNames()
	self.BaseClass:HUDPaint()
end
