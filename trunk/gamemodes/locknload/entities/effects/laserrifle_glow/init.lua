EFFECT.MatStart = Material("Sprites/light_glow02_add")

function EFFECT:Init( data )
	self.Player = data:GetEntity()
	self.Attachment = data:GetAttachment()
	if ValidEntity(self.Player) and ValidEntity(self.Player:GetActiveWeapon()) then
		self.Weapon = self.Player:GetActiveWeapon():GetClass()
		self.Color = Color (255,255,255,255)
		self.ChargeTime = 1.7
		local ft = self.Player:GetActiveWeapon():GetNWInt ("ft", 0)
		if ft == 1 then
			self.Color = Color (255,150,150,255)
		elseif ft == 2 then
			self.Color = Color (255,255,150,255)
			self.ChargeTime = 1.2
		elseif ft == 3 then
			self.Color = Color (150,150,255,255)
			self.ChargeTime = 2.2
		end
		self.Alpha = 0.2
	end
	
	printd( "Laser rifle glow init ", self.Player, "CLIENT:", CLIENT )
end

function EFFECT:AttachmentPosition( attachment )
	local vm = self.Player:GetActiveWeapon()
	if ( !ValidEntity( vm ) ) then return end
	if ( self.Player == LocalPlayer() ) then
		vm = LocalPlayer():GetViewModel()
	end
	
	local attach = vm:GetAttachment( attachment )
	if ( !attach ) then return end
	
	return attach.Pos
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	if (!self.Alpha) or (!self.ChargeTime) then return false end
	
	self.StartPos = self:AttachmentPosition( self.Attachment )
	
	if !self.StartPos then return true end
	self.Entity:SetRenderBoundsWS( self.StartPos, self.StartPos )
	
	if ( !ValidEntity( self.Player ) ) then return false end
	local weap = self.Player:GetActiveWeapon()
	if ( !ValidEntity( weap ) ) then return false end
	if ( !weap:GetNWBool( "chg" ) ) then return false end

	return true
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )
	
	if (!self.Alpha) or (!self.ChargeTime) then return end
	self.Alpha = math.min (1, self.Alpha + FrameTime() * 0.8 / self.ChargeTime)
	--print (self.Alpha)
	
	if ( !self.StartPos ) then return end
	
	render.SetMaterial(self.MatStart)
	render.DrawSprite (self.StartPos, 16, 16, Color(self.Color.r * self.Alpha, self.Color.g * self.Alpha, self.Color.b * self.Alpha, 255))
	render.DrawSprite (self.StartPos, 16, 16, Color(self.Color.r * self.Alpha, self.Color.g * self.Alpha, self.Color.b * self.Alpha, 255))
	--render.DrawSprite (self.StartPos, 16, 16, self.Color)

end
