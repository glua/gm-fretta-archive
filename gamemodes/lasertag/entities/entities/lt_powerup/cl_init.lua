// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Powerup effects.

include("shared.lua")

local matBase = Material("LaserTag/HUD/powerup_base")

/*-------------------------------------------------------------------
	[ Initialize ]
	When the entity is initialized.
-------------------------------------------------------------------*/
function ENT:Initialize()
	self.Entity:SetCollisionBounds(Vector(-32,-32,-32), Vector(32,32,0))
	self.Entity:SetSolid(SOLID_NONE)
	self.m_fDot = 1
	self.m_iRot = 1
end

/*-------------------------------------------------------------------
	[ Think ]
	Think function.
-------------------------------------------------------------------*/
function ENT:Think()

end

/*-------------------------------------------------------------------
	[ Draw ]
	When the entity renders for a client.
-------------------------------------------------------------------*/
function ENT:Draw()
	if not GAMEMODE.Powerups then return print("GM.Powerups doesn't exist.") end
	//print(self:GetNWString("Powerup"))
	local pstr = self:GetNWString("Powerup") 
	local powerup = GAMEMODE.Powerups.Master[pstr]
	if not pstr or not powerup then return false end // No powerup.
	
	//DrawBox( pos, size, rot)
	//DrawBox( Pos, 31, CurTime())
	local pos = self:GetPos() + Vector(0,0,16)
	local w,h = 64,32
	local rot = self.m_iRot
	
	// All this code does is rotate the powerup effect at differnet rates depending on what direction it faces.
	// DotProduct gives a decimal value from 0 to 1 that represents how parallel one vector is to another.
	// I have no clue what this will do if you have a retardedly fast/slow framerate. Don't blame me if your powerups are spinning like all hell.
	if self.m_fDot > 0.98 or self.m_fDot < -0.98 then rot = rot + 0.003
	else rot = rot + 0.09 end
	self.m_iRot = rot
	
	// Do the rotation calculation.
	local fwd = Vector(math.sin(rot),math.cos(rot),0)
	local fwd2 = self:GetForward()
	self.m_fDot = fwd2:DotProduct(fwd)
	
	// Draw the base quad.
	render.SetMaterial(matBase)
	render.DrawQuadEasy(pos,fwd,w,h,powerup.Color,180)
	
	// Draw the icon quad.
	render.SetMaterial(powerup.Mat)
	render.DrawQuadEasy(pos,fwd,w,h,Color(255,255,255,150),180)
	
	// Calculate where to draw the label.
	local ang = fwd:Angle()
	ang:RotateAroundAxis(ang:Up(),90)
	ang:RotateAroundAxis(ang:Forward(),90)
	
	// Draw the labels.
	self:DrawText(pos + Vector(0,0,-16),ang,color_white,powerup.Name)
	ang:RotateAroundAxis(ang:Right(),180)
	self:DrawText(pos + Vector(0,0,-16),ang,color_white,powerup.Name)
	
	return false // We don't want anything else to render, e.g. the giant floating ERROR sign. It can look unprofessional. :colbert:
end

/*-------------------------------------------------------------------
	[ DrawText ]
	Draw the text label for the powerup.
-------------------------------------------------------------------*/
function ENT:DrawText(pos,ang,col,text)
	cam.Start3D2D(pos,ang,0.15)
		draw.DrawText(text,"FRETTA_HUGE_SHADOW",0,0,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
 
