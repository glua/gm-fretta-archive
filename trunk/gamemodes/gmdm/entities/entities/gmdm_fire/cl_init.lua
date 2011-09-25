

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()	

	self.Flame 	= Material( "particles/fire1" )
	self.Glow 	= Material( "particle/fire" )
	
	self.StartTime = CurTime()
	
	self.GlowSize 	= math.Rand( 64, 128 )
	
	
	self.Entity:SetCollisionBounds( Vector( -32, -32, -32 ), Vector( 32, 32, 0 ) )
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
end


local FADETIME = 0.5

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()

	if (self.Fires == nil) then return end
	
	local DieTime		= self.Entity:GetNetworkedFloat( 0 )
	
	if ( self.DownTrace == nil ) then
	
		local trace = {}
			trace.start 	= self.Entity:GetPos()
			trace.endpos 	= trace.start - self.Entity:GetAngles():Forward() * 128
			trace.filter 	= self.Entity
		self.DownTrace = util.TraceLine( trace )
	
	end
	
	local Mul = 1
	
	if ( self.StartTime + FADETIME > CurTime() ) then
	
		Mul = (self.StartTime + FADETIME) - CurTime()
		Mul = Mul / FADETIME
		Mul = 1 - Mul
	
	end
	
	if ( DieTime - FADETIME < CurTime() ) then
	
		Mul = CurTime() - (DieTime - FADETIME)
		Mul = Mul / FADETIME
		Mul = 1 - Mul
	
	end
	
	self.Angles 		= self.Entity:GetAngles()
	local Pos	 		= self.Entity:GetPos()
	local PlyAngles 	= LocalPlayer():GetAngles()
	self.ViewNormal 	= PlyAngles:Forward()
	
	self.Flame:SetMaterialFloat( "$alpha", Mul )
	render.SetMaterial( self.Flame )
		
	for k, v in pairs(self.Fires) do
	
		self:DrawFire( v, Mul )
	
	end

	self.Glow:SetMaterialFloat( "$alpha", Mul )
	render.SetMaterial( self.Glow )
	
	local SizeFlicker = math.Rand( 1, 32 )
	render.DrawQuadEasy( Pos - self.Angles:Forward() * 32 ,
					 self.DownTrace.HitNormal,
					 self.GlowSize + SizeFlicker, self.GlowSize + SizeFlicker,
					 Color( 255, 200-SizeFlicker, 100, Mul*255 ) )

end


function ENT:DrawFire( tab, mul )

	tab.Frame = tab.Frame + FrameTime() * tab.Speed
	if (tab.Frame > 53) then tab.Frame = 0 end

	self.Flame:SetMaterialFloat( "$frame", tab.Frame )

	render.DrawQuadEasy( tab.Pos,
						 self.ViewNormal,
						 tab.Width, tab.Height,
						 Color( 255, 255, 255, 255 ), self.Angles.pitch - 90 )
end


function ENT:Think()

	if (self.Fires != nil) then return end

	self.Fires = {}
	local Right = LocalPlayer():GetAngles():Right()
	
	local fire = {}
		fire.Pos 	= self.Entity:GetPos()
		fire.Width 	= math.Rand( 32, 64 )
		fire.Height = math.Rand( 64, 96 )
		fire.Speed 	= math.Rand( 25, 28 )
		fire.Frame 	= math.Rand( 0, 50 )

	table.insert( self.Fires, fire )
	
	for i=0,5 do
	
		local fire = {}
			fire.Pos 	= self.Entity:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0)  * math.Rand( 16, 32 )
			fire.Width 	= math.Rand( 16, 64 )
			fire.Height = math.Rand( 64, 96 )
			fire.Speed 	= math.Rand( 25, 28 )
			fire.Frame 	= math.Rand( 0, 50 )
			
		table.insert( self.Fires, fire )
	
	end
	
end


include('shared.lua')