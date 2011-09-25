EFFECT.shoulddie = false

if !effects_onoff then
	effects_onoff = {}
	usermessage.Hook("effectoff",
		function(um)
			local pos = um:ReadShort()
			if effects_onoff[pos] && effects_onoff[pos]:IsValid() then
				effects_onoff[pos].shoulddie = true
			end
			effects_onoff[pos] = nil 
		end)
end

function EFFECT:Init(data)
//	self.Created = CurTime()
//	effects_onoff[data:GetMagnitude()] = self
end

function EFFECT:Think()
	return true
end

function EFFECT:Render()
end