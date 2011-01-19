
local matRefract = Material( "models/spawn_effect" )
local matLight	 = Material( "models/spawn_effect2" )

function EFFECT:Init( data )

	self.Time = 0.5
	self.LifeTime = CurTime() + self.Time
	
	local ent = data:GetEntity()
	if ( ent == NULL ) then return end
	
	self.ParentEntity = ent
	self.Entity:SetModel( ent:GetModel() )
	self.Entity:SetPos( ent:GetPos() )
	self.Entity:SetAngles( ent:GetAngles() )
	self.Entity:SetParent( ent )
	
end

function EFFECT:Think( )

	if (!self.ParentEntity || !self.ParentEntity:IsValid()) then return false end

	return ( self.LifeTime > CurTime() ) 
	
end

function EFFECT:Render()

	local Fraction = (self.LifeTime - CurTime()) / self.Time
	Fraction = math.Clamp( Fraction, 0, 1 )
	
	self.Entity:SetColor( 255, 255, 255, Fraction * 255 )

	local EyeNormal = self.Entity:GetPos() - EyePos()
	local Distance = EyeNormal:Length()
	EyeNormal:Normalize()
	
	local Pos = EyePos() + EyeNormal * Distance * 0.01

	cam.Start3D( Pos, EyeAngles() )

		SetMaterialOverride( matLight )
			self.Entity:DrawModel()
		SetMaterialOverride( 0 )

		if ( render.GetDXLevel() >= 80 ) then
		
			render.UpdateRefractTexture()
			
			matRefract:SetMaterialFloat( "$refractamount", Fraction ^ 3 )

			SetMaterialOverride( matRefract )
				self.Entity:DrawModel()
			SetMaterialOverride( 0 )
		
		end

	cam.End3D()

end



