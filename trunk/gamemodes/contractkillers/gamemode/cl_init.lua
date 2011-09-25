include( 'shared.lua' )
include( 'cl_hud.lua' )

function GM:PositionScoreboard( ScoreBoard )

	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( (ScrW() - ScoreBoard:GetWide()) / 2, 50 )

end

function contract_updated_hook(um)
CLContract =  um:ReadEntity()
end

usermessage.Hook("new_contract",contract_updated_hook)

function contract_clear_hook(um)
CLContract =  nil
end

usermessage.Hook("reset_contract",contract_clear_hook)