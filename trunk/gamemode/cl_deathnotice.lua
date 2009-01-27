local hud_deathnotice_time = CreateConVar( "hud_deathnotice_time", "6", FCVAR_REPLICATED )

// These are our kill icons
local Color_Icon = Color( 200, 200, 200, 255 ) 
local NPC_Color = Color( 250, 50, 50, 255 ) 

killicon.AddFont( "gmdm_pistol", "HL2MPTypeDeath", "-", Color_Icon )
killicon.AddFont( "gmdm_smg", "HL2MPTypeDeath", "/", Color_Icon )
killicon.AddFont( "gmdm_rail", "HL2MPTypeDeath", "2", Color_Icon )
killicon.AddFont( "gmdm_shotgun", "HL2MPTypeDeath", "0", Color_Icon )
killicon.AddFont( "rpg_rocket", "HL2MPTypeDeath", "3", Color_Icon )
killicon.AddFont( "gmdm_crossbow", "HL2MPTypeDeath", "1", Color_Icon )
killicon.AddFont( "flechette_shrapnel", "HL2MPTypeDeath", "1", Color_Icon )
killicon.AddFont( "flechette_bolt", "HL2MPTypeDeath", "1", Color_Icon )
killicon.AddFont( "env_explosion", "HL2MPTypeDeath", "*", Color_Icon )
killicon.AddFont( "gmdm_tripmine", "HL2MPTypeDeath", "*", Color_Icon )
killicon.AddFont( "smg_grenade", "HL2MPTypeDeath", "7", Color_Icon )
killicon.AddFont( "grenade_electricity", "HL2MPTypeDeath", "4", Color_Icon )
killicon.AddFont( "gmdm_electricity_nades", "HL2MPTypeDeath", "4", Color_Icon )
killicon.AddFont( "gmdm_crowbar", "HL2MPTypeDeath", "6", Color_Icon )

killicon.AddFont( "headshot", "HVACSKillIcons", "D", Color_Icon )

GM.KillMsgSettings = {}
GM.KillMsgSettings.ChatArea = false;
GM.KillMsgSettings.Background = true;
GM.KillMsgSettings.BackgroundColor = Color( 0, 0, 0, 50 );
GM.KillMsgSettings.Font = "HudBarItemSmall"
GM.KillMsgSettings.Outlined = true;

local Deaths = {}

local function PlayerIDOrNameToString( var )

	if ( type( var ) == "string" ) then 
		if ( var == "" ) then return "" end
		return "#"..var 
	end
	
	local ply = Entity( var )
	
	if (ply == NULL) then return "NULL!" end
	
	return ply:Name()
	
end

function LookupWeapon( class )
	for k, v in pairs( weapons.GetList() ) do
		if( v.ClassName == class ) then
			return v.PrintName
		end
	end
	
	return class;
end
local function RecvPlayerKilledByPlayer( message )

	local victim 	= message:ReadEntity();
	local inflictor	= message:ReadString();
	local attacker 	= message:ReadEntity();
	local headshot	= message:ReadBool();
	
	if( attacker and attacker == LocalPlayer() and victim ) then
		GAMEMODE:SetLatestVictim( victim )
	end
	
	if( victim and victim == LocalPlayer() and attacker and attacker:IsValid() ) then
		GAMEMODE:SetLatestVictim( attacker, true )
	end
			
	if( GAMEMODE.KillMsgSettings.ChatArea == true ) then
		LocalPlayer():PrintMessage( HUD_PRINTTALK, attacker:Name() .. " [" .. LookupWeapon( inflictor ) .. "] " .. victim:Name() );
	else
		GAMEMODE:AddDeathNotice( attacker:Name(), attacker:Team(), inflictor, victim:Name(), victim:Team(), headshot )
	end
end
	
usermessage.Hook( "PlayerKilledByPlayer", RecvPlayerKilledByPlayer )


local function RecvPlayerKilledSelf( message )

	local victim 	= message:ReadEntity();			
	
	if( victim and victim:IsValid() ) then

		if( victim == LocalPlayer() ) then
			GAMEMODE:SetLatestVictim( victim )
		end
		
		if( GAMEMODE:IsPlayerTeam( victim:Team() ) ) then -- don't show kill messages when switching from unassigned/spec
			GAMEMODE:AddDeathNotice( victim:Name(), victim:Team(), "suicide", nil, 0 ); -- GM:AddDeathNotice( Victim, team1, Inflictor, Attacker, team2, headshot )
		end
	end
	

end
	
usermessage.Hook( "PlayerKilledSelf", RecvPlayerKilledSelf )


local function RecvPlayerKilled( message )

	local victim 	= message:ReadEntity();
	local inflictor	= message:ReadString();
	local attacker 	= "#" .. message:ReadString();
			
	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim:Name(), victim:Team() )

end
	
usermessage.Hook( "PlayerKilled", RecvPlayerKilled )

local function RecvPlayerKilledNPC( message )

	local victim 	= "#" .. message:ReadString();
	local inflictor	= message:ReadString();
	local attacker 	= message:ReadEntity();
	local headshot = message:ReadBool();
			
	GAMEMODE:AddDeathNotice( attacker:Name(), attacker:Team(), inflictor, victim, -1, headshot )

end
	
usermessage.Hook( "PlayerKilledNPC", RecvPlayerKilledNPC )


local function RecvNPCKilledNPC( message )

	local victim 	= "#" .. message:ReadString();
	local inflictor	= message:ReadString();
	local attacker 	= "#" .. message:ReadString();
	local headshot = message:ReadBool();
			
	GAMEMODE:AddDeathNotice( attacker, -1, inflictor, victim, -1, headshot )

end
	
usermessage.Hook( "NPCKilledNPC", RecvNPCKilledNPC )

local function RecvCaptured( message )

end

usermessage.Hook( "PlayerPointCapture", RecvCaptured )


function GM:AddPointCapture( capturers, kteam, killicon, message, point, vteam )

	local Death = {}
	Death.victim = point
	Death.attacker = capturers
	Death.time = CurTime()
	
	Death.left = capturers
	Death.right = point

	if ( team == -1 ) then Death.color1 = table.Copy( NPC_Color ) 
	else Death.color1 = table.Copy( team.GetColor( kteam ) ) end
		
	if ( vteam == -1 ) then Death.color2 = table.Copy( NPC_Color ) 
	else Death.color2 = table.Copy( team.GetColor( vteam ) ) end
	
	Death.headshot = false;
	Death.icon = killicon;
	
	Death.pointcapture = true;
	Death.message = message;
	
	table.insert( Deaths, Death )
end

/*---------------------------------------------------------
   Name: gamemode:AddDeathNotice( Victim, Attacker, Weapon )
   Desc: Adds an death notice entry
---------------------------------------------------------*/
function GM:AddDeathNotice( Victim, team1, Inflictor, Attacker, team2, headshot )

	local Death = {}
	Death.victim 	= 	Victim
	Death.attacker	=	Attacker
	Death.time		=	CurTime()
	
	Death.left		= 	Victim
	Death.right		= 	Attacker
	
	Death.headshot	= 	headshot
	Death.icon		=	Inflictor
	
	if ( team1 == -1 ) then Death.color1 = table.Copy( NPC_Color ) 
	else Death.color1 = table.Copy( team.GetColor( team1 ) ) end
		
	if ( team2 == -1 ) then Death.color2 = table.Copy( NPC_Color ) 
	else Death.color2 = table.Copy( team.GetColor( team2 ) ) end
	
	table.insert( Deaths, Death )

end

local function DrawDeath( x, y, death, hud_deathnotice_time )

	local fadeout = ( death.time + hud_deathnotice_time ) - CurTime()
	local alpha = math.Clamp( fadeout * 255, 0, 255 )
	
	death.color1.a = alpha
	death.color2.a = alpha
	
	-- widths
	local rightw = GetNameWidth( death.right );
	local rightwname = 0;
	
	if( !death.right ) then
		death.right = "";
	end
	
	if( !death.left) then
		death.left = "";
	end
	
	if( death.pointcapture ) then
		rightwname = rightw;
		rightw = rightw + GetNameWidth( death.message ) + 14
	end
	
	local w, h = 0, 0;
	
	if( death.icon != "none" ) then
		w, h = killicon.GetSize( death.icon )
	end
	
	local kw = w;
	local kh = h;
	
	local leftw = GetNameWidth( death.left );
	
	local wx = 0;
	local hx = 0;
	
	if( death.headshot ) then
		wx, hx = killicon.GetSize( "headshot" )
		w = w + wx + 10		
	end
	
	if( x < ScrW()/2 ) then
		x = x + ( w + leftw + rightw + 30 );
	end
	
	-- background
	if( GAMEMODE.KillMsgSettings.Background ) then
		draw.RoundedBox( 6, x - rightw - w - 20 - leftw - 10, y - 10, rightw + w + 40 + leftw, 36, Color( GAMEMODE.KillMsgSettings.BackgroundColor.r, GAMEMODE.KillMsgSettings.BackgroundColor.g, GAMEMODE.KillMsgSettings.BackgroundColor.b, math.Clamp( GAMEMODE.KillMsgSettings.BackgroundColor.a, 0, 75 ) ) ); 
	end
	
	-- drawing
	DrawName( death.right, death.color2, x, y )
	
	if( death.pointcapture ) then
		local col = Color_Icon
		col.a = alpha;
		
		DrawName( death.message, col, x - rightwname - 7, y )
	end
			
	if( death.icon != "none" ) then
		if( death.headshot ) then
			killicon.Draw( x - rightw - (wx/2) - 10, y, "headshot", alpha )
			killicon.Draw( x - rightw - wx - (kw/2) - 10, y, death.icon, alpha )
		else
			killicon.Draw( x - rightw - (kw/2) - 10, y, death.icon, alpha )
		end
	end
	
	DrawName( death.left, death.color1, x - rightw - w - 20, y )

	local perc = y/ScrH()
	
	if( perc < 0.6 ) then
		return y + 42
	end
	
	return y - 42
end

function DrawName( name, color, x, y )

	local font = GAMEMODE.KillMsgSettings.Font;
	
	if( GAMEMODE.KillMsgSettings.Outlined ) then
		draw.SimpleTextOutlined( name, font, x, y, 	color, 	TEXT_ALIGN_RIGHT, TEXT_ALIGN_MIDDLE, 1, Color(0,0,0,255) )
	else
	draw.SimpleText( name, font, x, y, color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_MIDDLE )
	end
end

function GetNameWidth( name )

	if( !name ) then
		return 0;
	end
	
	local font = GAMEMODE.KillMsgSettings.Font;
	surface.SetFont( font );
	local w, h = surface.GetTextSize( name )
	
	return w
end

function GM:DrawDeathNotice( x, y )

	local hud_deathnotice_time = hud_deathnotice_time:GetFloat()

	x = x * ScrW()
	y = y * ScrH()
	
	local deathtable = Deaths
	local countdeaths = table.Count( Deaths )
	
	if( y > 0.6 ) then
		deathtable = {}
		
		for k, v in pairs( Deaths ) do
			deathtable[ countdeaths - k + 1 ] = v;
		end
	end
	
	// Draw
	for k, Death in pairs( deathtable ) do

		if (Death.time + hud_deathnotice_time > CurTime()) then
	
			if (Death.lerp) then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end
			
			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
		
			y = DrawDeath( x, y, Death, hud_deathnotice_time )
		
		end
		
	end
	
	// We want to maintain the order of the table so instead of removing
	// expired entries one by one we will just clear the entire table
	// once everything is expired.
	for k, Death in pairs( Deaths ) do
		if (Death.time + hud_deathnotice_time > CurTime()) then
			return
		end
	end
	
	Deaths = {}

end
