
include( "shared.lua" )
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]

ENT.blipdelta = 0
ENT.lastblip = 0

function ENT:Draw()

    --self.BaseClass.Draw(self)  			-- We want to override rendering, so don't call baseclass.
	
	if ( self.lastblip != self.Entity:GetBlip() ) then
		self.blipdelta = 1.5
		self.lastblip = self.Entity:GetBlip()
	end
	
	local divide = 0.125
	self.blipdelta = self.blipdelta + ( ( 1 - self.blipdelta ) * divide ) //Sophisticated stuff right here!
	local sc = self.blipdelta
	
	self.Entity:SetModelScale( Vector( sc, sc, sc ) )
    self.Entity:DrawModel()
	
	sc = ( sc - 1 ) * 200
	
	local ang = self.Entity:GetAngles()
	local forward = ang:Forward()
	local up = ang:Up()
	
	render.SetMaterial( Material( "sprites/light_glow02_add" ) )
	render.DrawSprite( self.Entity:GetPos() + ( up * 5 ), sc, sc, color_white )

end