if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.Weight				= 1
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	
end

if CLIENT then

	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
	SWEP.CSMuzzleFlashes	= false

	SWEP.ViewModelFOV		= 55
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Baton"
	SWEP.IconLetter = "!"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	
	SWEP.IconFont = "HL2MPTypeDeath"
	
	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( self.IconLetter, self.IconFont, x + wide/2, y + tall/2.5, Color( 15, 20, 200, 255 ), TEXT_ALIGN_CENTER )
	end
	
	killicon.AddFont( "gta_billyclub", SWEP.IconFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.HoldType = "melee"

SWEP.ViewModel  = "models/weapons/v_stunstick.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.Primary.Sound			= Sound("weapons/stunstick/stunstick_swing1.wav")
SWEP.Primary.Hit            = Sound("weapons/stunstick/stunstick_impact1.wav")
SWEP.Primary.HitWorld       = Sound("weapons/stunstick/stunstick_fleshhit1.wav")
SWEP.Primary.Deploy         = Sound("weapons/stunstick/spark1.wav")
SWEP.Primary.Damage			= 100
SWEP.Primary.HitForce       = 5
SWEP.Primary.Delay			= 0.750
SWEP.Primary.Automatic		= false

SWEP.Primary.ClipSize       = 1
SWEP.Primary.DefaultClip    = 1

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	if SERVER then
		self:SetWeaponHoldType( self.HoldType )
	end
	
end

function SWEP:Deploy()

	self.Weapon:EmitSound( self.Primary.Deploy )
	self.Weapon:SendWeaponAnim( ACT_VM_DEPLOY )

	return true
	
end  

function SWEP:Think()	

end

function SWEP:Reload()
	
end

function SWEP:CanPrimaryAttack()

	return true
	
end

function SWEP:PrimaryAttack()

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:MeleeTrace( self.Primary.Damage )
	
end

function SWEP:MeleeTrace( dmg )
	
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 40
	local ent = self.Owner:TraceHullAttack( pos, pos + aim, Vector(-16,-16,-16), Vector(16,16,16), dmg, DMG_CLUB, self.Primary.HitForce, false )

	if not ValidEntity( ent ) then 
		
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		
		return 
		
	else
	
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		
		if ( !ent:IsPlayer() and not string.find( ent:GetClass(), "npc" ) ) then 
		
			ent:EmitSound( self.Primary.HitWorld )
			return 
			
		end
		
	end
	
	ent:EmitSound( self.Primary.Hit )
	
	if ent:IsPlayer() and ent:Team() == TEAM_GANG then
	
		ent:SetCash( 0 )
		ent:Notice( table.Random( GAMEMODE.ArrestNotices ), 5, 255, 0, 0 )
		
		self.Owner:Notice( table.Random( GAMEMODE.CopNotices ), 5, 0, 255, 0 )
		self.Owner:AddFrags( 1 )
	
	end

end

function SWEP:GetViewModelPosition( pos, ang )

	local Offset = Vector( -2.5252, -2.602, -6.0112 )
	local Ang = Vector( 0, 0, -12.2141 )
	
	ang:RotateAroundAxis( ang:Right(), Ang.x )
	ang:RotateAroundAxis( ang:Up(), Ang.y )
	ang:RotateAroundAxis( ang:Forward(), Ang.z )
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	pos = pos + Offset.x * Right 
	pos = pos + Offset.y * ang:Forward() 
	pos = pos + Offset.z * Up 
	
	return pos, ang
	
end

function SWEP:CanSecondaryAttack()

	return true

end

function SWEP:SecondaryAttack()

end

function SWEP:DrawHUD()
	
end