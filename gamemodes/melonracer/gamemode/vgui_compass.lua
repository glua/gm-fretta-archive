
local PANEL = {}

/*---------------------------------------------------------
   Init
---------------------------------------------------------*/
function PANEL:Init()

	self:SetModel( "models/props_c17/doll01.mdl" )
	
	self.Visible = false
	self:SetPos( ScrW()-1, 0 )
	
	self:PerformLayout()
	
end

/*---------------------------------------------------------
   Think
---------------------------------------------------------*/
function PANEL:Think()


end

/*---------------------------------------------------------
   LayoutEntity
---------------------------------------------------------*/
function PANEL:LayoutEntity( Entity )

	if (!IsValid(LocalPlayer())) then return end

	self:SetCamPos( Vector( 0, 20, 0 ) )
	self:SetLookAt( Vector( 0, 0, 0 ) )
	
	local TargetDir = LocalPlayer():GetNWVector( "CPDir", Vector(0,0,0) )
	
	if ( TargetDir == Vector(0,0,0) && self.Visible ) then
		self:MoveTo( ScrW()-1, 0, 1, 0, 0.5 )
		self.Visible = false
	elseif ( TargetDir != Vector(0,0,0) && !self.Visible ) then
		self:MoveTo( ScrW()-self:GetWide(), 0, 1, 0, 2 )
		self.Visible = true
	end
	
	local TargetDir = (LocalPlayer():EyePos() - TargetDir)
	TargetDir.z = 0
	
	local DIR = TargetDir:Angle()
	local EYEANGLE = LocalPlayer():EyeAngles()
	
	EYEANGLE.pitch = 0
	local DIR = DIR - EYEANGLE
	
	Entity:SetPos( Vector( 0, 0, 0 ) )
	Entity:SetAngles( DIR + Angle( 70, 90, 0 ) )

end


/*---------------------------------------------------------
   PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( ScrW()*0.3, ScrW()*0.3 )

end

if ( Compass ) then Compass:Remove() end
Compass = vgui.CreateFromTable( vgui.RegisterTable( PANEL, "DModelPanel" ) )