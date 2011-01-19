////////////////////////////////////////////////
// // GarryWare Gold                          //
// by Hurricaaane (Ha3)                       //
//  and Kilburn_                              //
// http://www.youtube.com/user/Hurricaaane    //
//--------------------------------------------//
// Ware Speedclock                            //
////////////////////////////////////////////////

PANEL.Base = "DPanel"

/*---------------------------------------------------------
   Name: gamemode:Init
---------------------------------------------------------*/
function PANEL:Init()
	
	self:SetPaintBackground( false )
	
	self.ShadeTexPath = "ware/interface/ware_shade"
	self.ShadeTexID   = surface.GetTextureID( self.ShadeTexPath )
	
	self.ClockTexPath = "ware/interface/ware_clock_two"
	self.ClockTexID   = surface.GetTextureID( self.ClockTexPath )
	
	self.TrotterTexPath = "ware/interface/ware_trotter"
	self.TrotterTexID   = surface.GetTextureID( self.TrotterTexPath )
	
	self.StartAngle = 15
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( ScrW(), ScrH() )
	self:SetPos( 0, 0 )
	
end

function PANEL:Think()
	self:InvalidateLayout()
end

function PANEL:Hide()
	self:SetVisible( false )
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Paint()	
	local achieved = 0
	local locked = 0
	if LocalPlayer():IsValid() then
		achieved = LocalPlayer():GetAchieved()
		locked = LocalPlayer():GetLocked()
		
	end
	
	surface.SetTexture( self.ClockTexID )
	if (CurTime() < gws_NextgameStart) then
		surface.SetDrawColor( 255,255,255,255 )
		
	elseif (CurTime() < gws_NextwarmupEnd) then
		surface.SetDrawColor( 255,245,165,255 )
		
	elseif (achieved == nil) then
		surface.SetDrawColor( 166,225,225,255 )
		
	elseif (achieved and not locked) then
		surface.SetDrawColor( 170,235,255,255 )
		
	elseif (achieved and locked) then
		surface.SetDrawColor( 60,180,244,255 )
		
	elseif (not achieved and not locked) then
		surface.SetDrawColor( 250,213,213,255 )
		
	elseif (not achieved and locked) then
		surface.SetDrawColor( 255,155,155,255 )
		
	else
		surface.SetDrawColor( 0,255,0,255 )
		
	end
	surface.DrawTexturedRectRotated( ScrW()*0.05, ScrH() - ScrH()*0.05 , 256, 256, self.StartAngle )
	
	
	surface.SetDrawColor( 255, 255, 255, 128 )
	surface.SetTexture( self.ShadeTexID )
	surface.DrawTexturedRectRotated( ScrW()*0.05, ScrH() - ScrH()*0.05 , 192, 192, self.StartAngle )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( self.TrotterTexID )
	
	local fSpecPercent = 0
	if (CurTime() < gws_NextgameStart) then
		fSpecPercent = (60 - (CurTime() - gws_NextgameStart)) / 60
	elseif (CurTime() < gws_NextwarmupEnd) then
		fSpecPercent = (gws_WarmupLen - (CurTime() - gws_NextwarmupEnd)) / gws_WarmupLen
	elseif (CurTime() < gws_NextgameEnd) then
		fSpecPercent = (gws_WareLen - (CurTime() - gws_NextgameEnd)) / gws_WareLen
	else
		fSpecPercent = 0
	end
	surface.DrawTexturedRectRotated( ScrW()*0.05, ScrH() - ScrH()*0.05 , 256, 256, 360 * fSpecPercent + 90 + self.StartAngle )

end
