--[[EXAMPLES

function FallHook(ply,attacker,dmg)
	if dmg:IsFallDamage() then
		ply:AddAchievement(ACH_FALL)
	end
end

function FirstBloodHook(ply,attacker,dmg)
	if attacker:IsPlayer() then
		ply:AddAchievement(ACH_FIRSTBLOOD)
	end
end

ACH_FALL = 1
ACH_FIRSTBLOOD = 2
Achievements.Create("Sidewalk Pizza","Die from falling off a high ledge.",ACH_FALL,FallHook,"DoPlayerDeath")
Achievements.Create("First Blood","Kill an enemy.",ACH_FIRSTBLOOD,FirstBloodHook,"DoPlayerDeath")]]

