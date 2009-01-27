-- this is where GMDM becomes more of a base for future gamemodes
GM.FOVModifier = 0; -- you can use this to reduce or increase the FOV of the player's view without SetFOV()
GM.PlayerWalkSpeed = 200; -- player walk speed (CS base weapons also use this value for their walk and run speed modifiers)
GM.PlayerRunSpeed = 500; -- player run speed

-- == HIT INDICATORS ==
GM.HitIndicatorEnts = { "player", "npc_" } -- the ents that should trigger a hit indicator

function GM:ShouldDrawHitIndicator() -- you can make this always return true or false if you want for your gamemode
	return gmdm_hitindicators:GetBool();
end
