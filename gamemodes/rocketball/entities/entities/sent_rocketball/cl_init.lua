include('shared.lua')
 
ENT.RenderGroup                 = RENDERGROUP_TRANSLUCENT
 
local matBall = Material( "sprites/sent_ball" )
 
/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
        self.LightColor = Vector( 0, 0, 0 )
end
 
/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
       
        local pos = self.Entity:GetPos()
        local vel = self.Entity:GetVelocity()
		local rr,gg,bb,aa = self.Entity:GetColor()
		
        render.SetMaterial( matBall )
       
        local lcolor = render.GetLightColor( self:GetPos() ) * 2
       
        lcolor.x = rr * mathx.Clamp( lcolor.x, 0, 1 )
        lcolor.y = gg * mathx.Clamp( lcolor.y, 0, 1 )
        lcolor.z = bb * mathx.Clamp( lcolor.z, 0, 1 )
               
        if ( vel:Length() > 1 ) then
       
                for i = 1, 10 do
               
                        local col = Color( lcolor.x, lcolor.y, lcolor.z, 200 / i )
                        render.DrawSprite( pos + vel*(i*-0.005), 32, 32, col )
                       
                end
       
        end
               
        render.DrawSprite( pos, 32, 32, Color( lcolor.x, lcolor.y, lcolor.z, 255 ) )
       
end

function ENT:Think()
	local Ang = self.Entity:GetAngles()
	local Pos = self.Entity:GetPos() + (Ang:Up() * 9)
	local AngVec = self.Entity:GetAngles():Forward()
	local Offset = Pos + (AngVec * -5)
	local rcolor = math.random(160, 190)
	local team  = self.Entity:GetOwner():Team()
	
	local emitter = ParticleEmitter( Offset )
	
	local particle = emitter:Add( "particle/smokestack", Offset + Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5)))
	particle:SetVelocity( Vector(math.random(-5,5),math.random(-5,5),math.random(-5,5)+20) )
	particle:SetDieTime( 1 )
	particle:SetStartAlpha( 150 )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( 4 )
	particle:SetEndSize( 10 )
	particle:SetRoll( math.Rand( -2, 2 ) )
	particle:SetRollDelta( 0 )
	particle:SetAirResistance(0)
	
	if team != nil then
		if team == 1 then
			particle:SetColor( rcolor,rcolor,240 )
		else
			particle:SetColor( 240,rcolor,rcolor )
		end
	else
		particle:SetColor( rcolor,rcolor,rcolor )
	end
			
	emitter:Finish()
end