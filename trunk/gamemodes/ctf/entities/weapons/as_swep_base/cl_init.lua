include( "shared.lua" );
include( "cl_viewmodel.lua" );

SWEP.CrosshairScale		= 1.7; // default crosshair scale (crosshair_scale multiplies on top of this
SWEP.ScopeTexture		= surface.GetTextureID( "weapons/scopes/scope2" ); // for scoped weapons, default scope

if( CLIENT ) then
	SWEP.PrintName				= "AS SWEP Base";
	SWEP.Slot					= 0;
	SWEP.SlotPos				= 0;
	
	crosshair_r = CreateClientConVar( "crosshair_r", 255, true, false );
	crosshair_g = CreateClientConVar( "crosshair_g", 255, true, false );
	crosshair_b = CreateClientConVar( "crosshair_b", 255, true, false );
	crosshair_a = CreateClientConVar( "crosshair_a", 200, true, false );
	crosshair_scale = CreateClientConVar( "crosshair_scale", 1, true, false );
	crosshair = GetConVar( "crosshair" );
end

/*
	CROSSHAIR
*/


function SWEP:DrawCrosshairBit( x, y, width, height, alpha )

	surface.SetDrawColor( 0, 0, 0, alpha );
	surface.DrawRect( x, y, width, height );
	
	surface.SetDrawColor( crosshair_r:GetInt(), crosshair_g:GetInt(), crosshair_b:GetInt(), alpha );	
	surface.DrawRect( x+1, y+1, width-2, height-2 );
	
end

function SWEP:DrawCrosshairHUD()
	
	if( !self.LastCrosshairGap ) then
		self.LastCrosshairGap = 0;
	end
	
	if( self.DrawCrosshair == true ) then
		self.DrawCrosshair = false
	end
	
	if( crosshair:GetBool() == false ) then return end
	
	
	local scopeTime = self.ScopeTime or 0.25;
	local fIronTime = self.fIronTime or 0
	
	if( self.Weapon:GetNetworkedBool( "Ironsights", false ) && CurTime() > fIronTime + scopeTime ) then
		return
	end
	
	local x = ScrW()/2
	local y = ScrH()/2
	
	if( self.Owner ) then
		local trace = self.Owner:GetEyeTrace();
		if( trace and trace.HitPos ) then
			local localpos = trace.HitPos:ToScreen();
			
			x = localpos.x;
			y = localpos.y;
		end
	end
	
	if( !self.Primary.Cone ) then
		self.Primary.Cone = 0.02;
	end
	
	local gap = math.Approach( self.LastCrosshairGap, ( (self.Primary.Cone * ( 260 * (ScrH()/720) ) ) * (1/self:GetAccuracyModifier())) * ( crosshair_scale:GetFloat() * self.CrosshairScale ), FrameTime() * 50 );
	gap = math.Clamp( gap, 0, (ScrH()/2)-100 );
	local length = ( gap + 13 ) * 0.6
	local alpha = crosshair_a:GetInt();
	
	if( gap > 40 * (ScrH()/720) ) then
		local overgap = gap - ( 40 * (ScrH()/720) )
		local newalpha = alpha - (overgap * 4);
		
		alpha = math.Clamp( newalpha, 0, 255 );
	end
	
	if( alpha > 0 ) then
		self:DrawCrosshairBit( x - gap - length, y - 1, length, 3, alpha ) -- left
		self:DrawCrosshairBit( x + gap + 1, y - 1, length, 3, alpha ) -- right
		self:DrawCrosshairBit( x - 1, y - gap - length, 3, length, alpha ) -- top 
		self:DrawCrosshairBit( x - 1, y + gap + 1, 3, length, alpha ) -- bottom
	end
	
	self.LastCrosshairGap = gap;

end

function SWEP:DrawScope()
	
	local bIron = self.Weapon:GetNetworkedBool( "Ironsights", false )	
	local fIronTime = self.fIronTime or 0
		
	if( bIron && CurTime() > fIronTime + self.IronsightTime ) then
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

	if( self.ScopedWeapon ) then
		self:DrawScope();
	end
	
	self:DrawCrosshairHUD()
	
end