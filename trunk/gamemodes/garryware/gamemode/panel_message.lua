local PANEL = {}

function PANEL:Init()
	self:SetPaintBackground( false )

	self.INS_DefFore   =  Color(255, 255, 255, 255)
	self.INS_DefBack   =  Color(128, 170, 128, 192)
	
	self.DYN_INS_Foreground   =  Color( 255, 0, 0, 128 )
	self.DYN_INS_Background   =  Color( 255, 0, 0, 128 )
	self.DYN_INS_Border       =  Color( 255, 255, 255, 128 )
	self.INS_BorderAlpha = 220
	
	self.INS_Time = 0
	self.INS_Text = ""
	
	self.__INS_AppearDuration = 0.16
	self.INS_RemainDuration = 5.0
	self.INS_RemainDurationDefault = 5.0
	--self.__INS_Y = 12/16
	
	self.__INS_BaseHeight  = 38
	self.__INS_ExtraBorder = 4
	self.__INS_Expand      = 2
	
	self._INS_Xc = 0
	self._INS_Yc = 0
	self._INS_Wc = 0
	self._INS_Hc = 0
	
	self._INS_Xb = 0
	self._INS_Yb = 0
	self._INS_Wb = 0
	self._INS_Hb = 0
	
	self._INS_Xt = 0
	self._INS_Yt = 0
	
	self:InvalidateLayout()
	
end

function PANEL:PrepareDrawData(sText, cFore, cBack, oftfRemainOverride)
	self:MakeDrawData(sText or "", cFore or self.INS_DefFore, cBack or self.INS_DefBack, oftfRemainOverride or self.INS_RemainDurationDefault)
	
end

function PANEL:MakeDrawData(sText, cFore, cBack, fRemainDuration)
	self.INS_RemainDuration = fRemainDuration
	self.INS_Time = CurTime()
	self.INS_Text = sText

	surface.SetFont( "garryware_instructions" )
	local wB, hB = surface.GetTextSize( self.INS_Text )
	
	self._INS_Wc = wB + self.__INS_BaseHeight
	self._INS_Hc = self.__INS_BaseHeight --cst
	self._INS_Xc = self.__INS_ExtraBorder * ( 1 + self.__INS_Expand )
	self._INS_Yc = self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) --cst
	
	self._INS_Wb = self._INS_Wc + self.__INS_ExtraBorder * 2
	self._INS_Hb = self._INS_Hc + self.__INS_ExtraBorder * 2 --cst
	self._INS_Xb = self.__INS_ExtraBorder * self.__INS_Expand
	self._INS_Yb = self.__INS_ExtraBorder * self.__INS_Expand --cst
	
	self._INS_Xt = (2 * self._INS_Xc + self._INS_Wc) / 2
	self._INS_Yt = (2 * self._INS_Yc + self._INS_Hc) / 2 --cst
	
	self.DYN_INS_Foreground.r = cFore.r
	self.DYN_INS_Foreground.g = cFore.g
	self.DYN_INS_Foreground.b = cFore.b
	
	self.DYN_INS_Background.r = cBack.r
	self.DYN_INS_Background.g = cBack.g
	self.DYN_INS_Background.b = cBack.b
	
	self:SetVisible( true )
	self:InvalidateLayout()
	
end

function PANEL:Think()
	if self:IsVisible() and (CurTime() - self.INS_Time) > self.INS_RemainDuration then
		self:SetVisible( false )
	end 
	
end

function PANEL:PerformLayout()
	self:SetWidth(  self._INS_Wb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
	self:SetHeight( self._INS_Hb + self.__INS_ExtraBorder * ( 1 + self.__INS_Expand ) * 2 )
	
end


function PANEL:Paint()
	if (CurTime() - self.INS_Time) > self.INS_RemainDuration then return false end -- Compensated by think
	
	local delta = CurTime() - self.INS_Time
	local visRate = (delta > self.__INS_AppearDuration) and (1 - (delta / self.INS_RemainDuration) ^ 3) or (delta / self.__INS_AppearDuration)
	local specialSize = (delta > self.__INS_AppearDuration) and 0 or ((1 - delta / self.__INS_AppearDuration) * self.__INS_ExtraBorder * self.__INS_Expand)
	self.DYN_INS_Border.a     = self.INS_BorderAlpha * visRate
	self.DYN_INS_Foreground.a = 255 * ((delta > self.__INS_AppearDuration) and visRate or 1)
	self.DYN_INS_Background.a = 255 * visRate

	
	draw.RoundedBox(self.__INS_ExtraBorder, self._INS_Xb - specialSize, self._INS_Yb - specialSize, self._INS_Wb + specialSize * self.__INS_Expand, self._INS_Hb + specialSize * self.__INS_Expand, self.DYN_INS_Border)
	draw.RoundedBox(self.__INS_ExtraBorder, self._INS_Xc - specialSize, self._INS_Yc - specialSize, self._INS_Wc + specialSize * self.__INS_Expand, self._INS_Hc + specialSize * self.__INS_Expand, self.DYN_INS_Background)
	
	draw.SimpleText(self.INS_Text, "garryware_instructions", self._INS_Xt, self._INS_Yt, self.DYN_INS_Foreground, 1, 1 ) -- 1 and 1 are alignment
	
	return true
	
end

vgui.Register( "GWMessage", PANEL, "DPanel" )