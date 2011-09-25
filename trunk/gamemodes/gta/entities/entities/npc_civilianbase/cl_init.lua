include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.FriendMat = Material( "gta/defend" )
ENT.EnemyMat = Material( "gta/target" )

function ENT:Draw()

	self.Entity:DrawModel()
	
end

function ENT:DrawTranslucent()

	self.Entity:Draw()
	
end

function ENT:BuildBonePositions( NumBones, NumPhysBones )

	// You can use this section to position the bones of
	// any animated model using self:SetBonePosition( BoneNum, Pos, Angle )
	
	// This will override any animation data and isn't meant as a 
	// replacement for animations. We're using this to position the limbs of ragdolls
	
end

function ENT:SetRagdollBones( bIn )

	// If this is set to true then the engine will call 
	// DoRagdollBone (below) for each ragdoll bone
	// It will then automatically fill in the rest of the bones

	self.m_bRagdollSetup = bIn

end

function ENT:DoRagdollBone( PhysBoneNum, BoneNum )

	// self:SetBonePosition( BoneNum, Pos, Angle )
	
end
