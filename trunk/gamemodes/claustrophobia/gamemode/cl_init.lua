include( 'shared.lua' )

// Since  we're copying the same brush ent hundreds of times, each time one gets shot the bullet decals get added to all of them, which sucks
// This is a bit of a hack to remove the decals.
timer.Create("decalTimer", 0.5, 0, function() LocalPlayer():ConCommand('r_cleardecals') end )
