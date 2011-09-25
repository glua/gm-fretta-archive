local FLASHTIMER = 5; --time in seconds, for the grenade to transition from full white to clear
local EFFECT_DELAY = 2; --time, in seconds when the effects still are going on, even when the whiteness of the flash is gone (set to -1 for no effects at all =]).

local Endflash, Endflash2;

if (CLIENT) then

	/*---------------------------------------------------------
	Initialize
	---------------------------------------------------------*/
	function ENT:Initialize()

		local Pos = self:GetPos()

		timer.Simple(2, function()
			local dynamicflash = DynamicLight( self:EntIndex() )

			if ( dynamicflash ) then
				dynamicflash.Pos = Pos
				dynamicflash.r = 255
				dynamicflash.g = 255
				dynamicflash.b = 255
				dynamicflash.Brightness = 5
				dynamicflash.Size = 1000
				dynamicflash.Decay = 1000
				dynamicflash.DieTime = CurTime() + 0.5
			end 
		end)
	end

	/*---------------------------------------------------------
	Think
	---------------------------------------------------------*/
	function ENT:Think()
	end

	/*---------------------------------------------------------
	Draw
	---------------------------------------------------------*/
	function ENT:Draw()

		self.Entity:DrawModel()
	end

	/*---------------------------------------------------------
	IsTranslucent
	---------------------------------------------------------*/
	function ENT:IsTranslucent()

		return true
	end
	
	function FlashEffect() if LocalPlayer():GetNetworkedFloat("FLASHED_END") > CurTime() then

		local pl 			= LocalPlayer();
		local FlashedEnd 		= pl:GetNetworkedFloat("FLASHED_END")
		local FlashedStart 	= pl:GetNetworkedFloat("FLASHED_START")
		
		local Alpha

		if(FlashedEnd - CurTime() > FLASHTIMER) then
			Alpha = 150;
		else
			local FlashAlpha = 1 - (CurTime() - (FlashedEnd - FLASHTIMER)) / (FlashedEnd - (FlashedEnd - FLASHTIMER));
			Alpha = FlashAlpha * 150;
		end
		
			surface.SetDrawColor(255, 255, 255, math.Round(Alpha))
			surface.DrawRect(0, 0, surface.ScreenWidth(), surface.ScreenHeight())
		end 
	end
	
	hook.Add("HUDPaint", "FlashEffect", FlashEffect);
	
		local function StunEffect()
		local pl 			= LocalPlayer();
		local FlashedEnd 		= pl:GetNetworkedFloat("FLASHED_END")
		local FlashedStart 	= pl:GetNetworkedFloat("FLASHED_START")
	
		if (FlashedEnd > CurTime() and FlashedEnd - EFFECT_DELAY - CurTime() <= FLASHTIMER) then
			local FlashAlpha = 1 - (CurTime() - (FlashedEnd - FLASHTIMER)) / (FLASHTIMER);
			DrawMotionBlur( 0, FlashAlpha / ((FLASHTIMER + EFFECT_DELAY) / (FLASHTIMER * 4)), 0);

		elseif (FlashedEnd > CurTime()) then
			DrawMotionBlur( 0, 0.01, 0);
		else
			DrawMotionBlur( 0, 0, 0);
		end
	end
	
	hook.Add( "RenderScreenspaceEffects", "StunEffect", StunEffect )
end

ENT.Type = "anim"

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function ENT:OnRemove()
end

/*---------------------------------------------------------
PhysicsUpdate
---------------------------------------------------------*/
function ENT:PhysicsUpdate()
end

/*---------------------------------------------------------
PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("Flashbang.Bounce"))
	end
	
	local impulse = -data.Speed * data.HitNormal * .4 + (data.OurOldVelocity * -.6)
	phys:ApplyForceCenter(impulse)
end