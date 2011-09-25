
include('shared.lua')


SWEP.PrintName          = "Sniper rifle"     // 'Nice' Weapon name (Shown on HUD)
SWEP.Slot               = 0                     // Slot in the weapon selection menu
SWEP.SlotPos            = 10                    // Position in the slot
SWEP.DrawAmmo           = false                  // Should draw the default HL2 ammo counter
SWEP.DrawCrosshair      = false                  // Should draw the default crosshair
SWEP.DrawWeaponInfoBox  = true                  // Should draw the weapon info box
SWEP.BounceWeaponIcon   = true                  // Should the weapon icon bounce?
SWEP.SwayScale          = 1.0                   // The scale of the viewmodel sway
SWEP.BobScale           = 1.0                   // The scale of the viewmodel bob

SWEP.RenderGroup        = RENDERGROUP_OPAQUE

// Override this in your SWEP to set the icon in the weapon selection
SWEP.WepSelectIcon      = surface.GetTextureID( "weapons/swep" )

// This is the corner of the speech bubble
SWEP.SpeechBubbleLid    = surface.GetTextureID( "gui/speech_lid" )

/*---------------------------------------------------------
    You can draw to the HUD here - it will only draw when
    the client has the weapon deployed..
---------------------------------------------------------*/
function SWEP:DrawHUD()
    if self.zoom > 0.05 then
        local w = surface.ScreenWidth()
        local h = surface.ScreenHeight()
        local s
        if w > h then s = h else s = w end
        s = math.floor((s * 0.9) / 4) * 4
        local l = (w - s) / 2
        local r = l + s
        local b = (h - s) / 2
        local t = b + s

        surface.SetDrawColor(0, 0, 0, self.zoom * 255)
        surface.SetTexture(surface.GetTextureID("gui/sniper_corner"))

        surface.DrawRect(0, 0, l, h)
        surface.DrawRect(r, 0, w - r, h)
        surface.DrawRect(l, 0, s, b)
        surface.DrawRect(l, t, s, h - t)
        // these lines will overlap a little with everything else, but noone will notice
        surface.DrawRect(l, b + (s / 2) - 1, s, 2)
        surface.DrawRect(l + (s / 2) - 1, b, 2, s)
        l = l + (s / 4)
        b = b + (s / 4)
        surface.DrawTexturedRectRotated(l,           b,           s / 2, s / 2, 0)
        surface.DrawTexturedRectRotated(l + (s / 2), b,           s / 2, s / 2, 270)
        surface.DrawTexturedRectRotated(l,           b + (s / 2), s / 2, s / 2, 90)
        surface.DrawTexturedRectRotated(l + (s / 2), b + (s / 2), s / 2, s / 2, 180)
    end
    //self.zoom
    //
	//	surface.SetDrawColor(0,0,0,255)
	//	surface.DrawRect(0,0,self.QuadTable.x,self.QuadTable.h)
	//	surface.DrawRect(surface.ScreenWidth() - self.QuadTable.x,0,self.QuadTable.x,self.QuadTable.h)
	//
	//	surface.SetTexture(surface.GetTextureID("gui/sniper_corner"))
	//	surface.DrawTexturedRectRotated(self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,0)
	//	surface.DrawTexturedRectRotated(self.ScopeTable.x,surface.ScreenHeight() - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,90)
	//	surface.DrawTexturedRectRotated(surface.ScreenWidth() - self.ScopeTable.x,surface.ScreenHeight() - self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,180)
	//	surface.DrawTexturedRectRotated(surface.ScreenWidth() - self.ScopeTable.x,self.ScopeTable.y,self.ScopeTable.w,self.ScopeTable.h,270)
end


/*---------------------------------------------------------
    Checks the objects before any action is taken
    This is to make sure that the entities haven't been removed
---------------------------------------------------------*/
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

    // Set us up the texture
    surface.SetDrawColor( 255, 255, 255, alpha )
    surface.SetTexture( self.WepSelectIcon )

    // Lets get a sin wave to make it bounce
    local fsin = 0

    if ( self.BounceWeaponIcon == true ) then
        fsin = math.sin( CurTime() * 10 ) * 5
    end

    // Borders
    y = y + 10
    x = x + 10
    wide = wide - 20

    // Draw that mother
    surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin) )

    // Draw weapon info box
    self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

end


/*---------------------------------------------------------
    This draws the weapon info box
---------------------------------------------------------*/
function SWEP:PrintWeaponInfo( x, y, alpha )

    if ( self.DrawWeaponInfoBox == false ) then return end

    if (self.InfoMarkup == nil ) then
        local str
        local title_color = "<color=230,230,230,255>"
        local text_color = "<color=150,150,150,255>"

        str = "<font=HudSelectionText>"
        if ( self.Author != "" ) then str = str .. title_color .. "Author:</color>\t"..text_color..self.Author.."</color>\n" end
        if ( self.Contact != "" ) then str = str .. title_color .. "Contact:</color>\t"..text_color..self.Contact.."</color>\n\n" end
        if ( self.Purpose != "" ) then str = str .. title_color .. "Purpose:</color>\n"..text_color..self.Purpose.."</color>\n\n" end
        if ( self.Instructions != "" ) then str = str .. title_color .. "Instructions:</color>\n"..text_color..self.Instructions.."</color>\n" end
        str = str .. "</font>"

        self.InfoMarkup = markup.Parse( str, 250 )
    end

    surface.SetDrawColor( 60, 60, 60, alpha )
    surface.SetTexture( self.SpeechBubbleLid )

    surface.DrawTexturedRect( x, y - 64 - 5, 128, 64 )
    draw.RoundedBox( 8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color( 60, 60, 60, alpha ) )

    self.InfoMarkup:Draw( x+5, y+5, nil, nil, alpha )

end


/*---------------------------------------------------------
   Name: SWEP:FreezeMovement()
   Desc: Return true to freeze moving the view
---------------------------------------------------------*/
function SWEP:FreezeMovement()
    return false
end


/*---------------------------------------------------------
   Name: SWEP:ViewModelDrawn()
   Desc: Called straight after the viewmodel has been drawn
---------------------------------------------------------*/
function SWEP:ViewModelDrawn()
end


/*---------------------------------------------------------
   Name: OnRestore
   Desc: Called immediately after a "load"
---------------------------------------------------------*/
function SWEP:OnRestore()
end

/*---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
---------------------------------------------------------*/
function SWEP:OnRemove()
end

/*---------------------------------------------------------
   Name: CustomAmmoDisplay
   Desc: Return a table
---------------------------------------------------------*/
function SWEP:CustomAmmoDisplay()
end

/*---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------*/
function SWEP:GetViewModelPosition( pos, ang )

    return pos, ang

end

/*---------------------------------------------------------
   Name: TranslateFOV
   Desc: Allows the weapon to translate the player's FOV (clientside)
---------------------------------------------------------*/
function SWEP:TranslateFOV( current_fov )

    return current_fov - (self.zoom * 0.7 * current_fov)
end


/*---------------------------------------------------------
   Name: DrawWorldModel
   Desc: Draws the world model (not the viewmodel)
---------------------------------------------------------*/
function SWEP:DrawWorldModel()

    self.Weapon:DrawModel()

end


/*---------------------------------------------------------
   Name: DrawWorldModelTranslucent
   Desc: Draws the world model (not the viewmodel)
---------------------------------------------------------*/
function SWEP:DrawWorldModelTranslucent()

    self.Weapon:DrawModel()

end


/*---------------------------------------------------------
   Name: AdjustMouseSensitivity()
   Desc: Allows you to adjust the mouse sensitivity.
---------------------------------------------------------*/
function SWEP:AdjustMouseSensitivity()

    return nil

end

/*---------------------------------------------------------
   Name: GetTracerOrigin()
   Desc: Allows you to override where the tracer comes from (in first person view)
         returning anything but a vector indicates that you want the default action
---------------------------------------------------------*/
function SWEP:GetTracerOrigin()

/*
    local ply = self:GetOwner()
    local pos = ply:EyePos() + ply:EyeAngles():Right() * -5
    return pos
*/

end
