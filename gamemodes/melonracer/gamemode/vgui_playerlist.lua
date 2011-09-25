
PANEL.Base = "DPanel"

/*---------------------------------------------------------
   Name: gamemode:HUDThink
---------------------------------------------------------*/
function PANEL:Init()

	self:SetSkin( "melonracer" )
	self:SetPaintBackground( false )
	self:SetSize( 100, 32 )
	
	self.List 		= vgui.Create( "DListView", self )
	self.List:SetDrawBackground( false )
	self.List:SetSortable( false )
	
	local Place = self.List:AddColumn( "" )
	local Col1 = self.List:AddColumn( "" )
	local Col2 = self.List:AddColumn( "Lap" )
	local Wins = self.List:AddColumn( "Wins" )
	//local Losses = self.List:AddColumn( "Fails" )
	
	Place:SetMinWidth( 32 )
	Place:SetMaxWidth( 32 )
	
	Wins:SetMinWidth( 32 )
	Wins:SetMaxWidth( 32 )
	
	//Losses:SetMinWidth( 32 )
	//Losses:SetMaxWidth( 32 )	
	
	Col2:SetMinWidth( 64 )
	Col2:SetMaxWidth( 64 )
		
	self.NextThink = RealTime()
	
end

function STNDRD( num )

	num = tonumber( string.Right( tostring(num), 1 ) ) 

	if ( num == 1 ) then return "st" end
	if ( num == 2 ) then return "nd" end
	if ( num == 3 ) then return "rd" end
	
	return "th"

end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()

	if ( self.NextThink > RealTime() ) then return end
	self.NextThink = RealTime() + 0.1
	self.List:Clear()
	
	local Places = {}
	for k, ply in pairs( player.GetAll() ) do
		
		local place = ply:GetNWInt( "place", 99 )
		if ( place != 99 ) then
			Places[ place ] = ply
		end
		
	end
	
	for k, ply in SortedPairs( Places ) do
		self.List:AddLine( k .. STNDRD(k), ply:Nick(), ply:GetNWInt( "lap", "-" ).." / "..GAMEMODE:GetNumLaps(), ply:GetNWInt( "wins", "-" )/*, ply:GetNWInt( "losses", "-" ) */ )
	end

	self.List:DataLayout()
	
end


/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	self:SetSize( 300, 600 )
	self:SetPos( 10, ScrH()*0.1 )
	
	self.List:StretchToParent( 5,5,5,5 )
	
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self.List:GetInnerTall()+self.List:GetHeaderHeight()+10, Color(0,0,0,200) )
	
end
