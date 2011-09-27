EFFECT.Flare = Material("effects/blueflare1")
EFFECT.EndFlare = Material("effects/yellowflare")
EFFECT.Mat = Material("effects/yellowflare")
EFFECT.Color = Color (200,200,255,255)

function EFFECT:Init (data)
	InitLNLLaserTracer (self, data)
end

function EFFECT:Think ()
	return ThinkLNLLaserTracer (self)
end

function EFFECT:Render ()
	RenderLNLLaserTracer (self, self.Color)
end