
EFFECT.PsySounds = { "ambient/levels/citadel/strange_talk1.wav",
"ambient/levels/citadel/strange_talk3.wav",
"ambient/levels/citadel/strange_talk4.wav",
"ambient/levels/citadel/strange_talk7.wav",
"ambient/levels/citadel/strange_talk8.wav",
"ambient/levels/citadel/strange_talk9.wav",
"ambient/levels/citadel/strange_talk10.wav",
"ambient/levels/citadel/strange_talk11.wav",
"ambient/levels/labs/teleport_weird_voices1.wav",
"ambient/levels/labs/teleport_weird_voices2.wav",
"ambient/atmosphere/city_skybeam1.wav",
"ambient/atmosphere/city_skypass1.wav",
"ambient/atmosphere/cave_hit6.wav"}

function EFFECT:Init( data )

	local pos = data:GetOrigin()
	
	if LocalPlayer():GetPos():Distance( pos ) > 50 then return end

	DisorientTime = CurTime() + 20
	ViewWobble = 1.0
	MotionBlur = 0.9
	Sharpen = 5.5
	ColorModify[ "$pp_colour_mulr" ] = 3.5
		
	LocalPlayer():EmitSound( table.Random( self.PsySounds ), 100, 50 )
	
end

function EFFECT:Think( )

	return false
	
end

function EFFECT:Render()

end