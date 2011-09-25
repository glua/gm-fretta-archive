include( "shared.lua" );
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

function ENT:Initialize()
	
	self:SetModel( "models/props_junk/PopCan01a.mdl" );
	
end

function ENT:SetOnGet( func )
	
	self.OnGet = func;
	
end

function ENT:SetOnEndTime( func )
	
	self.OnEndTime = func;
	
end

function ENT:SetTime( t )
	
	self.Time = t;
	
end

function ENT:SetTText( text )
	
	self:SetNWString( "text", text );
	
end

function ENT:SetTColor( col )
	
	self:SetNWVector( "color", Vector( col.r, col.g, col.b ) );
	
end

function ENT:SetRenderMat( indx )
	
	self.RenderMat = indx;
	
end

function ENT:FadeAway()
	
	self:SetNWInt( "FadeStart", CurTime() );
	
	timer.Simple( 1, function()
		
		self:Remove();
		
	end );
	
end
