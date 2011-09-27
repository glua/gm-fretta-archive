
AddCSLuaFile( "shared.lua" )

SWEP.Author			= "Clavus"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= "[Default] Left click: Shoot lead; Right click: absorb player;\n[Player absorbed] Left click: hold to charge, release to fire."

if ( CLIENT ) then

	SWEP.PrintName			= "Player Cannon"
	SWEP.Slot				= 1		
	SWEP.SlotPos			= 0	
	SWEP.DrawAmmo			= false	
	SWEP.DrawCrosshair		= true 
	SWEP.DrawWeaponInfoBox	= true
	SWEP.BounceWeaponIcon   = false
	SWEP.SwayScale			= 1.0
	SWEP.BobScale			= 1.0

	SWEP.IconLetter = "0"
	SWEP.IconFont = "HL2MPTypeDeath"
	killicon.AddFont("weapon_playercannon", SWEP.IconFont, SWEP.IconLetter, Color(255, 80, 0, 255 ))

	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
		draw.SimpleText( "b", "HalfLife2", x + wide/2, y + tall/2, Color( 255, 255, 70 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
end

SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_shotgun.mdl"
SWEP.WorldModel		= "models/weapons/w_shotgun.mdl"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= -1				// Size of a clip
SWEP.Primary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Primary.Automatic		= false				// Automatic/Semi Auto
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Sound			= Sound("weapons/shotgun/shotgun_fire6.wav")
SWEP.Primary.Sound2			= Sound("weapons/gauss/fire1.wav")

SWEP.Secondary.Sound		= Sound("weapons/physcannon/superphys_launch3.wav")
SWEP.Secondary.FailSound	= Sound("SuitRecharge.Deny")
SWEP.Secondary.ClipSize		= -1				// Size of a clip
SWEP.Secondary.DefaultClip	= -1				// Default number of bullets in a clip
SWEP.Secondary.Automatic	= true				// Automatic/Semi Auto
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadSound = Sound("weapons/shotgun/shotgun_cock.wav")

SWEP.MaxCharge = 1200

SWEP.ImpactSounds = {}
for i = 1, 6 do
	table.insert(SWEP.ImpactSounds, Sound("physics/body/body_medium_impact_hard"..i..".wav"))
end

function SWEP:Initialize()

	self:SetWeaponHoldType( "shotgun" )

end

function SWEP:SetupDataTables()
	// Prediction goodness! Thanks Garry :D
	// For future reference: http://www.garry.tv/?p=1198
	self:DTVar( "Bool", 0, "ChargeInit" )
	self:DTVar( "Int", 0, "WeaponMode" )
	self:DTVar( "Float", 0, "ChargeStart" )
	self:DTVar( "Float", 1, "Charge" )
	self:DTVar( "Float", 2, "AbsorbStartTime" )
	self:DTVar( "Entity", 1, "Absorbed" )
end

function SWEP:PrimaryAttack()

	if not IsFirstTimePredicted() then return end

	if ValidEntity(self:GetAbsorbedPlayer()) then
		if self.dt.ChargeInit == false and self.dt.Charge == 0 then
			self.dt.ChargeInit = true
			self.dt.ChargeStart = CurTime()
			self.dt.Charge = 0
		end
	else

		local pos = self.Owner:GetShootPos()
		local ang = self.Owner:GetAimVector()
		local tracedata = {}
		tracedata.start = pos
		tracedata.endpos = pos+(ang*5000)
		tracedata.filter = team.GetPlayers(self.Owner:Team())
		tracedata.mins = Vector(-4,-4,-4)
		tracedata.maxs = Vector(4,4,4)
		
		local trace = util.TraceHull(tracedata)

		if ValidEntity(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity:Team() != self.Owner:Team() then

			local newvel = self.Owner:GetAimVector()*math.min(700,700*1500/trace.HitPos:Distance(pos))
			newvel = newvel + Vector(0,0,1)*newvel:Length()/3 // add some upwards force
			trace.Entity:SetVelocity(newvel)
			
			trace.Entity:EmitSound(table.Random(self.ImpactSounds))
			
			local eff = EffectData()
				eff:SetNormal(trace.HitNormal)
				eff:SetOrigin(trace.HitPos)
			util.Effect("shot_hit", eff)
		
			if SERVER and not self.Owner.forceshotnoted and math.random(1,3) == 1 then
				self.Owner.forceshotnoted = true
				self.Owner:Notify("Remember: force shots do not inflict damage!", NOTIFY_GENERIC)
			end
		end
	
		local eff = EffectData()
			eff:SetEntity(self.Weapon)
			eff:SetAttachment(self.Weapon:LookupAttachment("muzzle"))
			eff:SetNormal(self.Owner:GetAimVector())
			eff:SetOrigin(pos)
		util.Effect("launcher_shot", eff)
		
		self:ShootEffects(true)
		
		// Punch the player's view
		self.Owner:ViewPunch( Angle( -3, 0, 0 ) )
		self.Weapon:EmitSound( self.Primary.Sound, 40 )
		self.Weapon:EmitSound( self.Primary.Sound2, 30 )
	end
	
	self:SetNextPrimaryFire( CurTime() + 0.6 )
end


function SWEP:FirePlayer( force, was_forced )

	local pl = self:GetAbsorbedPlayer()
	if not ValidEntity(pl) then 
		// TODO: add some funny sound / effect for empty weapon firing
		self.Weapon:EmitSound(self.Secondary.FailSound)
		self:ShootEffects(false)
		
	else
		self.Weapon:EmitSound(self.Secondary.Sound)
		
		if CLIENT then
			if force < 100 and self.lastfailshotnag < CurTime() - 10 then
				if not was_forced then
					GAMEMODE:AddNotify( "HOLD your fire button to launch with more force!", NOTIFY_ERROR, 5 )
				else
					GAMEMODE:AddNotify( "Don't hold players longer than 10 seconds!", NOTIFY_ERROR, 5 )
				end
				self.lastfailshotnag = CurTime()
			end
			
			/*if force > 120 then
				timer.Simple(0.1, function( ent )
					ParticleEffectAttach( "burning_engine_01", PATTACH_ABSORIGIN_FOLLOW, ent, 0 )
				end, pl)
				timer.Simple(force/600, function( ent )
					if ValidEntity(ent) then
						ent:StopParticles()
					end
				end, pl)
			end*/
		
		end
		
		if SERVER then
			
			local newpos = self.Owner:GetShootPos()+(self.Owner:GetAimVector()*30)
		
			trace={}
			trace.start = self.Owner:GetPos()
			trace.endpos = newpos
			//trace.filter = self.Owner
			trace.mask = MASK_SOLID_BRUSHONLY
			
			// Some checks to prevent players from shooting each other in walls
			local tr = util.TraceEntity( trace , self.Owner )
			if tr.HitWorld then
				newpos = self.Owner:GetPos()+Vector(0,0,20)
				if pl:Team() != self.Owner:Team() then
					local aimvec = self.Owner:GetAimVector()
					aimvec.z = 0
					aimvec:Normalize()
					local newownerpos = self.Owner:GetPos()+aimvec*-40
					self.Owner:SetPos(newownerpos)
				end
			end
		
			if pl:Team() != self.Owner:Team() then
				pl:SetNWFloat("tempnocollidestart", CurTime())
			end	
		
			pl:RestorePlayer(newpos)
			pl:SetAngles(self.Owner:GetAimVector():Angle())
			pl:SetEyeAngles(self.Owner:GetAimVector():Angle())
			pl:SetLocalVelocity(self.Owner:GetAimVector()*force)
			pl:DisallowTrajectoryBreaking()

			pl:ChainPlayer( self.Owner )
			self.Owner.PlayersLaunched = self.Owner.PlayersLaunched + 1
		end
	
		self:ShootEffects(true)
	end
	
	self.dt.ChargeInit = false
	self.dt.WeaponMode = 0
	
	// Punch the player's view
	self.Owner:ViewPunch( Angle( -force/100, 0, 0 ) )
	self:SetNextPrimaryFire( CurTime() + 0.6 )
	self:SetNextSecondaryFire( CurTime() + 1.5 )
	
	if SERVER then
		// Invalidate the absorbed entity
		self.dt.Absorbed = Entity()
		self.Owner:SetAbsorbedPlayer( Entity() )
	end

end

function SWEP:Think()

	if self.dt.ChargeInit then
		if self.Owner:KeyDown(IN_ATTACK) and self.dt.Charge != self.MaxCharge  then
			self.dt.Charge = math.min((CurTime()-self.dt.ChargeStart)*400,self.MaxCharge)
		else
			self:FirePlayer( self.dt.Charge )
		end
	else
		self.dt.Charge = math.max(self.dt.Charge / 1.2,0)
		if self.dt.Charge < 0.1 then self.dt.Charge = 0 end
		
		// Forces player to drop absorbed player
		if ValidEntity(self:GetAbsorbedPlayer()) and self.dt.AbsorbStartTime < CurTime()-10 then
			self:FirePlayer( 0, true )
		end
	end
	
end


function SWEP:SecondaryAttack()

	if not IsFirstTimePredicted() then return end
	if ValidEntity(self:GetAbsorbedPlayer()) then return end

	local pl = self:GetEntityInRange()
	if not ValidEntity(pl) then return end
	if not pl:IsPlayer() then return end
	if pl:HasAbsorbedPlayer() and pl:Team() == self.Owner:Team() then return end
	
	if (self.Owner:GetShootPos():Distance(pl:GetPos()+Vector(0,0,30)) > 50) then
		local dir = (self.Owner:GetShootPos()-pl:GetPos()):GetNormal()
		/*local phys = pl:GetPhysicsObject()
		if ValidEntity(phys) then
			phys:Wake()
			phys:ApplyForceCenter(dir*1500)
		else*/
		pl:SetLocalVelocity(dir*250)
		
	else
		self:Absorb(pl)
	end

end

function SWEP:Absorb( pl )
	if not SERVER then return end

	// Restores any players the player you absorb has absorbed
	// to prevent any 'yo dawg' meme shit.
	pl:DropAbsorbedPlayer()
	
	pl:SetNWBool("isabsorbed", true)
	pl:SetNWEntity("absorber", self.Owner)
	pl.WeaponsStored = {}
	for k, weapon in pairs( pl:GetWeapons() ) do
		table.insert(pl.WeaponsStored, weapon:GetClass())
	end
	pl.PrevHealth = pl:Health()

	// Remove powerup effects
	pl:RemoveTrail()
	pl:RemoveEyeLaser()
	
	pl:StripWeapons()
	pl:Spectate( OBS_MODE_CHASE )
	pl:SpectateEntity(self.Owner)
	self.dt.Absorbed = pl
	self.Owner:SetAbsorbedPlayer( pl )
		
	self.dt.WeaponMode = 1
	self.dt.AbsorbStartTime = CurTime()
	
	self.Weapon:SendWeaponAnim( ACT_SHOTGUN_PUMP )
	self.Weapon:EmitSound( "Weapon_Shotgun.Special1" )

	self.Weapon:SetNextSecondaryFire( CurTime() + 0.3 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )
end

function SWEP:GetAbsorbedPlayer()
	return self.dt.Absorbed
end

function SWEP:GetEntityInRange()

	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ang*150)
	tracedata.filter = self.Owner
	tracedata.mins = Vector(-8,-8,-8)
	tracedata.maxs = Vector(8,8,8)

	local trace = util.TraceHull(tracedata)
	if trace.HitNonWorld then
	   return trace.Entity
	end

	return nil
end

function SWEP:ShootEffects( success )

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		// View model animation
	self.Owner:SetAnimation( PLAYER_ATTACK1 )				// 3rd Person Animation

	local magnitude = 50
	
	if success then
		self.Owner:MuzzleFlash()								// Crappy muzzle light
		magnitude = 100
	end
	
	local fx = EffectData()
	fx:SetEntity(self.Weapon)
	fx:SetOrigin(self.Owner:GetShootPos())
	fx:SetNormal(self.Owner:GetAimVector())
	fx:SetAttachment(self.Weapon:LookupAttachment("muzzle"))
	fx:SetMagnitude(magnitude)
	util.Effect("launcher_fire",fx)
	
end

if CLIENT then

	SWEP.lastfailshotnag = 0
	
	function SWEP:DrawHUD()
	
		local w = ScrW()
		local h = ScrH()
		local x = w-40
		local y = h-130
		local wi = 30
		local he = 120
	
		if self.dt.WeaponMode == 1 then
		
			local anim = math.floor((CurTime()*3)%4) // glowy effect
			if anim == 3 then anim = 1 end
			draw.SimpleTextOutlined( "b", "HalfLife2Big", w-240, h-130, Color( 255, 255, 70 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, anim, Color( 255, 255, 100, 20 ) )
		
			surface.SetDrawColor( 0, 0, 0, 80 )
			surface.DrawRect(x,y,wi,he)
			
			surface.SetDrawColor( 255, 255, 70, 255 )
			surface.DrawRect(x,y+he-he*self.dt.Charge/self.MaxCharge,wi,he*self.dt.Charge/self.MaxCharge)
			surface.SetDrawColor( 255, 255, 100, 255 )
			surface.DrawRect(x+3,y+he-he*self.dt.Charge/self.MaxCharge,wi-6,he*self.dt.Charge/self.MaxCharge)
			
			surface.SetDrawColor( 0, 0, 0, 255 )
			surface.DrawOutlinedRect(x,y,wi,he)
			surface.DrawOutlinedRect(x-1,y-1,wi+2,he+2)
			
			draw.SimpleTextOutlined( tostring(math.floor(self.dt.Charge)), "InfoSmaller", x+wi/2, y+2, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, COLOR_BLACK )
			
			// Show absorbed player
			local pl = self:GetAbsorbedPlayer()
			local name = "n/a"
			if ValidEntity(pl) then
				name = pl:Name()
			end
			
			local loadstr = "Loaded: "..name
			local primstr = "Primary: HOLD to charge; RELEASE to fire"
			surface.SetFont("InfoSmall")
			local loadw, loadh = surface.GetTextSize( loadstr )
			local primw, primh = surface.GetTextSize( primstr )
			
			local loadx, loady = w-90, h-55
			local primx, primy = w-55, h-110
			
			draw.RoundedBox( 6, loadx-loadw-4, loady-2, loadw+8, loadh+4, Color(0,0,0,200) )
			draw.RoundedBox( 6, primx-primw-4, primy-2, primw+8, primh+4, Color(0,0,0,200) )
		
			draw.SimpleText( loadstr, "InfoSmall", loadx, loady, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			draw.SimpleText( primstr, "InfoSmall", primx, primy, COLOR_WHITE, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )
			
		elseif self.dt.WeaponMode == 0 then
			
			draw.SimpleText( "b", "HalfLife2Big", w-240, h-130, Color( 255, 255, 70 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
			local secstr = "Secondary: Absorb player"
			local primstr = "Primary: Force shot"
			surface.SetFont("InfoSmall")
			local secw, sech = surface.GetTextSize( secstr )
			local primw, primh = surface.GetTextSize( primstr )
			
			local primx, primy = w-240, h-110
			local secx, secy = w-240, h-55
			
			draw.RoundedBox( 6, secx-4, secy-2, secw+8, sech+4, Color(0,0,0,200) )
			draw.RoundedBox( 6, primx-4, primy-2, primw+8, primh+4, Color(0,0,0,200) )
			
			draw.SimpleText( primstr, "InfoSmall", primx, primy, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( secstr, "InfoSmall", secx, secy, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		end
	end


end

