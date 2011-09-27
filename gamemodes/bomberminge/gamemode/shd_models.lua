-- ALL MODELS SHOULD BE REGISTERED HERE

-------------------------------------------------------------------------------------------------------
-- BOMBS
-------------------------------------------------------------------------------------------------------

--[[---------------------------------------------------------
-- Regular bomb, explodes after 3 seconds
-----------------------------------------------------------]]

multimodel.Register("bomb", {
	{
		model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
		transform = {Vector(0,0,0),Angle(45,0,0),Vector(1,1,1)},
		color = Color(20,20,20,255),
		material = "models/debug/debugwhite",
		
		Think = function(self, time)
			local s = 1 + 0.1 * (1 + math.sin(10*time))
			self.transform[3] = Vector(s, s, s)
		end,
	},
	{
		transform = {Vector(0,0,0),Angle(45,45,0),Vector(1,1,1)},
		
		Think = function(self, time)
			local s = 1 + 0.035 * (1 + math.sin(10*time))
			self.transform[3] = Vector(s, s, s)
		end,
		
		children = {
			{
				model = "models/props_junk/propane_tank001a.mdl",
				color = Color(20,20,20,255),
				material = "models/debug/debugwhite",
				transform = {Vector(0,0,4),Angle(180,0,0),Vector(1,1,1)},
			},
			{
				model = "models/Gibs/HGIBS_rib.mdl",
				transform = {Vector(0,-3,18),Angle(-4,-280,-67),Vector(1,1,1)},
				children = {
					{
						effect = "effect_fuse_sparks",
						delay = 0.1,
						transform = {Vector(-5.2806, -7.0081, 0.8919),Angle(0,0,0),Vector(1,1,1)},
					},
				}
			},
		}
	},
})

--[[---------------------------------------------------------
-- Remote controlled bomb, explodes on user right click
-----------------------------------------------------------]]

multimodel.Register("bomb_remote", {
	{
		model = "models/props_wasteland/laundry_washer001a.mdl",
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.4,0.4,0.3)},
		
		Think = function(self, time)
			local s = 0.02 * (1 + math.sin(10*time))
			self.transform[3] = Vector(0.4+s, 0.4+s, 0.3-s)
		end,
		
		children = {
			{
				sprite = "effects/blueflare1",
				transform = {Vector(-30,0,35),Angle(0,0,0),Vector(32,32,32)},
				color = Color(255,255,255,255),
				
				Think = function(self, time)
					local c = HSVToColor(math.NormalizeAngle(200*time), 1, 1)
					self.color = c
				end,
			}
		},
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(1,1,1)},
		children = {
			{
				model = "models/props_pipes/valve001.mdl",
				transform = {Vector(0,0,30),Angle(180,0,0),Vector(1,1,1)},
				Think = function(self, time)
					local s = 0.8 * (1 + math.sin(10*time))
					self.transform[1] = Vector(0, 0, 30-s)
					self.transform[2].y = math.NormalizeAngle(120*time)
				end,
			}
		}
	},
})

--[[---------------------------------------------------------
-- Plasma bomb, explosions aren't blocked by crates
-----------------------------------------------------------]]

multimodel.Register("bomb_plasma", {
	{
		model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
		transform = {Vector(0,0,0),Angle(45,0,0),Vector(1,1,1)},
		color = Color(20,20,50,255),
		material = "models/debug/debugwhite",
		
		Think = function(self, time)
			local s = 1 + 0.1 * (1 + math.sin(10*time))
			self.transform[3] = Vector(s, s, s)
		end,
	},
	{
		transform = {Vector(0,0,0),Angle(0,45,0),Vector(1,1,1)},
		
		Think = function(self, time)
			local s = 1 + 0.055 * (1 + math.sin(10*time))
			self.transform[3] = Vector(s, s, s)
		end,
		
		children = {
			{
				model = "models/props_c17/utilityconnecter006c.mdl",
				transform = {Vector(0,0,12),Angle(0,0,0),Vector(0.9,0.9,0.5)},
			},
			{
				model = "models/props_c17/utilityconnecter006c.mdl",
				transform = {Vector(12,0,0),Angle(90,0,0),Vector(0.9,0.9,0.5)},
			},
			{
				model = "models/props_c17/utilityconnecter006c.mdl",
				transform = {Vector(-12,0,0),Angle(90,180,0),Vector(0.9,0.9,0.5)},
			},
			{
				model = "models/props_c17/utilityconnecter006c.mdl",
				transform = {Vector(0,-12,0),Angle(0,180,-90),Vector(0.9,0.9,0.5)},
			},
			{
				model = "models/props_c17/utilityconnecter006c.mdl",
				transform = {Vector(0,12,0),Angle(0,0,-90),Vector(0.9,0.9,0.5)},
			},
		}
	},
})

--[[---------------------------------------------------------
-- Randomizer bomb, on right click, randomizes the explosion time
-----------------------------------------------------------]]

local Segments = {
{-35, -80 -6, 70, 12},
{-35,   0 -6, 70, 12},
{-35,  80 -6, 70, 12},
{-50 -6, -80, 12, 80},
{-50 -6, 5, 12, 80},
{50 -6, -80, 12, 80},
{50 -6, 5, 12, 80},
}

local Digits = {
[0]={1,3,4,5,6,7},
{6,7},
{1,2,3,5,6},
{1,2,3,6,7},
{2,4,6,7},
{1,2,3,4,7},
{1,2,3,4,5,7},
{1,6,7},
{1,2,3,4,5,6,7},
{1,2,3,4,6,7},
}

local function Draw7SegDigit(x, y, sx, sy, d)
	surface.SetDrawColor(255,0,0,255)
	for k,i in ipairs(Digits[d] or Digits[8]) do
		local v = Segments[i]
		surface.DrawRect(x+sx*v[1],y+sy*v[2],sx*v[3],sy*v[4])
	end
end

multimodel.Register("bomb_random", {
	{
		model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
		transform = {Vector(0,0,0),Angle(45,0,0),Vector(1,1,1)},
		color = Color(20,20,20,255),
		material = "models/debug/debugwhite",
		
		Think = function(self, time)
			local s = 1 + 0.1 * (1 + math.sin(10*time))
			self.transform[3] = Vector(s, s, s)
		end,
		
		children = {
			{
				model = "models/props_lab/monitor01b.mdl",
				transform = {Vector(-8,0,8),Angle(-45,180,0),Vector(1.4,1.4,1.4)},
				children = {
					{
						custom = function(self,pos,ang,scl,ent)
							local ang2 = ang:Up():Angle()
							local vec = ang2:Up()
							ang2:RotateAroundAxis(vec, -90)
							
							-- Compensate depth issues due to distance
							if not LocalPlayer():GetNWBool("FPSMode") and ViewFOV then
								pos = pos + vec * ((ViewFOV-40)/70)
							end
							
							local n = ent:GetNWInt("ScreenCounter")
							local s = ent:GetNWBool("Scrambled")
							if s and LocalPlayer()~=ent:GetNWEntity("BombOwner") then n = math.random(1,99) end
							
							local d1, d2 = math.floor(n/10), n%10
							
							cam.Start3D2D(pos, ang2, scl.x/14)
								surface.SetDrawColor(0,0,0,255)
								surface.DrawRect(-80,-74,130,135)
								if d1>0 then Draw7SegDigit(-45,-10,0.4,0.65,d1) end
								Draw7SegDigit(15,-10,0.4,0.65,d2)
							cam.End3D2D()
						end,
						transform = {Vector(6.3,0,0),Angle(0,0,0),Vector(1,1,1)},
					},
					{
						sprite = "effects/blueflare1",
						transform = {Vector(6.5,4.7,4),Angle(0,0,0),Vector(4,4,4)},
						color = Color(0,255,0,255),
						
						Think = function(self, time, ent)
							local n = ent:GetNWInt("ScreenCounter")
							local mul
							if n<0 then mul = 20
							else mul = 10
							end
							
							if math.sin(CurTime()*mul)>0 then
								self.transform[1].z = 4
								self.color.r = 0
								self.color.g = 255
							else
								self.transform[1].z = 2
								self.color.r = 255
								self.color.g = 0
							end
						end,
					},
				},
			},
		}
	},
	{
		transform = {Vector(0,0,0),Angle(45,45,0),Vector(1,1,1)},
		
		Think = function(self, time)
			local s = 1 + 0.035 * (1 + math.sin(10*time))
			self.transform[3] = Vector(s, s, s)
		end,
		
		children = {
			{
				model = "models/props_junk/propane_tank001a.mdl",
				color = Color(20,20,20,255),
				material = "models/debug/debugwhite",
				transform = {Vector(0,0,4),Angle(180,0,0),Vector(1,1,1)},
			},
			{
				model = "models/Gibs/HGIBS_rib.mdl",
				transform = {Vector(0,-3,18),Angle(-4,-280,-67),Vector(1,1,1)},
				children = {
					{
						effect = "effect_fuse_sparks",
						delay = 0.1,
						transform = {Vector(-5.2806, -7.0081, 0.8919),Angle(0,0,0),Vector(1,1,1)},
					},
				}
			},
		}
	},
})

multimodel.Register("bomb_rocket", {
	{
		model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(1,1,1)},
		
		Think = function(self, time)
			local s = 0.04 * (1 + math.sin(10*time))
			self.transform[3] = Vector(0.8+s, 0.8+s, 0.8-s)
		end,
		
	},
	
	{
		model = "models/props_wasteland/wheel01a.mdl",
		transform = {Vector(0,0,6),Angle(0,0,90),Vector(0.3,0.3,0.3)},
		
		Think = function(self, time)
			local s = 0.04 * (1 + math.sin(10*time))
			self.transform[3] = Vector(0.35+s, 0.7-s, 0.35+s)
		end,
	},
	
	{
		model = "models/props_wasteland/wheel01a.mdl",
		transform = {Vector(0,0,-6),Angle(0,0,-90),Vector(0.3,0.3,0.3)},
		
		Think = function(self, time)
			local s = 0.04 * (1 + math.sin(10*time))
			self.transform[3] = Vector(0.35+s, 0.7-s, 0.35+s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(1,1,1)},
		
		Think = function(self, time)
			local s = 0.08 * (math.sin(10*time)-2)
			self.transform[3] = Vector(0.8+s, 0.8+s, 0.8+s)
		end,
		
		children = {
			{
				transform = {Vector(0,0,0),Angle(0,0,0),Vector(1,1,1)},
				
				children = {
					{
						model = "models/props_junk/propane_tank001a.mdl",
						transform = {Vector(-18,0,0),Angle(90,0,0),Vector(1.5,1.5,0.6)},
					},
					{
						model = "models/props_junk/propane_tank001a.mdl",
						transform = {Vector(18,0,0),Angle(90,180,0),Vector(1.5,1.5,0.6)},
					},
					{
						model = "models/props_junk/propane_tank001a.mdl",
						transform = {Vector(0,-18,0),Angle(90,90,0),Vector(1.5,1.5,0.6)},
					},
					{
						model = "models/props_junk/propane_tank001a.mdl",
						transform = {Vector(0,18,0),Angle(90,-90,0),Vector(1.5,1.5,0.6)},
					},
				},
			}
		}
	},
})

multimodel.Register("bomb_rocket_sub", {
	{
		model = "models/props_junk/propane_tank001a.mdl",
		transform = {Vector(0,0,0),Angle(90,180,0),Vector(1.5,1.5,1.2)},
		
		children = {
			{
				effect = "effect_propane_trail",
				delay = 0.05,
				transform = {Vector(0, 0, 10),Angle(0,0,0),Vector(1,1,1)},
			}
		}
	}
})

multimodel.Register("bomb_melon", {
	{
		model = "models/props_junk/watermelon01.mdl",
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(2,2,2)},
		
		Think = function(self, time)
			local s = 0.12 * (1 + math.sin(10*time))
			self.transform[3] = Vector(2+s, 2+s, 2-s)
		end,
		
	},
})

multimodel.Register("bomb_mine", {
	{
		transform = {Vector(0,0,-22),Angle(0,0,0),Vector(1,1,1)},
		children = {
			{
				model = "models/props_wasteland/laundry_basket002.mdl",
				color = Color(100,100,255,255),
				transform = {Vector(0,0,0),Angle(180,0,0),Vector(0.6,0.6,0.15)},
				
				Think = function(self, time, ent)
					if ent.Animation==1 then
						self.color.a = Lerp(time*time, 0, 255)
					else
						self.color.a = Lerp(time*time, 255, 0)
					end
				end,
			},
			{
				model = "models/props_pipes/pipe02_connector01.mdl",
				color = Color(255,255,0,255),
				transform = {Vector(-0.1,-0.15,3.7),Angle(90,0,0),Vector(0.4,0.4,0.4)},
			},
		}
	}
})

multimodel.Register("bomb_danger", {
	{
		model = "models/props_c17/pottery02a.mdl",
		transform = {Vector(-10,-10,-10),Angle(45,45,0),Vector(2.2,2.2,2.2)},
		color = Color(150,50,50,255),
		
		Think = function(self, time)
			local s = 2.2 + 0.1 * (1 + math.sin(10*time))
			self.transform[3] = Vector(s, s, s)
			
			self.color.r = 180 + 30*math.sin(10*time)
			self.color.g = 25 - 30*math.sin(10*time)
			self.color.b = 25 - 30*math.sin(10*time)
		end,
	},
	{
		transform = {Vector(0,0,0),Angle(45,45,0),Vector(1,1,1)},
		
		Think = function(self, time)
			local s = 1 + 0.035 * (1 + math.sin(10*time))
			self.transform[3] = Vector(s, s, s)
		end,
		
		children = {
			{
				model = "models/Gibs/HGIBS_rib.mdl",
				transform = {Vector(0,-3,12),Angle(-4,-280,-67),Vector(1,1,1)},
				children = {
					{
						effect = "effect_fuse_sparks",
						delay = 0.1,
						transform = {Vector(-5.2806, -7.0081, 0.8919),Angle(0,0,0),Vector(1,1,1)},
					},
				}
			},
		}
	},
})

local function invisbomb_color_think(self, time, ent)
	local min_alpha
	if ent:GetNWEntity("BombOwner")==LocalPlayer() then
		min_alpha = 50
	else
		min_alpha = 0
	end
	
	if ent.Animation==1 then
		self.color.a = Lerp(time*time, min_alpha, 255)
	else
		self.color.a = min_alpha
	end
end

multimodel.Register("bomb_invis", {
	{
		model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
		transform = {Vector(0,0,0),Angle(45,0,0),Vector(1,1,1)},
		color = Color(20,20,20,255),
		material = "models/debug/debugwhite",
		
		Think = function(self, time, ent)
			invisbomb_color_think(self, time, ent)
			local s = 1 + 0.1 * (1 + math.sin(10*time))
			self.transform[3] = Vector(s, s, s)
		end,
	},
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,150,0,255),
		transform = {Vector(0,0,0),Angle(-90,0,0),Vector(1,1,1)},
		
		Think = function(self, time, ent)
			invisbomb_color_think(self, time, ent)
			
			if ent.Animation==1 then
				self.ringspeed = Lerp(1/(1+time*time), 0, 10)
			else
				self.ringspeed = Lerp(1/(1+time*time), 10, 0)
			end
			if self.ringangle then self.ringangle = math.NormalizeAngle(self.ringangle + FrameTime() * self.ringspeed)
			else self.ringangle = 0 end
			
			self.transform[1].z = 20*math.sin(self.ringangle)
			
			local s = 1 + 0.1 * (1 + math.sin(10*time))
			s = s * math.abs(math.cos(self.ringangle))
			self.transform[3] = Vector(s, s, s)
		end,
	},
})

multimodel.Register("bomb_nuke", {
	{
		model = "models/props_c17/canister_propane01a.mdl",
		transform = {Vector(0,0,-24),Angle(0,0,0),Vector(0.9,0.9,0.7)},
		color = Color(90,20,20,255),
		
		Think = function(self, time)
			local s = 0.7 + 0.03 * (1 + math.sin(10*time))
			self.transform[3].z = s
		end,
		
		children = {
			{
				model = "models/props_c17/canister02a.mdl",
				transform = {Vector(13,13,24),Angle(0,135,0),Vector(1,1,0.8)},
			},
			{
				model = "models/props_c17/canister02a.mdl",
				transform = {Vector(-13,13,24),Angle(0,-135,0),Vector(1,1,0.8)},
			},
			{
				model = "models/props_c17/canister02a.mdl",
				transform = {Vector(13,-13,24),Angle(0,45,0),Vector(1,1,0.8)},
			},
			{
				model = "models/props_c17/canister02a.mdl",
				transform = {Vector(-13,-13,24),Angle(0,-45,0),Vector(1,1,0.8)},
			},
			{
				model = "models/props_combine/combine_mine01.mdl",
				transform = {Vector(0,0,70),Angle(180,0,0),Vector(1.1,1.1,1.5)},
				color = Color(255,0,0,255),
			},
			{
				model = "models/props_combine/combine_lock01.mdl",
				transform = {Vector(-24,-4,48),Angle(180,90,0),Vector(1.1,1.1,1.5)},
				color = Color(255,0,0,255),
				children = {
					{
						sprite = "effects/blueflare1",
						transform = {Vector(-3.6,5,-9),Angle(0,0,0),Vector(8,8,8)},
						color = Color(255,20,0,255),
						
						Think = function(self, time)
							local s = math.Rand(7,9)
							self.transform[3].x = s
							self.transform[3].y = s
						end,
					},
				}
			},
		}
	},
})

multimodel.Register("bomb_radio", {
	{
		model = "models/props_lab/citizenradio.mdl",
		color = Color(255,255,255,255),
		transform = {Vector(0,0,-10),Angle(0,180,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			self.transform[1].z = -10 + 4 * math.sin(2*time)
		end,
		
		children = {
			{
				model = "models/props_rooftop/antenna01a.mdl",
				transform = {Vector(0,5,28),Angle(0,-90,0),Vector(0.15,0.15,0.1)},
			},
			{
				model = "models/props_lab/keypad.mdl",
				transform = {Vector(0,-5,17),Angle(-90,0,0),Vector(1, 1, 1)},
			},
			{
				model = "models/dav0r/hoverball.mdl",
				transform = {Vector(-1,0,1),Angle(-90,0,0),Vector(1.3, 1.3, 1.3)},
			},
			{
				sprite = "effects/blueflare1",
				transform = {Vector(10,-9.9,7.4),Angle(0,0,0),Vector(4,4,4)},
				color = Color(0,255,0,255),
				
				Think = function(self, time, ent)
					if math.sin(CurTime()*10)>0 then
						self.transform[1].z = 3.8
						self.color.r = 0
						self.color.g = 255
					else
						self.transform[1].z = 7.4
						self.color.r = 255
						self.color.g = 0
					end
				end,
			},
		}
	},
})

multimodel.Register("bomb_physics", {
	{
		model = "models/props_c17/oildrum001_explosive.mdl",
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(1,1,1)},
		
		children = {
			{
				model = "models/Gibs/HGIBS_rib.mdl",
				transform = {Vector(6,-2,50),Angle(-4,0,-67),Vector(1,1,1)},
				children = {
					{
						effect = "effect_fuse_sparks",
						delay = 0.1,
						transform = {Vector(-5.2806, -7.0081, 0.8919),Angle(0,0,0),Vector(1,1,1)},
					},
				}
			},
		}
	},
})


-------------------------------------------------------------------------------------------------------
-- HATS
-------------------------------------------------------------------------------------------------------

multimodel.Register("hat", {
	{
		model = "models/props_junk/watermelon01.mdl",
		transform = {Vector(2.5,1.5,0),Angle(90,80,0),Vector(0.7,0.7,0.7)},
		color = Color(255,255,255,255),
		material = "models/debug/debugwhite",
		
		skins = {
			{color = Color(255,255,255,255)},
			{color = Color(20 ,20 ,20 ,255)},
			{color = Color(240,30 ,30 ,255)},
			{color = Color(30 ,240,30 ,255)},
			{color = Color(30 ,30 ,240,255)},
			{color = Color(240,240,30 ,255)},
			{color = Color(30 ,240,240,255)},
			{color = Color(240,30 ,240,255)},
		},
		
		children = {
			{
				model = "models/props_junk/watermelon01.mdl",
				transform = {Vector(0,-4,8),Angle(0,0,0),Vector(0.4,0.4,0.4)},
				color = Color(255,50,100,255),
				material = "models/debug/debugwhite",
			},
		}
	},
	
})

-------------------------------------------------------------------------------------------------------
-- POWERUPS (and powerdowns herp derp)
-------------------------------------------------------------------------------------------------------


multimodel.Register("item_bombup", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
				transform = {Vector(0,0,0),Angle(45,0,0),Vector(1,1,1)},
				color = Color(20,20,20,255),
				material = "models/debug/debugwhite",
			},
			{
				transform = {Vector(0,0,0),Angle(45,45,0),Vector(1,1,1)},
				children = {
					{
						model = "models/props_junk/propane_tank001a.mdl",
						color = Color(20,20,20,255),
						material = "models/debug/debugwhite",
						transform = {Vector(0,0,4),Angle(180,0,0),Vector(1,1,1)},
					},
					{
						model = "models/Gibs/HGIBS_rib.mdl",
						transform = {Vector(0,-3,18),Angle(-4,-280,-67),Vector(1,1,1)},
					},
				}
			},
		}
	},
})



multimodel.Register("item_bombdown", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
				transform = {Vector(0,0,0),Angle(45,0,0),Vector(1,1,1)},
				color = Color(20,20,20,255),
				material = "models/debug/debugwhite",
			},
			{
				transform = {Vector(-10,0,20),Angle(180-55,0,0),Vector(1,1,1)},
				children = {
					{
						model = "models/Gibs/wood_gib01a.mdl",
						color = Color(255,20,20,255),
						material = "models/debug/debugwhite",
						transform = {Vector(0,0,0),Angle(0,45,0),Vector(1,1,1)},
					},
					{
						model = "models/Gibs/wood_gib01b.mdl",
						color = Color(255,20,20,255),
						material = "models/debug/debugwhite",
						transform = {Vector(0,0,0),Angle(0,-45,0),Vector(1,1,1)},
					},
				}
			},
			{
				transform = {Vector(0,0,0),Angle(45,45,0),Vector(1,1,1)},
				children = {
					{
						model = "models/props_junk/propane_tank001a.mdl",
						color = Color(20,20,20,255),
						material = "models/debug/debugwhite",
						transform = {Vector(0,0,4),Angle(180,0,0),Vector(1,1,1)},
					},
					{
						model = "models/Gibs/HGIBS_rib.mdl",
						transform = {Vector(0,-3,18),Angle(-4,-280,-67),Vector(1,1,1)},
					},
				}
			},
		}
	},
})

multimodel.Register("item_fireup", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_junk/gascan001a.mdl",
				transform = {Vector(0,0,0),Angle(45,0,0),Vector(1.4,1.4,1.4)},
			},
		}
	},
})

multimodel.Register("item_superfireup", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			local s = 0.8 + 0.12 * (1 + math.sin(8*time))
			self.transform[1].z = 4*math.sin(4*time)
			self.transform[3] = Vector(s, s, s)
		end,
		
		children = {
			{
				model = "models/props_junk/gascan001a.mdl",
				transform = {Vector(0,0,0),Angle(45,0,0),Vector(1.4,1.4,1.4)},
			},
			{
				effect = "effect_supergascan_fire",
				delay = 0.1,
				transform = {Vector(0,0,-5),Angle(0,0,0),Vector(1,1,1)},
			},
		}
	},
})

multimodel.Register("item_firedown", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_junk/metalgascan.mdl",
				transform = {Vector(0,0,0),Angle(45,0,0),Vector(1.4,1.4,1.4)},
			},
			{
				transform = {Vector(-10,0,6),Angle(180-55,0,0),Vector(1,1,1)},
				children = {
					{
						model = "models/Gibs/wood_gib01a.mdl",
						color = Color(255,20,20,255),
						material = "models/debug/debugwhite",
						transform = {Vector(0,0,0),Angle(0,45,0),Vector(1,1,1)},
					},
					{
						model = "models/Gibs/wood_gib01b.mdl",
						color = Color(255,20,20,255),
						material = "models/debug/debugwhite",
						transform = {Vector(0,0,0),Angle(0,-45,0),Vector(1,1,1)},
					},
				}
			},
		}
	},
})

multimodel.Register("item_speedup", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_junk/Shoe001a.mdl",
				transform = {Vector(0,0,0),Angle(0,90,45),Vector(3,3,3)},
			},
			{
				model = "models/props_vehicles/carparts_wheel01a.mdl",
				transform = {Vector(-14,10,-12),Angle(0,90,45),Vector(0.4,0.4,0.4)},
			},
			{
				model = "models/props_vehicles/carparts_wheel01a.mdl",
				transform = {Vector(-14,-10,-12),Angle(0,90,45),Vector(0.4,0.4,0.4)},
			},
		}
	},
})

multimodel.Register("item_speeddown", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_junk/Shoe001a.mdl",
				transform = {Vector(0,0,0),Angle(0,90,45),Vector(3,3,3)},
				color = Color(40,200,255,255),
			},
			{
				model = "models/props_vehicles/carparts_wheel01a.mdl",
				transform = {Vector(-14,10,-12),Angle(0,90,45),Vector(0.4,0.4,0.4)},
				color = Color(255,180,180,255),
			},
			{
				model = "models/props_vehicles/carparts_wheel01a.mdl",
				transform = {Vector(-14,-10,-12),Angle(0,90,45),Vector(0.4,0.4,0.4)},
				color = Color(255,180,180,255),
			},
			{
				transform = {Vector(-10,0,6),Angle(180-55,0,0),Vector(1,1,1)},
				children = {
					{
						model = "models/Gibs/wood_gib01a.mdl",
						color = Color(255,20,20,255),
						material = "models/debug/debugwhite",
						transform = {Vector(0,0,0),Angle(0,45,0),Vector(1,1,1)},
					},
					{
						model = "models/Gibs/wood_gib01b.mdl",
						color = Color(255,20,20,255),
						material = "models/debug/debugwhite",
						transform = {Vector(0,0,0),Angle(0,-45,0),Vector(1,1,1)},
					},
				}
			},
		}
	},
})


multimodel.Register("item_remotebomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_wasteland/laundry_washer001a.mdl",
				transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.4,0.4,0.3)},
			},
			{
				model = "models/props_pipes/valve001.mdl",
				transform = {Vector(0,0,30),Angle(180,20,0),Vector(1,1,1)},
			},
		}
	},
})


multimodel.Register("item_plasmabomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
				transform = {Vector(0,0,0),Angle(45,0,0),Vector(1,1,1)},
				color = Color(20,20,50,255),
				material = "models/debug/debugwhite",
			},
			{
				transform = {Vector(0,0,0),Angle(0,45,0),Vector(1,1,1)},
				children = {
					{
						model = "models/props_c17/utilityconnecter006c.mdl",
						transform = {Vector(0,0,12),Angle(0,0,0),Vector(0.9,0.9,0.5)},
					},
					{
						model = "models/props_c17/utilityconnecter006c.mdl",
						transform = {Vector(12,0,0),Angle(90,0,0),Vector(0.9,0.9,0.5)},
					},
					{
						model = "models/props_c17/utilityconnecter006c.mdl",
						transform = {Vector(-12,0,0),Angle(90,180,0),Vector(0.9,0.9,0.5)},
					},
					{
						model = "models/props_c17/utilityconnecter006c.mdl",
						transform = {Vector(0,-12,0),Angle(0,180,-90),Vector(0.9,0.9,0.5)},
					},
					{
						model = "models/props_c17/utilityconnecter006c.mdl",
						transform = {Vector(0,12,0),Angle(0,0,-90),Vector(0.9,0.9,0.5)},
					},
				}
			}
		}
	}
})

multimodel.Register("item_randombomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
				transform = {Vector(0,0,0),Angle(45,0,0),Vector(1,1,1)},
				color = Color(20,20,20,255),
				material = "models/debug/debugwhite",
				
				Think = function(self, time)
					local s = 1 + 0.1 * (1 + math.sin(10*time))
					self.transform[3] = Vector(s, s, s)
				end,
				
				children = {
					{
						model = "models/props_lab/monitor01b.mdl",
						transform = {Vector(-8,0,8),Angle(-45,180,0),Vector(1.4,1.4,1.4)},
					},
				}
			},
			{
				transform = {Vector(0,0,0),Angle(45,45,0),Vector(1,1,1)},
				
				Think = function(self, time)
					local s = 1 + 0.035 * (1 + math.sin(10*time))
					self.transform[3] = Vector(s, s, s)
				end,
				
				children = {
					{
						model = "models/props_junk/propane_tank001a.mdl",
						color = Color(20,20,20,255),
						material = "models/debug/debugwhite",
						transform = {Vector(0,0,4),Angle(180,0,0),Vector(1,1,1)},
					},
					{
						model = "models/Gibs/HGIBS_rib.mdl",
						transform = {Vector(0,-3,18),Angle(-4,-280,-67),Vector(1,1,1)},
					},
				}
			},
		}
	},
})

multimodel.Register("item_rocketbomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
				transform = {Vector(0,0,0),Angle(0,0,0),Vector(1,1,1)},
			},
			
			{
				model = "models/props_wasteland/wheel01a.mdl",
				transform = {Vector(0,0,6),Angle(0,0,90),Vector(0.3,0.3,0.3)},
			},
			
			{
				model = "models/props_wasteland/wheel01a.mdl",
				transform = {Vector(0,0,-6),Angle(0,0,-90),Vector(0.3,0.3,0.3)},
			},
			
			{
				transform = {Vector(0,0,0),Angle(0,0,0),Vector(1,1,1)},
				
				children = {
					{
						transform = {Vector(0,0,0),Angle(0,0,0),Vector(1,1,1)},
						
						children = {
							{
								model = "models/props_junk/propane_tank001a.mdl",
								transform = {Vector(-18,0,0),Angle(90,0,0),Vector(1.5,1.5,0.6)},
							},
							{
								model = "models/props_junk/propane_tank001a.mdl",
								transform = {Vector(18,0,0),Angle(90,180,0),Vector(1.5,1.5,0.6)},
							},
							{
								model = "models/props_junk/propane_tank001a.mdl",
								transform = {Vector(0,-18,0),Angle(90,90,0),Vector(1.5,1.5,0.6)},
							},
							{
								model = "models/props_junk/propane_tank001a.mdl",
								transform = {Vector(0,18,0),Angle(90,-90,0),Vector(1.5,1.5,0.6)},
							},
						},
					}
				}
			},
		}
	},
})

multimodel.Register("item_minebomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.85,0.85,0.85)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_wasteland/laundry_basket002.mdl",
				color = Color(100,100,255,255),
				transform = {Vector(0,0,0),Angle(180,0,0),Vector(0.6,0.6,0.15)},
			},
			{
				model = "models/props_pipes/pipe02_connector01.mdl",
				color = Color(255,255,0,255),
				transform = {Vector(-0.1,-0.15,3.7),Angle(90,0,0),Vector(0.4,0.4,0.4)},
			},
		}
	},
})

multimodel.Register("item_dangerbomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_c17/pottery02a.mdl",
				transform = {Vector(-10,-10,-10),Angle(45,45,0),Vector(2.2,2.2,2.2)},
				color = Color(150,50,50,255),
			},
			{
				transform = {Vector(0,0,0),Angle(45,45,0),Vector(1,1,1)},
				children = {
					{
						model = "models/Gibs/HGIBS_rib.mdl",
						transform = {Vector(0,-3,12),Angle(-4,-280,-67),Vector(1,1,1)},
					},
				}
			},
		}
	}
})

multimodel.Register("item_invisbomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
				transform = {Vector(0,0,0),Angle(45,0,0),Vector(1,1,1)},
				color = Color(20,20,20,255),
				material = "models/debug/debugwhite",
			},
			{
				model = "models/props_c17/pipe_cap005.mdl",
				color = Color(255,150,0,255),
				transform = {Vector(0,0,0),Angle(-90,0,0),Vector(1,1,1)},
			},
		}
	}
})

multimodel.Register("item_nukebomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.7,0.7,0.7)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_c17/canister_propane01a.mdl",
				transform = {Vector(0,0,-24),Angle(0,0,0),Vector(0.9,0.9,0.7)},
				color = Color(90,20,20,255),
				
				children = {
					{
						model = "models/props_c17/canister02a.mdl",
						transform = {Vector(13,13,24),Angle(0,135,0),Vector(1,1,0.8)},
					},
					{
						model = "models/props_c17/canister02a.mdl",
						transform = {Vector(-13,13,24),Angle(0,-135,0),Vector(1,1,0.8)},
					},
					{
						model = "models/props_c17/canister02a.mdl",
						transform = {Vector(13,-13,24),Angle(0,45,0),Vector(1,1,0.8)},
					},
					{
						model = "models/props_c17/canister02a.mdl",
						transform = {Vector(-13,-13,24),Angle(0,-45,0),Vector(1,1,0.8)},
					},
					{
						model = "models/props_combine/combine_mine01.mdl",
						transform = {Vector(0,0,70),Angle(180,0,0),Vector(1.1,1.1,1.5)},
						color = Color(255,0,0,255),
					},
					{
						model = "models/props_combine/combine_lock01.mdl",
						transform = {Vector(-24,-4,48),Angle(180,90,0),Vector(1.1,1.1,1.5)},
						color = Color(255,0,0,255),
					},
				}
			},
		}
	}
})

multimodel.Register("item_radiobomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_lab/citizenradio.mdl",
				color = Color(255,255,255,255),
				transform = {Vector(0,0,-10),Angle(-20,180,0),Vector(1.2,1.2,1.2)},
				
				children = {
					{
						model = "models/props_rooftop/antenna01a.mdl",
						transform = {Vector(0,5,28),Angle(0,-90,0),Vector(0.15,0.15,0.1)},
					},
					{
						model = "models/props_lab/keypad.mdl",
						transform = {Vector(0,-5,17),Angle(-90,0,0),Vector(1, 1, 1)},
					},
					{
						model = "models/dav0r/hoverball.mdl",
						transform = {Vector(-1,0,1),Angle(-90,0,0),Vector(1.3, 1.3, 1.3)},
					},
				}
			},
		}
	}
})

multimodel.Register("item_physicsbomb", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_c17/oildrum001_explosive.mdl",
				transform = {Vector(0,21,0),Angle(0,0,90),Vector(0.9,0.9,0.9)},
				
				children = {
					{
						model = "models/Gibs/HGIBS_rib.mdl",
						transform = {Vector(6,-2,50),Angle(-4,0,-67),Vector(1,1,1)},
					},
				}
			},
		}
	}
})

multimodel.Register("item_skull", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/Gibs/HGIBS.mdl",
				transform = {Vector(0,0,0),Angle(-20,180,0),Vector(5,5,5)},
				
				children = {
					{
						sprite = "effects/blueflare1",
						transform = {Vector(3,1.5,0.8),Angle(0,0,0),Vector(3,3,3)},
						color = Color(255,20,0,255),
						
						Think = function(self, time)
							local s = math.Rand(2.5,4.5)
							self.transform[3].x = s
							self.transform[3].y = s
						end,
					},
					{
						sprite = "effects/blueflare1",
						transform = {Vector(3,-1.5,0.8),Angle(0,0,0),Vector(3,3,3)},
						color = Color(255,20,0,255),
						
						Think = function(self, time)
							local s = math.Rand(1.5,4.5)
							self.transform[3].x = s
							self.transform[3].y = s
						end,
					},
				}
			},
		}
	},
})

multimodel.Register("item_bombkick", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/Combine_Helicopter/helicopter_bomb01.mdl",
				transform = {Vector(0,15,15),Angle(45,0,0),Vector(0.6,0.6,0.6)},
				color = Color(20,20,20,255),
				material = "models/debug/debugwhite",
			},
			{
				transform = {Vector(0,-14,0),Angle(-45,90,0),Vector(1.3,1.3,1.3)},
				children = {
					{
						model = "models/props_docks/dock03_pole01a_256.mdl",
						material = "models/debug/debugwhite",
						color = Color(100,100,100,255),
						
						transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.6,0.6,0.12)},
					},
					{
						model = "models/props_junk/Shoe001a.mdl",
						transform = {Vector(3.5,-1,-15),Angle(0,0,0),Vector(1.4,1.4,1.4)},
					},
				}
			},
		}
	},
})

multimodel.Register("item_bombpunch", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/weapons/w_physics.mdl",
				transform = {Vector(0,-20,10),Angle(0,110,45),Vector(2,2,2)},
				
				children = {
					{
						effect = "effect_gravgun_glow_orange",
						delay = 0.1,
						transform = {Vector(22,0,0),Angle(0,0,0),Vector(1,1,1)},
					}
				}
			},
		}
	},
})

multimodel.Register("item_bombthrow", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/weapons/w_physics.mdl",
				transform = {Vector(0,-20,10),Angle(0,110,45),Vector(2,2,2)},
				skin = 1,
				
				children = {
					{
						effect = "effect_gravgun_glow_blue",
						delay = 0.1,
						transform = {Vector(22,0,0),Angle(0,0,0),Vector(1,1,1)},
					}
				}
			},
		}
	},
})

multimodel.Register("item_cratehide", {
	{
		model = "models/props_c17/pipe_cap005.mdl",
		color = Color(255,0,0,255),
		transform = {Vector(0,0,-20),Angle(-90,0,0),Vector(1.2,1.2,1.2)},
		
		Think = function(self, time)
			local s = 1 + 0.2 * (1 + math.sin(10*time))
			self.transform[2].y = math.NormalizeAngle(100*time)
			self.transform[3] = Vector(s, s, s)
		end,
	},
	
	{
		transform = {Vector(0,0,0),Angle(0,0,0),Vector(0.8,0.8,0.8)},
		
		Think = function(self, time)
			self.transform[1].z = 2*math.sin(4*time)
		end,
		
		children = {
			{
				model = "models/props_junk/wood_crate001a.mdl",
				transform = {Vector(0,0,0),Angle(0,40,0),Vector(0.6,0.6,0.6)},
			},
		}
	}
})