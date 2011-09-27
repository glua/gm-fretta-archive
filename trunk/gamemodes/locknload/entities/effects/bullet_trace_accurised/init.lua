EFFECT.Mat = Material ("effects/spark")
EFFECT.Color = Color (150,150,255,255)

function EFFECT:Init (data)
	return InitLNLTracer (self, data)
end

function EFFECT:Think( )
	return ThinkLNLTracer (self)
end

function EFFECT:Render( )
	RenderLNLTracer (self, self.Color)			 
end