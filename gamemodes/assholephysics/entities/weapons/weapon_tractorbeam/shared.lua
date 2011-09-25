if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
	SWEP.HoldType = "ar2"
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false

	SWEP.PrintName = "Tractor Beam"
	SWEP.IconLetter = "2"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	SWEP.IconFont = "HL2MPTypeDeath"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
	killicon.AddFont( "weapon_tractorbeam", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.ViewModel		= "models/weapons/v_irifle.mdl"
SWEP.WorldModel		= "models/weapons/w_irifle.mdl"

SWEP.Primary.PowerUp        = Sound( "buttons.snd6" )
SWEP.Primary.PowerDown      = Sound( "apc_engine_stop" )
SWEP.Primary.PowerLoop    	= Sound( "apc_engine_start" )
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.100
SWEP.Primary.Delay			= 0.400

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1

SWEP.Attacking = false

function SWEP:Initialize()

	if SERVER then
		self:SetWeaponHoldType( self.HoldType )
	end
	
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
	
end  

function SWEP:Holster()

	self.Weapon:EndAttack( false )
	return true
	
end

function SWEP:OnRemove()

	self.Weapon:EndAttack( false )
	return true
	
end

function SWEP:Think()
	
	if self.Owner:KeyPressed( IN_ATTACK ) or self.Owner:KeyPressed( IN_ATTACK2 ) then
	
		self.Weapon:StartAttack()
		return
		
	elseif self.Owner:KeyDown( IN_ATTACK ) or self.Owner:KeyDown( IN_ATTACK2 ) then
	
		self.Weapon:UpdateAttack()
		return
		
	elseif self.Owner:KeyReleased( IN_ATTACK ) or self.Owner:KeyReleased( IN_ATTACK2 ) then
	
		self.Weapon:EndAttack( true )
		return
		
	end

end

function SWEP:StartAttack()
	
	if SERVER then
		
		if not self.Beam then
		
			self.Beam = ents.Create( "tractor_beam" )
			self.Beam:SetPos( self.Owner:GetShootPos() )
			self.Beam:Spawn()
			
		end
		
		self.Beam:SetParent( self.Owner )
		self.Beam:SetOwner( self.Owner )
	
	end

	self.Attacking = true
	
	self.Weapon:UpdateAttack()
	self.Weapon:EmitSound( self.Primary.PowerLoop )
	self.Weapon:EmitSound( self.Primary.PowerUp )

end

function SWEP:UpdateAttack()
	
	if not self.Attacking then 
	
		self.Weapon:EndAttack( false ) 
		return 
		
	end

	if self.Timer and self.Timer > CurTime() then return end
	
	self.Timer = CurTime() + 0.05
	
	local trace = {}
	trace.start = self.Owner:GetShootPos()
	trace.endpos = trace.start + self.Owner:GetAimVector() * 5000
	trace.filter = { self.Owner, self.Weapon }
		
	local tr = util.TraceLine( trace )
	
	if SERVER and ValidEntity( self.Beam ) then
		self.Beam:GetTable():SetEndPos( tr.HitPos )
	end
	
	if ValidEntity( tr.Entity ) and not tr.Entity:IsWorld() then
		
		if ( SERVER ) then
		
			if string.find( tr.Entity:GetClass(), "prop_" ) and tr.Entity:GetPos():Distance( self.Owner:GetPos() ) > 100 then

				local force = 8000
				
				if self.Owner:KeyDown( IN_ATTACK ) then
					force = force * -1.25
				end
				
				local phys = tr.Entity:GetPhysicsObject()
				
				if ValidEntity( phys ) then
				
					tr.Entity:SetPhysicsAttacker( self.Owner )
					phys:ApplyForceCenter( self.Owner:GetAimVector() * force )
					phys:EnableGravity( false )
					
				end
				
				timer.Simple( 0.5, function( phys ) if ValidEntity( phys ) then phys:EnableGravity( true ) end end, phys )
			
			elseif tr.Entity:IsPlayer() then
			
				local force = 300
				
				if self.Owner:KeyDown( IN_ATTACK ) then
					force = force * -1
				end
			
				tr.Entity:SetVelocity( self.Owner:GetAimVector() * force )
			
			end
		end
	end
end

function SWEP:EndAttack( shutdownsound )
	
	self.Weapon:StopSound( self.Primary.PowerLoop )
	
	if ( shutdownsound ) then
		self.Weapon:EmitSound( self.Primary.PowerDown )
	end
	
	self.Attacking = false
	
	if CLIENT then return end
	if not ValidEntity( self.Beam ) then return end
	
	self.Beam:Remove()
	self.Beam = nil
	
end

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()
	
	return true
	
end

function SWEP:PrimaryAttack()
	
end

function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()

	if self.Owner:KeyDown( IN_ATTACK ) or self.Owner:KeyDown( IN_ATTACK2 ) then return end

	local w, h = ScrW(), ScrH()
	local wh, lh, sh = w * 0.5, h * 0.5, 5
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.DrawLine( wh - sh, lh - sh, wh + sh, lh - sh ) 
	surface.DrawLine( wh - sh, lh + sh, wh + sh, lh + sh ) 
	surface.DrawLine( wh - sh, lh - sh, wh - sh, lh + sh ) 
	surface.DrawLine( wh + sh, lh - sh, wh + sh, lh + sh ) 
	
end

