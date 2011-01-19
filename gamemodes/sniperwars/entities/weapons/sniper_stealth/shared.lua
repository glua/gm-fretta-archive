if SERVER then

	AddCSLuaFile("shared.lua")
	
	SWEP.HoldType = "ar2"
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Stealth Sniper"
	SWEP.IconLetter = "n"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "sniper_stealth", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) );
	
end

SWEP.Base = "sniper_base"

SWEP.ViewModel	= "models/weapons/v_snip_scout.mdl"
SWEP.WorldModel = "models/weapons/w_snip_scout.mdl"

SWEP.SprintPos = Vector(-1.7763, -1.9796, 1.677)
SWEP.SprintAng = Vector(-11.9431, -36.4352, 0)

SWEP.ScopePos = Vector(5.0124, -8.9394, 2.1298)
SWEP.ScopeAng = Vector(0, 0, -0.3972)

SWEP.ZoomModes = { 0, 40, 5 }
SWEP.ZoomSpeeds = { 0.25, 0.40, 0.40 }

SWEP.Primary.Sound			= Sound("weapons/m4a1/m4a1-1.wav")
SWEP.Primary.Recoil			= 3.2
SWEP.Primary.Damage			= 60
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.001
SWEP.Primary.Delay			= 1.210

SWEP.Primary.ClipSize		= 5
SWEP.Primary.Automatic		= false

SWEP.Secondary.Sound        = Sound( "weapons/sniper/sniper_zoomout.wav" )
SWEP.Secondary.Delay  		= 0.5

function SWEP:Holster()

	if SERVER then
		self.Owner:Cloak( false )
	end

	return true

end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, 1, "line_tracer" )
	self.Weapon:TakePrimaryAmmo( 1 )
	
	if SERVER then
	
		self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) * self.Primary.Recoil, 0))
		
		if self.Weapon:GetZoomMode() != 1 then
			self.Weapon:SetZoomMode(1)
			self.Weapon:SetNWBool("ReverseAnim",true)
			self.Weapon:SetViewModelPosition(self.ScopePos,self.ScopeAng,0.3)
			self.Owner:DrawViewModel( true )
		end	
		
	end

end

function SWEP:Think()	

	if self.Owner:KeyDown(IN_DUCK) and SERVER then
		if self.Owner:KeyDown(IN_FORWARD) or self.Owner:KeyDown(IN_BACK) or self.Owner:KeyDown(IN_MOVELEFT) or self.Owner:KeyDown(IN_MOVERIGHT) then
			self.Owner:Cloak( false )
		else
			self.Owner:Cloak( true )
		end
	elseif not self.Owner:KeyDown(IN_DUCK) and SERVER then
		self.Owner:Cloak( false )
	end

	if self.Owner:KeyDown(IN_SPEED) then
		self.LastRunFrame = CurTime() + 0.3
		if self.Weapon:GetZoomMode() != 1 and SERVER then
			self.Weapon:SetZoomMode(1)
			self.Weapon:SetNWBool("ReverseAnim",true)
			self.Weapon:SetViewModelPosition(self.ScopePos,self.ScopeAng,0.3)
			self.Owner:DrawViewModel( true )
		end
	end
	
	if self.MoveTime and self.MoveTime < CurTime() and SERVER then
		self.MoveTime = nil
		self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
		self.Owner:DrawViewModel( false )
	end

end

function SWEP:DrawHUD()

	local clk = self.Owner:GetNWBool( "Cloaked", false )
	
	if clk then
		local vm = self.Owner:GetViewModel()
		if vm:IsValid() then
			vm:SetMaterial( "sprites/heatwave" )
		end
	else
		local vm = self.Owner:GetViewModel()
		if vm:IsValid() then
			vm:SetMaterial( "" )
		end
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
		surface.DrawLine( 0, h * 0.50, w, h * 0.50 )
		surface.DrawLine( w * 0.50, 0, w * 0.50, h )
		
		local tr = util.TraceLine( util.GetPlayerTrace(self.Owner) )
		local dist = math.Clamp( math.ceil( tr.HitPos:Distance(self.Owner:GetPos()) / 16 ), 2, 999999 )
		local target = "N/A"
		
		if tr.Entity:IsValid() and tr.Entity:IsPlayer() then
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
		
	end
	
end

