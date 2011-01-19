AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.InitialVelocity 	= 1900 	// How much speed should it have when it spawns?
ENT.NumBounces 			= 5 	// How many bounces before it dissipates?
ENT.HitEffect 			= "hitsmoke" 	// Todo: effect to play when ball hits the ground/wall. Leave as "" for no effect
ENT.DieEffect			= "smoke_poof"	// Todo: effect to use on the ball for death. Leave as "" for no effect.
ENT.Bounciness 			= 2.5 // How much hitnormal force to apply when ball hits a surface?
ENT.Trail 				= "" 	// Todo: effect to use on the ball for trails etc. Leave as "" for no effect.
ENT.Damage              = 60    // How much damage does the ball deal upon impact?
ENT.BouncePower         = 450   // Super bouncy player
ENT.HitSound			= Sound("weapons/fx/rics/ric2.wav")