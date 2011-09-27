if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Laser Designator"
	SWEP.IconLetter = "m"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "sent_bomb", "HL2MPTypeDeath", "7", Color( 255, 80, 0, 255 ) )
	
end

SWEP.Base = "sniper_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel	= "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"

SWEP.SprintPos = Vector(0.2863, -3.3665, -3.6323)
SWEP.SprintAng = Vector(33.2219, 5.3649, 0)

SWEP.ZoomModes = { 0, 40, 25 }
SWEP.ZoomSpeeds = { 0.25, 0.50, 0.40 }

SWEP.Primary.Sound			= Sound("items/nvg_on.wav")
SWEP.Primary.Ping           = Sound("buttons/button15.wav")
SWEP.Primary.Failed			= Sound("items/suitchargeno1.wav")
SWEP.Primary.Worked			= Sound("npc/roller/remote_yes.wav")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 1
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 5.500

SWEP.Primary.ClipSize		= 100
SWEP.Primary.Automatic		= false

SWEP.Secondary.Sound        = Sound( "weapons/sniper/sniper_zoomout.wav" )
SWEP.Secondary.Delay  		= 0.5

SWEP.LoadTime = 0

function SWEP:PingTrace()
	
	local tr = util.TraceLine( util.GetPlayerTrace( self.Owner ) )
	if not tr.HitSky then
		table.insert( self.Traces, tr.HitPos + tr.HitNormal * 10  )
	end

	if SERVER then
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		util.Effect( "laser_blink", ed, true, true )
	end
	
end
	
function SWEP:VerifyTrace()

	self.Weapon:PingTrace()
	
	if #self.Traces < 3 then
		self.Owner:EmitSound( self.Primary.Failed )
		return
	end
	
	local last = self.Traces[1]
	local valid = true
	
	for k,v in pairs( self.Traces ) do
		if v:Distance(last) > 250 then
			valid = false
		end
		last = v
	end
	
	if valid then
		self.Owner:EmitSound( self.Primary.Worked )
		self.Weapon:AirStrike( table.Random( self.Traces ) )
	else
		self.Owner:EmitSound( self.Primary.Failed )
	end

end

function SWEP:AirStrike( pos )
	
	if SERVER then
	
		local trace = {}
		trace.start = pos + Vector(0,0,1000)
		trace.endpos = pos + Vector(0,0,99999)
		local tr = util.TraceLine(trace)
	
		WorldSound( Sound( table.Random( GAMEMODE.Airplanes ) ), pos, 150, math.random( 80, 100 ) )
		
		for i=1, 10 do
		
			local vec = VectorRand() * 350
			vec.z = 0
		
			local btrace = {}
			btrace.start = tr.HitPos
			btrace.endpos = tr.HitPos + vec
			local btrace = util.TraceLine( btrace )
			
			local bombfunc = function( owner, pos ) 
			
				if not owner or not owner:IsValid() then return end
			
				local bomb = ents.Create( "sent_bomb" )
				bomb:SetPos( pos )
				bomb:SetOwner( owner )
				bomb:Spawn()
			end
			
			timer.Simple( i * 0.15, bombfunc, self.Owner, btrace.HitPos )
		
		end
		
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		util.Effect( "laser_blink", ed, true, true )
		
	end
	
end
	
function SWEP:Deploy()

	if SERVER then
		self.Weapon:SetViewModelPosition()
		self.Weapon:SetZoomMode(1)
		self.Owner:DrawViewModel( true )
	end	

	self.TraceTime = nil
	self.Traces = {}
	
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	return true
	
end 

function SWEP:Think()	

	if self.Owner:KeyDown(IN_SPEED) then
		self.LastRunFrame = CurTime() + 0.3
		if self.Weapon:GetZoomMode() != 1 and SERVER then
			self.Weapon:SetZoomMode(1)
			self.Owner:DrawViewModel( true )
		end
	end
	
	if self.TraceTime then
		if self.PingTime < CurTime() then
			self.Weapon:PingTrace()
			self.Weapon:EmitSound( self.Primary.Ping )
			if self.PingTime < self.TraceTime - 1 then
				self.PingTime = CurTime() + 1
			else
				self.PingTime = CurTime() + 5
			end
		end
		if self.TraceTime < CurTime() then
			self.Weapon:VerifyTrace()
			self.TraceTime = nil
		end
	else
		if self.LoadTime < CurTime() and self.Weapon:Clip1() < 100 then
			self.LoadTime = CurTime() + 1.2
			self.Weapon:SetClip1( self.Weapon:Clip1() + 10 )
		end
	end
end

function SWEP:Reload()

end

function SWEP:CanPrimaryAttack()

	if self.Owner:KeyDown(IN_SPEED) or self.LastRunFrame > CurTime() then
		return false
	end

	if self.Weapon:Clip1() < 100 then
		return false
	end
	
	return true
	
end

function SWEP:SecondaryAttack()

	if not self.Weapon:CanSecondaryAttack() then return end

	self.Weapon:EmitSound( self.Secondary.Sound )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )

	if SERVER then
		self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
	end
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self.Weapon:EmitSound( self.Primary.Sound )
	self.Weapon:TakePrimaryAmmo( 100 )
	
	self.PingTime = CurTime() + 2
	self.TraceTime = CurTime() + 5
	self.Traces = {}

end

function SWEP:DrawHUD()
	
	local mode = self.Weapon:GetNWInt("Mode",1)
	
	local w = ScrW()
	local h = ScrH()
	
	local wh, lh, sh = w*.5, h*.5, 4
		
	surface.SetDrawColor( CrossRed:GetInt(), CrossGreen:GetInt(), CrossBlue:GetInt(), CrossAlpha:GetInt() )
	surface.DrawLine(wh - sh, lh - sh, wh + sh, lh - sh) //top line
	surface.DrawLine(wh - sh, lh + sh, wh + sh, lh + sh) //bottom line
	surface.DrawLine(wh - sh, lh - sh, wh - sh, lh + sh) //left line
	surface.DrawLine(wh + sh, lh - sh, wh + sh, lh + sh) //right line
	
	if mode != 1 then

		surface.SetTexture( surface.GetTextureID("sprites/reticle2") )
		surface.SetDrawColor( 255, 255, 255, 200 )
		surface.DrawTexturedRect( w*.25, 0, w*.5, h ) 
		
	end
	
end


