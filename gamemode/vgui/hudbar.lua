
include( "huditems.lua" )

local PANEL = {}
PANEL.BGColor = Color( 0, 0, 0, 200 )

surface.CreateFont( "coolvetica", 32, 500, true, false, "HudBarItem" )
surface.CreateFont( "coolvetica", 18, 500, true, false, "HudBarItemSmall" )

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Init()
	
	self.Left = {}
	self.Right = {}

end

function PANEL:AddToLeft( vguip )
	table.insert( self.Left, vguip )
end

function PANEL:AddToLeft( vguip )
	table.insert( self.Left, vguip )
end


/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/
function PANEL:Paint()
	if( self:ShouldDraw() == false ) then return end
	self:PaintBackground()
end

function PANEL:ShouldDraw()
	if( !ValidEntity( LocalPlayer() ) ) then return false end
	if( LocalPlayer():Alive() == false or LocalPlayer():Team() == TEAM_UNASSIGNED or LocalPlayer():Team() == TEAM_SPECTATOR or GetGlobalBool( "EndOfGame", false ) == true or LocalPlayer():GetNetworkedBool( "ShowSpectatorUI", false ) == true ) then
		return false
	end
	
	return true
end

function PANEL:PaintBackground()
	draw.RoundedBox( 8, 0, 16, self:GetWide(), 32, self.BGColor )
end


/*---------------------------------------------------------
   Name: Reconfigure
---------------------------------------------------------*/
function PANEL:Reconfigure()

	for k, v in ipairs( self.Left ) do
		if( v.Reconfigure ) then
			v:Reconfigure()
		end
	end
	for k, v in ipairs( self.Right ) do
		if( v.Reconfigure ) then
			v:Reconfigure()
		end
	end

	self:InvalidateLayout()
	
end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function PANEL:Think()
    if ValidEntity( LocalPlayer( ) ) then
		local CurWep = LocalPlayer():GetActiveWeapon()
		
		if ( CurWep == self.LastWeapon ) then
			self:Reconfigure()
			return 
		end	
		
		self.LastWeapon = CurWep
		self:Reconfigure()
	end
end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	local w, h = 0,0
	if( self.OverrideSize and self.OverrideSize == true ) then
		w, h = 640, 64

		self:SetSize( w, h )
		self:SetPos( (ScrW() - w) * 0.5, ScrH() * 0.9 )
	else
		w, h = self:GetSize()
	end
	
	local x, y = 16,0
	
	for k, v in ipairs( self.Left ) do
		if ( v and v.IsVisible and v:IsVisible() ) then
			v:SetPos( x, 0 )
			x = x + v:GetWide()
		end
	end
	
	local x, y = self:GetWide() - 16,0
	
	for k, v in ipairs( self.Right ) do
		if ( v and v.IsVisible and v:IsVisible() ) then
			x = x - v:GetWide()
			v:SetPos( x, 0 )
		end
	end

end

/*---------------------------------------------------------
   Name: ApplySchemeSettings
---------------------------------------------------------*/
function PANEL:ApplySchemeSettings()
end

vgui.Register( "HUDBar", PANEL, "Panel" )