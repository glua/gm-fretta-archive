
SWEP.Base = "cb_weapon_base"

if CLIENT then
	
	SWEP.PrintName          = "Medic Gun"
	SWEP.Slot               = 0
	SWEP.SlotPos            = 1
	
	SWEP.VElements = {
		["health_left"] = { type = "Model", model = "models/healthvial.mdl", bone = "Base", pos = Vector(-3.576, -6.875, -2.326), angle = Angle(-135, -90, 0), size = Vector(1.335, 1.335, 1.335), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["health_glow"] = { type = "Sprite", sprite = "particle/Particle_Glow_04", bone = "Base", pos = Vector(1.325, 1.399, 0), size = { x = 14, y = 14 }, color = Color(0, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["health"] = { type = "Model", model = "models/healthvial.mdl", bone = "Base", pos = Vector(3.575, -6.875, -2.326), angle = Angle(-135, -90, 0), size = Vector(1.335, 1.335, 1.335), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
	SWEP.WElements = {
		["health_left"] = { type = "Model", model = "models/healthvial.mdl", pos = Vector(10.324, -6.85, -11.65), angle = Angle(-30, 175, -30), size = Vector(1.134, 1.134, 1.134), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["health_glow"] = { type = "Sprite", sprite = "particle/Particle_Glow_04", pos = Vector(17.625, -2.175, -5.7), size = { x = 14, y = 14 }, color = Color(0, 255, 0, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
		["health"] = { type = "Model", model = "models/healthvial.mdl", pos = Vector(11.5, -1.601, -13.726), angle = Angle(-30, 175, -30), size = Vector(1.134, 1.134, 1.134), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	
end

SWEP.ViewModel = "models/weapons/v_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"

SWEP.MaxEnergy = 120
SWEP.UberLast = 10
SWEP.AddHealth = 2
SWEP.HoldType = "physgun"

/*-------------------------------------
	SWEP:Initialize()
-------------------------------------*/
function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )

	// networked variables
	self:InstallDataTable()
	selfVar( "Int", 0, "Energy" )
	selfVar( "Entity", 0, "Target" )
	selfVar( "Bool", 0, "IsUber" )

	if( SERVER ) then

		self.Energy = 0

		self.NextAmmoRegeneration = CurTime()
		self.NextIdleTime = CurTime()

	end
	
	if CLIENT then

		self.NextHealEffect = CurTime()
	
		self:CreateModels(self.VElements) // create viewmodels
		self:CreateModels(self.WElements) // create worldmodels
		
		// init view model bone build function
		self.BuildViewModelBones = function( s )
			if LocalPlayer():GetActiveWeapon() == self and self.ViewModelBonescales then
				for k, v in pairs( self.ViewModelBonescales ) do
					local bone = s:LookupBone(k)
					if (!bone) then continue end
					local m = s:GetBoneMatrix(bone)
					if (!m) then continue end
					m:Scale(v)
					s:SetBoneMatrix(bone, m)
				end
			end
		end
		
	end

end

/*-------------------------------------
	SWEP:Holster()
-------------------------------------*/
function SWEP:Holster()
	
	self.ReloadSound:Stop()

	self.Target = nil
	self.IsUber = nil
	return true
	
end

/*-------------------------------------
	SWEP:Think()
-------------------------------------*/
function SWEP:Think()
	
	if( SERVER ) then
		
		// do idle
		if( self.NextIdleTime <= CurTime() ) then

			self:SendWeaponAnim( ACT_VM_IDLE )
			self.NextIdleTime = CurTime() + self:SequenceDuration()

		end
		
		// regenerate energy
		if( self.NextAmmoRegeneration <= CurTime() ) then
			
			if self.Energy <= 0 then
				self.IsUber = false
			end

			amnt = 0
			if ( IsValid(self.Target) ) then
				amnt = 1
			end
			if self.IsUber then
				amnt = -(self.MaxEnergy/(5*self.UberLast))
			end
			
			if IsValid(self.Target) and not self.IsUber then
				
				if (self.Target:GetPos()-self.Owner:GetPos()):LengthSqr() > 160000 then
					self.Target = nil
				else
					--Set Health
					self.Target:SetHealth(math.min( self.Target:GetMaxHealth(), self.Target:Health()+self.AddHealth ))
				end
				
			end
			
			self.Energy = math.min( self.MaxEnergy, self.Energy + amnt )
			self.NextAmmoRegeneration = CurTime() + 0.2

		end

	else
		
		if not IsValid(self.Target) then
			self:StopParticleEmission()
		end

	end
	
end

/*-------------------------------------
	SWEP:PrimaryAttack()
-------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start + (self.Owner:GetAimVector()*400)
	tr.filter = {self, self.Owner}
	tr = util.TraceLine(tr)
	
	if tr.Entity and tr.Entity:IsPlayer() and (tr.Entity:Team() == self.Owner:Team()) then
		self.Target = tr.Entity
		if CLIENT then
			self:SetAttachment(self:LookupAttachment("muzzle"))
			local tab = {}
			tab[1] = self.Target:LocalToWorld(self.Target:OBBCenter())
			self:CreateParticleEffect( "medicgun_beam_red", PATTACH_POINT_FOLLOW, tab )
		end
	else
		if CLIENT then
			self:StopParticleEmission()
		end
		self.Target = nil
	end
	
end

/*-------------------------------------
	SWEP:SecondaryAttack()
-------------------------------------*/
function SWEP:SecondaryAttack()
	
	if self:CanAttack(50) then
		
		--Make "uber" charge
		
	end
	
end