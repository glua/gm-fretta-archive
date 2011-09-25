
include('shared.lua')

local pedo1 = Material( "pedobear/pedobear" )
local pedo2 = Material( "pedobear/pedobear1" )

function ENT:Initialize()

  self.drawtime=CurTime()
  self.pass=1
end


/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
if(self.drawtime+0.2<CurTime()) then
self.drawtime=CurTime()
  if (self.pass==1) then
    self.pass=2
  else
    self.pass=1
  end
end

local pos = self.Entity:GetPos()

if(self.pass==1) then
	render.SetMaterial( pedo1 )
else	
  render.SetMaterial( pedo2 )
end
	render.DrawSprite( pos+Vector(0,0,22), 50, 100, "255 255 255 255" )
end

