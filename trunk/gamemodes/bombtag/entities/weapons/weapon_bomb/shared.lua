if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Time Bomb"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.HoldType = "slam"
SWEP.ViewModel		= "models/weapons/v_c4.mdl"
SWEP.WorldModel		= "models/weapons/w_c4.mdl"

SWEP.Primary.Sound			= Sound("buttons/blip2.wav")
SWEP.Primary.Deploy         = Sound("ambient/alarms/warningbell1.wav")
SWEP.Primary.Warning        = Sound("ambient/alarms/klaxon1.wav")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NextTick = 0
SWEP.EndingTime = nil

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )
	
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:EmitSound( self.Primary.Deploy )
	
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.75 )
	
	return true
	
end  

function SWEP:Think()	

	if CLIENT and not self.EndingTime then
	
		self.EndingTime = CurTime() + math.Clamp( self.Owner:GetNWInt( "Time", 0 ) - 1, 0, 60 )
		self.TimeLength = math.Clamp( self.Owner:GetNWInt( "Time", 0 ) - 1, 0, 60 )
		
	end
	
	if self.NextTick < CurTime() then
	
		self.NextTick = CurTime() + 1
		
		if CLIENT then return end
		
		self.Owner:AddTime( -1 )
		
		if self.Owner:GetNWInt( "Time", 1 ) <= 5 and self.Owner:GetNWInt( "Time", 1 ) > 0 then
			self.Owner:EmitSound( self.Primary.Warning, 100, 150 - 50 * self.Owner:GetNWInt( "Time", 1 ) / 5 )
		else
			self.Owner:EmitSound( self.Primary.Sound, 100, 120 )
		end
	end
end

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()
	
	return true
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:Trace()
	
end

function SWEP:Trace()
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 70
	
	local tr = {}
	tr.start = pos
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mins = Vector(-16,-16,-16)
	tr.maxs = Vector(16,16,16)

	local trace = util.TraceHull( tr )
	local ent = trace.Entity

	if not ValidEntity( ent ) or not ent:IsPlayer() then 
		
		return 
		
	else
	
		if ent:Team() == TEAM_DEAD then return end
		
		ent:SetCarrier( true )
		ent:SetTime( self.Owner:GetTime() )
		ent:StripWeapons()
		ent:Give( "weapon_bomb" )
	
		self.Owner:SetCarrier( false )
		self.Owner:Give( "weapon_manspuncher" )
		self.Owner:StripWeapon( "weapon_bomb" )
		
	end
	
end

function SWEP:SecondaryAttack()

	self.Weapon:PrimaryAttack()

end

if CLIENT then

	SWEP.MatBomb = surface.GetTextureID( "bombtag/bomb" )
	SWEP.MatClock = surface.GetTextureID( "bombtag/clock" )
	SWEP.MatHand = surface.GetTextureID( "bombtag/hand" )
	SWEP.MatFire = { "effects/muzzleflash1", "effects/muzzleflash2", "effects/muzzleflash3", "effects/muzzleflash4" }
	
	SWEP.WickHeight = ScrH() - ( ScrH() * 0.2 ) - 170
	SWEP.HandAng = 0

end

function SWEP:DrawHUD()

	if not self.EndingTime or not self.TimeLength then return end

	local scale = math.Clamp( ( ( self.EndingTime - CurTime() ) / self.TimeLength ), 0, 1 )

	surface.SetDrawColor( 25, 25, 25, 255 )
	
	surface.DrawRect( ScrW() - 90, ScrH() * 0.2 + ( 1 - scale ) * self.WickHeight, 4, self.WickHeight * scale )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.SetTexture( surface.GetTextureID( table.Random( self.MatFire ) ) )
	surface.DrawTexturedRectRotated( ScrW() - 90, ScrH() * 0.2 + ( 1 - scale ) * self.WickHeight, 40, 40, math.random(-360,360) )
	
	surface.SetTexture( self.MatBomb )
	surface.DrawTexturedRect( ScrW() - 170, ScrH() - 170, 160, 160 )
	
	surface.SetTexture( self.MatClock )
	surface.DrawTexturedRect( ScrW() - 140, ScrH() - 110, 100, 100 )
	
	self.HandAng = self.HandAng + ( FrameTime() * 10 ) + ( ( 1 - scale ) * FrameTime() * 1000 )
	
	if self.HandAng >= 360 then
		self.HandAng = -360
	end
	
	surface.SetTexture( self.MatHand )
	surface.DrawTexturedRectRotated( ScrW() - 90, ScrH() - 50, 70, 70, self.HandAng )
	
end

