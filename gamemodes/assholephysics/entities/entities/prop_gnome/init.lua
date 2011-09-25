AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Bounciness 	    	    = 1.05

ENT.Chatter = {"vo/citadel/br_laugh01.wav",
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

function ENT:Initialize()
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS ) 
	
	local phys = self.Entity:GetPhysicsObject()
	
	if ValidEntity( phys ) then
	
		phys:Wake()
		
	end
	
	self.ChatTime = 0
	self.Trail = util.SpriteTrail( self.Entity, 0, Color( 255, 255, 0, 255 ), false, 2, 1, 0.25, 1 / 32 * 0.5, "trails/plasma.vmt" )
	
end

function ENT:Think()

	if self.ChatTime < CurTime() then
		
		self.ChatTime = CurTime() + math.random( 10, 20 )
		self.Entity:EmitSound( Sound( table.Random( self.Chatter ) ), 100, 130 )
		
	end
	
end

function ENT:OnTakeDamage( dmg )

	if not dmg:GetAttacker():IsPlayer() then return end
	
	local ply = dmg:GetAttacker()
	
	ply:AddCash( 5000 )
	
	umsg.Start( "DrawPrice", ply )
	umsg.Vector( self.Entity:GetPos() )
	umsg.String( "Bouncing Gnome: $5000" )
	umsg.Short( 5000 )
	umsg.End()
	
	self.Trail:Remove()
	self.Entity:Remove()
	
end

function ENT:PhysicsCollide( data, physobj )

	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()
	
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
	local TargetVelocity = NewVelocity * LastSpeed * self.Bounciness
	
	physobj:SetVelocity( TargetVelocity )
	
end