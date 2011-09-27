local Mat = Material("cable/redlaser")

local AVec = Vector(99999, 99999, 99999)

local BoxSize = Vector(4,4,4)
local NegBoxSize = Vector(-4,-4,-4)

local CornerTwo = Vector(NegBoxSize.x,BoxSize.y,BoxSize.z)
local CornerFive = Vector(BoxSize.x,NegBoxSize.y,BoxSize.z)
local CornerSix = Vector(BoxSize.x,BoxSize.y,NegBoxSize.z)

local CornerOne = Vector(NegBoxSize.x,NegBoxSize.y,BoxSize.z)
local CornerThree = Vector(NegBoxSize.x,BoxSize.y,NegBoxSize.z)
local CornerFour = Vector(BoxSize.x,NegBoxSize.y,NegBoxSize.z)

local XAxis = Vector(200,0,0)
local YAxis = Vector(0,200,0)

function EFFECT:Init(efdata)
	self.Entity:SetRenderBounds(AVec*-1,AVec)
end 

function EFFECT:Think()
	return true
end 


local TehCol = Color(255,255,255,255)

function EFFECT:Render()

	render.SetMaterial(Mat)
	
	for k,v in pairs(LocalPlayer().NodePositions or {}) do
	
		render.DrawBeam( BoxSize+v, CornerSix+v, 5, 0, 0, TehCol ) 
		render.DrawBeam( BoxSize+v, CornerFive+v, 5, 0, 0, TehCol ) 
		render.DrawBeam( BoxSize+v, CornerTwo+v, 5, 0, 0, TehCol ) 
		
		render.DrawBeam( NegBoxSize+v, CornerOne+v, 5, 0, 0, TehCol ) 
		render.DrawBeam( NegBoxSize+v, CornerThree+v, 5, 0, 0, TehCol ) 
		render.DrawBeam( NegBoxSize+v, CornerFour+v, 5, 0, 0, TehCol ) 
		
		render.DrawBeam( CornerFive+v, CornerOne+v, 5, 0, 0, TehCol ) 
		render.DrawBeam( CornerTwo+v, CornerOne+v, 5, 0, 0, TehCol ) 
		
		render.DrawBeam( CornerTwo+v, CornerThree+v, 5, 0, 0, TehCol ) 
		render.DrawBeam( CornerFour+v, CornerFive+v, 5, 0, 0, TehCol ) 
		
		render.DrawBeam( CornerThree+v, CornerSix+v, 5, 0, 0, TehCol ) 
		render.DrawBeam( CornerFour+v, CornerSix+v, 5, 0, 0, TehCol ) 
		
		render.DrawBeam( v-XAxis, XAxis+v, 5, 0, 0, TehCol ) 
		render.DrawBeam( v-YAxis, YAxis+v, 5, 0, 0, TehCol ) 
	end
end 