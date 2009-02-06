

include( 'shared.lua' )
include( 'cl_postprocess.lua' )
include( 'cl_hud.lua' )
include( 'cl_hitindicator.lua' )
include( 'cl_deathnotice.lua' );
include( 'cl_targetid.lua' );
include( 'vgui/hudbar.lua' )
include( 'vgui/menubackground.lua' );
include( 'vgui/gmdmbutton.lua' );
include( "cl_teamselectmenu.lua" );
include( "cl_scoreboard.lua" );
include( "cl_weaponselect.lua" );

-- Gamemode stuff just in case anyone wants to use this as a base
GM.HUDPlayerBarElement = "HUDBar"; -- custom hud bar (dervived gamemodes)
GM.HUDPlayerLeftElements = { "HUDBar_Health" };
GM.HUDPlayerRightElements = { "HUDBar_Ammo2", "HUDBar_Ammo1", "HUDBar_Clock" };
GM.HUDPlayerPanel = nil
	
function GM:Initialize( )	

	-- precache stuff
	GAMEMODE:PrecacheTeamModels();
	GAMEMODE:DoConVars();
	
	if ( HUDBAR ) then
		HUDBAR:Remove()
	end
	
	GAMEMODE:PreVGUICreation()

	HUDBAR = vgui.Create( GAMEMODE.HUDPlayerBarElement )
	HUDBAR.OverrideSize = true;
	GAMEMODE.HUDPlayerPanel = HUDBAR;
	
	for k, v in pairs( GAMEMODE.HUDPlayerLeftElements ) do
		local newvgui = vgui.Create( v, GAMEMODE.HUDPlayerPanel );
		table.insert( GAMEMODE.HUDPlayerPanel.Left, newvgui )
	end
		
	for k, v in pairs( GAMEMODE.HUDPlayerRightElements ) do
		local newvgui = vgui.Create( v, GAMEMODE.HUDPlayerPanel );
		table.insert( GAMEMODE.HUDPlayerPanel.Right, newvgui )
	end
		
	GAMEMODE:InitScoreboard()
	self.BaseClass:Initialize()	

end

-- create custom elements in this function (derived gamemodes)
function GM:PreVGUICreation()

end

function GM:PlayerBindPress( pl, bind, down ) 

	if( down && bind == "+menu" ) then
		LocalPlayer():ConCommand( "lastinv" )
		return false
	end
	
	return self.BaseClass:PlayerBindPress( pl, bind, down )
end

function GM:PostProcessPermitted( name )
	return true
end

local matPickup = Material( "sprites/pickup_cloud" )

function GM:DrawPickupWorldModel( ent, translucent )

	local DisplayPos = ent:GetPos( )
		
	if ( ent:GetNetworkedBool( "Respawner", false ) == false ) then return end
		
	if ( translucent ) then
	
		render.SetMaterial( matPickup )
		
		local t = CurTime() * 3
		local Forward = LocalPlayer():EyeAngles():Forward()
		
		local num = 128
		local Distance = Vector(0,0, /*164 / num*/ 0)

		for i=1, num do

			local Up = Vector( 0, 0, 1 ) - Forward * 0.4
			local dlta = (i/num)
			
			Up.x = Up.x + math.sin( t + i * 0.05 ) * 0.2
			Up.y = Up.y + math.cos( t + dlta * 4 ) * 0.2
			
			local col = Color( 255 - 255 * dlta^0.2, 255 - 255 * dlta^0.5, 255 - 200 * dlta^0.4, 255 - dlta ^ 6 * 255 )
			local size = 100 + 50 * dlta
		
			render.DrawQuadEasy( ent:GetPos( ) + Distance * i, Up, size, size, col, t * -20 + ( ( dlta ^ 2.5 ) * 180) )
		
		end
		
	end

end
