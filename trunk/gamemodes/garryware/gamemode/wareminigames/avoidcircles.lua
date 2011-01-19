WARE.Author = "Hurricaaane (Ha3)"
WARE.Room = "empty"

WARE.CircleRadius = 64

WARE.Circles = {}

function WARE:Initialize()
	GAMEMODE:SetFailAwards( AWARD_VICTIM )
	
	GAMEMODE:SetWareWindupAndLength(3, 4)

	GAMEMODE:SetPlayersInitialStatus( true )
	GAMEMODE:DrawInstructions( "Don't be on the circles!" )
	
	self.Circles = {}
	
	self.LastThinkDo = 0
	
	local ratio = 0.6
	local num = #GAMEMODE:GetEnts({"dark_ground","light_ground"}) * ratio
	local entposcopy = GAMEMODE:GetRandomLocations(num, {"dark_ground","light_ground"} )
	
	for k,v in pairs(entposcopy) do
		local ent = ents.Create("ware_ringzone_preset")
		ent:SetPos(v:GetPos() + Vector(0,0,4) )
		ent:SetAngles(Angle(0,0,0))
		ent:Spawn()
		ent:Activate()
		
		GAMEMODE:AppendEntToBin(ent)
		
		ent.LastActTime = 0
		
		table.insert( self.Circles , ent )

		GAMEMODE:AppendEntToBin(ent)
		GAMEMODE:MakeAppearEffect(ent:GetPos())
	end
	
	return
end

function WARE:StartAction()
	for _,v in pairs(team.GetPlayers(TEAM_HUMANS)) do
		v:Give( "sware_crowbar" )
	end
	
	return
end

function WARE:EndAction()

end


function WARE:Think( )
	if (CurTime() < (self.LastThinkDo + 0.1)) then return end
	self.LastThinkDo = CurTime()
	
	for k,ring in pairs(self.Circles) do
		local sphere = ents.FindInSphere(ring:GetPos(), self.CircleRadius)
		for _,target in pairs(sphere) do
			
			if (target:IsPlayer() and target:IsWarePlayer()) or ( target:GetClass() == "swent_crowbar" ) then
				if (CurTime() > (ring.LastActTime + 0.2)) then
					ring.LastActTime = CurTime()
					if target:IsPlayer() and target:IsWarePlayer() and not target:GetLocked() then
						ring:EmitSound("ambient/levels/labs/electric_explosion1.wav")
						
						local effectdata = EffectData( )
							effectdata:SetOrigin( ring:GetPos( ) )
							effectdata:SetNormal( Vector(0,0,1) )
						util.Effect( "waveexplo", effectdata, true, true )
					end
					
					if (target:IsPlayer() == false) then
						target:EmitSound("weapons/flame_thrower_airblast_rocket_redirect.wav")
						target:GetPhysicsObject():ApplyForceCenter((target:GetPos() - ring:GetPos()):Normalize() * 150000)
						
						if ((target.Deflected or false) == false) then
							target.Deflected = true
							local trail_entity = util.SpriteTrail( target,  --Entity
																	0,  --iAttachmentID
																	Color( 255, 255, 255, 255 ),  --Color
																	false, -- bAdditive
																	8, --fStartWidth
																	0, --fEndWidth
																	0.2, --fLifetime
																	1 / ((0.7+1.2) * 0.5), --fTextureRes
																	"trails/tube.vmt" ) --strTexture
						end
						
						
					else
						target:SetGroundEntity( NULL )
						target:SetVelocity(target:GetVelocity()*(-1) + (target:GetPos() + Vector(0,0,32) - ring:GetPos()):Normalize() * 500)
					end
				
				end
			end
			
			if target:IsPlayer() and not target:GetLocked() then
				target:ApplyLose()
				local dir = (target:GetPos() + Vector(0, 0, 128) - ring:GetPos()):Normalize()
				target:SimulateDeath( dir * 1000 )
				target:EjectWeapons( dir * 200, 100 )
				
			end
		end
	end
end
