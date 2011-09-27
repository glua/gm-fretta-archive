if (SERVER) then

	AddCSLuaFile( "shared.lua" )

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Glock 18"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "c"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "weapon_zo_glock18", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

SWEP.Base				= "zo_base"
	
SWEP.HoldType = "pistol"

SWEP.ViewModel	= "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.IronSightsPos = Vector (4.3618, 0.5381, 2.8266)
SWEP.IronSightsAng = Vector (0.4921, 0.0041, 0)
SWEP.IronsightsFOV = 65

SWEP.Primary.Sound			= Sound( "Weapon_Glock.Single" )
SWEP.Primary.Damage			= 22
SWEP.Primary.NumShots		= 1
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.090

SWEP.Primary.ClipSize		= 18
SWEP.Primary.Automatic		= false

SWEP.Primary.ShellType      = SHELL_9MM

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone )
	self.Weapon:TakePrimaryAmmo( 3 )
	
	if IsFirstTimePredicted() then
		self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
		if SERVER then
			local scale = 0.50
			if self.Owner:KeyDown(IN_DUCK) then
				scale = 0.25
			elseif self.Owner:KeyDown(IN_SPEED) then
				scale = 0.75
			end
			local pang, yang = math.Rand( -1 * scale, 0 ) * self.Primary.Recoil, math.Rand( -1 * ( scale / 3 ), ( scale / 3 ) ) * self.Primary.Recoil
			self.Owner:ViewPunch( Angle( pang, yang, 0) )
			self.Owner:AddCustomAmmo( self.Primary.AmmoType, -3 )
		end
	end
end