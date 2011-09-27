//By Rambo_6
//Ruined by Douglas Huck
if SERVER then

	AddCSLuaFile("shared.lua")
	resource.AddFile("materials/LazerTag/lasertex.vmt")
	resource.AddFile("materials/LazerTag/lasertex.vtf")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= true

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Crater Gun"
	SWEP.IconLetter = "t"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	SWEP.IconFont = "CSSelectIcons"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 50, 200, 50, 255 ), TEXT_ALIGN_CENTER )
	end
	
end

SWEP.ViewModel		= "models/weapons/v_smg1.mdl"
SWEP.WorldModel		= "models/weapons/w_smg1.mdl"
	
SWEP.HoldType = "smg"

SWEP.Primary.Sound			= Sound("weapons/ar1/ar1_dist1.wav")
SWEP.Primary.Burst          = Sound("Weapon_AR2.Single")
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.150

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Delay		=  3

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )
	
end

function SWEP:Deploy()

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetVar( "FireTime", -1 )
	
	return true
	
end  

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()
	
	return true
	
end

function SWEP:SecondaryAttack()
	if(GetGlobalBool( "InRealRound", false ))then
		if (SERVER) and ( self.Owner.points < 25 ) then return false end
		if (CLIENT) and ( self.Owner:GetNetworkedInt( "Points", 0 ) < 25 ) then return false end
		
		self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
		
		//local damage = math.random(8,12)
		
		/*if( self.Owner:Team() == TEAM_RED)then
			self.Weapon:ShootBullets( damage, self.Primary.NumShots, self.Primary.Cone, "red_tracer" )
		else
			self.Weapon:ShootBullets( damage, self.Primary.NumShots, self.Primary.Cone, "blue_tracer" )
		end*/
		if SERVER then
			local boxbomb = ents.Create("cw_bomb")
			
			local bombspawn = self.Owner:GetShootPos()
			bombspawn = bombspawn + self.Owner:GetForward() * 5
			bombspawn = bombspawn + self.Owner:GetRight() * 9
			bombspawn = bombspawn + self.Owner:GetUp() * -5
			boxbomb:SetPos( bombspawn )
			boxbomb:SetAngles( self.Owner:GetAngles() )
			
			boxbomb:SetOwner(self.Owner)
			boxbomb:SetPhysicsAttacker(self.Owner)
			boxbomb:Spawn()
			boxbomb:Activate()
			
			local phys = boxbomb:GetPhysicsObject()
			phys:SetVelocity(self.Owner:GetAimVector() * 1000)
			GAMEMODE:addpoints(self.Owner, -25)
			GAMEMODE:addStat(self.Owner, "nades", 1)
		end
	end
end

function SWEP:PrimaryAttack()
	if(GetGlobalBool( "InRealRound", false ))then
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
		self.Weapon:EmitSound( self.Primary.Burst, 100, math.random(90,110) )
		
		local damage = math.random(8,12)
		if( self.Owner:Team() == TEAM_RED)then
			self.Weapon:ShootBullets( damage, self.Primary.NumShots, self.Primary.Cone, "red_tracer" )
		else
			self.Weapon:ShootBullets( damage, self.Primary.NumShots, self.Primary.Cone, "blue_tracer" )
		end
	end
end

function SWEP:Think()	

end

function SWEP:ShootBullets( damage, numbullets, aimcone, tracer )

	local scale = aimcone
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = aimcone * 1.5
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( aimcone / 2, 0, 10 )
	end
	
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1	
	bullet.Force	= damage * 3							
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= tracer
	bullet.Callback = function ( attacker, tr, dmginfo )
	
	end
	
	self.Owner:FireBullets( bullet )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
end

if CLIENT then

	SWEP.CrossRed = CreateClientConVar( "crosshair_r", 255, true, false )
	SWEP.CrossGreen = CreateClientConVar( "crosshair_g", 255, true, false )
	SWEP.CrossBlue = CreateClientConVar( "crosshair_b", 255, true, false )
	SWEP.CrossAlpha = CreateClientConVar( "crosshair_a", 255, true, false )
	SWEP.CrossScale = CreateClientConVar( "crosshair_scale", 1, true, false )

end

SWEP.CrosshairScale = 1
function SWEP:DrawHUD()

	local x = ScrW() * 0.5
	local y = ScrH() * 0.5
	local scalebywidth = ( ScrW() / 1024 ) * 10
	
	local scale = self.Primary.Cone
	
	if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
		scale = scale * 1.2
	elseif self.Owner:KeyDown(IN_DUCK) or self.Owner:KeyDown(IN_WALK) then
		scale = math.Clamp( scale / 2, 0, 10 )
	end
	
	//scale = math.Clamp( ( 10 + ( scale * ( 260 * (ScrH()/720) ) ) ) * self.CrossScale:GetFloat(), 0, (ScrH()/2) - 100 )
	//self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 )
	
	// CAN'T GET THIS TO WORK NICELY
	
	scale = scale * scalebywidth * self.CrossScale:GetFloat()
	
	local dist = math.abs(self.CrosshairScale - scale)
	self.CrosshairScale = math.Approach(self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05)
	
	local gap = 40 * self.CrosshairScale
	local length = gap + 20 * self.CrosshairScale
	
	surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
	surface.DrawLine(x - length, y, x - gap, y)
	surface.DrawLine(x + length, y, x + gap, y)
	surface.DrawLine(x, y - length, x, y - gap)
	surface.DrawLine(x, y + length, x, y + gap)
	
	local color = team.GetColor(self.Owner:Team())
	local r = color.r
	local g = color.g
	local b = color.b
	draw.RoundedBoxEx( 6, 0, 68, 300, 24, Color(r, g, b, 100), false, true, false, true )
	draw.RoundedBoxEx( 6, 0, 102, 300, 24, Color(r, g, b, 100), false, true, false, true )
	struc = {}
	struc["pos"] = {4, 72}
	if(GetGlobalBool( "InRealRound", false ))then
		struc["color"] = Color(255, 255, 255, 200)
	else
		struc["color"] = Color(180, 180, 180, 200)
	end
	struc["text"] = "Left: Automatic Fire (FREE)"
	struc["font"] = "ChatFont"
	struc["xalign"] = TEXT_ALIGN_LEFT
	struc["yalign"] = TEXT_ALIGN_TOP
	draw.Text( struc )
	struc = {}
	struc["pos"] = {4, 106}
	if(GetGlobalBool( "InRealRound", false )) and (self.Owner:GetNetworkedInt( "Points", 0 ) >= 10)then
		struc["color"] = Color(255, 255, 255, 200)
	else
		struc["color"] = Color(180, 180, 180, 200)
	end
	struc["text"] = "Right: Fire Crate Grenade (-25 Box Point)"
	struc["font"] = "ChatFont"
	struc["xalign"] = TEXT_ALIGN_LEFT
	struc["yalign"] = TEXT_ALIGN_TOP
	draw.Text( struc )
end

