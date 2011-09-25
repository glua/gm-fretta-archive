local PANEL = {}
PANEL.TextInfo = {}
PANEL.Font = "As28DaysSmall"
PANEL.DefaultColor = Color( 255, 255, 255 );
PANEL.DrawDropShadow = true;
PANEL.MessageKeepTime = 5;
PANEL.TotalWidth = 0;
PANEL.LastAddTime = 0;

function PANEL:Init()
	self:SetSize( ScrW(), ScrH() );
	self:SetPos( 0, 0 );
	self:SetVisible( true );
	
	self:ParentToHUD();
end

function PANEL:Paint()

	local xpos = ( ScrW() / 2 ) - ( self.TotalWidth / 2 );
	local alpha = 255;
	surface.SetFont( self.Font );
	
	if( CurTime() > self.LastAddTime + self.MessageKeepTime ) then
		local timeover = CurTime() - self.LastAddTime - self.MessageKeepTime;
		alpha = 255 - ( timeover * 255 );
		
		if( alpha <= 0 ) then
			self:Clear();
			return;
		end
	end
	
	for k, v in pairs( self.TextInfo ) do
		
		if( self.DrawDropShadow ) then
			surface.SetTextColor( 0, 0, 0, alpha );
			surface.SetTextPos( xpos + 2, ( ScrH() * 0.75 ) + 2 );
			surface.DrawText( v.content );		
		end
		
		surface.SetTextColor( v.textcol.r, v.textcol.g, v.textcol.b, alpha );
		surface.SetTextPos( xpos, ScrH() * 0.75 );
		surface.DrawText( v.content );
		
		xpos = xpos + v.width;
		
	end
	
end

function PANEL:Clear()
	self.TextInfo = {};
	self.TotalWidth = 0;
	self.LastAddTime = 0;
end

function PANEL:AddText( text, color )
	local col = color or self.DefaultColor;
	local w, h = self:CalcTextSize( text );
	
	table.insert( self.TextInfo, { content = text, textcol = col, width = w, height = h } );
	self.TotalWidth = self.TotalWidth + w; // pre calculate this so we don't have to do it all the time. (two loops)
	self.LastAddTime = CurTime();
end

function PANEL:AddPlayer( player )
	if( IsValid( player ) ) then
		self:AddText( player:Name(), team.GetColor( player:Team() ) );
	end
end

function PANEL:ShowBasicMessage( text )
	self:Clear();
	self:AddText( text );
end

// Macro func, calculate the size of text, returns as w, h
function PANEL:CalcTextSize( text )
	surface.SetFont( self.Font );
	return surface.GetTextSize( text );
end

vgui.Register( "AsMessageCenter", PANEL );