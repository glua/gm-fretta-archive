
//Stole most of this from garry :D

if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 72
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= true
	
	// This is the font that's used to draw the death icons
	surface.CreateFont( "csd", ScreenScale( 30 ), 500, true, true, "CSKillIcons" )
	surface.CreateFont( "csd", ScreenScale( 60 ), 500, true, true, "CSSelectIcons" )
	
	SWEP.PrintName			= "C4"			
	SWEP.Slot				= 4
	SWEP.SlotPos			= 5
	SWEP.IconLetter			= "I"
	
	killicon.AddFont( "weapon_fw_c4", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )

end

local c4speech = { "vo/episode_1/npc/male01/cit_thesearesomuchfun.wav",
	"vo/canals/male01/stn6_incoming.wav",
	"ravenholm.madlaugh03",
	"npc_barney.ba_laugh03",
	"citadel.br_laugh01",
	"vo/npc/male01/gordead_ans07.wav",
	"vo/npc/male01/gotone02.wav",
	"vo/npc/male01/nice.wav",
	"vo/npc/male01/question05.wav",
	"vo/npc/male01/question30.wav",
	"vo/npc/male01/runforyourlife01.wav",
	"vo/npc/male01/vanswer01.wav",
	"npc_barney.ba_danger02"
}

SWEP.Author			= "Dlaor"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.HoldType			= "slam"

SWEP.ViewModel			= "models/weapons/v_c4.mdl"
SWEP.WorldModel			= "models/weapons/w_c4.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Grenade"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	if ( SERVER ) then
		self:SetWeaponHoldType( self.HoldType )
	end
	
end

function SWEP:Reload()
	self.Weapon:DefaultReload( ACT_VM_DRAW )
end

function SWEP:Think()	
end

function SWEP:Deploy()
	self.Weapon:Reload()
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + 4 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 3 )
	
	if ( !self:CanPrimaryAttack() ) then return end
	
	self.Weapon:PlayAnim( self.Owner )
	if ( math.random( 1, 6 ) != 4 and SERVER ) then self.Owner:EmitSound( table.Random( c4speech ) ) end
	
	// In singleplayer this function doesn't get called on the client, so we use a networked float
	// to send the last shoot time. In multiplayer this is predicted clientside so we don't need to 
	// send the float.
	if ( (SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
	
end

function SWEP:PlayAnim( owner )
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) //Blip blip blip
	
	local bliptime = 2.733
	
	timer.Create( "dropanim", bliptime, 1, function()
	
		if ( !ValidEntity( self.Weapon ) or owner:GetActiveWeapon() != self.Weapon ) then return end
		self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK ) //Drop anim
		
		if ( !SERVER ) then return end
		
		local tpos = owner:GetShootPos()
		local tang = owner:GetAimVector()
		
		local tracedata = {}
			tracedata.start = tpos
			tracedata.endpos = tpos + ( tang * 64 )
			tracedata.filter = owner
		
		local trace = util.TraceLine(tracedata)
		local throw = false

		if ( !trace.Hit or trace.Entity:GetClass() == "player" ) then throw = true end
		
		if ( !throw ) then
			
			local angle = trace.HitNormal:Angle() + Angle( 90, 0, 0 )
			angle:RotateAroundAxis( trace.HitNormal, 180 )
			
			local bomb = ents.Create( "fw_c4" )
				bomb:SetPos( trace.HitPos )
				bomb:SetAngles( angle )
				bomb:SetNWEntity( "Owner", owner )
				bomb:Spawn()
				bomb:Activate()
			
			constraint.Weld( bomb, trace.Entity, trace.PhysicsBone, 0, 0, 1 )
			
		else
		
			local bomb = ents.Create( "fw_c4" )
				bomb:SetPos( tpos + ( tang * 8 ) )
				bomb:SetAngles( tang:Angle() )
				bomb:SetNWEntity( "Owner", owner )
				bomb:Spawn()
				bomb:Activate()
			
			local p, y, r = math.random( -36, 36 ), math.random( -36, 36 ), math.random( -36, 36 )
			local phys = bomb:GetPhysicsObject()
				phys:AddAngleVelocity( Angle( p, y, r ) )
				phys:ApplyForceCenter( tang * ( 510 * phys:GetMass() ) )
			
			self.Weapon:EmitSound( "weapons/iceaxe/iceaxe_swing1.wav" )
			
		end
		
		self:TakePrimaryAmmo( 1 )
		owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation
		
	end )
	
	timer.Create( "deployanim", 3.5, 1, function() 
		if ( !ValidEntity( self.Weapon ) or owner:GetActiveWeapon() != self.Weapon ) then return end
		self.Weapon:Reload()
	end )
	
end


/*---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2, y + tall*0.2, Color( 255, 210, 0, 255 ), TEXT_ALIGN_CENTER )
	
	// try to fool them into thinking they're playing a Tony Hawks game
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-14, 14), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	draw.SimpleText( self.IconLetter, "CSSelectIcons", x + wide/2 + math.Rand(-4, 4), y + tall*0.2+ math.Rand(-9, 9), Color( 255, 210, 0, math.Rand(10, 120) ), TEXT_ALIGN_CENTER )
	
end

function SWEP:SecondaryAttack()

	if ( SERVER ) then self.Owner:EmitSound( table.Random( c4speech ) ) end
	self.Weapon:SetNextSecondaryFire( CurTime() + 4 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
	
end