GM.FontName = "HudBarItem"
GM.SmallFontName = "HudBarItemSmall"
GM.HUDTextOffset = 18;

local texBackground = surface.GetTextureID( "hud/gmdm_icons/background" )

local PANEL = {}

PANEL.Wide = 160

/*---------------------------------------------------------
   Name: 
---------------------------------------------------------*/
function PANEL:Init()
end

/*---------------------------------------------------------
   Name: 
---------------------------------------------------------*/
function PANEL:Reconfigure()
	self:SetVisible( self:ShouldBeVisible() )
end

/*---------------------------------------------------------
   Name: 
---------------------------------------------------------*/
function PANEL:ShouldBeVisible()
	if( !ValidEntity( LocalPlayer() ) ) then return false end
	if( LocalPlayer():Alive() == false or LocalPlayer():Team() == TEAM_UNASSIGNED or LocalPlayer():Team() == TEAM_SPECTATOR or GetGlobalBool( "EndOfGame", false ) == true or LocalPlayer():GetNetworkedBool( "ShowSpectatorUI", false ) == true ) then
		return false
	end
	
	return true
end


/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()

	surface.SetTexture( texBackground )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( 0, 0, 64, 64 ) 
	
	local offset = 0;
	
	if ( self.texIcon ) then
	
		surface.SetTexture( self.texIcon )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 0, 0, 64, 64 ) 
		offset = 64;
	
	end
	
	self:PaintText( offset + 8, GAMEMODE.HUDTextOffset )

end

/*---------------------------------------------------------
   Name: PaintText
---------------------------------------------------------*/
function PANEL:PaintText()
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()
	self:SetSize( self.Wide, 64 )	
end

vgui.Register( "HUDBar_Item", PANEL, "Panel" )


/*---------------------------------------------------------

	CUSTOM PANEL
   
---------------------------------------------------------*/
local PANEL = {}
PANEL.Params = {}
/*---------------------------------------------------------
   Name: PaintText
---------------------------------------------------------*/
function PANEL:PaintText( x, y )
	if ( !ValidEntity( LocalPlayer( ) ) ) then return end
	
	local drawaltx = 0;
	
	if( self.Params.ShouldAlwaysDraw != false ) then
		if( self.Params.ShouldDraw and self.Params.ShouldDraw() == false ) then
			return
		end
	end

	if( self.Params.TextFunc != nil ) then
		if( !self.Params.TextFont ) then
			self.Params.TextFont = GAMEMODE.FontName
		end
		
		local returnval = self.Params.TextFunc();
		local color = Color( 255, 255, 255 );
		
		if( self.Params.GetColor ) then
			if( type( self.Params.GetColor ) == "table" ) then
				color = self.Params.GetColor;
			else
				color = self.Params:GetColor();
			end
		end
		
		surface.SetFont( self.Params.TextFont )
		drawaltx = x + surface.GetTextSize( returnval )
		
		draw.SimpleTextOutlined( returnval, self.Params.TextFont, x, y, color, 0, 0, 2, color_black )
	end
	
	if( self.Params.HasAltText and self.Params.AltTextFunc and self.Params.HasAltText == true ) then
		local color = Color( 255, 255, 255 );
		
		if( !self.Params.TextAltFont ) then
			self.Params.TextAltFont = GAMEMODE.SmallFontName;
		end
		
		if( self.Params.GetColor ) then
			if( type( self.Params.GetAltColor ) == "table" ) then
				color = self.Params.GetAltColor
			else
				color = self.Params:GetAltColor()
			end
		end
		
		local returnval = self.Params.AltTextFunc();
		draw.SimpleTextOutlined( " " .. returnval, self.Params.TextAltFont, drawaltx, y+8, color, 0, 0, 2, color_black )
	end
	
end

vgui.Register( "HUDBar_Simple", PANEL, "HUDBar_Item" )
CUSTOMPANEL = PANEL;

/*
	params table info:
		.Texture = texture of the icon you want to use
		.Wide = width of the panel
		.ShouldAlwaysDraw = boolean, set to false to call a function which decides whether an element should be drawn
		.ShouldDraw = function returning a bool, for above when false
		.TextFunc = function that returns the string to use for the HUD element
		.GetColor = Color table/function that returns a Color table (making it go red when below a certain amount for example) if this isn't defined it will draw white
		.TextFont = use a custom font
		.HasAltText = has smaller text?
		.AltTextFunc = function to return contents of small text
		.GetAltColor = Color table/function to return alt text colour, otherwise white
		.TextAltFont = use a custom font for the alt text
*/

function AddCustomElement( name, params )
	local custom = {}
	custom.Params = params;
	
	if( params.Texture ) then
		custom.texIcon = surface.GetTextureID( params.Texture );
	end
	
	if( params.Wide ) then
		custom.Wide = params.Wide;
	end
	
	vgui.Register( name, custom, "HUDBar_Simple" ) 
end

/*---------------------------------------------------------

	EASY TO CODE FOR BASE PANEL
   
---------------------------------------------------------*/
local PANEL = {}
PANEL.Font = GM.FontName
PANEL.AltFont = GM.SmallFontName

/*---------------------------------------------------------
   Name: PaintText
---------------------------------------------------------*/
function PANEL:PaintText( x, y )
	if ( !ValidEntity( LocalPlayer( ) ) ) then return end
	
	local drawaltx = 0;
	
	if( self:ShouldDraw() == false ) then
		return
	end

	local color = Color( 255, 255, 255 );
		
	if( self.GetDrawColor ) then
		if( type(self.GetDrawColor ) == "function" ) then
			color = self:GetDrawColor()
		else
			color = self.GetDrawColor
		end
	end
		
	surface.SetFont( self.Font )
	drawaltx = x + surface.GetTextSize( self:GetText() )
		
	draw.SimpleTextOutlined( self:GetText(), self.Font, x, y, color, 0, 0, 2, color_black )
	
	if( self:HasAltText() == true ) then
		local color = Color( 255, 255, 255 );

		if( self.GetAltDrawColor ) then
			if( type(self.GetAltDrawColor ) == "function" ) then
				color = self:GetAltDrawColor()
			else
				color = self.GetAltDrawColor
			end
		end
		
		draw.SimpleTextOutlined( " " .. self:GetAltText(), self.AltFont, drawaltx, y+8, color, 0, 0, 2, color_black )
	end
	
end

function PANEL:ShouldDraw()
	return true;
end

function PANEL:GetDrawColor()
	return Color( 255, 255, 255 );
end

function PANEL:GetText()
	return "";
end

function PANEL:HasAltText()
	return false;
end

function PANEL:GetAltDrawColor()
	return Color( 255, 255, 255 );
end

function PANEL:GetAltText()
	return "";
end

vgui.Register( "HUDBar_Easy", PANEL, "HUDBar_Item" )

/*--------------------------------------------------------
	CLOCK
------------------------------------------------------------*/

PANEL = {}

function PANEL:GetText()
		if( GetConVarNumber( "gmdm_timelimit" ) > 0 ) then
			local iTimeLimit = GetConVarNumber( "gmdm_timelimit" ) * 60;
			local fCurTime = CurTime();
		
			local iTimeTillEnd = 0;
			
			if( GetGlobalBool( "EndOfGame", false ) == false ) then
				if( iTimeLimit < fCurTime ) then
					iTimeTillEnd = 0;
				else
					iTimeTillEnd = iTimeLimit - fCurTime;
					
					if( iTimeTillEnd < 15 ) then
						self.GetDrawColor = Color( 200, ( math.sin( CurTime() * 3 ) + 1.0 ) * 100, ( math.sin( CurTime() * 3 ) + 1.0 ) * 100 );
					else
						self.GetDrawColor = Color( 200, 200, 200 ) ;
					end
				end
			
				return string.ToMinutesSeconds( iTimeTillEnd )
			end
		end
		
		return "";
end

vgui.Register( "HUDBar_Clock", PANEL, "HUDBar_Easy" );

/*---------------------------------------------------------

	HEALTH
   
---------------------------------------------------------*/
local PANEL = {}
PANEL.Wide = 130
PANEL.texIcon = surface.GetTextureID( "hud/gmdm_icons/health" )
function PANEL:Init() end

/*---------------------------------------------------------
   Name: PaintText
---------------------------------------------------------*/
function PANEL:PaintText( x, y )
      if ValidEntity( LocalPlayer( ) ) then
	local health = LocalPlayer():Health()
	
	local color = color_white
	if ( health < 20 ) then color = Color(255, 0, 0, 255) end

	draw.SimpleTextOutlined( health, GAMEMODE.FontName, x, y, color, 0, 0, 2, color_black )
	end
	return true

end

vgui.Register( "HUDBar_Health", PANEL, "HUDBar_Item" )


/*---------------------------------------------------------

	AMMO 1
   
---------------------------------------------------------*/
local PANEL = {}
PANEL.texIcon = surface.GetTextureID( "hud/gmdm_icons/ammo" )
function PANEL:Init() end

/*---------------------------------------------------------
   Name: 
---------------------------------------------------------*/
function PANEL:ShouldBeVisible()
	if( !ValidEntity( LocalPlayer() ) ) then return false end
	if( LocalPlayer():Alive() == false or LocalPlayer():Team() == TEAM_UNASSIGNED or LocalPlayer():Team() == TEAM_SPECTATOR or GetGlobalBool( "EndOfGame", false ) == true or LocalPlayer():GetNetworkedBool( "ShowSpectatorUI", false ) == true ) then
		return false
	end
	
      if ValidEntity( LocalPlayer( ) ) then 
	local Weapon = LocalPlayer():GetActiveWeapon()

	if (!Weapon || !Weapon:IsValid() || !Weapon.Primary ) then return false end
	
	if ( Weapon.Primary.Ammo == "none" ) then return false end
      end
	return true

end

/*---------------------------------------------------------
   Name: PaintText
---------------------------------------------------------*/
function PANEL:PaintText( x, y )
	if ValidEntity( LocalPlayer( ) ) then
	local Weapon = LocalPlayer():GetActiveWeapon()
	if (!Weapon || !Weapon:IsValid()) then return false end
	
	local Clip = Weapon:Clip1()
	local Stash = LocalPlayer():GetAmmoCount( Weapon:GetPrimaryAmmoType() )
	if ( Clip == -1 ) then
		Clip = Stash
		Stash = nil
	end
	
	local color = color_white
	if ( Clip < 2 ) then color = Color(255, 0, 0, 255) end
	
	draw.SimpleTextOutlined( Clip, GAMEMODE.FontName, x, y, color, 0, 0, 2, color_black )
	
	if ( Stash != nil ) then
	
		surface.SetFont( GAMEMODE.FontName )
		x = x + surface.GetTextSize( Clip )

		local color = color_white
		if ( Stash < 2 ) then color = Color(255, 0, 0, 255) end
	
		draw.SimpleTextOutlined( " / " .. Stash, GAMEMODE.SmallFontName, x, y+8, color, 0, 0, 2, color_black )
	
	end
	end
	return true

end

vgui.Register( "HUDBar_Ammo1", PANEL, "HUDBar_Item" )


/*---------------------------------------------------------

	AMMO 2
   
---------------------------------------------------------*/
local PANEL = {}
PANEL.Wide = 120
function PANEL:Init() end

/*---------------------------------------------------------
   Name: 
---------------------------------------------------------*/
function PANEL:ShouldBeVisible()
	if( !ValidEntity( LocalPlayer() ) ) then return false end
	if( LocalPlayer():Alive() == false or LocalPlayer():Team() == TEAM_UNASSIGNED or LocalPlayer():Team() == TEAM_SPECTATOR or GetGlobalBool( "EndOfGame", false ) == true or LocalPlayer():GetNetworkedBool( "ShowSpectatorUI", false ) == true ) then
		return false
	end
	
      if ValidEntity( LocalPlayer( ) ) then
	local Weapon = LocalPlayer():GetActiveWeapon()
	if (!Weapon || !Weapon:IsValid()) then return false end

	self.texIcon = Weapon.CustomAmmoIcon
	
	return Weapon.CustomSecondaryAmmo
	end
	return false
end

/*---------------------------------------------------------
   Name: PaintText
---------------------------------------------------------*/
function PANEL:PaintText( x, y )
      if ValidEntity( LocalPlayer( ) ) then
	local Weapon = LocalPlayer():GetActiveWeapon()
	if (!Weapon || !Weapon:IsValid()) then return false end
	
	local Ammo = Weapon:CustomAmmoCount()
	
	local color = color_white
	if ( Ammo != nil ) then
	if ( Ammo < 2 ) then color = Color(255, 0, 0, 255) end
	end

	draw.SimpleTextOutlined( Ammo, GAMEMODE.FontName, x, y, color, 0, 0, 2, color_black )
	end
	return true

end

vgui.Register( "HUDBar_Ammo2", PANEL, "HUDBar_Item" )