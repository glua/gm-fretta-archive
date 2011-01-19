local CLASS = {}

CLASS.DisplayName			= "Poltergeist"
CLASS.PlayerModel			= "models/props_junk/wood_crate001a.mdl"
CLASS.DisableFootsteps		= true
CLASS.DrawTeamRing			= false
CLASS.CanUseFlashlight      = false
CLASS.DrawViewModel			= false
CLASS.StartHealth			= 100
CLASS.Speed                 = 10.0

CLASS.ChangeSounds = {"ambient/levels/citadel/weapon_disintegrate1.wav",
"ambient/levels/citadel/weapon_disintegrate2.wav",
"ambient/levels/citadel/weapon_disintegrate3.wav",
"ambient/levels/citadel/weapon_disintegrate4.wav"}

CLASS.DieSounds = {"vo/npc/male01/pain01.wav",
"vo/npc/male01/pain02.wav",
"vo/npc/male01/pain03.wav",
"vo/npc/male01/pain04.wav",
"vo/npc/male01/pain05.wav",
"vo/npc/male01/pain06.wav",
"vo/npc/male01/pain07.wav",
"vo/npc/male01/pain08.wav",
"vo/npc/male01/pain09.wav",
"vo/streetwar/sniper/male01/c17_09_help01.wav",
"vo/streetwar/sniper/male01/c17_09_help02.wav",
"vo/npc/male01/help01.wav",
"vo/npc/male01/gordead_ans06.wav",
"vo/coast/bugbait/sandy_help.wav",
"vo/coast/odessa/male01/nlo_cubdeath01.wav",
"vo/coast/odessa/male01/nlo_cubdeath02.wav",
"vo/npc/male01/ow01.wav",
"vo/npc/male01/ow02.wav",
"vo/npc/male01/no01.wav",
"vo/npc/male01/no02.wav",
"vo/npc/male01/ohno.wav"}

CLASS.TauntSounds = {"vo/citadel/br_laugh01.wav",
"vo/npc/Barney/ba_yell.wav",
"vo/ravenholm/monk_blocked01.wav",
"vo/ravenholm/madlaugh01.wav",
"vo/ravenholm/madlaugh02.wav",
"vo/ravenholm/madlaugh03.wav",
"vo/ravenholm/madlaugh04.wav",
"vo/coast/bugbait/sandy_youthere.wav",
"vo/npc/male01/hi01.wav",
"vo/citadel/br_mock09.wav",
"vo/canals/male01/stn6_incoming.wav",
"vo/coast/bugbait/sandy_poorlaszlo.wav",
"vo/coast/bugbait/sandy_youthere.wav",
"vo/coast/odessa/male01/nlo_cheer01.wav",
"vo/coast/odessa/male01/nlo_cheer02.wav",
"vo/coast/odessa/male01/nlo_cheer03.wav",
"vo/coast/odessa/male01/nlo_cheer04.wav",
"vo/k_lab/ba_thereheis.wav",
"vo/npc/barney/ba_bringiton.wav",
"vo/npc/barney/ba_goingdown.wav",
"vo/npc/barney/ba_followme02.wav",
"vo/npc/barney/ba_hereitcomes.wav",
"vo/npc/barney/ba_heretheycome01.wav",
"vo/npc/barney/ba_heretheycome02.wav",
"vo/npc/barney/ba_uhohheretheycome.wav",
"vo/npc/barney/ba_laugh01.wav",
"vo/npc/barney/ba_laugh02.wav",
"vo/npc/barney/ba_laugh03.wav",
"vo/npc/barney/ba_laugh04.wav",
"vo/npc/barney/ba_ohyeah.wav",
"vo/npc/barney/ba_yell.wav",
"vo/npc/barney/ba_gotone.wav",
"vo/npc/male01/evenodds.wav",
"vo/npc/male01/behindyou01.wav",
"vo/npc/male01/behindyou02.wav",
"vo/npc/male01/cit_dropper04.wav",
"vo/npc/male01/fantastic02.wav",
"vo/npc/male01/gethellout.wav",
"vo/npc/male01/gordead_ques07.wav",
"vo/npc/male01/likethat.wav",
"vo/npc/male01/overhere01.wav",
"vo/npc/male01/overhere01.wav",
"vo/npc/male01/overthere02.wav",
"vo/npc/male01/excuseme01.wav",
"vo/npc/male01/pardonme01.wav",
"vo/npc/male01/question23.wav",
"vo/npc/male01/question06.wav",
"vo/npc/male01/okimready03.wav",
"vo/npc/male01/squad_away01.wav",
"vo/npc/male01/squad_away02.wav",
"vo/npc/male01/squad_away03.wav",
"vo/npc/male01/squad_follow02.wav",
"vo/npc/male01/vanswer13.wav",
"vo/npc/male01/heretheycome01.wav",
"vo/npc/male01/yeah02.wav",
"vo/npc/male01/gotone01.wav",
"vo/npc/male01/gotone02.wav",
"vo/npc/male01/headsup02.wav",
"vo/ravenholm/engage01.wav",
"vo/ravenholm/monk_death07.wav",
"vo/ravenholm/shotgun_closer.wav",
"vo/streetwar/sniper/ba_heycomeon.wav",
"vo/streetwar/sniper/ba_hearcat.wav",
"vo/streetwar/sniper/ba_overhere.wav"}

function CLASS:OnSpawn( pl )

	pl.SwapTime = 0
	pl.TauntTime = 0
	
	pl:SpawnProp( self.StartHealth )

end

function CLASS:OnDeath( pl )

	pl:EmitSound( Sound( table.Random( self.DieSounds ) ), 100, 130 )

	local prop = pl:GetProp()
	
	if prop and prop:IsValid() then
	
		prop:SetOwner()
	
		local low, high = prop:WorldSpaceAABB()
	
		local ed = EffectData()
		ed:SetOrigin( low )
		ed:SetStart( high )
		ed:SetMagnitude( prop:BoundingRadius() )
		util.Effect( "prop_die", ed, true, true )
	
		prop:Fire( "break", 1, 0.01 )
		timer.Simple( 1, function( prop ) if prop and prop:IsValid() then prop:Remove() end end, prop )
		
	end
	
end

function CLASS:Think( pl )

	local prop = pl:GetProp()
	if not prop or not prop:IsValid() then return end
	
	local phys = prop:GetPhysicsObject()
	if not phys or not phys:IsValid() then return end
	
	pl:SetPos( prop:GetPos() )
	
	if pl:KeyDown( IN_FORWARD ) then
		phys:ApplyForceCenter( pl:GetAimVector() * phys:GetMass() * self.Speed )
	elseif pl:KeyDown( IN_BACK ) then
		phys:ApplyForceCenter( pl:GetAimVector() * phys:GetMass() * -self.Speed )
	end
	
	local ang = pl:GetAimVector():Angle()
	ang.y = ang.y + 90
	
	if pl:KeyDown( IN_JUMP ) then
		phys:ApplyForceCenter( Vector(0,0,1) * phys:GetMass() * self.Speed * 1.5 )
	elseif pl:KeyDown( IN_MOVELEFT ) then
		phys:ApplyForceCenter( ang:Forward() * phys:GetMass() * self.Speed )
	elseif pl:KeyDown( IN_MOVERIGHT ) then
		ang.y = ang.y + 180
		phys:ApplyForceCenter( ang:Forward() * phys:GetMass() * self.Speed )
	end

end

function CLASS:OnKeyPress( pl, key )

	if not pl:Alive() or CLIENT then return end
	
	if ( key == IN_ATTACK2 and pl.SwapTime < CurTime() ) then
		
		local trace = { start = pl:GetPos(), endpos = pl:GetPos() + pl:GetAimVector() * 9000, filter = { pl, pl:GetProp() } }
		local tr = util.TraceLine( trace )
		
		local closest = 9000
		local choice = pl:GetProp()
		
		for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
			if v:GetPos():Distance( tr.HitPos ) < 250 and pl:GetProp() != v and not v:GetOwner():IsValid() then
				if v:GetPos():Distance( pl:GetPos() ) < closest then
					closest = v:GetPos():Distance( pl:GetPos() )
					choice = v
				end
			end
		end
		
		if choice != pl:GetProp() then
			pl:EmitSound( Sound( table.Random( self.ChangeSounds ) ), 100, 130 )
			pl:SetProp( choice )
			pl.SwapTime = CurTime() + 5
		end
		
	end
 
	if ( key == IN_SPEED and pl.TauntTime < CurTime() ) then
	
		pl:EmitSound( Sound( table.Random( self.TauntSounds ) ), 100, 130 )
		pl.TauntTime = CurTime() + 3
	
	end
	
end

player_class.Register( "GhostBase", CLASS )

local CLASS = {}

CLASS.Base                  = "GhostBase"
CLASS.DisplayName			= "Explosive Ghost"
CLASS.Description           = "Use your primary attack to detonate yourself and damage nearby humans!"
CLASS.StartHealth			= 150
CLASS.Speed                 = 5.0

function CLASS:Loadout( pl )
	
	pl:Give("weapon_prop_explode")
	
end

player_class.Register( "Explosive", CLASS )

local CLASS = {}

CLASS.Base                  = "GhostBase"
CLASS.DisplayName			= "Booster Ghost"
CLASS.Description           = "Use your primary attack to launch yourself towards humans at high speed!"
CLASS.StartHealth			= 100
CLASS.Speed                 = 10.0

function CLASS:Loadout( pl )
	
	pl:Give("weapon_prop_boost")
	
end

player_class.Register( "Boost", CLASS )

local CLASS = {}

CLASS.Base                  = "GhostBase"
CLASS.DisplayName			= "Electric Ghost"
CLASS.Description           = "Use your primary attack to shock nearby humans!"
CLASS.StartHealth			= 100
CLASS.Speed                 = 6.5

function CLASS:Loadout( pl )
	
	pl:Give("weapon_prop_shock")
	
end

player_class.Register( "Electric", CLASS )
