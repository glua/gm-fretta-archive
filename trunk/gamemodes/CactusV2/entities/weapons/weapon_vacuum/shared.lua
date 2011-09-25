
//Shared

AddCSLuaFile( "shared.lua" )

SWEP.Author			= "Grea$eMonkey"
SWEP.Contact		= ""
SWEP.Purpose		= "Suck them cacti up!"
SWEP.Instructions	= "Right click to suck!\nLeft click to blow and launch yourself into the air!"

if ( CLIENT ) then

	SWEP.PrintName			= "Vacuum"				// 'Nice' Weapon name (Shown on HUD)	
	SWEP.Slot				= 0						// Slot in the weapon selection menu
	SWEP.SlotPos			= 10					// Position in the slot
	SWEP.DrawAmmo			= false					// Should draw the default HL2 ammo counter
	SWEP.DrawCrosshair		= true 					// Should draw the default crosshair
	SWEP.DrawWeaponInfoBox	= false					// Should draw the weapon info box
	SWEP.BounceWeaponIcon   = false					// Should the weapon icon bounce?
	SWEP.SwayScale			= 1.0					// The scale of the viewmodel sway
	SWEP.BobScale			= 1.0					// The scale of the viewmodel bob
	SWEP.WepSelectIcon		= surface.GetTextureID( "weapons/swep" )

end

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_vacuum.mdl" --"models/weapons/v_maxisuck_9001.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl" --"models/weapons/w_maxisuck_9001.mdl"
--SWEP.AnimPrefix		= "python"
SWEP.HoldType 		= "357"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1				// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= 8					// Size of a clip
SWEP.Secondary.DefaultClip	= 32				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= true				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
 
	if ( SERVER ) then
		self:SetWeaponHoldType( "pistol" )
	end
	self.NextReplace = 15 --How many cacti caught before it needs to be replaced
	self.CactiCaught = 0 --Counter for cacti caught
	--self:SetNetworkedBool( "Reloading", false )
	self.cactusbeingcaught = false
	self.cactuscaught = false
	self.IsReloading = false

	if CLIENT && !ValidEntity( self.Cone ) then
		local ViewModel = LocalPlayer():GetViewModel()
		self.Cone = ClientsideModel( "models/props_combine/portalball.mdl", RENDERGROUP_OPAQUE )
		self.Cone:SetPos(ViewModel:GetPos()+ViewModel:GetForward()*30+ViewModel:GetRight()*8+Vector(0,0,-8))
		self.Cone:SetAngles(ViewModel:GetAngles())
		self.Cone:SetColor(0,0,0,0)
		self.Cone:SetParent(ViewModel)
		self.Cone:SetModelScale(Vector(1, 0.5, 0.5))
	end
	
end

function SWEP:CanSecondaryAttack()

	return !(self.CactiCaught >= 15 || self.IsReloading)

end

function SWEP:Reload()

	--self.Weapon:SetAnimation(ACT_VM_RELOAD)
	if !self.IsReloading then
		self.IsReloading = true

		self.Weapon:SendWeaponAnim( ACT_VM_RELOAD )
		self.Weapon:SetNextSecondaryFire( CurTime() + 4 )

		timer.Simple( 4,
			function( wep )
				if ValidEntity( wep ) then
					wep.IsReloading = false
					self.CactiCaught = 0
				end
			end,
		self )
	end
	--setanim
	--setnextfires
	--play sounds

end

/*---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
---------------------------------------------------------*/
function SWEP:SecondaryAttack()
	
	if !self:CanSecondaryAttack()then
		--play anim showing its full
		--show indicator on swep hud
		--show tip
		if !self.IsReloading then
			self.Weapon:EmitSound( "Weapon_Pistol.Empty" ) // Should be a plugged vacuum-y noise
			self:Reload()
		end
	return end
	
	self.Weapon:SendWeaponAnim( ACT_VM_ATTACK2 )
	// Play shoot sound
	--self.Weapon:EmitSound("Weapon_AR2.Single") //Get sound
	
	local dist_pull = 500 --distance that cacti can get pulled from
	local dist_grab = 100 --distance that cacti can get grabbed from
	local force = 3 --force multiplier
	local foundEnts = nil
	--local tr = UTIL_QuickTraceHull(self.Owner:GetShootPos(),self.Owner:GetShootPos()+self.Owner:GetAimVector()*dist_pull,Vector(-32,-32,-32),Vector(32,32,32),{self.Owner}) --needed?
	--local ent = tr.Entity --ent?
	
	local coneEnts = ents.FindInCone(self.Owner:GetShootPos(),self.Owner:GetAimVector(),500,50) --find all ents in cone
	
	for k,v in pairs(coneEnts) do --loop the ents
		if v:IsValid() then	--if ent is valid
			if v:IsValid() and v:IsCactus() then --if it's a cactus
				local dist = v:GetPos():Distance(self.Owner:GetShootPos()) --here's a quick distance calculation from ent to shootpos where they get caught
				local tr = {} --Set up a trace table; this will be used as a trace to every ent in the coneEnts
				tr[v] = util.QuickTrace(self.Owner:GetShootPos(),v:GetPos(),--[[Vector(-32,-32,-32),Vector(32,32,32),]]{self.Owner}) --make a trace for ent
				local isinroughview = (self.Owner:KeyDown(IN_USE) && self.Owner:GetAimVector():DotProduct( ( v:GetPos() - self.Owner:GetPos() ):Normalize() ) < 0.90)
				if tr[v].Hit then
					if dist < dist_pull then --if current dist is less than pull dist
						if SERVER then
							if !v then return end
							if dist < dist_grab and !v:GetCactusData():OnCapture() then
								v:SetMove((self.Owner:GetRight()*math.Rand(-1,1)*500)+(self.Owner:GetShootPos()-v:GetPos())*force)
							else
								v:SetMove((vector_up*(GetConVarNumber("sv_gravity")/12))+(self.Owner:GetShootPos()-v:GetPos())*force) --use my custom move physics function to pull the ent
							end
						end
					end
					if dist < dist_grab then --if current distance is less than grab dist
						--v:SetPNR(true, v:GetPos()) --Point of No Return
						--print("grabbing")
						if SERVER and v:GetCactusData():OnCapture() then
							--print("Caught")
							GAMEMODE:CaughtCactus(self.Owner,v) --run the catch function
							self.CactiCaught = self.CactiCaught+1
						end
					end
					foundEnts = true
				end
			end
		end
	end
	
	
	// Todo.. increase health..
	if foundEnts then
		self:SetNextSecondaryFire( CurTime() )
	else
		self:SetNextSecondaryFire( CurTime() + 0.1 )
	end

end

/*---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
---------------------------------------------------------*/
function SWEP:PrimaryAttack()
	
	self.Weapon:SendWeaponAnim(ACT_VM_ATTACK1)
	
	// Play shoot sound
	--self.Weapon:EmitSound("Weapon_AR2.Single") //Get vacuum sound
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( -5, 0, 0 ) )
	
	self:SetNextPrimaryFire( CurTime() + 1.5 )
	
	/*local trace = UTIL_QuickTraceHull(self.Owner:GetShootPos(),self.Owner:GetAimVector()*200,Vector(-32,-32,-32),Vector(32,32,32),{self.Owner})
	if trace.HitPos:Distance(self.Owner:GetShootPos()) > 300 then return end
	
	// Make the player/objects fly backwards..
	if trace.Entity:IsPlayer() and trace.Entity:IsHuman() then
		trace.Entity:SetGroundEntity( NULL )
		trace.Entity:SetLocalVelocity( trace.Entity:GetVelocity() + (self.Owner:GetShootPos()+trace.Entity:GetPos()) * 500 )
	elseif !trace.Entity:IsPlayer() and trace.Entity:IsCactus() then
		if SERVER then
			trace.Entity:SetMove( (self.Owner:GetAimVector()) * 500 )
		end
	else*/
		self.Owner:SetGroundEntity( NULL )
		self.Owner:SetLocalVelocity( self.Owner:GetVelocity() + self.Owner:GetAimVector() * -600 )
	--end
	

end

function SWEP:Holster( wep )
	if CLIENT && ValidEntity( self.Cone ) then
		self.Cone:SetColor(0,0,0,0)
	end
	return true
end

function SWEP:Deploy()
	--self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	if CLIENT && ValidEntity( self.Cone ) then
		self.Cone:SetColor(0,0,0,0)
	end
    return true
end

if !CLIENT then return end

local function linearInterpolate( p1, p2, mu )
	return p1 * ( 1 - mu ) + p2 * mu
end

local cacti_caught = {}
local cacti_suck_animation_time = CreateClientConVar( "ca_vacuum_animation_suck_time", 0.5, false, false )

local vortex_swirl_speed = 0
local vortex_swirl_max_speed = CreateClientConVar( "ca_vacuum_vortex_swirl_speed", 30, false, false )
local vortex_swirl_time_to_full_speed = CreateClientConVar( "ca_vacuum_vortex_time_to_full_speed", 0.5, false, false )
----------------------------------------------------------------------------------
local vortex_lastTime
local vortex_progress = 0
function SWEP:ViewModelDrawn()

	if !self.Weapon then return end

	local vm = LocalPlayer():GetViewModel()

	if !ValidEntity( vm ) then return end

	local vm_pos = vm:GetPos()

	vortex_lastTime = vortex_lastTime or CurTime()
	local Delta = CurTime() - vortex_lastTime

	vortex_lastTime = vortex_lastTime + Delta

	vortex_progress = math.Clamp( vortex_progress + ((self:CanSecondaryAttack() && LocalPlayer():KeyDown( IN_ATTACK2 )) and Delta or -Delta), 0, vortex_swirl_time_to_full_speed:GetFloat() )
	vortex_swirl_speed = vortex_progress / vortex_swirl_time_to_full_speed:GetFloat() * vortex_swirl_max_speed:GetFloat()

	local cone_angles = self.Cone:GetAngles()
	cone_angles:RotateAroundAxis( cone_angles:Forward(), vortex_swirl_speed )
	self.Cone:SetAngles( cone_angles )

	local mu = vortex_swirl_speed / vortex_swirl_max_speed:GetInt()

	self.Cone:SetColor( 80, 80, 100, mu * 255 )	// It would be cool if this worked.
	self.Cone:SetModelScale( Vector( mu, 0.5 * mu, 0.5 * mu ) )
	self.Cone:SetPos( vm:GetPos() + vm:GetForward() * linearInterpolate( 10, 30, mu ) + vm:GetRight() * 8 + vm:GetUp() * -8 )

	for k, v in pairs( cacti_caught ) do
		if !v[ 5 ] then	// vm:GetPos() returns vector_origin in the hook below, this is a workaround.
			v[ 2 ] = vm:WorldToLocal( v[ 2 ] )
			v[ 3 ] = vm:WorldToLocalAngles( v[ 3 ] )
			v[ 1 ]:SetParent( vm )
			v[ 5 ] = true
		end
		v[ 4 ] = v[ 4 ] + Delta
		local mu = math.Clamp( v[ 4 ] / cacti_suck_animation_time:GetFloat(), 0, 1 )
		local lpos = Vector( linearInterpolate( v[ 2 ].x, 30, mu ),
							 linearInterpolate( v[ 2 ].y, -8, mu ),
							 linearInterpolate( v[ 2 ].z, -8, mu ) )
		v[ 1 ]:SetPos( vm:LocalToWorld( lpos ) )
		local lang = Angle( linearInterpolate( v[ 3 ].p, 90, mu ),
							linearInterpolate( v[ 3 ].y, 0, mu ),
							linearInterpolate( v[ 3 ].r, 0, mu ) )
		v[ 1 ]:SetAngles( vm:LocalToWorldAngles( lang ) )
		v[ 1 ]:SetModelScale( Vector( linearInterpolate( 1, 0.01, mu ),
									  linearInterpolate( 1, 0.01, mu ),
									  linearInterpolate( 1, 0.01, mu ) ) )
		if mu == 1 then	// Clear the cactus from the list, it's out of view.
			v[ 1 ]:Remove()
			cacti_caught[ k ] = nil
		end
	end

end

usermessage.Hook( "c.CaughtCactus", function( um )

	local cactus = { ClientsideModel( "models/props_lab/cactus.mdl", RENDERGROUP_OPAQUE ), um:ReadVector(), um:ReadAngle(), 0, false }

	cactus[ 1 ]:SetPos( cactus[ 2 ] )
	cactus[ 1 ]:SetAngles( cactus[ 3 ] )
	cactus[ 1 ]:SetColor( um:ReadChar(), um:ReadChar(), um:ReadChar(), 255 )

	for i = 1, 4096 do
		if !cacti_caught[ i ] then
			cacti_caught[ i ] = cactus
			break
		end
	end

end )
