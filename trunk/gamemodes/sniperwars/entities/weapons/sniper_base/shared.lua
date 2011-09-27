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
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "BASE SNIPER"
	SWEP.IconLetter = "c"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
	surface.CreateFont( "Tahoma", 12, 500, true, false, "SniperHudText" )
	
end

SWEP.HoldType = "ar2"

SWEP.ViewModel	= "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.SprintPos = Vector(0,0,0)
SWEP.SprintAng = Vector(0,0,0)

SWEP.ScopePos = Vector(0,0,0)
SWEP.ScopeAng = Vector(0,0,0)

SWEP.ZoomModes = { 0, 50, 10 }
SWEP.ZoomSpeeds = { 5, 5, 5 }

SWEP.Primary.Sound			= Sound("Weapon_USP.Single")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= 99999
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.Sound        = Sound( "weapons/g3sg1/g3sg1_slide.wav" )
SWEP.Secondary.Delay  		= 0.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.LastRunFrame = 0

function SWEP:SetViewModelPosition( vec, ang, movetime ) // this is used for anything but sprinting positions
	
	self.Weapon:SetNWVector("ViewVector",vec)
	self.Weapon:SetNWVector("ViewAngle",ang)
	self.Weapon:SetNWInt("ViewDuration",movetime) 
	self.Weapon:SetNWInt("ViewTime",CurTime())

end

function SWEP:GetViewModelPosition( pos, ang )

	local newpos = self.Weapon:GetNWVector("ViewVector",nil)
	local newang = self.Weapon:GetNWVector("ViewAngle",nil)
	local movetime = self.Weapon:GetNWInt("ViewDuration",0.25) // time to reach position defaults to 0.25
	local duration = self.Weapon:GetNWInt("ViewTime",0) // the curtime when started
		
	if ( !newpos || !newang ) then
		newpos = pos
		newang = ang
	end
	
	local mul = 0
	
	if self.Owner:KeyDown( IN_SPEED ) then
	
		self.SwayScale 	= 1.25
		self.BobScale 	= 1.25
		
		if (!self.SprintStart) then
			self.SprintStart = CurTime()
		end
		
		mul = math.Clamp( (CurTime() - self.SprintStart) / movetime, 0, 1 )
		
		newang = self.SprintAng
		newpos = self.SprintPos
		
	else 
	
		self.SwayScale 	= 1.0
		self.BobScale 	= 1.0
		
		if ( self.SprintStart ) then
			self.SprintEnd = CurTime()
			self.SprintStart = nil
		end
	
		if ( self.SprintEnd ) then
		
			mul = 1 - math.Clamp( (CurTime() - self.SprintEnd) / movetime, 0, 1 )
			
			newang = self.SprintAng
			newpos = self.SprintPos
			
			if ( mul == 0 ) then
				self.SprintEnd = nil 
			end
			
		else
		
			mul = self:IdleViewModelPos( movetime, duration, mul )
			
		end
	end

	return self:MoveViewModelTo( newpos, newang, pos, ang, mul )
	
end

function SWEP:IdleViewModelPos( movetime, duration, mul )

	mul = 1
		
	if ( CurTime() - movetime < duration ) then
		mul = math.Clamp( (CurTime() - duration) / movetime, 0, 1 )
	end
	
	if self.Weapon:GetNWBool("ReverseAnim",false) then
		return 1 - mul
	end
	
	return mul

end

function SWEP:AngApproach( newang, ang, mul )

	ang:RotateAroundAxis( ang:Right(), 		newang.x * mul )
	ang:RotateAroundAxis( ang:Up(), 		newang.y * mul )
	ang:RotateAroundAxis( ang:Forward(), 	newang.z * mul )
	
	return ang

end

function SWEP:PosApproach( newpos, pos, ang, mul ) 

	local right 	= ang:Right()
	local up 		= ang:Up()
	local forward 	= ang:Forward()

	pos = pos + newpos.x * right * mul
	pos = pos + newpos.y * forward * mul
	pos = pos + newpos.z * up * mul
	
	return pos

end

function SWEP:MoveViewModelTo( newpos, newang, pos, ang, mul )

	ang = self:AngApproach( newang, ang, mul )
	pos = self:PosApproach( newpos, pos, ang, mul )

	return pos, ang

end

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )
	
end

function SWEP:Deploy()

	if SERVER then
		self.Weapon:SetViewModelPosition()
		self.Weapon:SetZoomMode(1)
		self.Owner:DrawViewModel( true )
	end	

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
end  

function SWEP:Think()	

	if self.Owner:KeyDown(IN_SPEED) then
		self.LastRunFrame = CurTime() + 0.3
		if self.Weapon:GetZoomMode() != 1 and SERVER then
			self.Weapon:SetZoomMode(1)
			self.Weapon:SetNWBool("ReverseAnim",true)
			self.Weapon:SetViewModelPosition(self.ScopePos,self.ScopeAng,0.3)
			self.Owner:DrawViewModel( true )
		end
	end
	
	if self.MoveTime and self.MoveTime < CurTime() and SERVER then
		self.MoveTime = nil
		self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
		self.Owner:DrawViewModel( false )
	end

end

function SWEP:Reload()

	if self.Weapon:Clip1() == self.Primary.ClipSize then return end

	if self.Weapon:GetZoomMode() != 1 and SERVER then
		self.Weapon:SetZoomMode(1)
		self.Weapon:SetNWBool("ReverseAnim",true)
		self.Weapon:SetViewModelPosition(self.ScopePos,self.ScopeAng,0.3)
		self.Owner:DrawViewModel( true )
	end	

	self.Weapon:DefaultReload( ACT_VM_RELOAD )
	
end

function SWEP:CanSecondaryAttack()

	if self.Owner:KeyDown(IN_SPEED) or self.LastRunFrame > CurTime() then return false end

	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_LEFT) or self.Owner:KeyDown(IN_RIGHT) or self.Weapon:Clip1() <= 0 then
	
		if self.Weapon:GetZoomMode() != 1 and SERVER then
			self.Weapon:SetZoomMode(1)
			self.Weapon:SetNWBool("ReverseAnim",true)
			self.Weapon:SetViewModelPosition(self.ScopePos,self.ScopeAng,0.3)
			self.Owner:DrawViewModel( true )
		end
	
		return false
		
	end
	
	return true
	
end

function SWEP:CanPrimaryAttack()

	if self.Owner:KeyDown(IN_SPEED) or self.LastRunFrame > CurTime() then return false end

	if self.Weapon:Clip1() <= 0 then
	
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		
		if self.Weapon:GetZoomMode() != 1 and SERVER then
			self.Weapon:SetZoomMode(1)
			self.Weapon:SetNWBool("ReverseAnim",true)
			self.Weapon:SetViewModelPosition(self.ScopePos,self.ScopeAng,0.3)
			self.Owner:DrawViewModel( true )
		end	
		
		return false
		
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 1, "line_tracer" )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if SERVER then
		self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
	end

end

function SWEP:SecondaryAttack()

	if not self.Weapon:CanSecondaryAttack() then return end

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )

	if SERVER then
		
		if self.Weapon:GetZoomMode() == 1 then
			self.Weapon:SetNWBool("ReverseAnim",false)
			self.Weapon:SetViewModelPosition(self.ScopePos, self.ScopeAng, 0.3)
			self.MoveTime = CurTime() + 0.35
		else
			self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
			
		end
	
	end
	
	self.Weapon:EmitSound( self.Secondary.Sound )
	
end

function SWEP:AdjustMouseSensitivity()

	local num = self.Weapon:GetNWInt("Mode",1)
	local scale = self.ZoomModes[num] / 100
	
	if scale == 0 then
		return nil
	end

	return scale
	
end

function SWEP:SetZoomMode( num )

	if num > #self.ZoomModes then
		num = 1
		self.Weapon:SetNWBool("ReverseAnim",true)
		self.Weapon:SetViewModelPosition(self.ScopePos,self.ScopeAng,0.3)
		self.Owner:DrawViewModel( true )
	end
	
	self.Weapon:SetNWInt("Mode",num)
	self.Owner:SetFOV(self.ZoomModes[num],self.ZoomSpeeds[num])

end

function SWEP:GetZoomMode()
	return self.Weapon:GetNWInt("Mode",1)
end

function SWEP:ShootBullets( damage, numbullets, aimcone, numtracer, tracername, nosound )

	local scale = aimcone
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = aimcone * 2.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( aimcone / 2.5, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= numtracer	
	bullet.Force	= math.Round(damage * 2)							
	bullet.Damage	= math.Round(damage)
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= tracername
	bullet.Callback = function ( attacker, tr, dmginfo )
		if tr.HitWorld and SERVER and !nosound then
			WorldSound( Sound(table.Random(GAMEMODE.Ricochet)), tr.HitPos, 100, math.random(90,110) )
		end
	end
	
	self.Owner:FireBullets( bullet )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
end

function SWEP:DrawHUD()

	local vm = self.Owner:GetViewModel()
	if vm:IsValid() then
		vm:SetMaterial( "" )
	end
	
	local mode = self.Weapon:GetNWInt( "Mode", 1 )
	
	if mode != 1 then
	
		local w = ScrW()
		local h = ScrH()
		local wr = ( h / 3 ) * 4

		surface.SetTexture( surface.GetTextureID( "gmod/scope" ) )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawTexturedRect( ( w / 2 ) - wr / 2, 0, wr, h )
		
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, ( w / 2 ) - wr / 2, h )
		surface.DrawRect( ( w / 2 ) + wr / 2, 0, w - ( ( w / 2 ) + wr / 2 ), h )
		surface.DrawLine( 0, h * 0.50, w, h * 0.50 )
		surface.DrawLine( w * 0.50, 0, w * 0.50, h )
		
		local tr = util.TraceLine( util.GetPlayerTrace(self.Owner) )
		local dist = math.Clamp( math.ceil( tr.HitPos:Distance(self.Owner:GetPos()) / 16 ), 2, 999999 )
		local target = "N/A"
		
		if tr.Entity:IsValid() and tr.Entity:IsPlayer() then
			if tr.Entity:Team() == self.Owner:Team() then
				target = "Friendly"
			else
				target = "Enemy"
			end
		end
		
		surface.SetFont( "SniperHudText" )
		surface.SetTextColor( 255, 255, 255, 255 )
		
		surface.SetTextPos( w * 0.90, h * 0.50 )
		surface.DrawText( "Distance: "..dist.." feet" )
		
		surface.SetTextPos( w * 0.90, h * 0.52 )
		surface.DrawText( "Target: "..target )
		
	end
	
end

