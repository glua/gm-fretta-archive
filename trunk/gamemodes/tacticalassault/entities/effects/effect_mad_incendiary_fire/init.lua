local matLight2 = Material("effects/yellowflare")

/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data) 
 	 
 	// This is how long the spawn effect  
 	// takes from start to finish. 
 	self.Time = 1
 	self.LifeTime = CurTime() + self.Time

 	self.vOffset = data:GetOrigin()
end

/*---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------*/
function EFFECT:Think() 
   
	return (self.LifeTime > CurTime())  
end 

/*---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------*/
function EFFECT:Render() 
 	 
 	local Fraction = (self.LifeTime - CurTime()) / self.Time 
 	Fraction = math.Clamp(Fraction, 0, 1) 
 	
	self.Entity:SetColor(255, 255, 255, 255 * Fraction)
	self.Entity:SetModelScale(Vector() * 100 * (1 - Fraction))
	
   	render.SetMaterial(matLight2)
	render.DrawQuadEasy(self.vOffset, VectorRand(), 500 * (Fraction) , 500 * (Fraction) , color_white)
	render.DrawQuadEasy(self.vOffset, VectorRand(), math.Rand(64, 1000), math.Rand(64, 1000), color_white)
	render.DrawSprite(self.vOffset, 500 * (Fraction), 500 * (Fraction), Color(255, 150, 150, 255))
end  