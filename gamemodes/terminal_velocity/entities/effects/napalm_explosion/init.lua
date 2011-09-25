local matRefraction	= Material( "sprites/heatwave" )

local tMats = {}

tMats.Glow1 = Material("sprites/light_glow02")
tMats.Glow2 = Material("sprites/yellowflare")
tMats.Glow3 = Material("sprites/redglow2")

for _,mat in pairs(tMats) do

	mat:SetMaterialInt("$spriterendermode",9)
	mat:SetMaterialInt("$ignorez",1)
	mat:SetMaterialInt("$illumfactor",8)
	
end

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.Pos = data:GetOrigin()
	self.Pos.z = self.Pos.z + 4
	self.DieTime = CurTime() + math.Rand(7,8)
	self.Size = 70
	self.Emitter = ParticleEmitter( self.Pos )
	
	for i=1,math.Rand(2,3) do
		local particle = self.Emitter:Add("sprites/light_glow02", self.Pos )
			particle:SetVelocity(Vector(0,0,0))
			particle:SetDieTime( math.Rand( 8, 9 ) )
			particle:SetStartAlpha( math.Rand(200, 220) )
			particle:SetEndAlpha( math.Rand(0,1) )
			particle:SetStartSize( self.Size * 50 )
			particle:SetEndSize( math.Rand( 1, 10 ) )
			particle:SetRoll( math.Rand( 10, 30 ) )
			particle:SetRollDelta( math.random( -1, 1 ) )
			particle:SetColor(220, 90, 20)
			particle:VelocityDecay( false )
	end
	self.Ang = Angle(0,0,0)
	for i=1, math.random(28,35) do
	
		self.Ang:RotateAroundAxis(self.Ang:Up(), (360/35))
		local forward = self.Ang:Forward()
		local particle = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Pos  )

		particle:SetVelocity( forward * math.Rand(90,120) )
		particle:SetDieTime( math.Rand( 7, 8 ) )
		particle:SetStartAlpha( math.Rand( 200, 240 ) )
		particle:SetEndAlpha( 1 )
		particle:SetStartSize( 48 )
		particle:SetEndSize( math.Rand( 220, 270 ) )
		particle:SetRoll( math.Rand( -180,180 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
		particle:VelocityDecay( true )	
				
	end
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	if self.DieTime - CurTime() > 0 then 
		self.Size = math.Clamp(self.Size/2, 1, 9999)
		return true
	else
		self.Emitter:Finish()
		return false	
	end
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )

end
