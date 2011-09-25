// -------------------------=== // LaserTag \\ ===------------------------- \\
// Created By: Fuzzylightning
// File: Powerup effects.

include("shared.lua")

/*-------------------------------------------------------------------
	[ Initialize ]
	When the entity is initialized.
-------------------------------------------------------------------*/
function ENT:Initialize()
	local owner = self:GetOwner()
	self.Color = color_white
	self.On = true
	
	if owner then
		self.Color = team.GetColor(owner:Team()) 
	end
end

/*-------------------------------------------------------------------
	[ Think ]
	We draw a dynamic light to make us look cool while flying and to make the explosion look good in dark spots.
-------------------------------------------------------------------*/
function ENT:Think()
	if not self.On then return end
	local dlight = DynamicLight(self.Entity:EntIndex())
	local size,dietime = 200,1
	
	if self:GetNWBool("Exploded") then
		size = 300
		dietime = 3
		self.On = false
	end
	
	if dlight then
		dlight.Pos = self.Entity:GetPos()
		dlight.r = self.Color.r
		dlight.g = self.Color.g
		dlight.b = self.Color.b
		dlight.Brightness = 3 //(stop and 3 or 1)
		dlight.Size = size
		dlight.Decay = size * 1
		dlight.DieTime = CurTime() + dietime
	end
end

/*-------------------------------------------------------------------
	[ Draw ]
	When the entity renders for a client.
function ENT:Draw()
	
end
-------------------------------------------------------------------*/
 
