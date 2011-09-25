
local matBlood = Material( "effects/bloodstream" )

function EFFECT:Init( data )

	self.Particles = {}
	
	self.PlaybackSpeed 	= math.Rand( 2, 5 )
	self.Width 			= math.Rand( 8, 16 )
	self.ParCount		= 8
	
	local speed = math.Rand( 100, 1000 )
	local delay = math.Rand( 3, 5 )
	local dir = VectorRand() * 0.5 + data:GetNormal() * 0.5
	
	dir.x = math.Clamp( dir.x, -1.0, 0 )
	
	for i=1, math.random(3,6) do
	
		local p = {}
		
		p.Pos = data:GetOrigin()
		p.Vel = dir * ( speed * ( i /16 ) )
		p.Delay = ( 16 - i ) * delay
		p.Rest = false
		
		table.insert( self.Particles, p )
	
	end
	
end

local function VectorMin( v1, v2 )
	
	if ( v1 == nil ) then return v2 end
	if ( v2 == nil ) then return v1 end
	
	local vr = Vector( v2.x, v2.y, v2.z )
	
	if ( v1.x < v2.x ) then vr.x = v1.x end
	if ( v1.y < v2.y ) then vr.y = v1.y end
	if ( v1.z < v2.z ) then vr.z = v1.z end
	
	return vr

end

local function VectorMax( v1, v2 )
	
	if ( v1 == nil ) then return v2 end
	if ( v2 == nil ) then return v1 end
	
	local vr = Vector( v2.x, v2.y, v2.z )
	
	if ( v1.x > v2.x ) then vr.x = v1.x end
	if ( v1.y > v2.y ) then vr.y = v1.y end
	if ( v1.z > v2.z ) then vr.z = v1.z end
	
	return vr

end

function EFFECT:Think( )

	print(6)

	local fspeed = self.PlaybackSpeed * FrameTime()
	
	local moved = false
	local min = self.Entity:GetPos()
	local max = min
	
	self.Width = self.Width - 0.7 * fspeed
	
	if self.Width < 0 then
	
		return false
		
	end
	
	for k, p in pairs( self.Particles ) do
	
		if p.Rest then
		
		elseif p.Delay > 0 then
			
			p.Delay = p.Delay - 100 * fspeed
			
		else
			
			p.Vel:Sub( Vector( 0, 0, 60 * fspeed ) )
			
			p.Vel.x = math.Approach( p.Vel.x, 0, 2 * fspeed )
			p.Vel.y = math.Approach( p.Vel.y, 0, 2 * fspeed )
			
			local trace = {}
			trace.start 	= p.Pos
			trace.endpos 	= p.Pos + p.Vel * fspeed
			trace.mask 		= MASK_NPCWORLDSTATIC
			
			local tr = util.TraceLine( trace )
			
			if tr.Hit then
				
				tr.HitPos:Add( tr.HitNormal * 2 )
				
				local effectdata = EffectData()
					effectdata:SetOrigin( tr.HitPos )
					effectdata:SetNormal( tr.HitNormal )
				//util.Effect( "bloodsplash", effectdata )
				
				if tr.HitNormal.z < -0.75 then
				
					p.Vel.z = 0
				
				else
				
					p.Rest = true
				
				end
			
			end
			
			p.Pos = tr.HitPos
			moved = true
		
		end
	
	end
	
	self.ParCount = table.Count( self.Particles )
	
	if moved then
	
		for k, p in pairs( self.Particles ) do
		
			min = VectorMin( min, p.Pos )
			max = VectorMax( max, p.Pos )
			
		end

		local pos = min + ( max - min ) * 0.5
		
		self.Entity:SetPos( pos )
		self.Entity:SetCollisionBounds( pos - min, pos - max )
		
	end
	
	return self.ParCount > 0
	
end

function EFFECT:Render()

	render.SetMaterial( matBlood )
	
	local lastpos = nil
	local count = 0
	local color = Color( 100, 0, 0, 255 )

	for k, p in pairs( self.Particles ) do
	
		local sin = math.sin( ( count / ( self.ParCount - 2 ) ) * math.pi )
		
		if lastpos then
		
			render.DrawBeam( lastpos, 		
					 p.Pos,
					 self.Width * Sin,					
					 1,					
					 0,				
					 color )
		
		end
		
		count = count + 1
		lastpos = p.Pos
	
	end
	
end



