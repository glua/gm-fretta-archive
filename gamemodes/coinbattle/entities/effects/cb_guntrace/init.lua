
EFFECT.Mat = Material( "effects/spark" )

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	
	local StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	local EndPos = data:GetOrigin()
	local distance = (StartPos-EndPos):Length()
	
	self.StartPos = StartPos
	self.EndPos = EndPos
	self.Normal = (self.EndPos - self.StartPos):GetNormal()
	self.Length = math.random(128,512)
	self.StartTime = CurTime()
	self.DieTime = CurTime()+(distance+self.Length)/5000

end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	if ( CurTime() > self.DieTime ) then
		return false 
	end
	
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )

	local time = CurTime() - self.StartTime
	
	local endDistance = 5000*time
	local startDistance = endDistance-self.Length
	
	startDistance = math.max(0,startDistance)
	
	local startPos = self.StartPos + self.Normal * startDistance
	local endPos = self.StartPos + self.Normal * endDistance
	
	render.SetMaterial( self.Mat )
	
	local col = Color( 0, 255, 0, 255 )
	if IsValid(self.WeaponEnt.Owner) then
		col = GAMEMODE:GetTeamColor(self.WeaponEnt.Owner)
	end
	
	render.DrawBeam(startPos, endPos, 8, 1, 0, col)

end
