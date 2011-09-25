include( "shared.lua" );

SWEP.PrintName				= "AS Sniper Base";
SWEP.Slot					= 0;
SWEP.SlotPos				= 0;
SWEP.ScopeTexture			= surface.GetTextureID( "weapons/scopes/scope2" );

function SWEP:ShouldDrawCrosshair() 

	local bIsSighted = self:IsIronsighted();
	local scopeTime = self.IronsightTime or 0.25;
	local fIronTime = self.fIronTime or 0
	
	if( !bIsSighted && !self.CrosshairUnscoped ) then
		return false;
	elseif( bIsSighted && CurTime() > fIronTime + scopeTime && self.CrosshairInScope ) then
		return true;
	elseif( bIsSighted && CurTime() > fIronTime + scopeTime ) then
		return false;
	end
	
	return true;
end

function SWEP:DrawScope()
		
	self.IronsightTime = self.IronsightTime or 0.25;
	self.fIronTime = self.fIronTime or CurTime()
		
	if( self.Weapon:GetNetworkedBool( "Ironsights", false ) == true && CurTime() >= ( self.fIronTime + self.IronsightTime ) ) then
		local w = (ScrH()/3)*4
		surface.SetDrawColor( 255, 255, 255, 255 );
		surface.SetTexture( self.ScopeTexture );
		surface.DrawTexturedRect( ( ScrW() / 2 ) - w/2, 0, w, ScrH() );
			
		surface.SetDrawColor( 0, 0, 0, 255 );
		surface.DrawRect( 0, 0, ( ScrW() / 2 ) - w/2, ScrH() )
		surface.DrawRect( ( ScrW() / 2 ) + w/2, 0, ScrW() - ( ( ScrW() / 2 ) + w/2 ), ScrH() )
	end	
end

function SWEP:DrawHUD()

	if( self:ShouldDrawCrosshair() ) then
		self:DrawCrosshairHUD()
	end
	
	self:DrawScope();
	
end

function SWEP:GetViewModelPosition( pos, ang )

	local vm = self:GetOwner():GetViewModel();
	
	self.IronsightTime = self.IronsightTime or 0.25;
	self.fIronTime = self.fIronTime or CurTime()
		
	if( self:IsIronsighted() ) then
		pos.z = pos.z - 99999;
		pos.x = pos.x - 99999;
	end
	
	return self:CalcViewModelEffects( pos, ang );
end