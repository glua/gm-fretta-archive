ENT.Type			= "anim"
ENT.Base 			= "base_anim"
ENT.Spawnable		= true
ENT.AdminSpawnable  	= true

ENT.PrintName		= "Helicopter"
ENT.Author			= "Entoros"
ENT.Contact    		= "Don't"
ENT.Purpose 		= ""
ENT.Instructions 		= "Spawn" 
ENT.AutomaticFrameAdvance = true

function ENT:CalcView(pl, pos, ang, fov)
	
	local view =  {}
	view.origin = pos + Vector(-500,0,300)
	view.angles = ang + Angle(30,0,0)
	view.fov = fov
	return view

end 
