EFFECT.Mat = Material( "effects/yellowflare" )
EFFECT.Color = Color( 119, 199, 255, 128 )
EFFECT.NumPins = 10
EFFECT.CirclePrecision = 24
EFFECT.Thickness = 2

function EFFECT:Init( data )
	print("harmonicsgenerating")
	self.Origin  = data:GetOrigin()
	self.Extrema = data:GetStart()
	local angleFake = data:GetAngle()
	self.Color = Color( angleFake.p, angleFake.y, angleFake.r )
	
	self.Distance = (self.Origin - self.Extrema):Length()
	
	self.Entity:SetRenderBoundsWS( Vector(-1000,1000,64), Vector(9000,9000,1000) )
	
	self.VD = {}
	for i = 1, 3 do
		table.insert(self.VD, 0 )
		table.insert(self.VD, ((math.random(0, 1) == 1) and 1 or -1) * math.Rand(0.7,3) )
	end
	
	self.BaseCircle = {}
	for d = 0, 359, (360 / self.CirclePrecision) do
		table.insert( self.BaseCircle, Vector( math.cos( math.rad(d) ) * self.Distance, math.sin( math.rad(d) ) * self.Distance, 0) )
	end
	
	self.SubSequents = {}
	for i=1,self.NumPins do
		self.SubSequents[i] = {}
		for k=1,self.CirclePrecision do
			table.insert( self.SubSequents[i], Vector(0,0,0) )
		end
	end
	
end

function EFFECT:Think( )
	return true
	
end

function EFFECT:CalculateAngle( iPhasis )
	return Angle( iPhasis * self.VD[2], iPhasis * self.VD[4], iPhasis * self.VD[6] )
end

function EFFECT:Render( )
	local phasis = math.floor(CurTime() * 10)
	
	render.SetMaterial( self.Mat )
	for i = 0, (self.NumPins - 1) do
		local angled = self:CalculateAngle( phasis - i )
		for k,_ in pairs( self.SubSequents[i+1] ) do
			GC_VectorCopy(self.SubSequents[i+1][k], self.BaseCircle[k])
			-- Rotate modiffies the original vector
			self.SubSequents[i+1][k]:Rotate( angled )
			self.SubSequents[i+1][k] = self.SubSequents[i+1][k] + self.Origin
			
		end
		for k,_ in pairs( self.SubSequents[i+1] ) do
			self.Color.a = 255 * (self.NumPins - i / self.NumPins)
			render.DrawBeam( self.SubSequents[i+1][k], 		
							 self.SubSequents[i+1][(k % self.CirclePrecision) + 1],
							 self.Thickness * (self.NumPins - i / self.NumPins),					
							 0.5,					
							 0.5,				
							 self.Color )
		end
		
	end
	
end
