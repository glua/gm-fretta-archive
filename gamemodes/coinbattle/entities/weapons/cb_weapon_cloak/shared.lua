
SWEP.Base = "cb_weapon_base"

SWEP.ViewModel = "models/weapons/v_fists.mdl"
SWEP.WorldModel = ""

SWEP.MaxEnergy = 35
SWEP.HoldType = "normal"

/*-------------------------------------
	SWEP:Initialize()
-------------------------------------*/
function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )

	self.Energy = self.MaxEnergy
	self.Camo = false

	self.NextAmmoRegeneration = CurTime()
	self.NextIdleTime = CurTime()

end

/*----------------------------------
	SWEP:SetCamo()
----------------------------------*/
function SWEP:SetCamo(on)
	
	if on then
		
		self:EmitSound("player/suit_sprint.wav",75,100)
		if CLIENT and (LocalPlayer()==self.Owner) then
			if self.Owner:GetViewModel():IsValid() then self.Owner:GetViewModel():SetMaterial("models/shadertest/predator") end
		else
			self.Owner:SetInvisible(true)
			self.Owner:SetWalkSpeed(self.Owner:GetPlayerClass().WalkSpeed*(2/3))
			self.Owner:SetRunSpeed(self.Owner:GetPlayerClass().RunSpeed*(2/3))
		end
		
		local ED = EffectData()
		ED:SetEntity(self.Owner)
		ED:SetAttachment(self.Owner:Team())
		util.Effect("cb_cloak", ED)
		
		self.Camo = true
		
	elseif !on then
		
		self:EmitSound("player/suit_sprint.wav",75,80)
		if CLIENT and (LocalPlayer()==self.Owner) then
			if self.Owner:GetViewModel():IsValid() then self.Owner:GetViewModel():SetMaterial("") end
		else
			self.Owner:SetInvisible(false)
			self.Owner:SetWalkSpeed(self.Owner:GetPlayerClass().WalkSpeed)
			self.Owner:SetRunSpeed(self.Owner:GetPlayerClass().RunSpeed)
		end
		
		self.Camo = false
		
	end
	
end

/*-------------------------------------
	SWEP:Holster()
-------------------------------------*/
function SWEP:Holster()

	if self.Camo == true then
		self:SetCamo(false)
	end
	
	return true
	
end

/*-------------------------------------
	SWEP:OnRemove()
-------------------------------------*/
function SWEP:OnRemove()

	if self.Camo == true then
		self:SetCamo(false)
	end

	if CLIENT then
		self:RemoveModels()
	end

end

/*-------------------------------------
	SWEP:Think()
-------------------------------------*/
function SWEP:Think()
	
	if self.Energy == 0 then self:SetCamo(false) end
	
	
	// do idle
	if( self.NextIdleTime <= CurTime() ) then

		self:SendWeaponAnim( ACT_VM_IDLE )
		self.NextIdleTime = CurTime() + self:SequenceDuration()

	end


	// regenerate energy
	if( self.NextAmmoRegeneration <= CurTime() ) then
	
		local amnt = 1
		if self.Camo then
			amnt = -1
		end
		
		self.Energy = math.min( self.MaxEnergy, self.Energy + amnt )
		self.NextAmmoRegeneration = CurTime() + 0.2

	end
	
end

/*-------------------------------------
	SWEP:PrimaryAttack()
-------------------------------------*/
function SWEP:PrimaryAttack()
	
	if self.Camo == true then
		self:SetCamo(false)
	else
		self:SetCamo(true)
	end
	
end

/*-------------------------------------
	SWEP:SecondaryAttack()
-------------------------------------*/
function SWEP:SecondaryAttack()
	
	self:PrimaryAttack()
	
end
