if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= false
	
	SWEP.PrintName = "Time Bomb"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	end
	
end

SWEP.WorldModel		= ""

SWEP.Primary.Sound			= Sound("ambient/alarms/klaxon1.wav")

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

function SWEP:Initialize()

end

function SWEP:Deploy()

	if SERVER then
		self.Owner:DrawWorldModel( false )
	end

	return true
	
end  

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()
	
	return true
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 10 )
	
	self.Ticks = 0
	self.TickTime = CurTime() + 1
	
	self.Weapon:EmitSound( self.Primary.Sound, 100, 150 )	
	
end

function SWEP:Think()	

	if self.TickTime and self.TickTime < CurTime() then
	
		self.TickTime = CurTime() + 1
		self.Ticks = self.Ticks + 1
	
		if self.Ticks >= 3 and SERVER then
			
			self.TickTime = CurTime() + 1
			
			local ed = EffectData()
			ed:SetOrigin( self.Owner:GetPos() )
			util.Effect( "Explosion", ed, true, true )
			
			util.BlastDamage( self.Owner, self.Owner, self.Owner:GetPos(), 300, 90 )
			
			if self.Owner:Alive() then
				self.Owner:Kill()
			end
			
		elseif self.Ticks < 3 then
		
			self.Weapon:EmitSound( self.Primary.Sound, 100, 150 + self.Ticks * 20 )
			
		end
	
	end

end

function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()
	
end

