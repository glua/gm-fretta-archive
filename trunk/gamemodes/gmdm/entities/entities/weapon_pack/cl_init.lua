
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

/*---------------------------------------------------------
   Name: Draw
   Desc: Draw it!
---------------------------------------------------------*/
function ENT:Draw()
	self.Entity:DrawModel()

	dLight = DynamicLight( self:EntIndex() );
	
	if( dLight ) then
		dLight.Pos = self:GetPos();
		dLight.r = 255;
		dLight.g = 0;
		dLight.b = 0;
		dLight.Brightness = 3;
		dLight.Decay = 0;
		dLight.Size = 35;
		dLight.DieTime = CurTime() + FrameTime() + 0.05;
	end
end

/*---------------------------------------------------------
   Name: DrawTranslucent
   Desc: Draw translucent
---------------------------------------------------------*/
function ENT:DrawTranslucent()

	// This is here just to make it backwards compatible.
	// You shouldn't really be drawing your model here unless it's translucent

	self:DrawEntityOutline( 2.0 );
	self:Draw()
	
end
