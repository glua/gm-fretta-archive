local menu = {}
menu.Guns = {};

function menu:PerformLayout()	

	self.Guns = GAMEMODE.PrimaryWeapons;
	self.m_bBackgroundBlur = true;
	local loop = 5;
	
	for k, v in pairs( self.Guns ) do
		local btn = vgui.Create( "DButton" );
		btn:SetParent( self );
		
		btn:SetPos( 5, loop * 30 );
		btn:SetText( v.class );
		
		btn:SetConsoleCommand( "as_cl_primaryweapon", string.sub( k, 11 ) )
		
		btn:SetWide( 350 );
		btn:SetTall( 25 );
		
		loop = loop + 1
	end
	
	self:SetSize( 450, 350 );
	
	DFrame.PerformLayout( self );
end

derma.DefineControl( "DHudLoadout", "Derma-based Weapon Menu", menu, "DFrame" )

local lpanel;
function OpenLoadout( )

	if( !lpanel || !lpanel:IsValid() ) then
		lpanel = vgui.Create( "DHudLoadout" );
	end
	
	lpanel:SetVisible( true );
	lpanel:SetMouseInputEnabled( true );
	lpanel:MakePopup();
	lpanel:Center();
	
end
concommand.Add( "open_loadout_menu", OpenLoadout );
