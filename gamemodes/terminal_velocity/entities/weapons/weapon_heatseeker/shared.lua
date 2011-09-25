
AddCSLuaFile( "shared.lua" )

if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "python"
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false

	SWEP.PrintName = "Heatseeker Missiles"
	SWEP.IconLetter = "3"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "HL2MPTypeDeath"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	end
	
	killicon.AddFont( "sent_heatseeker", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "weapon_heatseeker", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_rocket_launcher.mdl"
SWEP.AnimPrefix		= "python"
SWEP.PlaySound      = true
SWEP.Rotation       = 0

SWEP.Primary.Sound          = Sound( "weapons/stinger_fire1.wav" )
SWEP.Primary.Load           = Sound( "buttons/blip2.wav" )
SWEP.Primary.Find    		= Sound( "npc/sniper/reload1.wav" ) 
SWEP.Primary.Reload         = Sound( "vehicles/tank_readyfire1.wav" )
SWEP.Primary.Deny           = Sound( "weapons/ar2/ar2_empty.wav" )
SWEP.Primary.LockWait       = 1.5
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 5.0

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

function SWEP:PrimaryAttack()

	local target = self.Weapon:GetNWEntity( "Target", nil )
	local time = self.Weapon:GetNWFloat( "Timer", 0 )

	if ValidEntity( target ) and time != 0 and time < CurTime() then
	
		self.Weapon:ShootRocket( target )
		self.ReloadTime = CurTime() + self.Primary.Delay - 1
	
	else
	
		self.Weapon:EmitSound( self.Primary.Deny, 100, 140 )
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.2 )
	
	end

end

function SWEP:Think()

	if CLIENT then
	
		local target = self.Weapon:GetNWEntity( "Target", nil )
		
		if ValidEntity( target ) and not target:GetPos():ToScreen().visible then
		
			RunConsoleCommand( "tv_removetarget" )
		
		end
		
		return
	
	end

	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 90000
	trace.filter = { self.Owner, self.Weapon }
	table.Add( trace.filter, self.Owner.parts )
	
	local tr = util.TraceLine( trace )
	
	local target = self.Weapon:GetNWEntity( "Target", nil )
	local time = self.Weapon:GetNWFloat( "Timer", 0 )
	
	if not ValidEntity( target ) or not target:Alive() then
		
		self.Weapon:SetNWFloat( "Timer", 0 )
		
	end
	
	if ( !ValidEntity( target ) or target != tr.Entity ) and tr.Entity:IsPlayer() and tr.Entity:Team() != self.Owner:Team() and not tr.Entity:IsHuman() then
	
		self.PlaySound = true
		self.Weapon:SetNWFloat( "Timer", CurTime() + self.Primary.LockWait )
		self.Weapon:SetNWEntity( "Target", tr.Entity )
		self.Owner:EmitSound( self.Primary.Find, 100, 120 )
	
	end

	if time != 0 and time < CurTime() and self.PlaySound then
	
		self.Owner:EmitSound( self.Primary.Load, 100, 120 )
		self.PlaySound = false
	
	end
	
	if self.ReloadTime and self.ReloadTime < CurTime() then
	
		self.Owner:EmitSound( self.Primary.Reload, 100, 140 )
		self.ReloadTime = nil
	
	end

end

function SWEP:SecondaryAttack()

end

function SWEP:ShootEffects()

end

function SWEP:ShootRocket( enemy )

	if SERVER then
	
		local ent = ents.Create( "sent_heatseeker" )
		ent:SetOwner( self.Owner )
		ent:SetPos( self.Owner:GetShootPos() + self.Owner:GetUp() * -8 )
		ent:SetAngles( self.Owner:GetAimVector():Angle() )
		ent:Spawn()
		ent:SetTarget( enemy )
	
	end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
	
end

function SWEP:DrawHUD()
	
	local w, h = ScrW(), ScrH()
	local wh, lh, sh, dh = w * 0.5, h * 0.5, 5, 40
	
	local time = self.Weapon:GetNWFloat( "Timer", 0 )
	local target = self.Weapon:GetNWEntity( "Target", nil )
	
	if time != 0 then 
	
		self.TimeLeft = self.Primary.LockWait - math.Clamp( time - CurTime(), 0.01, self.Primary.LockWait )
		
		dh = math.Clamp( ( self.TimeLeft / self.Primary.LockWait ) * 40, 10, 40 )
		local cos, sin = math.cos( CurTime() * dh ) * dh, math.sin( CurTime() * dh ) * dh
		
		surface.SetDrawColor( 255, 0, 0, 255 )
		
		surface.DrawLine( wh - sh, lh - sh, wh + sh, lh - sh ) 
		surface.DrawLine( wh - sh, lh + sh, wh + sh, lh + sh ) 
		surface.DrawLine( wh - sh, lh - sh, wh - sh, lh + sh ) 
		surface.DrawLine( wh + sh, lh - sh, wh + sh, lh + sh )
		
		if ValidEntity( target ) then
		
			local pos = target:GetPos()
			pos = pos:ToScreen()
			wh = pos.x
			lh = pos.y
		
		end
		
		surface.SetTexture( surface.GetTextureID( "terminal_velocity/aimer" ) )
		surface.DrawTexturedRectRotated( wh, lh, dh, dh, self.Rotation )
		
		self.Rotation = self.Rotation + dh / 10
		
		if self.Rotation > 359 then
			self.Rotation = 0
		end

	else
	
		surface.SetDrawColor( 255, 255, 255, 255 )
		
		surface.DrawLine( wh - sh, lh - sh, wh + sh, lh - sh ) 
		surface.DrawLine( wh - sh, lh + sh, wh + sh, lh + sh ) 
		surface.DrawLine( wh - sh, lh - sh, wh - sh, lh + sh ) 
		surface.DrawLine( wh + sh, lh - sh, wh + sh, lh + sh )
	
	end
	
end

function RemoveTarget( ply, cmd, args )

	local weapon = ply:GetActiveWeapon()
	
	if not ValidEntity( weapon ) then return end

	weapon:SetNWEntity( "Target", NULL )
	
end

concommand.Add( "tv_removetarget", RemoveTarget )

