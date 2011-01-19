EFFECT.Mat = Material( "effects/yellowflare" )
EFFECT.Color = Color( 119, 199, 255, 128 )
EFFECT.NumPins = 10
EFFECT.CirclePrecision = 6
EFFECT.Thickness = 8
--EFFECT.ShiftDistance = 16
EFFECT.LastPhasis = 0

EFFECT.AngleDump = Angle(0,0,0)

function EFFECT:Init( data )
	self.Origin  = data:GetOrigin()
	self.Extrema = data:GetStart()
	self.Radius = data:GetRadius()
	self.Speed = data:GetMagnitude()
	local angleFake = data:GetAngle()
	self.Duration = data:GetScale()
	self.Birth = CurTime()

	self.AngleDiff = (self.Extrema - self.Origin):Angle().y - 360 / (6 * 2)
	
	self.Color = Color( angleFake.p, angleFake.y, angleFake.r )
	self.BaseAlpha = self.Color.a
	
	self.Distance = (self.Origin - self.Extrema):Length()
	
	self.Entity:SetRenderBoundsWS( self.Origin + Vector(1,1,1) * self.Radius * -1.5, self.Origin + Vector(1,1,1) * self.Radius * 1.5 )
	
	self.VD = {}
	for i = 1, 3 do
		table.insert(self.VD, math.random(0, 180) )
		table.insert(self.VD, ((math.random(0, 1) == 1) and 1 or -1) * math.Rand(7,15) )
		table.insert(self.VD, math.Rand(1,3) )
	end
	
	self.BaseCircle = {}
	for d = 0, 359, (360 / self.CirclePrecision) do
		local na = d + self.AngleDiff
		table.insert( self.BaseCircle, Vector( math.cos( math.rad(na) ) * self.Distance, math.sin( math.rad(na) ) * self.Distance, 0) )
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
	if CurTime() > (self.Birth + self.Duration) then
		return false
	end

	return true
	
end

function EFFECT:CalculateAngle( iPhasis , angleToModify )
	angleToModify.p = math.sin(math.rad(self.VD[1] + iPhasis * self.VD[2])) * self.VD[3]
	angleToModify.y = math.sin(math.rad(self.VD[4] + iPhasis * self.VD[5])) * self.VD[6]
	angleToModify.r = math.sin(math.rad(self.VD[7] + iPhasis * self.VD[8])) * self.VD[9]
end

function EFFECT:Render( )
	local phasis = math.floor(CurTime() * self.Speed)
	
	render.SetMaterial( self.Mat )
	local alphamul = 1.0 - ((CurTime() - self.Birth) / self.Duration) ^ 4
	for i = 1, self.NumPins do
		local delta = (self.NumPins - i + 1) / self.NumPins
		
		if phasis ~= self.LastPhasis then
			self:CalculateAngle( phasis - i , self.AngleDump )
			for k,_ in pairs( self.SubSequents[i] ) do
				self.SubSequents[i][k].x = self.BaseCircle[k].x * (1 - delta)
				self.SubSequents[i][k].y = self.BaseCircle[k].y * (1 - delta)
				--self.SubSequents[i][k].z = i * self.ShiftDistance * (1 - delta)
				self.SubSequents[i][k].z = 0
					
				-- Rotate modiffies the original vector
				self.SubSequents[i][k]:Rotate( self.AngleDump )
				self.SubSequents[i][k] = self.SubSequents[i][k] + self.Origin
				
			end
		end
		
		for k,_ in pairs( self.SubSequents[i] ) do
			self.Color.a = self.BaseAlpha * delta * alphamul
			render.DrawBeam( self.SubSequents[i][k], 		
							 self.SubSequents[i][(k % self.CirclePrecision) + 1],
							 self.Thickness,					
							 0.5,					
							 0.5,				
							 self.Color )
		end
		
	end
	self.LastPhasis = phasis
	
end
