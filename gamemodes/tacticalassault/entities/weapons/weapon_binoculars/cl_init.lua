include('shared.lua')

/*function SWEP:Initialize() 
	local wep, changing,lastchange,transition,curent,lastent = self.Weapon,false,0,0,LocalPlayer(),LocalPlayer()
	
	function DrawViews(ViewOrigin,ViewAngles)
	
		if wep and wep:IsValid() and wep:GetNWBool("IsLooking") then
		
			if lastchange != wep:GetNWInt("ChangeView") then
				lastchange = wep:GetNWInt("ChangeView")
				changing = true
				timer.Simple(FrameTime() * 70,function() changing = false end)
			end
			
			if curent != wep:GetNWEntity("ViewEnt") then 
				curent = wep:GetNWEntity("ViewEnt")
				lastent = curent
			end
			
			render.Clear( 0, 0, 0, 255 )
			
			if changing then
				transition = math.Approach(transition,100,2)
				
				local view = {}
					view.y = 50
					view.w = ScrW() - 100
					view.h = ScrH() - 100
				
				view.x = 55 + (ScrW()) * transition / 100
				view.angles =lastent:GetAimVector():Angle()
				view.origin = lastent:GetPos() + Vector(0,0,100) - lastent:GetForward() * 20
				render.RenderView( view )
		
				view.x = 50
				view.w = (ScrW() -50) * transition / 100
				view.angles = curent:GetAimVector():Angle()
				view.origin = curent:GetPos() + Vector(0,0,100) - curent:GetForward() * 20
				render.RenderView( view )
				
			else
			
				local view = {}
					view.x = 50
					view.y = 50
					view.w = ScrW() - 100
					view.h = ScrH() - 100
					view.angles = curent:GetAimVector():Angle()
					view.origin = curent:GetPos() + Vector(0,0,100) - curent:GetForward() * 20
				render.RenderView( view )
				
				transition = 0
			end

			return true
		end

	end
	hook.Add("RenderScene","DrawViews",DrawViews)
end
*/


/*function DrawSquad()
	
	if wep and wep:IsValid() and wep:GetNWBool("IsLooking") then
	
		draw.DrawText("Hello!","ScoreboardText",ScrW()/2,2,color_white,1)
		return true
	end
end
hook.Add("HUDPaint","DrawSquad",DrawSquad) */
