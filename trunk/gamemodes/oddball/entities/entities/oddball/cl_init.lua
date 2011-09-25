include('shared.lua')

function ENT:Draw()
	self.Entity:DrawModel()

	cam.Start3D(EyePos(), EyeAngles())

	render.SetMaterial(Material("oddball/grey_arrow"))

	render.DrawSprite(self.Entity:GetPos()+Vector(0,0,36), 32, 32, Color(255,255,255,255) ) --Draw that bitch above the skull

	cam.End3D()
end