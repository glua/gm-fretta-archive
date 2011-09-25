include('shared.lua')
require( 'renderx' )

function Plane( normal, point ) return { Normal = normal, Distance = normal:Dot( point ) } end    

function ENT:Initialize()
	
	local n = self.Entity:EntIndex()
	
	hook.Add("HUDPaint",n.."hud",function()
		
		if !self.Entity || !self.Entity:IsValid() then hook.Remove( "HUDPaint", n.."hud" ) return end
		
		local t = self.Entity:GetNWInt("Team")
		if t == 0 then return end
		
		if t == LocalPlayer():Team() and LocalPlayer():GetEyeTrace().Entity == self.Entity then
		
			draw.DrawText("Health: "..math.ceil((self.Entity:GetNWInt("Health")/self.Entity:GetNWInt("MaxHealth") * 100)).."%","ScoreboardText",ScrW()/2,ScrH()/2+30,Color(255,255,100),1)
		
		end
		
	end)
	
	self.Height = 0
	
end

function ENT:Draw()

	local build = self.Entity:GetNWInt("BuildTime")
	local max = self.Entity:GetNWInt("MaxBuild")
	local raise = self.Entity:GetNWInt("RaiseUp")
	
	if self.Height == 0 then self.Height = self.Entity:GetNWInt("Height") end
	
	if build > 0.1 then
		local plane = Plane( self:GetUp() * -1, self:GetPos() + Vector(0,0,self.Height* (max - build) / max - raise) )
		render.EnableClipping(true)  
		render.PushCustomClipPlane( plane.Normal, plane.Distance )  
		self:DrawModel()  
		render.PopCustomClipPlane() 
		render.EnableClipping(false)
	else
		self:DrawModel()  
	end
end