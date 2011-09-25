// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Laser beam tracer effect.

EFFECT.LaserMat = Material("LaserTag/lasertex")
EFFECT.EndSprMat = Material("effects/yellowflare")

/*-------------------------------------------------------------------
	[ Init ]
	When the entity is first initialised.
-------------------------------------------------------------------*/
function EFFECT:Init(data)
	self.Position = data:GetStart()
	self.Weapon = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	self.StartPos = self:GetTracerShootPos(self.Position,self.Weapon,self.Attachment)
	self.EndPos = data:GetOrigin()
	self.Length = (self.StartPos - self.EndPos):Length()
	
	if not IsValid(self.Weapon) then return false end
	
	self.Owner = self.Weapon:GetOwner()
	if not IsValid(self.Owner) then
		self.Color = Color(255,255,255,255)
	else
		self.Color = team.GetColor(self.Owner:Team())
	end
	
	self.Alpha = 255
	self.Width = data:GetMagnitude()
	self.Entity:SetRenderBoundsWS(self.StartPos,self.EndPos)
end

/*-------------------------------------------------------------------
	[ Think ]
	Think cycle; gradually reduces alpha until we end drawing (return false).
-------------------------------------------------------------------*/
function EFFECT:Think()
	if not self.Alpha then return false end
	self.Alpha = self.Alpha - FrameTime() * 300
	
	if self.Alpha < 0 then return false end
	return true
end

/*-------------------------------------------------------------------
	[ Render ]
	The visible aspect of the effect.
-------------------------------------------------------------------*/
function EFFECT:Render()
	if self.Alpha < 1 then return end
	
	// Complicated alpha equation (it's not).
	local alpha = self.Alpha + ((self.Alpha/2) * math.sin(CurTime()*((255-self.Alpha)*0.08))) 
   
	// Laser beams:
	render.SetMaterial(self.LaserMat)
	
	// Colored (TEAM) beam
	render.DrawBeam(self.StartPos, 						// Startpos
					self.EndPos,						// Endpos
					self.Width,							// Width
					CurTime()*15 + (self.Length*0.01),	// Start tex coord
					CurTime()*15,						// End tex coord
					Color(self.Color.r, self.Color.g, self.Color.b, alpha)) // Color
	
	// White booster beam
	render.DrawBeam(self.StartPos, 						// Startpos
					self.EndPos,						// Endpos
					self.Width,							// Width
					CurTime()*15 + (self.Length*0.01),	// Start tex coord
					CurTime()*15,						// End tex coord
					Color(255,255,255, alpha/2))		// Color
	
	// End sprite.
	render.SetMaterial(self.EndSprMat)
	
	// Colored (TEAM) sprites
	render.DrawSprite(self.StartPos, self.Width*2, self.Width*2, Color(self.Color.r, self.Color.g, self.Color.b, self.Alpha))
	render.DrawSprite(self.EndPos, self.Width*2, self.Width*2, Color(self.Color.r, self.Color.g, self.Color.b, self.Alpha))
	
	// White booster sprites
	render.DrawSprite(self.StartPos, self.Width, self.Width, Color(255,255,255, self.Alpha))
	render.DrawSprite(self.EndPos, self.Width, self.Width, Color(255,255,255, self.Alpha))
end
