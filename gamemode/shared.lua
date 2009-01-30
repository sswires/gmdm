DeriveGamemode( "sg_base" );

GameInfo = {};

include( 'cvars.lua' );
include( 'version.lua' );
include( 'extensions/pickup_manager.lua' );
include( 'ply_extension.lua' )
include( 'teamplay.lua' );
include( 'overrides.lua' );
include( 'achievements.lua' );

if( SERVER ) then
	AddCSLuaFile( "extensions/pickup_manager.lua" );
	AddCSLuaFile( "teamplay.lua" );
	AddCSLuaFile( "version.lua" );
	AddCSLuaFile( "overrides.lua" );
	AddCSLuaFile( "achievements.lua" );
end

if( GM.IsSVN == true ) then
	GM.Name 	= "GMDM Redux (SVN)"
else
	GM.Name		= "GMDM Redux " .. GM.Version
end

GM.Author 	= "TEAM GMDM"
GM.Email 	= "stephen.swires@gmail.com"
GM.Website 	= "http://s-swires.org/gmdm/"

local WalkTimer = 0
local VelSmooth = 0

// Global holding all our human gibs!
HumanGibs = {}

	table.insert( HumanGibs, "models/gibs/antlion_gib_medium_2.mdl" )
	table.insert( HumanGibs, "models/gibs/Antlion_gib_Large_1.mdl" )
	//table.insert( HumanGibs, "models/gibs/gunship_gibs_eye.mdl" )
	table.insert( HumanGibs, "models/gibs/Strider_Gib4.mdl" )
	table.insert( HumanGibs, "models/gibs/HGIBS.mdl" )
	table.insert( HumanGibs, "models/gibs/HGIBS_rib.mdl" )
	table.insert( HumanGibs, "models/gibs/HGIBS_scapula.mdl" )
	table.insert( HumanGibs, "models/gibs/HGIBS_spine.mdl" )


	for k, v in pairs( HumanGibs ) do
		util.PrecacheModel( v )
	end


GM.RegisteredCvars = false;

function GM:GetGameDescription( )
	return GAMEMODE.Name .. " - " .. GAMEMODE:GetModeDescription( )
end

function GM:GetModeDescription()

	local prefix = "";
	
	if( gmdm_headshotmode and gmdm_headshotmode:GetBool() ) then
		prefix = prefix .. "Headshots only "
	end
	
	if( GAMEMODE:IsTeamPlay() ) then
		prefix = prefix .. "Team ";
	end
	
	if( gmdm_soulcollector and gmdm_soulcollector:GetBool() ) then
		if( gmdm_instagib:GetInt() > 0 ) then
			return prefix .. "Soul Collector Insta-gib";
		else
			return prefix .. "Soul Collector";
		end
	elseif( gmdm_instagib and gmdm_instagib:GetInt() > 1 ) then
		return prefix .. "Instagib"
	elseif( gmdm_instagib and gmdm_instagib:GetInt() == 1 ) then
		return prefix .. "One Shot, One Kill DM"
	else
		return prefix .. "Deathmatch"
	end
end	
function GM:PlayerShouldTakeDamage( ply, attacker )
	if( SERVER and ply.Protected == true  ) then return false end
	local bTeamplay = GAMEMODE:IsTeamPlay()
	local bFriendlyFire = util.tobool( GetConVarNumber( "mp_friendlyfire" ) );
	
	if( !bTeamplay ) then return true end
	
	if( attacker:IsPlayer() and attacker:Team() == ply:Team() and ply != attacker ) then
		if( bFriendlyFire ) then
			PrintMessage( HUD_PRINTTALK, "[" .. team.GetName( attacker:Team() ) .. "] " .. attacker:Name() .. " attacked a teammate" )
			return true
		else
			return false
		end
	end
	
	return true
end

function GM:GetRagdollEyes( ply )

	local Ragdoll = nil
	
	Ragdoll = ply:GetRagdollEntity()
	if ( !Ragdoll ) then return end
	
	
	local att = Ragdoll:GetAttachment( Ragdoll:LookupAttachment("eyes") )
	if ( att ) then
	
		local RotateAngle = Angle( math.sin( CurTime() * 0.5 ) * 30, math.cos( CurTime() * 0.5 ) * 30, math.sin( CurTime() * 1 ) * 30 )	

		att.Pos = att.Pos + att.Ang:Forward() * 1
		att.Ang = att.Ang
		
		return att.Pos, att.Ang
	
	end
	

end

local LastStrafeRoll = 0

function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	
	local RagdollPos, RagdollAng = self:GetRagdollEyes( ply )
	if ( RagdollPos && RagdollAng ) then
		return self.BaseClass:CalcView( ply, RagdollPos, RagdollAng, 90 )
	end

	VelSmooth = math.Clamp( VelSmooth * 0.9 + vel:Length() * 0.1, 0, 700 )
	
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05
	
	// Roll on strafe (smoothed)
	LastStrafeRoll = (LastStrafeRoll * 3) + (ang:Right():DotProduct( vel ) * 0.0001 * VelSmooth * 0.3)
	LastStrafeRoll = LastStrafeRoll * 0.25
	angle.roll = angle.roll + LastStrafeRoll
	

	// Roll on steps
	if ( ply:GetGroundEntity() != NULL ) then	
	
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.000002 * VelSmooth
		angle.pitch = angle.pitch + math.cos( WalkTimer * 0.5 ) * VelSmooth * 0.000002 * VelSmooth
		angle.yaw = angle.yaw + math.cos( WalkTimer ) * VelSmooth * 0.000002 * VelSmooth
		
	end
	
	angle = angle + ply:HeadshotAngles() + ply:ShootShakeAngles()
	
	fov = fov + GAMEMODE.FOVModifier
		
	return self.BaseClass:CalcView( ply, origin, angle, fov )

end

function GM:SetupMove( ply, mv )

	return false

end

function GM:Move( ply, mv )

	return false

end


function GM:PlayerTraceAttack( ply, dmginfo, dir, trace )

	
	if( trace.HitGroup == HITGROUP_HEAD ) then
		dmginfo:SetDamageForce( VectorRand() * 500 );
		ply.Headshot = true;
	else
		ply.Headshot = false;
	end
	
	
	local bFriendlyFire = util.tobool( GetConVarNumber( "mp_friendlyfire" ) );
	
	if( ( ply.Protected == true and SERVER ) or ( GAMEMODE:IsTeamPlay() == true and bFriendlyFire == false and ply:Team() == dmginfo:GetAttacker():Team() ) ) then
		dmginfo:ScaleDamage( -1 );
		return false;
	end
	
	if( GAMEMODE:IsTeamPlay() == true and bFriendlyFire == true and ply:Team() == dmginfo:GetAttacker():Team() ) then
		dmginfo:SetDamage( 1 );
		return false;
	end
	
	if( SERVER and gmdm_headshotmode:GetBool() == true and trace.HitGroup != HITGROUP_HEAD and dmginfo:IsBulletDamage() == true ) then
		dmginfo:ScaleDamage( -1 );
		return false;
	end
	
	if( SERVER and gmdm_instagib:GetBool() == true ) then
		dmginfo:SetDamage( 250 );
		return false;
	end
	
	ply:TraceAttack( dmginfo, dir, trace )

	if( SERVER ) then
		dmginfo:ScaleDamage( GAMEMODE:GetHitboxMulti( trace.HitGroup ) ); -- hitbox based damage
		return false
	end
	
	return true
	
end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo ) 

	if( hitgroup == HITGROUP_HEAD ) then
		dmginfo:SetDamageForce( VectorRand() * 500 );
		npc.Headshot = true;
	else
		npc.Headshot = false;
	end

	dmginfo:ScaleDamage( GAMEMODE:GetHitboxMulti( hitgroup ) ); -- hitbox based damage
	
	if( dmginfo:GetAttacker():IsPlayer() and GAMEMODE:EntityFitsFilter( GAMEMODE.HitIndicatorEnts, npc:GetClass() ) and GAMEMODE:ShouldDrawHitIndicator() == true ) then
		GAMEMODE:SendHitIndicator( dmginfo:GetAttacker(), dmginfo:GetDamage()/100 );
	end

end


/*---------------------------------------------------------
   Name: gamemode:OnNPCKilled( entity, attacker, inflictor )
   Desc: The NPC has died
---------------------------------------------------------*/
function GM:OnNPCKilled( ent, attacker, inflictor )

	// Convert the inflictor to the weapon that they're holding if we can.
	if ( inflictor && inflictor != NULL && attacker == inflictor && (inflictor:IsPlayer() || inflictor:IsNPC()) ) then
	
		inflictor = inflictor:GetActiveWeapon()
		if ( attacker == NULL ) then inflictor = attacker end
	
	end
	
	local InflictorClass = "World"
	local AttackerClass = "World"
	
	if ( inflictor && inflictor != NULL ) then InflictorClass = inflictor:GetClass() end
	if ( attacker  && attacker != NULL ) then AttackerClass = attacker:GetClass() end

	if ( attacker && attacker != NULL && attacker:IsPlayer() ) then
	
		umsg.Start( "PlayerKilledNPC" )
		
			umsg.String( ent:GetClass() )
			umsg.String( InflictorClass )
			umsg.Entity( attacker )
			umsg.Bool( ent.Headshot )
		
		umsg.End()
		
	return end
	
	umsg.Start( "NPCKilledNPC" )
	
		umsg.String( ent:GetClass() )
		umsg.String( InflictorClass )
		umsg.String( AttackerClass )
		umsg.Bool( ent.Headshot )
	
	umsg.End()

end


function GM:Think( )

	local PlayerList = player.GetAll()
	for  k, pl in pairs(PlayerList) do
		pl:Think()
	end

end
