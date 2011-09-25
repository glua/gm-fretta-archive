local PANEL = {}

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	//Set up icon values
	self.IconFile = "gui/cactus"
	self.IconID   = surface.GetTextureID( self.IconFile )

	self.StartSize = {}
	self.StartPos = {}

	self.Wiggle = false
	self.Amplitude = nil
	self.Offset = 0
	self.Frequency = 5
	self.Ang = 5

	self.Caught = false
	self.CType = nil
	self.CColor = {}
	self.DefaultColor = color_white
	
end
function PANEL:SetAmplitude( amp )

	self.Amplitude = amp
	if amp == nil then return end
	
end
function PANEL:SetWiggle( on )

	self.Wiggle = on
	if on == nil then return end
	
end
function PANEL:SetCaught( on, typ )

	self.Caught = on
	
	if !Cactus.GetType(typ) then
		self.DefaultColor = color_white
	else
		self.NextColor = Cactus.GetType(typ)["CColor"]
	end
	if on == nil then return end

end

function PANEL:PerformLayout()
	
	local w, h = surface.GetTextureSize( self.IconID )
	self:SetSize( w/3, h/3 )
	self:SetPos( 220, ScrH()-self:GetTall()-10 )
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )
	
	if self.Caught then
		
		self:ColorTo(self.NextColor, 1, 0)
		
	else
		
		if LocalPlayer():IsCactus() then
			self.DefaultColor = LocalPlayer():GetCactusData("CColor")
			self:ColorTo(self.DefaultColor, 1, 0)
		end
		
	end
	
end

function PANEL:Paint()

	//Our color change code
	
	surface.SetDrawColor( self.DefaultColor )
	
	surface.SetTexture( self.IconID )
	
	
	local x,y = 0, 0
	local w,h = self:GetWide(), self:GetTall()
	
	local health = LocalPlayer():Health()
	local hp_fraction = health/LocalPlayer():GetMaxHealth()
	local drop = h*hp_fraction
	
	//Our wiggle code
	if self.Wiggle then
		local ampdiv = (self.Amplitude/2)
		local rot = TimedSin( self.Frequency + ampdiv, -self.Ang - ampdiv, self.Ang + ampdiv, self.Offset ) * ampdiv --freq, ang low, ang up, offset * amp
		surface.DrawTexturedRectRotated( x+w/2, y+h/2, w, h, rot )	
	else
		surface.DrawTexturedRect( x, y, w, h )
	end

	
end

function PANEL:Think()
	self:InvalidateLayout()
end

 
vgui.Register( "DHudCactusIcon", PANEL, "DPanel" )