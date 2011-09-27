
if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5

end

if ( CLIENT ) then

	SWEP.ViewModelFOV		= 60
	
	SWEP.PrintName = "Radiation Cannon"
	SWEP.IconLetter = "3"
	SWEP.Slot = 0
	SWEP.Slotpos = 4
	
	killicon.AddFont( "kh_radcannon", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_nuke", "HL2MPTypeDeath", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "kh_base"

SWEP.HoldType			= "rpg"

SWEP.ViewModel			= "models/weapons/v_rpg.mdl"
SWEP.WorldModel			= "models/weapons/w_rocket_launcher.mdl"

SWEP.Firemodes = { "Radiation Beam", "Nuclear Suicide" }

SWEP.SprintPos = Vector( -4.5845, -3.4396, -5.7527 )
SWEP.SprintAng = Vector( 12.3577, -5.0839, -2.6961 )
SWEP.NukePos = Vector( -6.87, -7.8159, 14.6546 )
SWEP.NukeAng = Vector( -35.1759, -4.2797, -4.4184 )

SWEP.Primary.Sound			= Sound( "weapons/stunstick/alyx_stunner1.wav" )
SWEP.Primary.Reload         = Sound( "vehicles/tank_readyfire1.wav" )
SWEP.Primary.Deploy         = Sound( "vehicles/tank_turret_start1.wav" )
SWEP.Primary.ModeChange		= Sound( "npc/turret_floor/retract.wav" )
SWEP.Primary.Damage			= 10
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 1.800

SWEP.Primary.ClipSize		= 100
SWEP.Primary.Automatic		= false

SWEP.Secondary.Sound		= Sound( "npc/scanner/scanner_siren1.wav" )
SWEP.Secondary.ModeChange	= Sound( "npc/turret_floor/deploy.wav" )
SWEP.Secondary.Damage		= 150
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.Cone			= 0.040
SWEP.Secondary.Delay        = 2.750

SWEP.Load = 0
SWEP.AnimTime = 0
SWEP.LaunchTime = nil

function SWEP:Deploy()

	self.Weapon:EmitSound( self.Primary.Deploy )

	if SERVER then
		self.Weapon:SetViewModelPosition()
	end	

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	return true
	
end  

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	if self.Weapon:GetFiremode() == 1 then

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(80,100) )
		self.Weapon:ShootRay( self.Weapon:Clip1(), self.Primary.NumShots, self.Primary.Cone )
		self.Weapon:TakePrimaryAmmo( self.Weapon:Clip1() )
		
		self.AnimTime = CurTime() + 0.2
		
	else

		self.Weapon:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )

		self.Weapon:EmitSound( self.Secondary.Sound, 100, math.random(95,105) )
		
		if SERVER then
		
			self.Weapon:SetViewModelPosition( self.NukePos, self.NukeAng, 0.5 )
			self.LaunchTime = CurTime() + 0.6
			
		end
	end
end

function SWEP:ShootRay( damage, numbullets, aimcone )

	self.ReloadPlay = false

	local scale = aimcone
	if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		scale = aimcone * 1.5
	elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		scale = math.Clamp( aimcone / 2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= damage * 2							
	bullet.Damage	= damage / 2
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "rad_tracer"
	bullet.Callback = function ( attacker, tr, dmginfo )
		if tr.HitWorld then
		
			util.Decal( "FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
			
			if CLIENT or not ValidEntity( self.Owner ) then return end
			
			local rad = ents.Create( "sent_radiation" )
			rad:SetPos( tr.HitPos )
			rad:SetOwner( self.Owner )
			rad:SetPlayer()
			rad:SetDamage( damage / 2 )
			rad:Spawn()
			
		else
		
			if CLIENT or not ValidEntity( self.Owner ) then return end
			
			for k,v in pairs( ents.FindByClass( "sent_radiation" ) ) do
				if v:GetPos():Distance( tr.HitPos ) < 100 then
					v:Remove()
				end
			end
			
			local rad = ents.Create( "sent_radiation" )
			rad:SetPos( tr.HitPos )
			rad:SetOwner( self.Owner )
			rad:SetPlayer( tr.Entity )
			rad:SetDamage( damage / 2 )
			rad:Spawn()
			
		end
	end
	
	self.Owner:FireBullets( bullet )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
end

function SWEP:FireBomb()
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	local nuke = ents.Create( "sent_nuke" )
	nuke:SetPos( self.Owner:GetPos() + Vector(0,0,25) )
	nuke:SetAngles( Angle(180,0,0) )
	nuke:SetOwner( self.Owner )
	nuke:Spawn()
	
end

function SWEP:Think()	

	if self.Owner:KeyDown( IN_SPEED ) then
		self.LastRunFrame = CurTime() + 0.3
	end
	
	if self.LaunchTime and self.LaunchTime < CurTime() then
	
		self:FireBomb()
		self.Weapon:EmitSound( self.Secondary.Sound, 100, math.random(95,105) )
		self.LaunchTime = nil
	
	end
	
	if self.Weapon:Clip1() >= 100 then return end
	
	if self.Load < CurTime() then
		self.Weapon:SetClip1( self.Weapon:Clip1() + 5 ) 
		self.Load = CurTime() + 0.5
	end
	
	if !self.AnimTime then return end
	
	if self.AnimTime < CurTime() and not self.LaunchTime then
		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:EmitSound( self.Primary.Reload )
		self.AnimTime = nil
	end

end

function SWEP:OnModeChange( mode )

end

function SWEP:Reload()

end
