include('shared.lua')

local matRefraction	= Material( "sprites/gmdm_pickups/base_r" )
local matLight 		= Material( "sprites/gmdm_pickups/light" )

function ENT:Initialize()
	self.Spin=0
end

function ENT:Draw()

	if( GetConVarNumber( "gmdm_instagib" ) == 2 ) then return end

		local timeToRespawn=math.Clamp(255*(math.Clamp(self:GetActiveTime()-CurTime(),0,5)/5),0,254)
		local realPos=self.Entity:GetPos()
		local bopPos=realPos+Vector(0,0,5*math.sin(CurTime()))
		
		--self.Entity:SetPos(bopPos) -- Make it bop up and down ///////////////////////////// Why is this only moving the 2nd drawmodel????
		
		-- Spin and draw it
		 self.Spin=self.Spin+1
		 self.Entity:SetAngles(Angle(0,self.Spin,0))
		 self.Entity:SetModelWorldScale(Vector(1,1,1))
		 self.Entity:SetMaterial("")
		 
		 self.Entity:SetColor(255,255,255,255-timeToRespawn)
		 self.Entity:DrawModel()
		
		

	
	if ( self:GetActiveTime() > CurTime() ) then
			
		render.SetMaterial( matLight )
		render.DrawSprite( self.Entity:GetPos(), 15, 15, Color( 0, 0, 255, 128 ) )
		
		local RefractAmount = 0.00

		local inval=self:GetActiveTime()-CurTime()
		RefractAmount = RefractAmount + ( math.sin( inval * 2 ) * 0.03 )
		matRefraction:SetMaterialFloat( "$refractamount", RefractAmount * -1 )
		render.SetMaterial( matRefraction )
		render.UpdateScreenEffectTexture()
		render.DrawSprite( self.Entity:GetPos(), 15, 15 )

	else
		-- Enlarge it, materialise it, draw it
		 self.Entity:SetModelScale(Vector(1.8,1.8,1.8))
		 self.Entity:SetMaterial("models/props_combine/portalball001_sheet")
		 --self.Entity:SetColor(255,255,255,255) -- This makes it draw more solidly on top of the previous but calling this makes the previous setcolor have no effect. Got to live with it.
		 self.Entity:DrawModel()
	end
		--self.Entity:SetPos(realPos) -- uncomment once issue above  with previous setpos is resolved
end
