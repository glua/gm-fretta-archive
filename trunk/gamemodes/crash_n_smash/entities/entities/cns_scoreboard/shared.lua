AddCSLuaFile("shared.lua")

ENT.Type 			= "anim"
ENT.PrintName		= ""
ENT.Author			= "Clavus"
ENT.Purpose			= ""

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Team = nil

function ENT:Initialize()

	self.Entity:DrawShadow( false )
	
end

if CLIENT then
	function ENT:Draw()
		self.Team = self.Team or GAMEMODE:TeamSide(self.Entity:GetPos())
		local score = 0
		local text = "< PENDING >"
		local color = Color(255,255,255,255)
		if self.Team == TEAM_RED or self.Team == TEAM_BLUE then
			score = teaminfo[self.Team].TotalPropValue
			color = team.GetColor(self.Team)
			text = "Score:"
		end
	
		local angle = self.Entity:GetAngles()
		angle:RotateAroundAxis(angle:Right(), 	-90)
		angle:RotateAroundAxis(angle:Up(), 		90)
		angle:RotateAroundAxis(angle:Forward(), 0)
	
		cam.Start3D2D(self.Entity:GetPos(), angle, 1)
			draw.SimpleText(text, "ScoreBig", 0, -30, color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
			draw.SimpleText(tostring(score), "ScoreHuge", 0, 8, color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		cam.End3D2D() 
	end
end
