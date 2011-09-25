include('shared.lua')

SWEP.SwayScale			= 1.2							// The scale of the viewmodel sway
SWEP.BobScale			= 1.2							// The scale of the viewmodel bob

SWEP.RenderGroup 			= RENDERGROUP_OPAQUE

local curpos = Vector(0,0,0)
local curang = Angle(0,0,0)
local iron_lerp = 0

local mul = 1.6
local rising,anim_done = true,false

function SWEP:GetViewModelPosition(pos, ang)

	if (not self.IronSightsPos) then return pos, ang end
	
	local Offset	= self.IronSightsPos
	
	local Mul = 1

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 		self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 		self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), 	self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
	
	if self.Weapon:GetNWBool("attack_anim") then
		if iron_lerp >= 100 then rising = false
		elseif iron_lerp == 0 && rising != true then rising,anim_done = true,true end
		
		if rising then iron_lerp = math.Approach(iron_lerp,100,10)
		else  iron_lerp = math.Approach(iron_lerp,0,10) end
		
		if !anim_done then
		pos = LerpVector(iron_lerp / 100,pos,pos + self.AttackPos)
		ang = LerpVector(iron_lerp / 100,ang,ang + self.AttackAng) end
	else rising,anim_done = true,false end

	return pos, ang
end
