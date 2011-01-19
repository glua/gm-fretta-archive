
include( "shared.lua" )
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]

local mat = Material( "models/fw/flaginner" )
local col = Vector( 0, 0, 0 )
local progress = 0
local changing = false

function ENT:Think()
	
	local goalcol = self.Entity:GetNWVector( "RColor", Vector( 1, 1, 1 ) ) //R from Refract!
	local thinktime = 1/45
	
	if ( col != goalcol ) then
		if ( !changing ) then
			progress = 0
			changing = true
		end
	else
		changing = false
	end
	
	if ( changing ) then
	
		progress = progress + FrameTime()
		if ( progress >= 1 ) then
			progress = 1
			changing = false
			col = goalcol
		end
		
		col = LerpVector( progress, col, goalcol )
		
	else
		col = goalcol
		thinktime = 1/15
	end
	
	mat:SetMaterialVector( "$refracttint", col ) //I typed lots of sophisticated code and all I got was this lousy color fade effect!
	
	local size = 256
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = col.x * 255
		dlight.g = col.y * 255
		dlight.b = col.z * 255
		dlight.Brightness = 1
		dlight.Size = size
		dlight.Decay = size * 5
		dlight.DieTime = CurTime() + 1
	end
	
	self.Entity:NextThink( CurTime() + thinktime )
	return true // Note: You need to return true to override the default next think time
	
end

function ENT:Draw()

    --self.BaseClass.Draw(self)  			-- We want to override rendering, so don't call baseclass.
	
    self.Entity:DrawModel()

end
