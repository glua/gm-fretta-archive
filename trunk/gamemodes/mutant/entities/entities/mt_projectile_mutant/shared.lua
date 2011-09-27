AddCSLuaFile("shared.lua")

ENT.Type = "anim"
ENT.Base = "mt_projectile"

if SERVER then
	ENT.Damage = 30
end

ENT.ParticleSuffix = "m"

if CLIENT then
	function ENT:SpriteColor()
		return Color(math.random(120,170),255,math.random(30,70),255)
	end
end
