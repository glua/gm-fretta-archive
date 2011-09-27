if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Railgun"
	SWEP.IconLetter = "o"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "sniper_railgun", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "sniper_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel	= "models/weapons/v_snip_sg550.mdl"
SWEP.WorldModel = "models/weapons/w_snip_sg550.mdl"

SWEP.SprintPos = Vector(0, -2.336, 0)
SWEP.SprintAng = Vector(3.321, -23.9052, 0.2161)

SWEP.ScopePos = Vector(5.5229, -4.1958, 1.4141)
SWEP.ScopeAng = Vector(0.3601, 1.3746, 0)

SWEP.ZoomModes = { 0, 40, 20 }
SWEP.ZoomSpeeds = { 0.25, 0.40, 0.40 }

SWEP.Primary.Sound			= Sound("weapons/gauss/fire1.wav")
SWEP.Primary.Zing           = Sound("weapons/fx/nearmiss/bulletLtoR12.wav")
SWEP.Primary.Recoil			= 4.6
SWEP.Primary.Damage			= 90
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.0015
SWEP.Primary.Delay			= 1.250

SWEP.Primary.ClipSize		= 3
SWEP.Primary.Automatic		= false

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(110,120) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 1, "rail_tracer" )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if SERVER then
		self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
	end

end

function SWEP:ShootBullets( damage, numbullets, aimcone, numtracer, tracername )

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
	bullet.Callback = function( a, b, c ) self:BulletPenetrate( a, b, c, 0 ) end
	
	self.Owner:FireBullets( bullet )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:MuzzleFlash()								// Crappy muzzle light
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	
end

SWEP.PenetrationDist = 64
function SWEP:BulletPenetrate( attacker, tr, dmginfo, passes )
	
	// do not pass through more than 3 walls
	if passes >= 3 then return end
	
	// Hit the sky, don't go any further
	if tr.HitSky then return end
	
	// Direction (and length) that we are gonna penetrate
	local pdir = tr.Normal * self.PenetrationDist
		
	local ptrace = {}
	ptrace.start = tr.HitPos + tr.Normal
    ptrace.endpos = ptrace.start + pdir
    ptrace.mask = MASK_SOLID + CONTENTS_HITBOX
	   
	// Quick check. This fixes a bug with going through the world into the void
	if ( util.PointContents( ptrace.endpos ) != 0 ) then return false end
		
	local ptrace = util.TraceLine( ptrace ) 
	
	// This shouldn't really ever happen.
	if (!ptrace.StartSolid) then return false end
		
	// Bullet didn't penetrate.
	if ( ptrace.FractionLeftSolid == 1 || ptrace.FractionLeftSolid == 0 ) then return false end

	// Work out the exit point.
	local exit = ptrace.StartPos + ( pdir * ( ptrace.FractionLeftSolid / 2 ) )
		
	// Fire bullet from the exit point using the original tradjectory
	local bullet = 
	{	
		Num 		= 1,
		Src 		= exit,
		Dir 		= attacker:GetAimVector(),	
		Spread 		= Vector( 0, 0, 0 ),
		Tracer		= 1,
		TracerName 	= "rail_rico_tracer",
		Force		= 500,
		Damage		= 80,
		AmmoType 	= "Pistol",
		HullSize	= 2
	}
	
	bullet.Callback    = function( a, b, c ) 
		if self.BulletPenetrate then
			return self:BulletPenetrate( a, b, c, passes + 1 ) 
		end
	end
	
	
	util.Decal( "Impact.Concrete", exit, exit )

	
	WorldSound( self.Primary.Zing, exit, 100, math.random(90,110) )
	
	timer.Simple( 0.05, attacker.FireBullets, attacker, bullet, true )

	return true

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
		
		local wh, lh, sh = w*.5, h*.5, 4
		surface.SetDrawColor( CrossRed:GetInt(), CrossGreen:GetInt(), CrossBlue:GetInt(), CrossAlpha:GetInt() )
		surface.DrawLine(wh - sh, lh - sh, wh + sh, lh - sh) //top line
		surface.DrawLine(wh - sh, lh + sh, wh + sh, lh + sh) //bottom line
		surface.DrawLine(wh - sh, lh - sh, wh - sh, lh + sh) //left line
		surface.DrawLine(wh + sh, lh - sh, wh + sh, lh + sh) //right line
		
		local tr = util.TraceLine( util.GetPlayerTrace(self.Owner) )
		local dist = math.Clamp( math.ceil( tr.HitPos:Distance(self.Owner:GetPos()) / 16 ), 2, 999999 )
		local target = "N/A"
		
		if tr.Entity:IsValid() and tr.Entity:IsPlayer() then
			self.TargetEnt = tr.Entity
			self.TargetTime = CurTime() + 2
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
		
		if self.TargetEnt and self.TargetEnt:IsValid() and self.TargetEnt:Alive() and self.TargetTime > CurTime() then
		
			local obbmin = ( self.TargetEnt:GetPos() + ( self.Owner:GetRight() * -25 ) ):ToScreen()
			local obbmax = ( self.TargetEnt:GetPos() + ( self.Owner:GetRight() * 21 ) + ( self.TargetEnt:GetUp() * 72) ):ToScreen()
			local col = team.GetColor( self.TargetEnt:Team() )
			
			surface.SetDrawColor( col.r, col.g, col.b, 255 )
			surface.DrawLine( obbmin.x, obbmax.y, obbmax.x, obbmax.y )
			surface.DrawLine( obbmin.x, obbmin.y, obbmin.x, obbmax.y )
			surface.DrawLine( obbmax.x, obbmax.y, obbmax.x, obbmin.y )
			surface.DrawLine( obbmin.x, obbmin.y, obbmax.x, obbmin.y )
		
		else
			
			self.Target = nil
			
		end
		
	end
	
end


