include('shared.lua')

local matLight 		= Material( "sprites/light_ignorez" )
local matBeam		= Material( "effects/lamp_beam" )

// Override this in your SWEP to set the icon in the weapon selection
if (file.Exists("../materials/weapons/weapon_mad_medic.vmt")) then
	SWEP.WepSelectIcon	= surface.GetTextureID("weapons/weapon_mad_medic")
end

function SWEP:Initialize()

	self.PixVis = util.GetPixelVisibleHandle()
	
	/*function DrawTranslucent()
		
		local targ = self:GetNWEntity("targ")
		if !ValidEntity(targ) || !ValidEntity(self:GetNWEntity("scanner")) then return end
		
		local LightPos = targ:GetPos() + targ:OBBCenter()
		render.SetMaterial( matLight )
		
		local ViewNormal = targ:GetPos() + targ:OBBCenter() - EyePos()
		local Distance = ViewNormal:Length()
		ViewNormal:Normalize()
			
		local Visibile = util.PixelVisible( LightPos, 4, self.PixVis )	
		
		if (!Visibile) then return end
		
		local Alpha = 255
		
		render.DrawSprite( LightPos, 8, 8, Color(255, 255, 255, Alpha), Visibile )
		render.DrawSprite( LightPos, 8, 8, Color(255, 255, 255, Alpha), Visibile )
		render.DrawSprite( LightPos, 8, 8, Color(255, 255, 255, Alpha), Visibile )
		render.DrawSprite( LightPos, 32, 32, Color( 255, 255, 255, 64 ), Visibile )

		
	end
	hook.Add("PreDrawOpaqueRenderables",self:EntIndex().."draw",DrawTranslucent)*/
	
end

function SWEP:Think()

	local targ = self:GetNWEntity("targ")
	if !ValidEntity(targ) || !ValidEntity(self:GetNWEntity("scanner")) then return end

	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = targ:GetPos() + targ:OBBCenter()
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 3
		dlight.Decay = 500 * 5
		dlight.Size = 500
		dlight.DieTime = CurTime() + 1
	end
	
end