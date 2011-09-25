/*---------------------------------------------------------
	EFFECT:Init(data)
---------------------------------------------------------*/
function EFFECT:Init(data)
	
	self.WeaponEnt 	= data:GetEntity()
	self.Attachment 	= data:GetAttachment()

	if not (self.WeaponEnt:IsValid() and self.WeaponEnt:IsWeapon()) then return end
	
	self.Normal 	= data:GetNormal()

	if self.WeaponEnt:IsCarriedByLocalPlayer() and GetViewEntity() == LocalPlayer() then 
	
		local ViewModel 	= LocalPlayer():GetViewModel()
		if not ViewModel:IsValid() then return end
				
		self.EjectionPort = ViewModel:GetAttachment(self.Attachment)
		if not self.EjectionPort then return end

		self.Angle 		= self.EjectionPort.Ang
		self.Forward 	= self.Angle:Forward()
		self.Position 	= self.EjectionPort.Pos
	else
		self.EjectionPort = self.WeaponEnt:GetAttachment(self.Attachment)
		if not self.EjectionPort then return end
		
		self.Forward 	= self.Normal:Angle():Right()
		self.Angle 		= self.Forward:Angle()
		self.Position 	= self.EjectionPort.Pos - (0.5 * self.WeaponEnt:BoundingRadius()) * self.EjectionPort.Ang:Forward()	
	end

	local AddVel 		= self.WeaponEnt:GetOwner():GetVelocity()

	local effectdata 		= EffectData()
		effectdata:SetOrigin(self.Position)
		effectdata:SetAngle(self.Angle)
		effectdata:SetEntity(self.WeaponEnt)
		util.Effect("ShotgunShellEject", effectdata)
end

/*---------------------------------------------------------
	EFFECT:Think()
---------------------------------------------------------*/
function EFFECT:Think()

	return false
end

/*---------------------------------------------------------
	EFFECT:Render()
---------------------------------------------------------*/
function EFFECT:Render()
end