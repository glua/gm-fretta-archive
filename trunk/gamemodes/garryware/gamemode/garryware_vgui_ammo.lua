PANEL.Base = "DPanel"

function PANEL:Init()
	self:SetSkin( G_GWI_SKIN )
	self:SetPaintBackground( false )
	self:SetVisible( true )
	
	self.colors = {}
	self.colors.Good     = Color(   0, 164, 237 )
	self.colors.Bad      = Color( 255,  87,  87 )
	self.colors.Border  =  Color( 255, 255, 255, 192 )
	
	self.dClip = vgui.Create("GWLabel", self)
	self.dClip:SetText("")
	self.dClip:SetFont( "garryware_largetext" )
	self.dClip:SetColor( color_white )
	self.dClip:SetZPos( 1500 )
	self.dClip:SetContentAlignment( 5 )
	self.dClip:SetBorderColor( self.colors.Border )
	
	
	self.dBox  = vgui.Create("GWLabel", self)
	self.dBox:SetText("")
	self.dBox:SetFont( "garryware_mediumtext" )
	self.dBox:SetColor( color_white )
	self.dBox:SetZPos( 2000 )
	self.dBox:SetContentAlignment( 5 )
	self.dBox:SetBorderColor( self.colors.Border )
	

	self.m_smalltext  = ""
	self.m_bigtext    = ""
	
	self.m_candraw = false
	
	self:InvalidateLayout( true )
	
end


function PANEL:PerformLayout()
	self:SetSize( 48 , 48 )
	self:SetPos( ScrW()*0.9 - self:GetWide() , ScrH()*0.9 - self:GetTall() )
	
	self.dClip:SetSize( self:GetWide() , self:GetTall() * 0.8 )
	self.dClip:SetPos( 0, 0 )
	
	self.dBox:SetSize( self:GetWide() * 0.8 , self:GetTall() * 0.37 )
	self.dBox:Center()
	self.dBox:AlignBottom()
	
end

function PANEL:Show()
	if self:IsVisible() then return end
	
	self:SetVisible( true )

end

function PANEL:Hide()
	if not self:IsVisible() then return end
	
	self:SetVisible( false )

end

function PANEL:Think()
	if ValidEntity(LocalPlayer()) and LocalPlayer():Alive() then
		local SWEP = LocalPlayer():GetActiveWeapon()
		self.tvars = {}
		
		if SWEP:IsValid() then
			self.tvars.clip1type = SWEP:GetPrimaryAmmoType() or ""
			self.tvars.clip1     = tonumber(SWEP:Clip1()) or -1
			self.tvars.clip1left = LocalPlayer():GetAmmoCount(self.tvars.clip1type)
			
		else
			self.tvars.clip1 = -1
			self.tvars.clip1left = -1
			
		end
		
		--Sweps, not the phys/gravgun...
		if self.tvars.clip1 >= 0 and self.tvars.clip1type ~= -1 then	
			local rate = -1
			if self.tvars.clip1 <= 0 then
				self.dClip:SetBackgroundColor( self.colors.Bad )
				
			else
				self.dClip:SetBackgroundColor( self.colors.Good )
				
			end
			
			if self.tvars.clip1left > 0 then
				self.m_smalltext = self.tvars.clip1left
				self.dBox:SetBackgroundColor( self.colors.Good )
				
			else
				self.m_smalltext = "x"
				self.dBox:SetBackgroundColor( self.colors.Bad )
				
			end
			
			self.m_bigtext = self.tvars.clip1
			self.m_candraw = true
		
		--Gravgun/nades
		elseif self.tvars.clip1left > 0 then
			self.m_bigtext = self.tvars.clip1left
			self.m_candraw = true
			
		else
			self.m_candraw = false
			
		end
		
	else
		self.m_candraw = false
	end
	
	if self.m_candraw then
		self.dClip:SetText( self.m_bigtext )
		self.dBox:SetText( self.m_smalltext )
		self.dClip:SetVisible( true )
		self.dBox:SetVisible( true )
		
	else
		self.dClip:SetVisible( false )
		self.dBox:SetVisible( false )
		
	end
	
end

--Derma_Hook( PANEL, "Paint", "Paint", "GWInstructions" )