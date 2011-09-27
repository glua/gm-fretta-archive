if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5

end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Tesla Cannon"
	SWEP.IconLetter = ","
	SWEP.Slot = 0
	SWEP.Slotpos = 6
	
	killicon.AddFont( "kh_tesla", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_tesla", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_beacon", "HL2MPTypeDeath", "!", Color( 255, 80, 0, 255 ) )

end

SWEP.Base = "kh_base"

SWEP.HoldType			= "smg"

SWEP.ViewModel	= "models/weapons/v_superphyscannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"

SWEP.Firemodes = { "Tesla Bolt", "Deploy Beacon" }

SWEP.SprintPos = Vector( -0.385, 0, 6.7291 )
SWEP.SprintAng = Vector( -9.5608, 0.5845, 0 )

SWEP.Primary.Sound			= Sound( "npc/scanner/scanner_electric2.wav" )
SWEP.Primary.Deny			= Sound( "player/suit_denydevice.wav" )
SWEP.Primary.Charge         = Sound( "npc/scanner/scanner_scan1.wav" )
SWEP.Primary.Charge2        = Sound( "npc/scanner/scanner_scan4.wav" )
SWEP.Primary.ModeChange		= Sound( "ambient/levels/citadel/pod_open1.wav" )
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 1.500

SWEP.Primary.ClipSize		= 100
SWEP.Primary.Automatic		= false

SWEP.Secondary.Sound        = Sound( "npc/waste_scanner/grenade_fire.wav" )
SWEP.Secondary.ModeChange	= Sound( "ambient/levels/citadel/pod_close1.wav" )
SWEP.Secondary.Damage		= 1
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.020
SWEP.Secondary.Delay        = 3.300

SWEP.Load = 0
SWEP.Charge = false

function SWEP:CanPrimaryAttack()

	if self.Owner:KeyDown( IN_SPEED ) or self.LastRunFrame > CurTime() then
		return false
	end
	
	return true
	
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self.Weapon:GetFiremode() == 1 then

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self.Weapon:ShootTesla()
		
	else

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
		self.Weapon:EmitSound( self.Secondary.Sound, 100, math.random(110,130) )
		self.Weapon:ShootBeacon()
	
	end
	
end

function SWEP:Think()	

	if self.Owner:KeyDown( IN_SPEED ) then
		self.LastRunFrame = CurTime() + 0.3
	end
	
	if self.Weapon:Clip1() >= 100 or CLIENT then return end
	
	if self.Load < CurTime() then
	
		for k,v in pairs( ents.FindByClass( "sent_beacon" ) ) do
		
			if v:GetPos():Distance( self.Owner:GetPos() ) < 200 then
		
				self.Load = CurTime() + 0.20
		
				self.Weapon:SetClip1( self.Weapon:Clip1() + 1 ) 
				if self.Weapon:Clip1() >= 100 then return end
				
			end
			
		end
		
		self.Charge = not self.Charge
		
		if self.Load < CurTime() then
		
			self.Load = CurTime() + 0.30
			self.Weapon:SetClip1( self.Weapon:Clip1() + 1 ) 
			
			if self.Charge then
				self.Owner:EmitSound( self.Primary.Charge )
			end
			
		else
		
			self.Owner:EmitSound( self.Primary.Charge2, 100, 120 )
		
		end
		
	end

end

function SWEP:ShootTesla()

	local power = self.Weapon:Clip1()
	local distance = 250
	
	if power >= 25 and power < 50 then
		distance = 500
	elseif power >= 50 and power < 75 then
		distance = 1000
	elseif power >= 75 and power < 100 then
		distance = 2000
	else
		distance = 5000
	end
	
	local tracedata = {}
	tracedata.start = self.Owner:GetShootPos()
	tracedata.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * distance )
	tracedata.filter = self.Owner
	local tr = util.TraceLine( tracedata )
	
	local closest = nil
	local dist = 9999
	local tbl = ents.FindByClass( "prop_phys*" )
	table.Add( tbl, ents.FindByClass( "sent_beacon" ) )
	table.Add( tbl, player.GetAll() )
	
	for k,v in pairs( tbl ) do
	
		local pd = v:GetPos():Distance( tr.HitPos )
		
		local tracedata = {}
		tracedata.start = self.Owner:GetShootPos()
		tracedata.endpos = v:GetPos() + Vector(0,0,10)
		tracedata.filter = self.Owner
		local tr = util.TraceLine( tracedata )
		
		if pd < dist and not tr.HitWorld and v != self.Owner then
		
			closest = v
			dist = pd
		
		end
		
	end
	
	if ValidEntity( closest ) then
	
		if SERVER then
	
			self.Owner:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
			self.Weapon:SetClip1( 1 )
			
			local tesla = ents.Create( "sent_tesla" )
			tesla:SetTarget( closest )
			tesla:SetScale( power / 100 )
			tesla:SetOwner(self.Owner)
			tesla:Spawn()
			
			closest:TakeDamage( ( power / 100 ) * 50 + ( closest:WaterLevel() * 25 ), self.Owner, tesla )
			
		end
	
		self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 	// View model animation
	
	else
	
		self.Owner:EmitSound( self.Primary.Deny, 100, 90 )
	
	end
	
end

function SWEP:ShootBeacon()

	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) 	// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
	if self.Weapon:Clip1() > 20 then
		self.Weapon:TakePrimaryAmmo( 20 )
	else
		self.Weapon:SetClip1( 1 )
	end
	
	if CLIENT then return end

	local beacon = ents.Create( "sent_beacon" )
	beacon:SetPos( self.Owner:GetShootPos() + self.Owner:GetAimVector() * 25 )
	beacon:SetAngles( self.Owner:GetAngles() )
	beacon:SetOwner( self.Owner )
	beacon:Spawn()
	
end

function SWEP:OnModeChange( mode )

end 