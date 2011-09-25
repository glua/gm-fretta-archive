include('shared.lua')

ENT.Velocity = Vector(0,0,1)

ENT.FriendMat = Material( "gta/defend" )
ENT.EnemyMat = Material( "gta/target" )

function ENT:Initialize()

	self.SmokeOffset = 50
	self.Emitter = ParticleEmitter( self.Entity:GetPos() )
	
end

function ENT:OnRemove()

	if not self.Emitter then return end

	self.Emitter:Finish()

end

function ENT:Think()

	local maxhp = self.StartHealth
	local hp = self.Entity:GetNWInt( "Health", 100 )
	
	local level = math.floor( ( hp / maxhp ) * 100 ) 
	
	if level >= 75 then return end
	
	local center = self.Entity:LocalToWorld( self.Entity:OBBCenter() ) + self.Entity:GetForward() * self.SmokeOffset + VectorRand() * 10
	
	if level < 10 then
	
		local col = math.random( 10, 50 )
		
		for i=1,math.random( 2, 4 ) do
		
			local particle = self.Emitter:Add( "effects/muzzleflash"..math.random( 1, 4 ), center + VectorRand() * 5 )

			particle:SetVelocity( ( self.Velocity * math.Rand( 30, 60 ) ) + WindVector )
			particle:SetDieTime( math.Rand( 0.5, 1.5 ) )
			particle:SetStartAlpha( 250 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 10, 50 ) )   
			particle:SetEndSize( 0 )      
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -2.0, 2.0 ) )
			particle:SetColor( math.Rand( 150, 255 ), math.Rand( 100, 150 ), 100 )
			
		end
	
		local particle = self.Emitter:Add( "particles/smokey", center )

		particle:SetVelocity( ( self.Velocity * math.Rand( 30, 60 ) ) + WindVector )
		particle:SetDieTime( math.Rand( 1.5, 3.0 ) )
		particle:SetStartAlpha( math.random( 50, 100 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 40 ) )
		particle:SetEndSize( math.Rand( 50, 100 ) )   
		particle:SetRoll( 0 )
		particle:SetRollDelta( 0 )
		particle:SetColor( col, col, col )
		
		return
	
	elseif level < 30 then
	
		local col = math.random( 50, 100 )
		local particle = self.Emitter:Add( "particles/smokey", center )

		particle:SetVelocity( ( self.Velocity * math.Rand( 25, 50 ) ) + WindVector )
		particle:SetDieTime( math.Rand( 1.5, 2.5 ) )
		particle:SetStartAlpha( math.random( 100, 150 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 40 ) )
		particle:SetEndSize( math.Rand( 50, 100 ) )   
		particle:SetRoll( 0 )
		particle:SetRollDelta( 0 )
		particle:SetColor( col, col, col )
		
		return

	elseif level < 50 then
	
		local col = math.random( 100, 150 )
		local particle = self.Emitter:Add( "particles/smokey", center )

		particle:SetVelocity( ( self.Velocity * math.Rand( 20, 40 ) ) + WindVector )
		particle:SetDieTime( math.Rand( 1.5, 2.5 ) )
		particle:SetStartAlpha( math.random( 50, 100 ) )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 40 ) )
		particle:SetEndSize( math.Rand( 50, 100 ) )   
		particle:SetRoll( 0 )
		particle:SetRollDelta( 0 )
		particle:SetColor( col, col, col )
		
		return
		
	elseif level < 75 then
	
		local col = math.random( 150, 200 )
		local particle = self.Emitter:Add( "particles/smokey", center )

		particle:SetVelocity( ( self.Velocity * math.Rand( 20, 40 ) ) + WindVector )
		particle:SetDieTime( math.Rand( 1.5, 2.5 ) )
		particle:SetStartAlpha( 50 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( math.Rand( 10, 40 ) )
		particle:SetEndSize( math.Rand( 50, 100 ) )    
		particle:SetRoll( 0 )
		particle:SetRollDelta( 0 )
		particle:SetColor( col, col, col )
		
		return
		
	end

end

function ENT:Draw()

	self.Entity:DrawModel()
	
	local dist = LocalPlayer():GetPos():Distance( self.Entity:GetPos() )
	
	if dist > 1000 or LocalPlayer() == self.Entity:GetOwner() then return end
	
	if LocalPlayer():Team() == TEAM_GANG then
		
		render.SetMaterial( self.EnemyMat ) 
		
	elseif LocalPlayer():Team() == TEAM_POLICE then
		
		render.SetMaterial( self.FriendMat )
		
	end
	
	local size = ScrW() * 0.025
	local alpha = 255 - ( 255 * ( dist / 1000 ) )	
	
	render.DrawSprite( self.Entity:LocalToWorld( self.Entity:OBBCenter() ) + Vector(0,0,75), size * 2, size, Color( 255, 255, 255, alpha ) ) 
	
end

