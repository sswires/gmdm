-- achievements enum
ACH_THUNDERSTRUCK = 1;
ACH_DEMOLITIONS = 2;

-- achievements
function ThunderstruckHook( ply, attacker, dmginfo )
	
	local inflictor = dmginfo:GetInflictor()
	
	if attacker:IsPlayer() and inflictor and inflictor:GetClass() == "grenade_electricity"  then
		ply:AddAchievementID( ACH_THUNDERSTRUCK );
	end
end

Achievements.Create( "Thunderstruck", "Kill 30 enemies with the electricity nade.", ACH_THUNDERSTRUCK, ThunderstruckHook, "DoPlayerDeath", 30 );

function DemolitionsHook( ply, attacker, dmginfo )
	
	local inflictor = dmginfo:GetInflictor()
	
	if attacker:IsPlayer() and inflictor and inflictor:GetClass() == "item_tripmine" and inflictor.Remote then
		ply:AddAchievementID( ACH_DEMOLITIONS );
	end
end

Achievements.Create( "Demolitions", "Kill 5 enemies with remotely detonated tripmine.", ACH_DEMOLITIONS, DemolitionsHook, "DoPlayerDeath", 5 );

Achievements.Create( "Dead", "Die", 3, function( pl ) pl:AddAchievement( 3 ) end, "DoPlayerDeath" );