if (SERVER) then

	AddCSLuaFile( "shared.lua" )
	
	SWEP.HoldType = "slam"

end

if ( CLIENT ) then
	
	SWEP.PrintName = "Knife"
	SWEP.Slot = 1
	SWEP.Slotpos = 1
	SWEP.IconLetter = "j"
	
	SWEP.IconFont = "CSSelectIcons"
	SWEP.KillFont = "CSKillIcons"
	
	killicon.AddFont( "jj_knife", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	killicon.AddFont( "sent_knife", SWEP.KillFont, SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
	RegisterName( "jj_knife", SWEP.PrintName )
	
end

SWEP.Base = "jj_base"

SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Sound			= Sound( "weapons/knife/knife_slash1.wav" )
SWEP.Primary.Deploy         = Sound( "weapons/knife/knife_deploy1.wav" )
SWEP.Primary.Stab           = { Sound( "weapons/knife/knife_hit1.wav" ),
								Sound( "weapons/knife/knife_hit2.wav" ),
								Sound( "weapons/knife/knife_hit3.wav" ),
								Sound( "weapons/knife/knife_hit4.wav" ) }
SWEP.Primary.Damage			= 250
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.250 //default spread without factoring in the firing
SWEP.Primary.Delay			= 0.450

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end
	
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Weapon:MeleeTrace( self.Primary.Damage, 10 )
	
end	

function SWEP:MeleeTrace( dmg, force )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 40
	
	local tr = {}
	tr.start = pos
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mins = Vector(-16,-16,-16)
	tr.maxs = Vector(16,16,16)

	local trace = util.TraceHull( tr )
	local ent = trace.Entity

	if ValidEntity( ent ) and ent:IsPlayer() then
		
		ent:TakeDamage( dmg, self.Owner, self.Weapon )
		ent:EmitSound( table.Random( self.Primary.Stab ), 100, math.random(90,110) )
		
		local ed = EffectData()
		ed:SetOrigin( ent:GetPos() + Vector( 0, 0, 40 ) )
		ed:SetNormal( trace.HitNormal )
		ed:SetMagnitude( 50 )
		util.Effect( "blood_splat", ed, true, true )
		
	end

end

function SWEP:SecondaryAttack()

	if CLIENT then return end

	self.Weapon:ThrowKnife()
	
	self.Owner:StripWeapon( "jj_knife" )

end

function SWEP:ThrowKnife()

	if CLIENT then return end
	
	self.Owner:EmitSound( self.Primary.Sound, 100, math.random(90,110) )
	self.Owner:EmitSound( self.Primary.Deploy, 100, math.random(90,110) )

	local random = ( self.Owner:GetAimVector() + VectorRand() * 0.02 ):Normalize()
	random.x = 0

	local knife = ents.Create( "sent_knife" )
	knife:SetPos( self.Owner:GetShootPos() )
	knife:SetAngles( ( random ):Angle() )
	knife:SetOwner( self.Owner )
	knife:Spawn()

end