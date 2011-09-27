EFFECT.Mat = Material( "effects/spark" )

function GetTracerShootPosLNL (self, Position, Ent, Attachment)
 	self.ViewModelTracer = false 
 	 
 	if !Ent:IsValid() or !Ent:IsWeapon() then return Position end 
   
 	// Shoot from the viewmodel 
 	if Ent:IsCarriedByLocalPlayer() && GetViewEntity() == LocalPlayer() then 
 		local ViewModel = LocalPlayer():GetViewModel() 
 		 
 		if ViewModel:IsValid() then
 			local att = ViewModel:GetAttachment(Attachment)
 			if att then
 				Position = att.Pos
				local pl = LocalPlayer()
				local DefPos = (pl:GetActiveWeapon().ViewModelAimPos or Vector (0,0,0)) * pl:GetActiveWeapon().DegreeOfZoom
				local angles = pl:EyeAngles()
				usefulViewAng = lockedViewAng or angles
				--calculate angle weapon model is actually at
				SimilarizeAngles (angles, usefulViewAng)
				--print ("1", angles)
				vm_angles = (angles * (LNL_FOVRATIO or 0.8)) + (usefulViewAng * (1 - (LNL_FOVRATIO or 0.8)))
				--print ("2", angles, LNL_FOVRATIO)
				--Something clever with vectors and angles. Made sense at time, fixes FOV discrepancy.
				local relativePos = Position - pl:GetShootPos()
				local magnitude = relativePos:Length()
				local relativeAng = relativePos:Angle()
				local oldpitch = relativeAng.p
				--print (relativePos, magnitude, relativeAng)
				SimilarizeAngles (relativeAng, usefulViewAng)
				relativeAng = (relativeAng * (LNL_FOVRATIO or 0.8)) + (usefulViewAng * (1 - (LNL_FOVRATIO or 0.8)))
				relativeAng.p = oldpitch
				local newRelativePos = relativeAng:Forward() * magnitude
				Position = newRelativePos + pl:GetShootPos()
				--print (relativeAng, newRelativePos)
				--move it around based on vector offset from normal
				local Right 	= vm_angles:Right()
				local Up 		= vm_angles:Up()
				local Forward 	= vm_angles:Forward()
				Position = Position + DefPos.x * Right
				Position = Position + DefPos.y * Forward
				Position = Position + DefPos.z * Up
				
 				self.ViewModelTracer = true
 			end
 		end
 	// Shoot from the world model 
 	else 
 		local att = Ent:GetAttachment (Attachment) 
 		if att then 
 			Position = att.Pos 
 		end
 	end
	
 	return Position
end

/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function InitLNLTracer (self, data)
	self.StartPos 	= data:GetStart()	
	self.EndPos 	= data:GetOrigin()
	
	self.Weapon = data:GetEntity()
	
	self.StartPos = GetTracerShootPosLNL (self, self.StartPos, self.Weapon, 1)
	if self.Weapon:IsCarriedByLocalPlayer() then
		self.OwnerPos = LocalPlayer():GetPos()
	end
	
	self.Dir 		= self.EndPos - self.StartPos
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	self.TracerTime = 0.1
	
	// Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime
end

function EFFECT:Init (data)
	return InitLNLTracer (self, data)
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/

function ThinkLNLTracer (self)
	if CurTime() > (self.DieTime or 0) then return false end
	return true
end

function EFFECT:Think( )
	return ThinkLNLTracer (self)
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/

function RenderLNLTracer (self, color)
	if self.OwnerPos and (CurTime() < self.DieTime - 0.08) then
		local diff = LocalPlayer():GetPos() - self.OwnerPos
		self.StartPos = self.StartPos + diff
		self.OwnerPos = LocalPlayer():GetPos()
		self.Dir 		= self.EndPos - self.StartPos
	end
	
	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 )
			
	render.SetMaterial( self.Mat )
	
	local sinWave = math.sin( fDelta * math.pi )
	
	render.DrawBeam( self.EndPos - self.Dir * (fDelta - sinWave * 0.3 ), 		
					 self.EndPos - self.Dir * (fDelta + sinWave * 0.3 ),
					 4 + sinWave * 10,	
					 --8,
					 1,					
					 0,				
					 color )
end

function EFFECT:Render( )
	RenderLNLTracer (self, color_white)
end
