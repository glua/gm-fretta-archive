
// The SWEP draws its own ammo display. Optionally.




// Don't draw Weapon Selection crap.
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	killicon.Draw( x + (wide/2), y + (tall*0.4), self:GetClass(), alpha );
end

function SWEP:ViewModelDrawn()
end

function SWEP:DrawCrosshairBit( x, y, width, height )

	surface.SetDrawColor( 0, 0, 0, 90 );
	surface.DrawRect( x, y, width, height );
	
	surface.SetDrawColor( cl_gmdm_xhair_r:GetInt(), cl_gmdm_xhair_g:GetInt(), cl_gmdm_xhair_b:GetInt(), cl_gmdm_xhair_a:GetInt() );	
	surface.DrawRect( x+1, y+1, width-2, height-2 );
	
end

cl_gmdm_xhair_r = CreateClientConVar( "crosshair_r", 255, true, false );
cl_gmdm_xhair_g = CreateClientConVar( "crosshair_g", 255, true, false );
cl_gmdm_xhair_b = CreateClientConVar( "crosshair_b", 255, true, false );
cl_gmdm_xhair_a = CreateClientConVar( "crosshair_a", 200, true, false );
cl_gmdm_xhair_scale = CreateClientConVar( "crosshair_scale", 1, true, false );
cl_gmdm_crosshair = GetConVar( "crosshair" );

function SWEP:DrawCrosshairHUD()
	
	if( self.DrawCrosshair == true ) then
		self.DrawCrosshair = false
	end
	
	if( cl_gmdm_crosshair:GetBool() == false ) then return end
	
	
	local scopeTime = self.ScopeTime or 0.25;
	local fIronTime = self.fIronTime or 0
	
	if( self.Weapon:GetNetworkedBool( "Ironsights", false ) && CurTime() > fIronTime + scopeTime ) then
		return
	end
	
	local x = ScrW()/2
	local y = ScrH()/2
	
	if( !self.Primary.Cone ) then
		self.Primary.Cone = 0.02;
	end
	
	local gap = ( 10 + (self.Primary.Cone * ( 260 * (ScrH()/720) ) ) * (1/self:GetStanceAccuracyBonus())) * cl_gmdm_xhair_scale:GetFloat();
	
	--local scopetime = self.ScopeTime or 1;
	--gap = gap * (1/scopetime);
	
	--local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 );
	
	gap = math.Clamp( gap, 0, (ScrH()/2)-100 );
	local length = ( gap + 15 ) * 0.6

	self:DrawCrosshairBit( x - gap - length, y - 1, length, 3 ) -- left
	self:DrawCrosshairBit( x + gap + 1, y - 1, length, 3 ) -- right
 	self:DrawCrosshairBit( x - 1, y - gap - length, 3, length ) -- top 
 	self:DrawCrosshairBit( x - 1, y + gap + 1, 3, length ) -- bottom

end

function SWEP:DrawHUD()

	self:DrawCrosshairHUD()
	
	local Clip = self.Weapon:Clip1()
	local Stash = self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() )
	
	if ( Clip == -1 ) then
	
		Clip = Stash
		Stash = nil
	else
	
		Stash = "/ " .. Stash
	
	end
	
	self.LastHealth = self.LastHealth or 0
	self.LastHealthChange = self.LastHealthChange or 0
	
	if ( Clip != self.LastHealth ) then
	
		self.LastHealth = Clip
		self.LastHealthChange = CurTime()
	
	end

	//GAMEMODE:DrawInfoTab( 0.7, Clip, Stash, Color( 255, 200, 200, 200 ), Color( 255, 0, 0, 200 ), self.LastHealthChange )
	
	//GM:DrawInfoTab( XPos, Text, SmallText, BGColor, FontColor )
	
	//draw.SimpleText( "128", "GMDMAmmo_Large", ScrW() - 200, g_WeaponHUDAmmoStart, Color(0, 250, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )

end

